%%% ************************************************************************
%%% * Collaborative Spatial Reuse in Wireless Networks via Selfish MABs    *
%%% * Author: Francesc Wilhelmi (francesc.wilhelmi@upf.edu)                *
%%% * Co-authors: C. Cano, G. Neu, B. Bellalta, A. Jonsson & S. Barrachina *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi          *
%%% * GitHub repository:                                                   *
%%% *   https://github.com/wn-upf/Collaborative_SR_in_WNs_via_Selfish_MABs *
%%% * More info on https://www.upf.edu/en/web/fwilhelmi                    *
%%% ************************************************************************

function throughputPerConfiguration = compute_throughput_all_combinations...
    (wlans, actions_ch, actions_cca, actions_tpc, noise)
% Computes the throughput experienced by each WLAN for all the possible
% combinations of Channels, CCA and TPC 
%
%   NOTE: the "allcomb" function does not hold big amounts of combinations 
%   (a reasonable limit is 4 WLANs with 2 channels and 4 levels of TPC)
%
% OUTPUT:
%   * throughputPerConfiguration - tpt achieved by each WLAN for each configuration (Mbps)
% INPUT:
%   * wlans - object containing all the WLANs information 
%   * actions_ch - set of channels
%   * actions_cca - set of carrier sense thresholds
%   * actions_tpc - set of transmit power values
%   * noise - floor noise in dBm

    disp('      - Computing the throughput for all the combinations...')

    % Each state represents an [i,j,k] combination for indexes on "channels", "CCA" and "TxPower"
    possible_actions = 1:(size(actions_ch,2)*size(actions_cca,2)*size(actions_tpc,2));
    % Set of possible combinations of configuration  
    possible_comb = allcomb(possible_actions,possible_actions,possible_actions,possible_actions);

    n_WLANs = size(wlans,2);
    nChannels = size(actions_ch, 2);
    
    wlan_aux = wlans;    % Generate a copy of the WLAN object to make modifications

    % Try all the combinations
    for i = 1:size(possible_comb, 1)
        % Change WLANs configuration 
        for j = 1:n_WLANs 
            [ch, ~, tpc_ix] = val2indexes(possible_comb(i,j), nChannels, size(actions_cca,2), size(actions_tpc,2));
            wlan_aux(j).Channel = ch;   
            wlan_aux(j).TxPower = actions_tpc(tpc_ix);            
        end
        % Compute the Throughput and store it
        powerMatrix = power_matrix(wlan_aux); 
        throughputPerConfiguration(i, :) = compute_throughput_from_sinr(wlan_aux, powerMatrix, noise); 
    end
    
    % Find the best configuration for each WLAN and display it
    for i = 1 : size(throughputPerConfiguration, 1)
        agg_tpt(i) = sum(throughputPerConfiguration(i,:));
        fairness(i) = jains_fairness(throughputPerConfiguration(i,:));
        prop_fairness(i) = sum(log(throughputPerConfiguration(i,:)));
    end    
    
    [val, ix] = max(prop_fairness);
    disp('---------------')
    disp(['Best proportional fairness: ' num2str(val)])
    disp(['Aggregate throughput: ' num2str(agg_tpt(ix)) ' Mbps'])   
    disp(['Mean individual throughput: ' num2str(mean(throughputPerConfiguration(ix, :))) ' Mbps']) 
    disp(['std: ' num2str(std(throughputPerConfiguration(ix, :))) ' Mbps']) 
    disp(['Fairness: ' num2str(fairness(ix))])
    disp(['Best configurations: ' num2str(possible_comb(ix, :))])
    for i = 1:n_WLANs
        [a, ~, c] = val2indexes(possible_comb(ix, i), nChannels, size(actions_cca, 2), size(actions_tpc, 2));  
        disp(['   * WLAN' num2str(i) ':'])
        disp(['       - Channel:' num2str(a)])
        disp(['       - TPC:' num2str(actions_tpc(c))])
    end
    
    
    [val2, ix2] = max(agg_tpt);
    disp('---------------')
    disp(['Best aggregate throughput: ' num2str(val2) ' Mbps'])
    disp(['Max individual throughput: ' num2str(max(throughputPerConfiguration(ix2, :))) ' Mbps']) 
    disp(['Min individual throughput: ' num2str(min(throughputPerConfiguration(ix2, :))) ' Mbps']) 
    disp(['Mean individual throughput: ' num2str(mean(throughputPerConfiguration(ix2, :))) ' Mbps']) 
    disp(['std: ' num2str(std(throughputPerConfiguration(ix2, :))) ' Mbps'])    
    disp(['Fairness: ' num2str(fairness(ix2))])
    disp(['Best configurations: ' num2str(possible_comb(ix2, :))])
    for i = 1:n_WLANs
        [a, ~, c] = val2indexes(possible_comb(ix2, i), nChannels, size(actions_cca, 2), size(actions_tpc, 2));  
        disp(['   * WLAN' num2str(i) ':'])
        disp(['       - Channel:' num2str(a)])
        disp(['       - TPC:' num2str(actions_tpc(c))])
    end
    
end
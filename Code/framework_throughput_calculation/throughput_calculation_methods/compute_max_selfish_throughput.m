%%% ************************************************************************
%%% * Collaborative Spatial Reuse in Wireless Networks via Selfish MABs    *
%%% * Author: Francesc Wilhelmi (francesc.wilhelmi@upf.edu)                *
%%% * Co-authors: C. Cano, G. Neu, B. Bellalta, A. Jonsson & S. Barrachina *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi          *
%%% * GitHub repository:                                                   *
%%% *   https://github.com/wn-upf/Collaborative_SR_in_WNs_via_Selfish_MABs *
%%% * More info on https://www.upf.edu/en/web/fwilhelmi                    *
%%% ************************************************************************

function optimalThroughputPerWlan = compute_max_selfish_throughput( wlans )
% Given an WLAN (AP+STA), compute the maximum capacity achievable according
% to the power obtained at the receiver without interference
%
% OUTPUT:
%   * optimalThroughputPerWlan - maximum achievable throughput per WLAN (Mbps)
% INPUT:
%   * wlan - object containing all the WLANs information 
%   * powerMatrix - power received from each AP
%   * noise - floor noise in dBm

    load('constants.mat')

    wlans_aux = wlans;
    num_wlans = size(wlans_aux, 2);
    
    % Iterate for each WLAN
%     for i = 1 : num_wlans
%         for j = 1 : num_wlans
%             if j ~= i
%                 wlans_aux(j).TxPower = min(txPowerActions);
%                 wlans_aux(j).Channel = max(channelActions);
%             end
%         end
%         wlans_aux(i).TxPower = max(txPowerActions);
%         wlans_aux(i).Channel = min(channelActions);
%         tpt = compute_throughput_from_sinr(wlans_aux, NOISE_DBM); % Mbps
%         optimalThroughputPerWlan(i) = tpt(i);
%     end

    for i = 1 : num_wlans
        wlans_aux(i).TxPower = max(txPowerActions);
    end
    powMatrix = power_matrix(wlans_aux);
    snr_dbm = powMatrix - NOISE_DBM;
    optimalThroughputPerWlan = compute_theoretical_capacity(wlans_aux(1).BW, diag(snr_dbm)') / 1e6; % Mbps
    
end
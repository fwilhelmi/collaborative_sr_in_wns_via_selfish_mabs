%%% ************************************************************************
%%% * Collaborative Spatial Reuse in Wireless Networks via Selfish MABs    *
%%% * Author: Francesc Wilhelmi (francesc.wilhelmi@upf.edu)                *
%%% * Co-authors: C. Cano, G. Neu, B. Bellalta, A. Jonsson & S. Barrachina *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi          *
%%% * GitHub repository:                                                   *
%%% *   https://github.com/wn-upf/Collaborative_SR_in_WNs_via_Selfish_MABs *
%%% * More info on https://www.upf.edu/en/web/fwilhelmi                    *
%%% ************************************************************************

function throughputPerWlan = compute_throughput_from_sinr( wlans, noise )
% Computes the throughput of each WLAN in wlan according to the
% interferences sensed 
%  * Assumption: all the devices transmit at the same time and the
%    throughput is computed as the capacity obtained from the total SINR 
%
% OUTPUT:
%   * throughputPerWlan - throughput achieved by each WLAN (Mbps)
% INPUT:
%   * wlan - object containing all the WLANs information 
    
    % Initialize variables
    num_wlans = size(wlans,2);
    throughputPerWlan = zeros(1, num_wlans);
    sinr_dbm = zeros(1, num_wlans);  
    % Compute the power matrix
    powerStaFromAp = power_matrix(wlans);
    % Compute the interference experienced per WLAN
    interference_per_wlan_mw = compute_interference_per_wlan(wlans, powerStaFromAp); %dBm 
    interference_plus_noise = pow2db(interference_per_wlan_mw + db2pow(noise));
    for i = 1 : num_wlans
        % Compute the SINR per WLAN                   
        sinr_dbm(i) = powerStaFromAp(i,i) - interference_plus_noise(i); % dBm
        % Compute the tpt of each WLAN according to the sensed interferences
        throughputPerWlan(i) = compute_theoretical_capacity(wlans(i).BW, sinr_dbm(i)) / 1e6; % Mbps     
    end
        
end
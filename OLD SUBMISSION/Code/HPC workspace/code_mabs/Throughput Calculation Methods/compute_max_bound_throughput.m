%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exploiting Spatial Reuse in Wireless Networks through Decentralised MABs
% F. Wilhelmi, B. Bellalta, A. Jonsson, C. Cano, G. Neu, S. Barrachina
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function optimalThroughputPerWlan = compute_max_bound_throughput(wlan, powerMatrix, noise, maxPower)
% Given an WLAN (AP+STA), compute the maximum capacity achievable according
% to the power obtained at the receiver without interference
%
% OUTPUT:
%   * optimalThroughputPerWlan - maximum achievable throughput per WLAN (Mbps)
% INPUT:
%   * wlan - object containing all the WLANs information 
%   * powerMatrix - power received from each AP
%   * noise - floor noise in dBm

    wlan_aux = wlan;
    % Iterate for each WLAN
    for i = 1 : size(wlan_aux,2)
        wlan_aux(i).TxPower = maxPower;
        optimalThroughputPerWlan(i) = compute_theoretical_capacity(wlan_aux(i).BW, ...
            db2pow(powerMatrix(i,i) - noise))/1e6; % Mbps
    end
    
end
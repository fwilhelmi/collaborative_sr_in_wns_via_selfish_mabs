%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exploiting Spatial Reuse in Wireless Networks through Decentralised MABs
% F. Wilhelmi, B. Bellalta, A. Jonsson, C. Cano, G. Neu, S. Barrachina
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function throughputPerWlan = compute_throughput_from_sinr(wlans, powerMatrix, noise)
% Computes the throughput of each WLAN in wlan according to the
% interferences sensed 
%  * Assumption: all the devices transmit at the same time and the
%    throughput is computed as the capacity obtained from the total SINR 
%
% OUTPUT:
%   * tpt - tpt achieved by each WLAN (Mbps)
% INPUT:
%   * wlan - object containing all the WLANs information 
%   * powMat - power received from each AP
%   * noise - floor noise in dBm

    n_Wlans = size(wlans,2);
    sinr = zeros(1,n_Wlans);  
    % Activate all the WLANs
    for j = 1:n_Wlans, wlans(j).transmitting = 1; end
    % Compute the tpt of each WLAN according to the sensed interferences
    for i = 1:n_Wlans
        interferences = Interferences(wlans, powerMatrix); %dBm                      
        sinr(i) = powerMatrix(i,i) - pow2db((interferences(i) + db2pow(noise))); % dBm
        throughputPerWlan(i) = compute_theoretical_capacity(wlans(i).BW, db2pow(sinr(i))) / 1e6; % Mbps     
    end
    
end
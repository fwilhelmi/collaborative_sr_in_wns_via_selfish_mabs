%%% ************************************************************************
%%% * Collaborative Spatial Reuse in Wireless Networks via Selfish MABs    *
%%% * Author: Francesc Wilhelmi (francesc.wilhelmi@upf.edu)                *
%%% * Co-authors: C. Cano, G. Neu, B. Bellalta, A. Jonsson & S. Barrachina *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi          *
%%% * GitHub repository:                                                   *
%%% *   https://github.com/wn-upf/Collaborative_SR_in_WNs_via_Selfish_MABs *
%%% * More info on https://www.upf.edu/en/web/fwilhelmi                    *
%%% ************************************************************************

function interference_per_wlan_mw = compute_interference_per_wlan(wlans, powerMatrix)
% Interferences - Returns the interferences power received at each WLAN
%   OUTPUT:
%       * intMat: 1xN array (N is the number of WLANs) with the
%       interferences noticed on each AP in mW
%   INPUT:
%       * wlans: contains information of each WLAN in the map. For instance,
%       wlans(1) corresponds to the first one, so that it has unique
%       parameters (x,y,z,BW,CCA,etc.).
%       * powMat: matrix NxN (N is the number of WLANs) with the power
%       received at each AP in dBm.

% We assume that overlapping channels also create an interference with lower level (20dB/d) - 20 dB == 50 dBm

    wlans_aux = wlans;
   
    load('constants.mat')
    
    num_wlans = size(wlans_aux, 2);
    interference_per_wlan_mw = zeros(1, size(wlans_aux, 2)); 
               
    for i = 1 : num_wlans
        for j = 1 : num_wlans
            if i ~= j 
                if COCHANNEL_INTERFERENCE
                    adjacent_interference = 20 * (abs(wlans_aux(i).Channel - wlans_aux(j).Channel));
                    if wlans_aux(i).Channel ~= wlans_aux(j).Channel
                        interference_per_wlan_mw(i) = interference_per_wlan_mw(i) + ...
                            db2pow(powerMatrix(i,j) - adjacent_interference);
                    else
                        interference_per_wlan_mw(i) = interference_per_wlan_mw(i) + ...
                            db2pow(powerMatrix(i,j));
                    end  
                else
                    if wlans_aux(i).Channel == wlans_aux(j).Channel
                        interference_per_wlan_mw(i) = interference_per_wlan_mw(i) + db2pow(powerMatrix(i,j));
                    end
                end
            end
        end
    end

end
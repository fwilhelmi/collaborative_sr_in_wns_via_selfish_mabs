%%% ************************************************************************
%%% * Collaborative Spatial Reuse in Wireless Networks via Selfish MABs    *
%%% * Author: Francesc Wilhelmi (francesc.wilhelmi@upf.edu)                *
%%% * Co-authors: C. Cano, G. Neu, B. Bellalta, A. Jonsson & S. Barrachina *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi          *
%%% * GitHub repository:                                                   *
%%% *   https://github.com/wn-upf/Collaborative_SR_in_WNs_via_Selfish_MABs *
%%% * More info on https://www.upf.edu/en/web/fwilhelmi                    *
%%% ************************************************************************

function interferences = Interferences(wlans, powerMatrix)
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

    interferences = zeros(1, size(wlans, 2)); 
    
    for i = 1:size(wlans, 2)
        
        for j = 1:size(wlans, 2)
            
            if i ~= j && wlans(j).transmitting == 1
                
                interferences(i) = interferences(i) + db2pow(powerMatrix(i,j) - db2pow(20 * (abs(wlans(i).Channel - wlans(j).Channel))));
            
            end
            
        end
        
    end

end
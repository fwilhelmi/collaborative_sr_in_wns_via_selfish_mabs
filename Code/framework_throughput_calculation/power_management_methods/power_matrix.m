%%% ************************************************************************
%%% * Collaborative Spatial Reuse in Wireless Networks via Selfish MABs    *
%%% * Author: Francesc Wilhelmi (francesc.wilhelmi@upf.edu)                *
%%% * Co-authors: C. Cano, G. Neu, B. Bellalta, A. Jonsson & S. Barrachina *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi          *
%%% * GitHub repository:                                                   *
%%% *   https://github.com/wn-upf/Collaborative_SR_in_WNs_via_Selfish_MABs *
%%% * More info on https://www.upf.edu/en/web/fwilhelmi                    *
%%% ************************************************************************

function powerStaFromAp = power_matrix( wlans )
% power_matrix - Returns the power received by each AP from all the others
%   OUTPUT:
%       - powMat: matrix NxN (N is the number of WLANs) with the power
%       received at each AP in dBm
%   INPUT:
%       - wlan: contains information of each WLAN in the map. For instance,
%       wlan(1) corresponds to the first one, so that it has unique
%       parameters (x,y,z,BW,CCA,etc.)
    
    load('constants.mat')

    % Initialize variables
    num_wlans = size(wlans,2);    
    powerStaFromAp = zeros(num_wlans, num_wlans);

    % Compute the received power on each STA from every AP
    for i = 1 : num_wlans
        for j = 1 : num_wlans
            d = sqrt((wlans(i).xn - wlans(j).x)^2 + (wlans(i).yn - ...
                wlans(j).y)^2 + (wlans(i).zn - wlans(j).z)^2);                 
            PL = PLd1 + 10 * alfa * log10(d) + shadowing / 2 + (d/10) .* obstacles / 2;
            powerStaFromAp(i,j) = wlans(j).TxPower - PL;  
        end
    end
    
end
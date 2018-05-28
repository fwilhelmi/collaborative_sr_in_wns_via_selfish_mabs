%%% ************************************************************************
%%% * Collaborative Spatial Reuse in Wireless Networks via Selfish MABs    *
%%% * Author: Francesc Wilhelmi (francesc.wilhelmi@upf.edu)                *
%%% * Co-authors: C. Cano, G. Neu, B. Bellalta, A. Jonsson & S. Barrachina *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi          *
%%% * GitHub repository:                                                   *
%%% *   https://github.com/wn-upf/Collaborative_SR_in_WNs_via_Selfish_MABs *
%%% * More info on https://www.upf.edu/en/web/fwilhelmi                    *
%%% ************************************************************************

function powerMatrix = power_matrix(wlans)
% power_matrix - Returns the power received by each AP from all the others
%   OUTPUT:
%       - powMat: matrix NxN (N is the number of WLANs) with the power
%       received at each AP in dBm
%   INPUT:
%       - wlan: contains information of each WLAN in the map. For instance,
%       wlan(1) corresponds to the first one, so that it has unique
%       parameters (x,y,z,BW,CCA,etc.)

    
    PLd1=5;                     % Path-loss factor
    shadowing = 9.5;            % Shadowing factor
    obstacles = 30;             % Obstacles factor
%     shadowingmatrix = shadowing*randn(nWlans);       % Shadowing affecting each WLAN
%     obstaclesmatrix = obstacles*rand(nWlans);        % Obstacles affecting each WLAN

    nWlans = size(wlans,2);

    % Compute the received power on all the APs from all the others
    for i = 1 : nWlans
        for j = 1 : nWlans
            if(i ~= j)
                % Distance between APs of interest
                d_AP_AP = sqrt((wlans(i).x - wlans(j).x)^2 + (wlans(i).y - wlans(j).y)^2 + (wlans(i).z - wlans(j).z)^2); 
                % Propagation model
                alfa = 4.4;
                %PL_AP = PLd1 + 10*alfa*log10(d_AP_AP) + shadowingmatrix(i,j) + (d_AP_AP/10).*obstaclesmatrix(i,j);
                PL_AP = PLd1 + 10 * alfa * log10(d_AP_AP) + shadowing / 2 + (d_AP_AP/10) .* obstacles / 2;
                powerMatrix(i,j) = wlans(j).TxPower - PL_AP;        
            else
                % Calculate Power received at the STA associated to the AP
                d_AP_STA = sqrt((wlans(i).x - wlans(j).xn)^2 + (wlans(i).y - wlans(j).yn)^2 + (wlans(i).z - wlans(j).zn)^2); 
                % Propagation model
                alfa = 4.4;
                PL_AP = PLd1 + 10 * alfa * log10(d_AP_STA) + shadowing / 2 + (d_AP_STA / 10) .* obstacles / 2;
                powerMatrix(i,j) = wlans(i).TxPower - PL_AP;
            end
        end
    end
%     disp('Received Power at each TX ')
%     disp(powMat)   
end
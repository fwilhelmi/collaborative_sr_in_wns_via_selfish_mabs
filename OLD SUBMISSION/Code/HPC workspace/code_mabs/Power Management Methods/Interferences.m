%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exploiting Spatial Reuse in Wireless Networks through Decentralised MABs
% F. Wilhelmi, B. Bellalta, A. Jonsson, C. Cano, G. Neu, S. Barrachina
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function interferences = Interferences(wlans, powerMatrix)
% Interferences - Returns the interferences power received at each WLAN
%   OUTPUT:
%       * intMat: 1xN array (N is the number of WLANs) with the
%       interferences noticed on each AP in mW
%   INPUT:
%       * wlan: contains information of each WLAN in the map. For instance,
%       wlan(1) corresponds to the first one, so that it has unique
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
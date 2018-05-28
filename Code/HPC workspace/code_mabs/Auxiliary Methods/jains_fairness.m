%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exploiting Spatial Reuse in Wireless Networks through Decentralised MABs
% F. Wilhelmi, B. Bellalta, A. Jonsson, C. Cano, G. Neu, S. Barrachina
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function fairness = jains_fairness(C)
% JainsFairness returns the Jain's fairness measure given the inputted array
%   OUTPUT: 
%       * fairness - Jain's fairness measure from 0 to 1
%   INPUT: 
%       * C - array of capacities that each WLAN experiences

    numRows = size(C, 1);
    
    for i = 1:numRows
        fairness(i) = sum(C(i,:))^2 ./ (size(C(i,:),2)*sum(C(i,:).^2));
    end

end
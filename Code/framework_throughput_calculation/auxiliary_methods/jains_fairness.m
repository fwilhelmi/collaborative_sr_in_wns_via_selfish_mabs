%%% ************************************************************************
%%% * Collaborative Spatial Reuse in Wireless Networks via Selfish MABs    *
%%% * Author: Francesc Wilhelmi (francesc.wilhelmi@upf.edu)                *
%%% * Co-authors: C. Cano, G. Neu, B. Bellalta, A. Jonsson & S. Barrachina *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi          *
%%% * GitHub repository:                                                   *
%%% *   https://github.com/wn-upf/Collaborative_SR_in_WNs_via_Selfish_MABs *
%%% * More info on https://www.upf.edu/en/web/fwilhelmi                    *
%%% ************************************************************************

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
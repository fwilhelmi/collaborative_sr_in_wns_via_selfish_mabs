%%% ************************************************************************
%%% * Collaborative Spatial Reuse in Wireless Networks via Selfish MABs    *
%%% * Author: Francesc Wilhelmi (francesc.wilhelmi@upf.edu)                *
%%% * Co-authors: C. Cano, G. Neu, B. Bellalta, A. Jonsson & S. Barrachina *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi          *
%%% * GitHub repository:                                                   *
%%% *   https://github.com/wn-upf/Collaborative_SR_in_WNs_via_Selfish_MABs *
%%% * More info on https://www.upf.edu/en/web/fwilhelmi                    *
%%% ************************************************************************

function [ arm ] = select_action_ucb( rewards_per_configuration, t, times_arm_has_been_played )
% selectActionUCB: returns the best possible arm given the current distribution
%   OUTPUT:
%       * arm - chosen arm to be played - configuration composed by [channel,CCA,TPC]
%   INPUT:
%       - rewards_per_configuration: rewards noticed at each configuration
%       - t: current iteration
%       - times_arm_has_been_played: number of plays of each arm

    rewards_with_bounds = rewards_per_configuration + sqrt(2 * log(t) ./ times_arm_has_been_played);
   
    [val, ~] = max(rewards_with_bounds);
    
    % Break ties randomlyselected_armtime_arm_is_played
    
    if sum(rewards_with_bounds==val) > 1
        if val ~= Inf
            indexes = find(rewards_with_bounds == val);
            arm = randsample(indexes,1);
        else
            arm = randsample(1:size(rewards_with_bounds, 2), 1);
        end
        
    % Select arm with maximum reward
    else
        [~, arm] = max(rewards_with_bounds);
    end
    
end
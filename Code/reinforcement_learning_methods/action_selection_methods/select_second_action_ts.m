%%% ************************************************************************
%%% * Collaborative Spatial Reuse in Wireless Networks via Selfish MABs    *
%%% * Author: Francesc Wilhelmi (francesc.wilhelmi@upf.edu)                *
%%% * Co-authors: C. Cano, G. Neu, B. Bellalta, A. Jonsson & S. Barrachina *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi          *
%%% * GitHub repository:                                                   *
%%% *   https://github.com/wn-upf/Collaborative_SR_in_WNs_via_Selfish_MABs *
%%% * More info on https://www.upf.edu/en/web/fwilhelmi                    *
%%% ************************************************************************
function [ arm ] = select_second_action_ts( mu_hat, times_arm_has_been_played )
% select_action_ts: returns the best possible arm given the current distribution
%   OUTPUT:
%       * arm - chosen arm to be played - configuration composed by {channel, CCA, TPC}
%   INPUT:
%       - mu_hat: estimates of each arm
%       - times_arm_has_been_played: number of plays of each arm

    % STEP 1. For each arm, sample theta_i(t) independently from the normal distribution
    K = size(times_arm_has_been_played, 2);
    for k = 1 : K
        theta(k) = normrnd(mu_hat(k), 1/(1+times_arm_has_been_played(k)));         
    end
    
    % STEP 2. Play arm i(t) that maximizes theta_i(t)
    [val,~] = max(theta);
    
    % Break ties randomly
    if sum(theta == val) > 1
        if val ~= Inf
            indexes = find(theta == val);
            best_arm = randsample(indexes, 1);
        else
            best_arm = randsample(1:size(theta, 2), 1);
        end
        
    % Select arm with maximum reward
    else
        [~, best_arm] = max(theta);
    end
    
    % 
    mu_hat(best_arm) = 0;
    times_arm_has_been_played(best_arm) = 0;
    
    for k = 1 : K
        theta(k) = normrnd(mu_hat(k), 1/(1+times_arm_has_been_played(k)));         
    end
    
    % STEP 2. Play arm i(t) that maximizes theta_i(t)
    [val,~] = max(theta);
    
    % Break ties randomly
    if sum(theta == val) > 1
        if val ~= Inf
            indexes = find(theta == val);
            arm = randsample(indexes, 1);
        else
            arm = randsample(1:size(theta, 2), 1);
        end
        
    % Select arm with maximum reward
    else
        [~, arm] = max(theta);
    end
    
    
end
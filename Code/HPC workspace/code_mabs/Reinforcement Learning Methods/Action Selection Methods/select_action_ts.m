%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exploiting Spatial Reuse in Wireless Networks through Decentralised MABs
% F. Wilhelmi, B. Bellalta, A. Jonsson, C. Cano, G. Neu, S. Barrachina
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ arm ] = select_action_ts( mu_hat, times_arm_has_been_played )
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
            arm = randsample(indexes, 1);
        else
            arm = randsample(1:size(theta, 2), 1);
        end
        
    % Select arm with maximum reward
    else
        [~, arm] = max(theta);
    end
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exploiting Spatial Reuse in Wireless Networks through Decentralised MABs
% F. Wilhelmi, B. Bellalta, A. Jonsson, C. Cano, G. Neu, S. Barrachina
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function arm = select_action_random(rewards_per_configuration, e)
% selectActionEGreedy: returns the best possible arm given the current distribution
%   OUTPUT:
%       * arm - which represents the configuration composed by [channel,CCA,TPC]
%   INPUT:
%   	* rewards_per_configuration - rewards noticed at each configuration
%       * e - epsilon (exploration coefficient)

    indexes=[];  % empty array to include configurations with the same value    
    
    if rand() > e    % Check if we have to "exploit"
        
        [val,~] = max(rewards_per_configuration);
        
        % Break ties randomly
        if sum(rewards_per_configuration==val)>1
            if val ~= Inf
                indexes = find(rewards_per_configuration==val);
                arm = randsample(indexes,1);
            else
                arm = randsample(1:size(rewards_per_configuration,2),1);
            end
            
        % Select arm with maximum reward
        else
            [~,arm] = max(rewards_per_configuration);
        end
        
    else             % Check if we have to "explore"
        
        arm = randi([1 size(rewards_per_configuration,2)], 1, 1);
        
    end
end
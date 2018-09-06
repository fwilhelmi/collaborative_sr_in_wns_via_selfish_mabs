%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exploiting Spatial Reuse in Wireless Networks through Decentralised MABs
% F. Wilhelmi, B. Bellalta, A. Jonsson, C. Cano, G. Neu, S. Barrachina
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ tptExperiencedByWlan ] = random_action( wlans, varargin )
                                               
% random_action - Given a WN, selects actions randomly 
%
%   OUTPUT: 
%       * tptExperiencedByWlan - throughput experienced by each WLAN
%         for each of the iterations done
%   INPUT: 
%       * wlan - wlan object containing information about all the WLANs

    constants
    
    try
        if size(varargin, 2) == 3
            % Update possible actions
            nChannels = varargin{1};
            channelActions = 1 : nChannels;
            ccaActions = varargin{2};
            txPowerActions = varargin{3};
            % Each state represents an [i,j,k] combination for indexes on "channels", "cca" and "tx_power"
            possibleActions = 1:(size(channelActions, 2) * ...
                size(ccaActions, 2) * size(txPowerActions, 2));
            K = size(possibleActions,2);   % Total number of actions
            allCombs = allcomb(1:K, 1:K);    
        end   
    catch
        if size(varargin, 2) ~= 3
            disp('Wrong number of input arguments')
        end
    end

    %% INITIALIZE ALGORITHM
    % Use a copy of wlan to make operations
    wlansAux = wlans;
    nWlans = size(wlansAux, 2);
    
    % Find the index of the initial action taken by each WLAN
    initialActionIxPerWlan = zeros(1, nWlans);
    for i = 1 : nWlans
        [~,indexCca] = find(ccaActions == wlansAux(i).CCA);
        [~,indexTpc] = find(txPowerActions == wlansAux(i).TxPower);
        initialActionIxPerWlan(i) = indexes2val(wlansAux(i).Channel, ...
            indexCca, indexTpc, size(channelActions,2), size(ccaActions,2));
    end
    % Initialize the indexes of the taken action
    actionIndexPerWlan = initialActionIxPerWlan;                           
    
    % Compute the maximum achievable throughput per WLAN
    powerMatrix = PowerMatrix(wlansAux);     
    upperBoundRewardPerWlan = compute_max_bound_throughput(wlansAux, powerMatrix, NOISE_DBM, max(txPowerActions));
    
    %% ITERATE UNTIL CONVERGENCE OR MAXIMUM CONVERGENCE TIME                
    iteration = 1;
    cumulativeThroughputExperiencedPerWlan = 0;
    cumulativeFairness = 0;
    while(iteration < totalIterations + 1) 
        % Assign turns to WLANs randomly 
        order = randperm(nWlans);  
        for i=1:nWlans % Iterate sequentially for each agent in the random order                   
            learningIteration = 1;
            while(learningIteration <= roundsPerIteration)
                % Select an action randomly
                randomActionIndex = round(((K-1)*rand() + 1));
                [action1, ~, action3] = val2indexes(randomActionIndex, size(channelActions,2), size(ccaActions,2), size(txPowerActions,2));
                % Change parameters according to the action obtained
                wlansAux(order(i)).channel = action1;   
                wlansAux(order(i)).TxPower = txPowerActions(action3);           
                % Prepare the next state according to the actions performed on the current state
                [~,indexCca] = find(ccaActions==wlansAux(order(i)).CCA);
                [~,indexTpc] = find(txPowerActions==wlansAux(order(i)).TxPower);
                actionIndexPerWlan(order(i)) =  indexes2val(wlansAux(order(i)).channel, indexCca, ...
                    indexTpc, size(channelActions,2), size(ccaActions,2)); 
                % Compute the reward with the throughput obtained in the round after applying the action
                powerMatrix = PowerMatrix(wlansAux);        
                tptAfterAction = compute_throughput_from_sinr(wlansAux, powerMatrix, NOISE_DBM);  % bps                                    
                cumulativeThroughputExperiencedPerWlan = cumulativeThroughputExperiencedPerWlan + tptAfterAction;
                cumulativeFairness = cumulativeFairness + jains_fairness(tptAfterAction);
                learningIteration = learningIteration + 1;                
            end
        end      
        powerMatrix = PowerMatrix(wlansAux);        
        tptExperiencedByWlan(iteration,:) = compute_throughput_from_sinr(wlansAux, powerMatrix, NOISE_DBM);  % bps 
        % Increase the number of 'learning iterations' of a WLAN
        iteration = iteration + 1;     
    end
       
end
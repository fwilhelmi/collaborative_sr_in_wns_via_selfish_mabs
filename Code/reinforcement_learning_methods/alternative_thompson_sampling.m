%%% ************************************************************************
%%% * Collaborative Spatial Reuse in Wireless Networks via Selfish MABs    *
%%% * Author: Francesc Wilhelmi (francesc.wilhelmi@upf.edu)                *
%%% * Co-authors: C. Cano, G. Neu, B. Bellalta, A. Jonsson & S. Barrachina *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi          *
%%% * GitHub repository:                                                   *
%%% *   https://github.com/wn-upf/Collaborative_SR_in_WNs_via_Selfish_MABs *
%%% * More info on https://www.upf.edu/en/web/fwilhelmi                    *
%%% ************************************************************************

function [ tptExperiencedPerWlan, timesArmHasBeenPlayed, regretExperiencedPerWlan ] = ...
	alternative_thompson_sampling( wlans, varargin )
% thompson_sampling applies TS to maximize the experienced
% throughput of a given scenario
%
%   OUTPUT: 
%       * tptExperiencedByWlan - throughput experienced by each WLAN
%         for each of the iterations done
%       * timesArmHasBeenPlayed - times each action has been played
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
    initialActionIndexPerWlan = zeros(1, nWlans);
    for i=1:nWlans
        [~,indexCca] = find(ccaActions==wlansAux(i).CCA);
        [~,indexTpc] = find(txPowerActions==wlansAux(i).TxPower);
        initialActionIndexPerWlan(i) = indexes2val(wlansAux(i).Channel, ...
            indexCca, indexTpc, size(channelActions,2), size(ccaActions,2));
    end
    % Initialize the indexes of the taken action
    actionIndexPerWlan = initialActionIndexPerWlan;                           
    
    % Compute the maximum achievable throughput per WLAN
    powerMatrix = power_matrix(wlansAux);     
    upperBoundRewardPerWlan = compute_max_bound_throughput(wlansAux, ...
        powerMatrix, NOISE_DBM, max(txPowerActions));
    
    selectedArm = actionIndexPerWlan;               % Initialize arm selection for each WLAN by using the initial action
    timesArmHasBeenPlayed = zeros(nWlans, K);       % Initialize the times an arm has been played
    currentAction = zeros(1, nWlans);
    previousAction = selectedArm;
    transitionsCounter = zeros(nWlans, K^2);
    cumulativeRewardPerWlan = zeros(nWlans, K);     % Initialize the cumulative reward obtained by each WLAN for each arm
    meanRewardPerWlan = zeros(nWlans, K);           % Initialize the mean reward obtained by each WLAN for each arm
    estimatedRewardPerWlan = zeros(nWlans, K);      % Initialize the mean reward obtained by each WLAN for each arm
    % Initialize the regret experienced by each WLAN
    regretAfterAction = zeros(1, nWlans);   
     
    %% INITIALIZE THE PAYOFF OF EACH ARM    
    
    iteration = 1;
    
    %% ITERATE UNTIL CONVERGENCE OR MAXIMUM CONVERGENCE TIME                 
    while(iteration < totalIterations + 1) 
        % Assign turns to WLANs randomly 
        order = randperm(nWlans);  
        % Iterate sequentially for each agent in the random order 
        for i = 1 : nWlans                      
            % Select an action according to the policy
            if mod(i,2) == 0
                selectedArm(order(i)) = select_action_ts(estimatedRewardPerWlan(order(i), :), ...
                    timesArmHasBeenPlayed(order(i), :));  
            else
                selectedArm(order(i)) = select_second_action_ts(estimatedRewardPerWlan(order(i), :), ...
                    timesArmHasBeenPlayed(order(i), :));  
            end
            % Update the current action
            currentAction(order(i)) = selectedArm(order(i));
            % Find the index of the current and the previous action in allCombs
            ix = find(allCombs(:, 1) == previousAction(order(i)) ...
                & allCombs(:, 2) == currentAction(order(i)));
            % Update the previous action
            previousAction(order(i)) = currentAction(order(i));  
            % Update the transitions counter
            transitionsCounter(order(i), ix) = transitionsCounter(order(i), ix) + 1;
            % Find channel and tx power of the current action
            [a, ~, c] = val2indexes(selectedArm(order(i)), ...
                size(channelActions, 2), size(ccaActions, 2), size(txPowerActions, 2));
            % Update WN configuration
            wlansAux(order(i)).Channel = a;   
            %wlan_aux(order(i)).CCA = ccaActions(b);
            wlansAux(order(i)).TxPower = txPowerActions(c);  
            % Compute the reward with the throughput obtained in the round after applying the action
            powerMatrix = power_matrix(wlansAux);                
            tptAfterAction = compute_throughput_from_sinr(wlansAux, powerMatrix, NOISE_DBM);  % bps  
            % Update the reward of each WN
            rw = zeros(1, nWlans);
            for wlan_i = 1 : nWlans     
                rw(wlan_i) = tptAfterAction(wlan_i)/((upperBoundRewardPerWlan(wlan_i)));       
                estimatedRewardPerWlan(wlan_i, selectedArm(wlan_i)) = ...
                    (estimatedRewardPerWlan(wlan_i, selectedArm(wlan_i)) * ...
                    timesArmHasBeenPlayed(wlan_i, selectedArm(wlan_i)) + rw(wlan_i)) / ...
                    (timesArmHasBeenPlayed(wlan_i, selectedArm(wlan_i)) + 2);                    
                cumulativeRewardPerWlan(wlan_i, selectedArm(wlan_i)) = cumulativeRewardPerWlan(wlan_i, selectedArm(wlan_i)) + rw(wlan_i);
                meanRewardPerWlan(wlan_i, selectedArm(wlan_i)) = ...
                    cumulativeRewardPerWlan(wlan_i, selectedArm(wlan_i)) /...
                    timesArmHasBeenPlayed(wlan_i, selectedArm(wlan_i));
            end 

            regretAfterAction = 1 - rw;
            
            % Update the times WN has selected the current action
            timesArmHasBeenPlayed(order(i), selectedArm(order(i))) = ...
                timesArmHasBeenPlayed(order(i), selectedArm(order(i))) + 1;  
            
        end
        
        % Store the throughput at the end of the iteration for statistics
        tptExperiencedPerWlan(iteration, :) = tptAfterAction;
        regretExperiencedPerWlan(iteration, :) = regretAfterAction;

        % Increase the number of 'learning iterations' of a WLAN
        iteration = iteration + 1; 
        
    end    
    
    %% PRINT RESULTS
    if printInfo 
        % Print the preferred action per wlan
        for i=1:nWlans
            [~, ix] = max(meanRewardPerWlan(i, :));
            [a, ~, c] = val2indexes(possibleActions(ix), size(channelActions,2), size(ccaActions,2), size(txPowerActions,2));  
            disp(['   * WLAN' num2str(i) ':'])
            disp(['       - Channel:' num2str(a)])
            disp(['       - TPC:' num2str(txPowerActions(c))])
        end
        % Print the preferred action per wlan
        for i=1:nWlans    
            timesArmHasBeenPlayed(i, :)/totalIterations
            [~, ix] = max(meanRewardPerWlan(i, :));
            [a, ~, c] = val2indexes(possibleActions(ix), size(channelActions,2), size(ccaActions,2), size(txPowerActions,2));  
            disp(['   * WN' num2str(i) ':'])
            disp(['       - Channel:' num2str(a)])
            disp(['       - TPC:' num2str(txPowerActions(c))])
            a = transitionsCounter(i,:);
            % Max value
            [val1, ix1] = max(a);
            [ch1_1, ~, x] = val2indexes(possibleActions(allCombs(ix1,1)), size(channelActions,2), size(ccaActions,2), size(txPowerActions,2)); 
            tpc1_1 = txPowerActions(x);
            [ch1_2, ~, x] = val2indexes(possibleActions(allCombs(ix1,2)), size(channelActions,2), size(ccaActions,2), size(txPowerActions,2)); 
            tpc1_2 = txPowerActions(x);
            % Second max value
            [val2, ix2] = max(a(a<max(a)));
            [ch2_1, ~, x] = val2indexes(possibleActions(allCombs(ix2,1)), size(channelActions,2), size(ccaActions,2), size(txPowerActions,2)); 
            tpc2_1 = txPowerActions(x);
            [ch2_2, ~, x] = val2indexes(possibleActions(allCombs(ix2,2)), size(channelActions,2), size(ccaActions,2), size(txPowerActions,2)); 
            tpc2_2 = txPowerActions(x);
            % Third max value
            [val3, ix3] = max(a(a<max(a(a<max(a)))));
            [ch3_1, ~, x] = val2indexes(possibleActions(allCombs(ix3,1)), size(channelActions,2), size(ccaActions,2), size(txPowerActions,2)); 
            tpc3_1 = txPowerActions(x);
            [ch3_2, ~, x] = val2indexes(possibleActions(allCombs(ix3,2)), size(channelActions,2), size(ccaActions,2), size(txPowerActions,2)); 
            tpc3_2 = txPowerActions(x);   

            disp(['Probability of going from ' num2str(allCombs(ix1,1)) ' (ch=' num2str(ch1_1) '/tpc=' num2str(tpc1_1) ')' ...
                ' to ' num2str(allCombs(ix1,2)) ' (ch=' num2str(ch1_2) '/tpc=' num2str(tpc1_2) ')' ...
                ' = ' num2str(val1/totalIterations)])

            disp(['Probability of going from ' num2str(allCombs(ix2,1)) ' (ch=' num2str(ch2_1) '/tpc=' num2str(tpc2_1) ')' ...
                ' to ' num2str(allCombs(ix2,2)) ' (ch=' num2str(ch2_2) '/tpc=' num2str(tpc2_2) ')' ...
                ' = ' num2str(val2/totalIterations)])

            disp(['Probability of going from ' num2str(allCombs(ix3,1)) ' (ch=' num2str(ch3_1) '/tpc=' num2str(tpc3_1) ')' ...
                ' to ' num2str(allCombs(ix3,2)) ' (ch=' num2str(ch3_2) '/tpc=' num2str(tpc3_2) ')' ...
                ' = ' num2str(val3/totalIterations)])
        end
    end
    
end
%%% ************************************************************************
%%% * Collaborative Spatial Reuse in Wireless Networks via Selfish MABs    *
%%% * Author: Francesc Wilhelmi (francesc.wilhelmi@upf.edu)                *
%%% * Co-authors: C. Cano, G. Neu, B. Bellalta, A. Jonsson & S. Barrachina *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi          *
%%% * GitHub repository:                                                   *
%%% *   https://github.com/wn-upf/Collaborative_SR_in_WNs_via_Selfish_MABs *
%%% * More info on https://www.upf.edu/en/web/fwilhelmi                    *
%%% ************************************************************************

function [ tptExperiencedPerWlan, timesArmHasBeenPlayed, regretExperiencedPerWlan, meanRewardPerWlanPerArm ] = ...
    ucb_with_memory( wlans, upperBoundThroughputPerWlan, first_iteration, last_iteration, varargin )
% ucb applies UCB to maximize the experienced throughput of a given scenario
%
%   OUTPUT: 
%       * tptExperiencedByWlan - throughput experienced by each WLAN
%         for each of the iterations done
%       * timesArmHasBeenPlayed - times each action has been played
%   INPUT: 
%       * wlan - wlan object containing information about all the WLANs

    load('constants.mat')
    
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
    for wlan_i = 1 : nWlans
        [~,indexCca] = find(ccaActions==wlansAux(wlan_i).CCA);
        [~,indexTpc] = find(txPowerActions==wlansAux(wlan_i).TxPower);
        initialActionIxPerWlan(wlan_i) = indexes2val(wlansAux(wlan_i).Channel, ...
            indexCca, indexTpc, size(channelActions,2), size(ccaActions,2));
    end
    
    % Initialize the indexes of the taken action
    actionIndexPerWlan = initialActionIxPerWlan;                           
    selectedArm = actionIndexPerWlan;              % Initialize arm selection for each WLAN by using the initial action
    timesArmHasBeenPlayed = ones(nWlans, K);   % Initialize the times an arm has been played
    currentAction = zeros(1, nWlans);
    previousAction = selectedArm;
    transitionsCounter = zeros(nWlans, K^2);
    cumulativeRewardPerWlanPerArm = zeros(nWlans, K);     % Initialize the cumulative reward obtained by each WLAN for each arm
    meanRewardPerWlanPerArm = zeros(nWlans, K);           % Initialize the mean reward obtained by each WLAN for each arm

    %% INITIALIZE THE PAYOFF OF EACH ARM    
    
    iteration = first_iteration;
    
    %disp(['WLAN ' num2str(w)])
    order_actions = zeros(nWlans, K);
    for wlan_i = 1 : nWlans
        order_actions(wlan_i, :) = randperm(K); 
    end
    
    % for each action k in K 
    for k = 1 : K       
        % for each WLAN w in nWlans
        for wlan_i = 1 : nWlans   
            selectedArm(wlan_i) = order_actions(wlan_i,k);
            [a, ~, c] = val2indexes(selectedArm(wlan_i), size(channelActions,2), size(ccaActions,2), size(txPowerActions,2));
            wlansAux(wlan_i).Channel = a;   
            wlansAux(wlan_i).TxPower = txPowerActions(c);              
        end
        tptAfterAction = compute_throughput_from_sinr(wlansAux, NOISE_DBM);  % bps  
        for wlan_i = 1 : nWlans
            cumulativeRewardPerWlanPerArm(wlan_i, order_actions(wlan_i,k)) = ...
                (tptAfterAction(wlan_i)/((upperBoundThroughputPerWlan(wlan_i))));
            tptExperiencedPerWlan(iteration - first_iteration + 1, wlan_i) = tptAfterAction(wlan_i);
            meanRewardPerWlanPerArm(wlan_i, order_actions(wlan_i,k)) = ...
                (tptAfterAction(wlan_i)/((upperBoundThroughputPerWlan(wlan_i))));
        end
        iteration = iteration + 1;
    end  
    
    %% ITERATE UNTIL CONVERGENCE OR MAXIMUM CONVERGENCE TIME                 
    while(iteration < last_iteration + 1) 
        % Iterate sequentially for each agent in the random order
        order = randperm(nWlans);
        for wlan_i = 1 : nWlans                  
            % Select an action according to the policy
            selectedArm(order(wlan_i)) = select_action_ucb(meanRewardPerWlanPerArm(order(wlan_i), :), ...
                iteration - K, timesArmHasBeenPlayed(order(wlan_i), :));   
            % Update the current action
            currentAction(order(wlan_i)) = selectedArm(order(wlan_i));
            % Find the index of the current and the previous action in allCombs
            ix = find(allCombs(:,1) == previousAction(order(wlan_i)) ...
                & allCombs(:,2) == currentAction(order(wlan_i)));
            % Update the previous action
            previousAction(order(wlan_i)) = currentAction(order(wlan_i));       
            % Update the transitions counter
            transitionsCounter(order(wlan_i), ix) = transitionsCounter(order(wlan_i), ix) + 1;                                
            % Update the times WN has selected the current action
            timesArmHasBeenPlayed(wlan_i, selectedArm(wlan_i)) = timesArmHasBeenPlayed(wlan_i, selectedArm(wlan_i)) + 1;                
            % Find channel and tx power of the current action
            [a, ~, c] = val2indexes(selectedArm(order(wlan_i)), size(channelActions,2), size(ccaActions,2), size(txPowerActions,2));
            % Update WN configuration
            wlansAux(order(wlan_i)).Channel = a;   
            wlansAux(order(wlan_i)).TxPower = txPowerActions(c);        
        end   
        % Compute the throughput noticed after applying the action           
        tptAfterAction = compute_throughput_from_sinr(wlansAux, NOISE_DBM);  % bps         
        rw = tptAfterAction ./ upperBoundThroughputPerWlan;         
        % Update the mean reward experienced by each WLAN             
        for wlan_i = 1 : nWlans       
            % Update the times WN has selected the current action
            cumulativeRewardPerWlanPerArm(wlan_i, selectedArm(wlan_i)) = ...
                cumulativeRewardPerWlanPerArm(wlan_i, selectedArm(wlan_i)) + rw(wlan_i);
            meanRewardPerWlanPerArm(wlan_i, selectedArm(wlan_i)) = ...
                cumulativeRewardPerWlanPerArm(wlan_i, selectedArm(wlan_i)) /...
                timesArmHasBeenPlayed(wlan_i, selectedArm(wlan_i));                                            
        end  
        
        % Store the throughput at the end of the iteration for statistics
        tptExperiencedPerWlan(iteration - first_iteration + 1, :) = tptAfterAction;                        
        regretExperiencedPerWlan(iteration - first_iteration + 1, :) = (1 - rw);
        % Increase the number of 'learning iterations' of a WLAN
        iteration = iteration + 1;         
    end
    
    %% PRINT RESULTS
    if printInfo 
        % Print the preferred action per wlan
        for wlan_i = 1 : nWlans
            [~, ix] = max(meanRewardPerWlanPerArm(wlan_i, :));
            [a, ~, c] = val2indexes(possibleActions(ix), size(channelActions,2), size(ccaActions,2), size(txPowerActions,2));  
            disp(['   * WLAN' num2str(wlan_i) ':'])
            disp(['       - Channel:' num2str(a)])
            disp(['       - TPC:' num2str(txPowerActions(c))])
        end
        % Print the preferred action per wlan
        for wlan_i = 1 : nWlans    
            timesArmHasBeenPlayed(wlan_i, :)/totalIterations
            [~, ix] = max(meanRewardPerWlanPerArm(wlan_i, :));
            [a, ~, c] = val2indexes(possibleActions(ix), size(channelActions,2), size(ccaActions,2), size(txPowerActions,2));  
            disp(['   * WN' num2str(wlan_i) ':'])
            disp(['       - Channel:' num2str(a)])
            disp(['       - TPC:' num2str(txPowerActions(c))])
            a = transitionsCounter(wlan_i,:);
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
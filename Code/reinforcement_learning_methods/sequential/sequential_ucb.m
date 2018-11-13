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
    sequential_ucb( wlans, upperBoundThroughputPerWlan, varargin )
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
    for i=1:nWlans
        [~,indexCca] = find(ccaActions==wlansAux(i).CCA);
        [~,indexTpc] = find(txPowerActions==wlansAux(i).TxPower);
        initialActionIxPerWlan(i) = indexes2val(wlansAux(i).Channel, ...
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

    cumulative_reward = zeros(1, nWlans);
    iterations_without_acting = ones(1, nWlans);        
    iteration_per_wlan = zeros(1, nWlans);    
    
    %% INITIALIZE THE PAYOFF OF EACH ARM        
    iteration = 1;    
    %disp(['WLAN ' num2str(w)])
    order_actions = zeros(nWlans, K);
    for w = 1 : nWlans
        order_actions(w, :) = randperm(K); 
    end    
    % for each action k in K 
    for k = 1 : K       
        % for each WLAN w in nWlans
        for w = 1 : nWlans   
            selectedArm(w) = order_actions(w,k);
            [a, ~, c] = val2indexes(selectedArm(w), size(channelActions,2), size(ccaActions,2), size(txPowerActions,2));
            wlansAux(w).Channel = a;   
            wlansAux(w).TxPower = txPowerActions(c);              
        end
        tptAfterAction = compute_throughput_from_sinr(wlansAux, NOISE_DBM);  % bps  
        for w = 1 : nWlans
            cumulativeRewardPerWlanPerArm(w, order_actions(w,k)) = ...
                (tptAfterAction(w)/((upperBoundThroughputPerWlan(w))));
            tptExperiencedPerWlan(iteration, w) = tptAfterAction(w);
            meanRewardPerWlanPerArm(w, order_actions(w,k)) = ...
                (tptAfterAction(w)/((upperBoundThroughputPerWlan(w))));
        end
        iteration = iteration + 1;
    end 
        
    %% ITERATE UNTIL CONVERGENCE OR MAXIMUM CONVERGENCE TIME  
    order = [];
    while(iteration < totalIterations + 1) 
        
        if isempty(order)
            order = randperm(nWlans);
        end        
        wlan_ix = order(1);
        order(1) = [];
        
        % Select an action according to the policy
        selectedArm(wlan_ix) = select_action_ucb(meanRewardPerWlanPerArm(wlan_ix,:), ...
            iteration, timesArmHasBeenPlayed(wlan_ix,:));   
        % Update the current action
        currentAction(wlan_ix) = selectedArm(wlan_ix);
        % Find the index of the current and the previous action in allCombs
        ix = find(allCombs(:,1) == previousAction(wlan_ix) ...
            & allCombs(:,2) == currentAction(wlan_ix));
        % Update the previous action
        previousAction(wlan_ix) = currentAction(wlan_ix);       
        % Update the transitions counter
        transitionsCounter(wlan_ix, ix) = transitionsCounter(wlan_ix, ix) + 1;                                
        % Find channel and tx power of the current action
        [a, ~, c] = val2indexes(selectedArm(wlan_ix), size(channelActions,2), size(ccaActions,2), size(txPowerActions,2));
        % Update WN configuration
        wlansAux(wlan_ix).Channel = a;   
        wlansAux(wlan_ix).TxPower = txPowerActions(c);  
        % Compute the throughput noticed after applying the action           
        tptAfterAction = compute_throughput_from_sinr(wlansAux, NOISE_DBM);  % bps         
        % Update the reward of each WN
        rw = tptAfterAction./upperBoundThroughputPerWlan;  
        cumulative_reward = cumulative_reward + rw;
        avg_reward = cumulative_reward(wlan_ix)/iterations_without_acting(wlan_ix);
        iterations_without_acting(wlan_ix) = 1;
        cumulative_reward(wlan_ix) = 0;  
        timesArmHasBeenPlayed(wlan_ix, selectedArm(wlan_ix)) = ...
                timesArmHasBeenPlayed(wlan_ix, selectedArm(wlan_ix)) + 1;                                                    
        cumulativeRewardPerWlanPerArm(wlan_ix, selectedArm(wlan_ix)) = ...
            cumulativeRewardPerWlanPerArm(wlan_ix, selectedArm(wlan_ix)) + avg_reward;
        meanRewardPerWlanPerArm(wlan_ix, selectedArm(wlan_ix)) = ...
            cumulativeRewardPerWlanPerArm(wlan_ix, selectedArm(wlan_ix)) /...
            timesArmHasBeenPlayed(wlan_ix, selectedArm(wlan_ix)); 
        % Update the mean reward experienced by each WN
        for wlan_ix_aux = 1 : nWlans                          
            if wlan_ix_aux ~= wlan_ix
                transitionsCounter(wlan_ix_aux, selectedArm(wlan_ix_aux)) = ...
                    transitionsCounter(wlan_ix_aux, selectedArm(wlan_ix_aux)) + 1;
            end 
        end  
        % Store the throughput at the end of the iteration for statistics
        tptExperiencedPerWlan(iteration, :) = tptAfterAction;                        
        regretExperiencedPerWlan(iteration, :) = (1 - rw);
        % Increase the number of 'learning iterations' of a WLAN
        iteration_per_wlan(wlan_ix) = iteration_per_wlan(wlan_ix) + 1;
        iteration = iteration + 1;         
    end
    
    %% PRINT RESULTS
    if printInfo 
        % Print the preferred action per wlan
        for i = 1 : nWlans
            [~, ix] = max(meanRewardPerWlanPerArm(i, :));
            [a, ~, c] = val2indexes(possibleActions(ix), size(channelActions,2), size(ccaActions,2), size(txPowerActions,2));  
            disp(['   * WLAN' num2str(i) ':'])
            disp(['       - Channel:' num2str(a)])
            disp(['       - TPC:' num2str(txPowerActions(c))])
        end
        % Print the preferred action per wlan
        for i = 1 : nWlans    
            timesArmHasBeenPlayed(i, :)/totalIterations
            [~, ix] = max(meanRewardPerWlanPerArm(i, :));
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
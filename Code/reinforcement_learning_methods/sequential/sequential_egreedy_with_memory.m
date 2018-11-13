%%% ************************************************************************
%%% * Collaborative Spatial Reuse in Wireless Networks via Selfish MABs    *
%%% * Author: Francesc Wilhelmi (francesc.wilhelmi@upf.edu)                *
%%% * Co-authors: C. Cano, G. Neu, B. Bellalta, A. Jonsson & S. Barrachina *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi          *
%%% * GitHub repository:                                                   *
%%% *   https://github.com/wn-upf/Collaborative_SR_in_WNs_via_Selfish_MABs *
%%% * More info on https://www.upf.edu/en/web/fwilhelmi                    *
%%% ************************************************************************

function [ tptExperiencedPerWlan, timesArmHasBeenPlayed, regretExperiencedPerWlan, rewardPerArm, epsilon, iteration_per_wlan, cumulative_reward] = ...
    sequential_egreedy_cumulative_with_memory( wlans, epsilon, upperBoundThroughputPerWlan, ...
    rewardPerArm, cumulative_reward, first_iteration, last_iteration, iteration_per_wlan, varargin )
% EGREEDY - Given a WN, applies e-greedy to maximize the experienced throughput
%
%   OUTPUT: 
%       * tptExperiencedByWlan - throughput experienced by each WLAN
%         for each of the iterations done
%       * timesArmHasBeenPlayed - times each action has been played
%   INPUT: 
%       * wlan - wlan object containing information about all the WLANs
%       * initialEpsilon - initial exploration coefficient

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
    for i = 1 : nWlans
        [~,indexCca] = find(ccaActions == wlansAux(i).CCA);
        [~,indexTpc] = find(txPowerActions == wlansAux(i).TxPower);
        initialActionIxPerWlan(i) = indexes2val(wlansAux(i).Channel, ...
            indexCca, indexTpc, size(channelActions,2), size(ccaActions,2));
    end
    % Initialize the indexes of the taken action
    actionIndexPerWlan = initialActionIxPerWlan;                           
    
    % Initialize arm selection for each WLAN by using the initial action
    selectedArm = actionIndexPerWlan;
    % Keep track of current and previous actions for getting the transitions probabilities
    currentAction = zeros(1, nWlans);
    previousAction = selectedArm;
    % Store the times a transition between actions is done in each WN
    transitionsCounter = zeros(nWlans, K^2);    
    % Store the times an action has been played in each WN
    timesArmHasBeenPlayed = zeros(nWlans, K);     
    
    %cumulative_reward = zeros(1, nWlans);
    iterations_without_acting = ones(1, nWlans);        
    %iteration_per_wlan = zeros(1, nWlans);    
    % Initialize epsilon
    %epsilon = initialEpsilon * ones(1, nWlans);     
    initialEpsilon = epsilon;
    for i = 1 : nWlans
        epsilon(i) = epsilon(i) / iteration_per_wlan(i);
    end
    
    %% ITERATE UNTIL CONVERGENCE OR MAXIMUM CONVERGENCE TIME            
    iteration = first_iteration;    
    order = [];
    while(iteration < last_iteration+1)   
        
        if isempty(order)
            order = randperm(nWlans);
        end        
        wlan_ix = order(1);
        order(1) = [];
%         disp(['Iteration: ' num2str(iteration)]) 
%         disp(['    * wlan_ix: ' num2str(wlan_ix)]) 
%         disp(['    * epsilon: ' num2str(epsilon(wlan_ix))]) 
%         disp(['    * rewardPerArm: ' num2str(rewardPerArm(wlan_ix,:))])
        %%%%%%%%%%%% Select an action according to the policy
        selectedArm(wlan_ix) = select_action_egreedy(rewardPerArm(wlan_ix, :), epsilon(wlan_ix));    
        %disp(['    * selectedArm: ' num2str(selectedArm(wlan_ix))])         
        
        % Update the current action
        currentAction(wlan_ix) = selectedArm(wlan_ix);
        % Find the index of the current and the previous action in allCombs
        ix = find(allCombs(:,1) == previousAction(wlan_ix)...
            & allCombs(:,2) == currentAction(wlan_ix));
        % Update the previous action
        previousAction(wlan_ix) = currentAction(wlan_ix);  
        % Update the transitions counter
        transitionsCounter(wlan_ix, ix) = transitionsCounter(wlan_ix, ix) + 1;  
        % Find channel and tx power of the current action
        [a, ~, c] = val2indexes(selectedArm(wlan_ix), ...
            size(channelActions,2), size(ccaActions,2), size(txPowerActions,2));        
        timesArmHasBeenPlayed(wlan_ix, selectedArm(wlan_ix)) = ...
            timesArmHasBeenPlayed(wlan_ix, selectedArm(wlan_ix)) + 1;                 
        % Update WN configuration
        wlansAux(wlan_ix).Channel = a;   
        wlansAux(wlan_ix).TxPower = txPowerActions(c);
        %%%%%%%%%%%%        
        % Compute the throughput noticed after applying the action
        tptAfterAction = compute_throughput_from_sinr(wlansAux, NOISE_DBM);  % bps          
        % Update the reward of each WN
        rw = tptAfterAction./upperBoundThroughputPerWlan;         
        for wlan_ix_aux = 1 : nWlans
            if wlan_ix_aux == wlan_ix
                cumulative_reward(wlan_ix_aux) = cumulative_reward(wlan_ix_aux) + rw(wlan_ix_aux);
                rewardPerArm(wlan_ix_aux, selectedArm(wlan_ix_aux)) = cumulative_reward(wlan_ix_aux)/iterations_without_acting(wlan_ix_aux);
                iterations_without_acting(wlan_ix_aux) = 1;
                cumulative_reward(wlan_ix_aux) = 0; 
            end
            % Update transitions counter of static WNs
            if wlan_ix_aux ~= wlan_ix
                iterations_without_acting(wlan_ix_aux) = iterations_without_acting(wlan_ix_aux) + 1;
                transitionsCounter(wlan_ix_aux, selectedArm(wlan_ix_aux)) = ...
                    transitionsCounter(wlan_ix_aux, selectedArm(wlan_ix_aux)) + 1; 
%                 timesArmHasBeenPlayed(wlan_ix_aux, selectedArm(wlan_ix_aux)) = ...
%                     timesArmHasBeenPlayed(wlan_ix_aux, selectedArm(wlan_ix_aux)) + 1;
            end
        end           
        % Store the throughput at the end of the iteration for statistics
        tptExperiencedPerWlan(iteration - first_iteration + 1, :) = tptAfterAction;
        regretExperiencedPerWlan(iteration - first_iteration + 1, :) = (1 - rw);
        % Update the exploration coefficient according to the inputted mode
        if updateMode == UPDATE_MODE_FAST
            epsilon(wlan_ix) = initialEpsilon(wlan_ix) / iteration_per_wlan(wlan_ix);    
        elseif updateMode == UPDATE_MODE_SLOW
            epsilon(wlan_ix) = initialEpsilon(wlan_ix) / sqrt(iteration_per_wlan(wlan_ix));   
        else
            disp(['updateModeEpsilon = ' num2str(epsilon) ' does not exist!'])
        end        
        % Increase the number of iterations
        iteration_per_wlan(wlan_ix) = iteration_per_wlan(wlan_ix) + 1;
        iteration = iteration + 1; 
        
    end
            
    %% PRINT INFORMATION REGARDING ACTION SELECTION
    if printInfo    
        % Print the preferred action per wlan
        for i= 1 : nWlans      
            timesArmHasBeenPlayed(i, :)/totalIterations
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
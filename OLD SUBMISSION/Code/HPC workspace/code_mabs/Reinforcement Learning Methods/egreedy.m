%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exploiting Spatial Reuse in Wireless Networks through Decentralised MABs
% F. Wilhelmi, B. Bellalta, A. Jonsson, C. Cano, G. Neu, S. Barrachina
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% function [tptExperiencedByWlan, times_arm_has_been_played] = egreedy(wlan, totalIterations, ...
%     MAX_LEARNING_ITERATIONS, initial_epsilon, updateMode, channelActions, ccaActions, txPowerActions, NOISE_DBM, printInfo)

function [ tptExperiencedByWlan, timesArmHasBeenPlayed ] = egreedy( wlans, initialEpsilon, varargin )
% EGREEDY - Given a WN, applies e-greedy to maximize the experienced throughput
%
%   OUTPUT: 
%       * tptExperiencedByWlan - throughput experienced by each WLAN
%         for each of the iterations done
%       * timesArmHasBeenPlayed - times each action has been played
%   INPUT: 
%       * wlan - wlan object containing information about all the WLANs
%       * initialEpsilon - initial exploration coefficient

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

%     % If theree are optional arguments, update information from 'constants'
%     if varagin > 3
%         % Update possible actions
%         nChannels = newNChannels;
%         channelActions = 1 : nChannels;
%         ccaActions = newCcaActions;
%         txPowerActions = newTxPowerActions;
%         % Each state represents an [i,j,k] combination for indexes on "channels", "cca" and "tx_power"
%         possibleActions = 1:(size(channelActions, 2) * ...
%             size(ccaActions, 2) * size(txPowerActions, 2));
%         K = size(possibleActions,2);   % Total number of actions
%         allCombs = allcomb(1:K, 1:K);
%         % Structured array with all the combinations (for computing the optimal)
%         possibleComb = allcomb(possibleActions,...
%             possibleActions,possibleActions,possibleActions);
%     end
    
    % Find the index of the initial action taken by each WLAN
    initialActionIxPerWlan = zeros(1, nWlans);
    for i= 1 : nWlans
        [~,indexCca] = find(ccaActions == wlansAux(i).CCA);
        [~,indexTpc] = find(txPowerActions == wlansAux(i).TxPower);
        initialActionIxPerWlan(i) = indexes2val(wlansAux(i).Channel, ...
            indexCca, indexTpc, size(channelActions,2), size(ccaActions,2));
    end
    % Initialize the indexes of the taken action
    actionIndexPerWlan = initialActionIxPerWlan;                           
    
    % Compute the maximum achievable throughput per WLAN
    powerMatrix = PowerMatrix(wlansAux);     
    upperBoundThroughputPerWlan = compute_max_bound_throughput(wlansAux, ...
        powerMatrix, NOISE_DBM, max(txPowerActions));
    
    % Initialize arm selection for each WLAN by using the initial action
    selectedArm = actionIndexPerWlan;             
    % Keep track of current and previous actions for getting the transitions probabilities
    currentAction = zeros(1, nWlans);
    previousAction = selectedArm;
    % Store the times a transition between actions is done in each WN
    transitionsCounter = zeros(nWlans, K^2);    
    % Store the times an action has been played in each WN
    timesArmHasBeenPlayed = zeros(nWlans, K);     
    % Initialize the mean reward obtained by each WLAN for each arm
    rewardPerArm = zeros(nWlans, K); 
    
    % Initialize epsilon
    epsilon = initialEpsilon; 
   
    %% ITERATE UNTIL CONVERGENCE OR MAXIMUM CONVERGENCE TIME            
  
    iteration = 1;

    while(iteration < totalIterations+1) 

        % Assign turns to WLANs randomly 
        order = randperm(nWlans);  
        % Iterate sequentially for each agent in the random order   
        for i = 1 : nWlans          
            % Select an action according to the policy
            selectedArm(order(i)) = select_action_egreedy(rewardPerArm(order(i),:), epsilon);    
            % Update the current action
            currentAction(order(i)) = selectedArm(order(i));
            % Find the index of the current and the previous action in allCombs
            ix = find(allCombs(:,1) == previousAction(order(i))...
                & allCombs(:,2) == currentAction(order(i)));
            % Update the previous action
            previousAction(order(i)) = currentAction(order(i));  
            % Update the transitions counter
            transitionsCounter(order(i), ix) = transitionsCounter(order(i), ix) + 1;  
            % Update the times WN has selected the current action
            timesArmHasBeenPlayed(order(i), selectedArm(order(i))) = ...
                timesArmHasBeenPlayed(order(i), selectedArm(order(i))) + 1;
            % Find channel and tx power of the current action
            [a, ~, c] = val2indexes(selectedArm(order(i)), ...
                size(channelActions,2), size(ccaActions,2), size(txPowerActions,2));
            % Update WN configuration
            wlansAux(order(i)).Channel = a;   
            %wlan_aux(order(i)).CCA = ccaActions(b);
            wlansAux(order(i)).TxPower = txPowerActions(c); 
            % Compute the throughput noticed after applying the action
            powerMatrix = PowerMatrix(wlansAux);
            tptAfterAction = compute_throughput_from_sinr(wlansAux, powerMatrix, NOISE_DBM);  % bps          
            
            % Update the reward of each WN
            for wlan_i = 1 : nWlans
                rw = tptAfterAction(wlan_i) / upperBoundThroughputPerWlan(wlan_i);
                rewardPerArm(wlan_i, selectedArm(wlan_i)) = rw;
            end   
            
        end
        
        % Store the throughput at the end of the iteration for statistics
        tptExperiencedByWlan(iteration,:) = tptAfterAction;  % bps
        
        % Update the exploration coefficient according to the inputted mode
        if updateMode == UPDATE_MODE_FAST
            epsilon = initialEpsilon / iteration;    
        elseif updateMode == UPDATE_MODE_SLOW
            epsilon = initialEpsilon / sqrt(iteration);   
        else
            disp(['updateModeEpsilon = ' num2str(updateModeEpsilon) ' does not exist!'])
        end
        
        % Increase the number of iterations
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
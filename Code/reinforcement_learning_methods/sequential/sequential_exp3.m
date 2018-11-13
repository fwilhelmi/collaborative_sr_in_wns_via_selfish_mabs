%%% ************************************************************************
%%% * Collaborative Spatial Reuse in Wireless Networks via Selfish MABs    *
%%% * Author: Francesc Wilhelmi (francesc.wilhelmi@upf.edu)                *
%%% * Co-authors: C. Cano, G. Neu, B. Bellalta, A. Jonsson & S. Barrachina *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi          *
%%% * GitHub repository:                                                   *
%%% *   https://github.com/wn-upf/Collaborative_SR_in_WNs_via_Selfish_MABs *
%%% * More info on https://www.upf.edu/en/web/fwilhelmi                    *
%%% ************************************************************************

function [tptExperiencedPerWlan, timesArmHasBeenPlayed, regretExperiencedPerWlan] = ...
    sequential_exp3(wlans, gamma, initialEta, upperBoundThroughputPerWlan, varargin)
% exp3 applies EXP3 (basic formulation) to maximize the experienced
% throughput of a given scenario
%
%   OUTPUT: 
%       * tptExperiencedByWlan - throughput experienced by each WLAN
%         for each of the iterations done
%       * timesArmHasBeenPlayed - times each action has been played
%   INPUT: 
%       * wlan - wlan object containing information about all the WLANs
%       * gamma - weigths regulator EXP3
%       * eta - learning rate EXP3

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
        [~,indexCca] = find(ccaActions==wlansAux(i).CCA);
        [~,indexTpc] = find(txPowerActions==wlansAux(i).TxPower);
        initialActionIxPerWlan(i) = indexes2val(wlansAux(i).Channel, ...
            indexCca, indexTpc, size(channelActions,2), size(ccaActions,2));
    end
    % Initialize the indexes of the taken action
    actionIndexPerWlan = initialActionIxPerWlan;                              
    selectedArm = actionIndexPerWlan;           % Initialize arm selection for each WLAN by using the initial action
    weightsPerArm = ones(nWlans, K);            % Initialize weight to 1 for each action
    previousAction = selectedArm;               % Initialize the previous action as the initial one
    timesArmHasBeenPlayed = zeros(nWlans, K);   % Initialize the number each arm has been played
    transitionsCounter = zeros(nWlans, K^2);    % Initialize the transitions counter   
    armsProbabilities = (1/K)*ones(nWlans, K);  % Initialize arms probabilities
    estimated_reward = zeros(1, nWlans);        % Initialize the estimated reward for each WN    
    regretAfterAction = zeros(1, nWlans);       % Initialize the regret experienced by each WLAN
    eta = initialEta * ones(1, nWlans);  % Initialize the learning rate
    previous_eta = eta;
    
    cumulative_reward = zeros(1, nWlans);
    iterations_without_acting = ones(1, nWlans);        
    iteration_per_wlan = zeros(1, nWlans);    
    
    %% ITERATE UNTIL CONVERGENCE OR MAXIMUM CONVERGENCE TIME
    iteration = 1;
    order = [];
    while(iteration < totalIterations + 1) 
        
        if isempty(order)
            order = randperm(nWlans);
        end        
        wlan_ix = order(1);
        order(1) = [];
        
        % Update arms probabilities according to weights      
        for k = 1 : K
            armsProbabilities(wlan_ix, k) = (1 - gamma) * ...
                (weightsPerArm(wlan_ix, k) / ...
                sum(weightsPerArm(wlan_ix, :))) + (gamma / K);                
            % To avoid errors in execution time
            if isnan(armsProbabilities(wlan_ix, k))
                armsProbabilities(wlan_ix, k) = 1/K;
            end
        end 
        % Draw an action according to probabilites distribution
        selectedArm(wlan_ix) = randsample(1:K, 1, true, armsProbabilities(wlan_ix,:));  
        % Find the index of the current and the previous action in allCombs
        ix = find(allCombs(:,1) == previousAction(wlan_ix) & allCombs(:,2) == selectedArm(wlan_ix));
        % Update the previous action
        previousAction(wlan_ix) = selectedArm(wlan_ix);      
        % Update the transitions counter
        transitionsCounter(wlan_ix, ix) = transitionsCounter(wlan_ix, ix) + 1;           
        % Find channel and tx power of the current action
        [a, ~, c] = val2indexes(selectedArm(wlan_ix), size(channelActions,2), size(ccaActions,2), size(txPowerActions,2));
        % Update WN configuration
        wlansAux(wlan_ix).Channel = a;   
        wlansAux(wlan_ix).TxPower = txPowerActions(c);  
        % Compute the reward with the throughput obtained in the round after applying the action
        tptAfterAction = compute_throughput_from_sinr(wlansAux, NOISE_DBM);  % bps    
        % Update the reward of each WN
        rw = tptAfterAction./upperBoundThroughputPerWlan;     
        cumulative_reward = cumulative_reward + rw;             
        % 
        % Update the times WN has selected the current action
        timesArmHasBeenPlayed(wlan_ix, selectedArm(wlan_ix)) = ...
            timesArmHasBeenPlayed(wlan_ix, selectedArm(wlan_ix)) + 1; 
        % Update estimated reward according to the past experience
        avg_reward = cumulative_reward(wlan_ix)/iterations_without_acting(wlan_ix);
        iterations_without_acting(wlan_ix) = 1;
        cumulative_reward(wlan_ix) = 0;  
        estimated_reward(wlan_ix) = (avg_reward / ...
            armsProbabilities(wlan_ix, selectedArm(wlan_ix)));
        % Update the weights of each action       
        for k = 1 : K
            if eta(wlan_ix) == 0 && previous_eta(wlan_ix) == 0
                weightsPerArm(wlan_ix, k) = weightsPerArm(wlan_ix, k)^0 * ...
                    exp((eta(wlan_ix) * estimated_reward(wlan_ix)));  
            else 
                if k == selectedArm(wlan_ix)
                    weightsPerArm(wlan_ix, k) = weightsPerArm(wlan_ix, k)^...
                        (eta(wlan_ix)/previous_eta(wlan_ix)) * ...
                        exp((eta(wlan_ix) * estimated_reward(wlan_ix)));
                    else
                        weightsPerArm(wlan_ix, k) = weightsPerArm(wlan_ix, k)^...
                            (eta(wlan_ix) / previous_eta(wlan_ix));
                end                
            end
            % Bound the weight assigned to each arm
            weightsPerArm(wlan_ix, k) = max( weightsPerArm(wlan_ix, k), 1e-6 );
        end   
        for wlan_ix_aux = 1 : nWlans
            if wlan_ix_aux ~= wlan_ix
                transitionsCounter(wlan_ix_aux, selectedArm(wlan_ix_aux)) = ...
                    transitionsCounter(wlan_ix_aux, selectedArm(wlan_ix_aux)) + 1;                                              
            end              
        end  
        % Store the throughput at the end of the iteration for statistics
        tptExperiencedPerWlan(iteration, :) = tptAfterAction;
        regretExperiencedPerWlan(iteration, :) = (1 - rw);  
        % Update the learning rate according to the "update mode"
        previous_eta(wlan_ix) = eta(wlan_ix);
        if updateMode == UPDATE_MODE_FAST
            eta(wlan_ix) = initialEta / iteration_per_wlan(wlan_ix);    
        elseif updateMode == UPDATE_MODE_SLOW
            eta(wlan_ix) = initialEta / sqrt(iteration_per_wlan(wlan_ix));   
        end     
        % Increase the number of iterations   
        iteration_per_wlan(wlan_ix) = iteration_per_wlan(wlan_ix) + 1;
        iteration = iteration + 1;   
    end
        
    %% PRINT INFORMATION REGARDING ACTION SELECTION
    if printInfo
        % Print the preferred action per wlan
        for i = 1 : nWlans      
            %timesArmHasBeenPlayed(i, :)/totalIterations
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
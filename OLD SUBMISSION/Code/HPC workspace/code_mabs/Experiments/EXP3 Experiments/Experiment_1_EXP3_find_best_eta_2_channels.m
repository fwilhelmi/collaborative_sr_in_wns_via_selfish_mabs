%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exploiting Spatial Reuse in Wireless Networks through Decentralised MABs
% F. Wilhelmi, B. Bellalta, A. Jonsson, C. Cano, G. Neu, S. Barrachina
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% EXPERIMENT EXPLANATION:
% By using a simple grid of 4 WLANs sharing 2 channels, we want to test several values of
% eta to evaluate the performance of EXP3 for each of them. We compare the obtained 
% results with the optimal configurations in terms of proportional fairness and aggregate
% throughput.

clc
clear all

% Add paths to methods folders
addpath(genpath('Power Management Methods/'));
addpath(genpath('Throughput Calculation Methods/'));
addpath(genpath('Network Generation Methods/'));
addpath(genpath('Reinforcement Learning Methods/'));
addpath(genpath('Reinforcement Learning Methods/Action Selection Methods/'));
addpath(genpath('Auxiliary Methods/'));

disp('-----------------------')
disp('EXP3: finding the best parameters')
disp('-----------------------')

constants

% Define EXP3 parameters
initialEta = 0 : .1 : 1;
gamma = 0;

% Setup the scenario: generate WLANs and initialize states and actions
wlans = generate_network_3D(nWlans, 'grid', 2, 0); % SAFE CONFIGURATION

% Initialize variables for storing the output
throughputEvolutionPerWlan = cell(1, totalRepetitions);
meanThroughputEvolutionPerWlan = cell(1, totalRepetitions);
fairnessEvolution = cell(1, totalRepetitions);
meanThroughputExperienced = cell(1, totalRepetitions);
aggregateThroughput = cell(1, totalRepetitions);

%% ITERATE FOR NUMBER OF REPETITIONS (TO TAKE THE AVERAGE)
for r = 1 : totalRepetitions
    disp('------------------------------------')
    disp(['ROUND ' num2str(r) '/' num2str(totalRepetitions) ...
        ' (' num2str(totalIterations) ' iterations)'])
    disp('------------------------------------')
    % Iterate for each gamma
    for g = 1 : size(gamma, 2)
        % Iterate for each eta
        for e = 1 : size(initialEta, 2)         
            [throughputEvolutionPerWlan{r}, actionsProbability] = exp3(wlans, gamma(g), initialEta(e));
            for iteration=1:totalIterations
                meanThroughputEvolutionPerWlan{r}(iteration) = mean(throughputEvolutionPerWlan{r}(iteration,:));
            end
            meanThroughputExperienced{r}(g, e) = ...
                mean(meanThroughputEvolutionPerWlan{r});            
            aggregateThroughput{r}(g, e) = ...
                mean(sum(throughputEvolutionPerWlan{r}, 2));        
        end        
    end
end

%% PLOT THE RESULTS

% Set font type
set(0,'defaultUicontrolFontName','Times New Roman');
set(0,'defaultUitableFontName','Times New Roman');
set(0,'defaultAxesFontName','Times New Roman');
set(0,'defaultTextFontName','Times New Roman');
set(0,'defaultUipanelFontName','Times New Roman');

% % Compute the optimal configuration to compare the approaches
% maximumAchievableThroughput = compute_throughput_all_combinations(wlans, ...
%     channelActions, ccaActions, txPowerActions, NOISE_DBM);
% % Find the best configuration for each WLAN and display it
% for i = 1 : size(maximumAchievableThroughput,1)
%     bestConfifgurationThroughput(i) = sum(maximumAchievableThroughput(i,:));
%     bestConfigurationFairness(i) = sum(log(maximumAchievableThroughput(i,:)));
% end    

% [optimalProportionalFairness, ix] = max(bestConfigurationFairness);
% disp('---------------')
% disp(['Best proportional fairness: ' num2str(optimalProportionalFairness)])
% disp(['Best configurations: ' num2str(possibleComb(ix, :))])
% for i = 1 : nWlans
%     [a, ~, c] = val2indexes(possibleComb(ix, i), nChannels, ...
%         size(ccaActions, 2), size(txPowerActions, 2));  
%     disp(['   * WLAN' num2str(i) ':'])
%     disp(['       - Channel:' num2str(a)])
%     disp(['       - TPC:' num2str(txPowerActions(c))])
% end
% 
% [optimalAggregateThroughput, ix2] = max(bestConfifgurationThroughput);
% disp('---------------')
% disp(['Best aggregate throughput: ' num2str(optimalAggregateThroughput) ' Mbps'])
% disp(['Best configurations: ' num2str(possibleComb(ix2, :))])
% for i = 1 : nWlans
%     [a, ~, c] = val2indexes(possibleComb(ix2, i), nChannels, ...
%         size(ccaActions, 2), size(txPowerActions, 2));  
%     disp(['   * WLAN' num2str(i) ':'])
%     disp(['       - Channel:' num2str(a)])
%     disp(['       - TPC:' num2str(txPowerActions(c))])
% end

% Compute the average results found and the standard deviation
auxArray = zeros(size(gamma, 2), size(initialEta, 2));
for g = 1 : size(gamma, 2)     
    for e = 1 : size(initialEta, 2)
        for i = 1 : totalRepetitions
            auxArray(g, e) = auxArray(g, e) + aggregateThroughput{i}(g, e);
        end
    end
end
meanAggregateThroughputPerEpsilon = auxArray / totalRepetitions;
disp('meanAggregateThroughputPerEpsilon')
disp(meanAggregateThroughputPerEpsilon)

auxArrayStd = zeros(size(gamma, 2), size(initialEta, 2));
for g = 1:size(gamma, 2)     
    for e = 1:size(initialEta, 2)
        for i = 1:totalRepetitions
            auxArrayStd(g, e) = auxArrayStd(g, e) + ((aggregateThroughput{i}(g, e) ...
                - meanAggregateThroughputPerEpsilon(g, e))^2);
        end
    end
end
stdAggregateThroughputPerEpsilon = sqrt(auxArrayStd / totalRepetitions);
disp('stdAggregateThroughputPerEpsilon')
disp(stdAggregateThroughputPerEpsilon)

% Plot the results with error
l = {};
figure('pos',[450 400 500 350])
axes;
axis([1 20 30 70]);
for g = 1:size(gamma, 2)   
    errorbar(initialEta, meanAggregateThroughputPerEpsilon(g, :), stdAggregateThroughputPerEpsilon(g, :), '-d');
    hold on
    l = [l ['\gamma = ' num2str(gamma(g))]];
end
grid on
plot(initialEta, agg_tpt_optimal_prop_fairness * ones(1, size(initialEta, 2)), '--r');
set(gca, 'FontSize', 22)
xlabel('\eta','FontSize', 24)
ylabel('Network Throughput (Mbps)','FontSize',24)
axis([min(initialEta) max(initialEta) 700 1.1 * agg_tpt_optimal_prop_fairness])
xticks(initialEta)
legend({'Mean agg. throughput', 'Optimal (max. prop. fairness)'})

save('./Output/exp3_exp1_workspace.mat')
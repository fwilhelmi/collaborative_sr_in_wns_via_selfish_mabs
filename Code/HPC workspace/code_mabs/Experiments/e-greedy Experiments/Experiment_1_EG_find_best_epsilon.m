%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exploiting Spatial Reuse in Wireless Networks through Decentralised MABs
% F. Wilhelmi, B. Bellalta, A. Jonsson, C. Cano, G. Neu, S. Barrachina
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% EXPERIMENT EXPLANATION:
% By using a simple grid of 4 WLANs sharing 2 channels, we want to test several values of
% gamma, alpha and initial epsilon to evaluate the performance of
% e-greedy for each of them. We compare the obtained results with the
% optimal configurations in terms of proportional fairness and aggregate
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
disp('e-greedy: finding the best parameters')
disp('-----------------------')

% Generate constants from 'constants.m'
constants

initialEpsilon = 0:.1:1;

policy = EG_POLICY;
  
% Initialize variables at which to store information per repetition
tptEvolutionPerWlanEgreedy = cell(1, totalRepetitions);
averageThroughputEvolution = cell(1, totalRepetitions);
meanThroughputExperienced = cell(1, totalRepetitions);
meanAggregateThroughput = cell(1, totalRepetitions);
proportionalFairness = cell(1, totalRepetitions);

%% ITERATE FOR NUMBER OF REPETITIONS (TO TAKE THE AVERAGE)
for r = 1 : totalRepetitions
    disp('------------------------------------')
    disp(['ROUND ' num2str(r) '/' num2str(totalRepetitions) ...
        ' (' num2str(totalIterations) ' iterations)'])
    disp('------------------------------------')   

    % Setup the scenario: generate WLANs and initialize states and actions
    wlans = generate_network_3D(nWlans, 'grid', 2, 0); % SAFE CONFIGURATION

    % Iterate for each initial epsilon
    for e = 1 : size(initialEpsilon, 2)        
        
        [tptEvolutionPerWlan, timesArmHasBeenPlayed] = egreedy( wlans, initialEpsilon(e) );

        tptEvolutionPerWlanEgreedy{r}  = tptEvolutionPerWlan;
        
        for iter = 1 : totalIterations
            averageThroughputEvolution{r}(iter) = mean(tptEvolutionPerWlanEgreedy{r}(iter,:));
        end

        meanThroughputExperienced{r}(e) = mean(averageThroughputEvolution{r});              
        meanAggregateThroughput{r}(e) = mean(sum(tptEvolutionPerWlanEgreedy{r}, 2));
        proportionalFairness{r}(e) = mean(sum(log(tptEvolutionPerWlanEgreedy{r}), 2));

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
% maximumAchievableThroughput = compute_throughput_all_combinations...
%     (wlans, channelActions, ccaActions, txPowerActions, NOISE_DBM);
% % Find the best configuration for each wlans and display it
% for i = 1:size(maximumAchievableThroughput, 1)
%     bestThroughputConfiguration(i) = sum(maximumAchievableThroughput(i, :));
%     bestFairnessConfiguration(i) = sum(log(maximumAchievableThroughput(i, :)));
% end    

for e = 1:size(initialEpsilon, 2)
    for i = 1:totalRepetitions
        auxArray(i,e) = meanAggregateThroughput{i}(e);
    end
end
meanAggregateThroughputPerEpsilon = mean(auxArray, 1);
stdAggregateThroughputPerEpsilon = std(auxArray, 1);

% Maximum value and index:
[maxVal,ix] = max(meanAggregateThroughputPerEpsilon(:));
disp(['Best epsilon = ' num2str(initialEpsilon(ix))]);

% Plot the aggregated throughput obtained for each epsilon
figure('pos', [450 400 500 350])
axes;
axis([1 20 30 70]);
errorbar(initialEpsilon, meanAggregateThroughputPerEpsilon, stdAggregateThroughputPerEpsilon, '-s')
hold on
xticks(initialEpsilon)
% Plot the optimal values
[optimal_prop_fairness, ix] = max(bestFairnessConfiguration);
[optimal_agg_tpt, ix2] = max(bestThroughputConfiguration);
plot(initialEpsilon, agg_tpt_optimal_prop_fairness * ones(1, size(initialEpsilon, 2)), '--', 'linewidth',2);
set(gca, 'FontSize', 22)
%l = {'\epsilon_{0}', 'Best Configuration'};
%legend(l)
ylabel('Network Throughput (Mbps)', 'FontSize', 24)
xlabel('\epsilon_{0}', 'FontSize', 24)
axis([min(initialEpsilon) max(initialEpsilon) 0 1.1 * agg_tpt_optimal_prop_fairness])
xticks(initialEpsilon)
legend({'Mean agg. throughput', 'Optimal (max. prop. fairness)'})

% Save the workspace
save('./Output/eg_exp1_workspace.mat')
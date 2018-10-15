%%% ************************************************************************
%%% * Collaborative Spatial Reuse in Wireless Networks via Selfish MABs    *
%%% * Author: Francesc Wilhelmi (francesc.wilhelmi@upf.edu)                *
%%% * Co-authors: C. Cano, G. Neu, B. Bellalta, A. Jonsson & S. Barrachina *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi          *
%%% * GitHub repository:                                                   *
%%% *   https://github.com/wn-upf/Collaborative_SR_in_WNs_via_Selfish_MABs *
%%% * More info on https://www.upf.edu/en/web/fwilhelmi                    *
%%% ************************************************************************

%%% EXPERIMENT EXPLANATION:
%%% By using a simple grid of 4 WLANs sharing 2 channels, we want to test 
%%% several values of the initial exploration coefficient (epsilon) to 
%%% evaluate the performance of e-greedy for each of them. We compare the 
%%% obtained results with the optimal configurations in terms of proportional 
%%% fairness.

%%% This Script generates the output shown in the article:
%%% - Section 5.1.2 Performance of the e-greedy policy
%%% - Figure 2

clc
clear all

% Add paths to methods folders
addpath(genpath('framework_throughput_calculation/power_management_methods/'));
addpath(genpath('framework_throughput_calculation/throughput_calculation_methods/'));
addpath(genpath('framework_throughput_calculation/network_generation_methods/'));
addpath(genpath('framework_throughput_calculation/auxiliary_methods/'));
addpath(genpath('reinforcement_learning_methods/'));
addpath(genpath('reinforcement_learning_methods/action_selection_methods/'));

disp('-----------------------')
disp('e-greedy: finding the best parameters')
disp('-----------------------')

% Generate constants from 'constants.m'
constants

% Setup the scenario: generate WLANs and initialize states and actions
wlans = generate_network_3D(nWlans, 'grid', 2, 0); % SAFE CONFIGURATION

% Compute the maximum achievable throughput per WLAN
upperBoundThroughputPerWlan = compute_max_selfish_throughput( wlans );

load('workspace_throughput_all_combinations_toy_scenario.mat')
% JFI
[max_f, ix_max_f] = max(jains_fairness(throughputPerConfiguration));
% Proportional fairness
[max_pf, ix_max_pf] = max(sum(log(throughputPerConfiguration)'));
agg_tpt_max_pf = sum(throughputPerConfiguration(ix_max_pf,:));
% Aggregate throughput
[max_agg, ix_max_agg] = max(sum(throughputPerConfiguration'));
% Max-min throughput
[max_max_min, ix_max_min] = max(min(throughputPerConfiguration'));

totalRepetitions = 100;
initialEpsilon = 0:.1:1;

% Initialize variables at which to store information per repetition
tptEvolutionPerWlanEgreedy = cell(1, totalRepetitions);
averageThroughputEvolution = cell(1, totalRepetitions);
meanThroughputExperienced = cell(1, totalRepetitions);
meanAggregateThroughput = cell(1, totalRepetitions);
proportionalFairness = cell(1, totalRepetitions);
maxMinThroughput = cell(1, totalRepetitions);

%% ITERATE FOR NUMBER OF REPETITIONS (TO TAKE THE AVERAGE)
for r = 1 : totalRepetitions
    
    totalIterations
    
    disp('------------------------------------')
    disp(['ROUND ' num2str(r) '/' num2str(totalRepetitions) ...
        ' (' num2str(totalIterations) ' iterations)'])
    disp('------------------------------------')   

    % Iterate for each initial epsilon
    for e = 1 : size(initialEpsilon, 2)        
        
        disp(['    - \epsilon_0 = ' num2str(initialEpsilon(e))])
    
        [tptEvolutionPerWlan, timesArmHasBeenPlayed] = egreedy( wlans, initialEpsilon(e), upperBoundThroughputPerWlan );

        tptEvolutionPerWlanEgreedy{r}  = tptEvolutionPerWlan;
        
        for iter = 1 : totalIterations
            averageThroughputEvolution{r}(iter) = mean(tptEvolutionPerWlanEgreedy{r}(iter,:));
        end

        meanThroughputExperiencedEgreedy{r}(e) = mean(averageThroughputEvolution{r});    
        stdThroughputExperiencedEgreedy{r}(e) = std(averageThroughputEvolution{r}); 
        meanAggregateThroughputEgreedy{r}(e) = mean(sum(tptEvolutionPerWlanEgreedy{r}, 2));
        stdAggregateThroughputEgreedy{r}(e) = std(sum(tptEvolutionPerWlanEgreedy{r}, 2));
        meanProportionalFairnessEgreedy{r}(e) = mean(sum(log(tptEvolutionPerWlanEgreedy{r}), 2));
        stdProportionalFairnessEgreedy{r}(e) = std(sum(log(tptEvolutionPerWlanEgreedy{r}), 2));
        meanMaxMinThroughputEgreedy{r}(e) = mean(min(tptEvolutionPerWlanEgreedy{r}'));
        stdMaxMinThroughputEgreedy{r}(e) = std(min(tptEvolutionPerWlanEgreedy{r}'));

    end
    
end

% Save the workspace
save('./Output/eg_exp1_workspace.mat')
save('meanThroughputExperiencedEgreedy', 'meanThroughputExperiencedEgreedy')
save('meanAggregateThroughputEgreedy', 'meanAggregateThroughputEgreedy')
save('meanMaxMinThroughputEgreedy', 'meanMaxMinThroughputEgreedy')
save('stdThroughputExperiencedEgreedy', 'stdThroughputExperiencedEgreedy')
save('stdAggregateThroughputEgreedy', 'stdAggregateThroughputEgreedy')
save('stdMaxMinThroughputEgreedy', 'stdMaxMinThroughputEgreedy')

%% PLOT THE RESULTS

% Set font type
set(0,'defaultUicontrolFontName','Times New Roman');
set(0,'defaultUitableFontName','Times New Roman');
set(0,'defaultAxesFontName','Times New Roman');
set(0,'defaultTextFontName','Times New Roman');
set(0,'defaultUipanelFontName','Times New Roman');

for e = 1:size(initialEpsilon, 2)
    for i = 1:totalRepetitions
        auxArray(i,e) = meanAggregateThroughputEgreedy{i}(e);
    end
end
meanAggregateThroughputPerEpsilon = mean(auxArray, 1);
stdAggregateThroughputPerEpsilon = std(auxArray, 1);
% Plot the aggregated throughput obtained for each epsilon
figure('pos', [450 400 500 350])
axes;
axis([1 20 30 70]);
errorbar(initialEpsilon, meanAggregateThroughputPerEpsilon, stdAggregateThroughputPerEpsilon, '-s')
hold on
xticks(initialEpsilon)
% Plot the optimal agg_tpt_max_pf
plot(initialEpsilon, agg_tpt_max_pf * ones(1, size(initialEpsilon, 2)), '--', 'linewidth',2);
set(gca, 'FontSize', 22)
%l = {'\epsilon_{0}', 'Best Configuration'};
%legend(l)
ylabel('Network Throughput (Mbps)', 'FontSize', 24)
xlabel('\epsilon_{0}', 'FontSize', 24)
axis([min(initialEpsilon) max(initialEpsilon) 350 1.1 * agg_tpt_max_pf])
xticks(initialEpsilon)
legend({'Mean agg. throughput', 'Optimal (max. prop. fairness)'})
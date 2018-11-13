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
%%% several values of the initial learning rate (eta) to evaluate the
%%% performance of e-greedy for each of them. We compare the obtained
%%% results with the optimal configurations in terms of proportional fairness.

%%% This Script generates the data to be displayed in Section 5.1.1 in the Article

clc
clear all

% Add paths to methods folders
addpath(genpath('framework_throughput_calculation/power_management_methods/'));
addpath(genpath('framework_throughput_calculation/throughput_calculation_methods/'));
addpath(genpath('framework_throughput_calculation/network_generation_methods/'));
addpath(genpath('framework_throughput_calculation/auxiliary_methods/'));
addpath(genpath('reinforcement_learning_methods/'));
addpath(genpath('reinforcement_learning_methods/action_selection_methods/'));

disp('************************************************************************')
disp('* Collaborative Spatial Reuse in Wireless Networks via Selfish MABs    *')
disp('* Author: Francesc Wilhelmi (francesc.wilhelmi@upf.edu)                *')
disp('* Co-authors: C. Cano, G. Neu, B. Bellalta, A. Jonsson & S. Barrachina *')
disp('* Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi          *')
disp('* GitHub repository:                                                   *')
disp('*   https://github.com/wn-upf/Collaborative_SR_in_WNs_via_Selfish_MABs *')
disp('* More info on https://www.upf.edu/en/web/fwilhelmi                    *')
disp('************************************************************************')

disp('-----------------------')
disp('SIM 1_1_2: EXP3 (toy scenario) finding the best parameters')
disp('-----------------------')

constants

% Define EXP3 parameters
initialEta = 0 : .1 : 1;
gamma = 0;

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

% Initialize variables for storing the output
throughputEvolutionPerWlan = cell(1, totalScenarios);
meanThroughputEvolutionPerWlan = cell(1, totalScenarios);
fairnessEvolution = cell(1, totalScenarios);
meanThroughputExperienced = cell(1, totalScenarios);
aggregateThroughput = cell(1, totalScenarios);

%% ITERATE FOR NUMBER OF REPETITIONS (TO TAKE THE AVERAGE)
for r = 1 : totalScenarios
    disp('------------------------------------')
    disp(['ROUND ' num2str(r) '/' num2str(totalScenarios) ...
        ' (' num2str(totalIterations) ' iterations)'])
    disp('------------------------------------')
    % Iterate for each gamma
    for g = 1 : size(gamma, 2)
        % Iterate for each eta
        for e = 1 : size(initialEta, 2)         
            [throughputEvolutionPerWlan{r}, actionsProbability] = concurrent_exp3(wlans, gamma(g), initialEta(e), upperBoundThroughputPerWlan);
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

% Compute the average results found and the standard deviation
auxArray = zeros(size(gamma, 2), size(initialEta, 2));
for g = 1 : size(gamma, 2)     
    for e = 1 : size(initialEta, 2)
        for i = 1 : totalScenarios
            auxArray(g, e) = auxArray(g, e) + aggregateThroughput{i}(g, e);
        end
    end
end
meanAggregateThroughputPerEta = auxArray / totalScenarios;

auxArrayStd = zeros(size(gamma, 2), size(initialEta, 2));
for g = 1:size(gamma, 2)     
    for e = 1:size(initialEta, 2)
        for i = 1:totalScenarios
            auxArrayStd(g, e) = auxArrayStd(g, e) + ((aggregateThroughput{i}(g, e) ...
                - meanAggregateThroughputPerEta(g, e))^2);
        end
    end
end
stdAggregateThroughputPerEta = sqrt(auxArrayStd / totalScenarios);

% Plot the results with error
l = {};
figure('pos',[450 400 500 350])
axes;
axis([1 20 30 70]);
for g = 1:size(gamma, 2)   
    errorbar(initialEta, meanAggregateThroughputPerEta(g, :), stdAggregateThroughputPerEta(g, :), '-d');
    hold on
    l = [l ['\gamma = ' num2str(gamma(g))]];
end
grid on
plot(initialEta, agg_tpt_max_pf * ones(1, size(initialEta, 2)), '--r');
set(gca, 'FontSize', 22)
xlabel('\eta_{0}','FontSize', 24)
ylabel('Network Throughput (Mbps)','FontSize',24)
axis([min(initialEta) max(initialEta) 0 1.1 * agg_tpt_max_pf])
xticks(initialEta)
legend({'Mean agg. throughput', 'Optimal (max. prop. fairness)'})

% Save the workspace
save('simulation_1_1_2_workspace.mat')
%%% ************************************************************************
%%% * Collaborative Spatial Reuse in Wireless Networks via Selfish MABs    *
%%% * Author: Francesc Wilhelmi (francesc.wilhelmi@upf.edu)                *
%%% * Co-authors: C. Cano, G. Neu, B. Bellalta, A. Jonsson & S. Barrachina *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi          *
%%% * GitHub repository:                                                   *
%%% *   https://github.com/wn-upf/Collaborative_SR_in_WNs_via_Selfish_MABs *
%%% * More info on https://www.upf.edu/en/web/fwilhelmi                    *
%%% ************************************************************************

% FILE DESCRIPTION:
% Script to plot the results of experiment 1.1 (Tuning parameters)
% This script plots article's Figure 3

clc
clear all

disp('************************************************************************')
disp('* Collaborative Spatial Reuse in Wireless Networks via Selfish MABs    *')
disp('* Author: Francesc Wilhelmi (francesc.wilhelmi@upf.edu)                *')
disp('* Co-authors: C. Cano, G. Neu, B. Bellalta, A. Jonsson & S. Barrachina *')
disp('* Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi          *')
disp('* GitHub repository:                                                   *')
disp('*   https://github.com/wn-upf/Collaborative_SR_in_WNs_via_Selfish_MABs *')
disp('* More info on https://www.upf.edu/en/web/fwilhelmi                    *')
disp('************************************************************************')

disp('--------------------------------------------')
disp('PLOT RESULTS OF PART 1_1: TUNING PARAMETERS)')
disp('--------------------------------------------')

constants

% Set font type
set(0,'defaultUicontrolFontName','Times New Roman');
set(0,'defaultUitableFontName','Times New Roman');
set(0,'defaultAxesFontName','Times New Roman');
set(0,'defaultTextFontName','Times New Roman');
set(0,'defaultUipanelFontName','Times New Roman');

% Load results from experiments in 5.1.1
load('simulation_1_1_1_workspace.mat')
load('simulation_1_1_2_workspace.mat')

initialEpsilon = 0 : .1 : 1;
initialEta = 0 : .1 : 1;

% Compute the average results found 
auxArray = zeros(1, size(initialEpsilon, 2));
auxArray2 = zeros(1, size(initialEpsilon, 2));

totalRepetitions = 100;

% Generate data structures to kindly perform calculations
aggregate_throughput_epsilon = zeros(size(initialEpsilon, 2), totalRepetitions);
average_throughput_epsilon = zeros(size(initialEpsilon, 2), totalRepetitions);
aggregate_throughput_eta = zeros(size(initialEta, 2), totalRepetitions);
average_throughput_eta = zeros(size(initialEta, 2), totalRepetitions);

for e = 1 : size(initialEpsilon, 2)
    for r = 1 : totalRepetitions
        % e-greedy
        aggregate_throughput_epsilon(e,r) = meanAggregateThroughputEgreedy{r}(e);
        average_throughput_epsilon(e,r) = meanThroughputExperiencedEgreedy{r}(e);
        % EXP3
        aggregate_throughput_eta(e,r) = meanThroughputExperienced{r}(e);
        average_throughput_eta(e,r) = aggregateThroughput{r}(e);
    end
end

% Calculate the average values to be plotted
for e = 1 : size(initialEpsilon, 2)
    % e-greedy
    meanAggregateThroughputPerEpsilon(e) = mean(aggregate_throughput_epsilon(e,:));
    stdAggregateThroughputPerEpsilon(e) = std(aggregate_throughput_epsilon(e,:));
    meanAverageThroughputPerEpsilon(e) = mean(average_throughput_epsilon(e,:));
    stdAverageThroughputPerEpsilon(e) = std(average_throughput_epsilon(e,:)); 
    % EXP3
    meanAggregateThroughputPerEta(e) = mean(aggregate_throughput_eta(e,:));
    stdAggregateThroughputPerEta(e) = std(aggregate_throughput_eta(e,:));
    meanAverageThroughputPerEta(e) = mean(average_throughput_eta(e,:));
    stdAverageThroughputPerEta(e) = std(average_throughput_eta(e,:));  
end

% Plot the results with error
l = {};
figure('pos',[450 400 500 350])
axes;
axis([1 20 30 70]);
errorbar(initialEpsilon, meanAggregateThroughputPerEpsilon, stdAggregateThroughputPerEpsilon, 'b-s');
hold on
errorbar(initialEta, meanAggregateThroughputPerEta, stdAggregateThroughputPerEta, 'y-d');
grid on
plot(initialEpsilon, agg_tpt_optimal_prop_fairness * ones(1, size(initialEpsilon, 2)), '--r');
set(gca, 'FontSize', 22)
xlabel('\epsilon_{0}','FontSize', 24)
ylabel('Network Throughput (Mbps)','FontSize',24)
axis([min(initialEpsilon) max(initialEpsilon) 700 1.1 * agg_tpt_optimal_prop_fairness])
xticks(initialEpsilon)
legend({'Mean agg. throughput', 'Optimal (max. prop. fairness)'})

% Plot the results with error
l = {};
figure('pos',[450 400 500 350])
axes;
axis([1 20 30 70]);
errorbar(initialEpsilon, meanAverageThroughputPerEpsilon, stdAverageThroughputPerEpsilon, 'b-s');
hold on
errorbar(initialEta, meanAverageThroughputPerEta, stdAverageThroughputPerEta, 'y-d');
grid on
plot(initialEpsilon, optimal_max_min * ones(1, size(initialEpsilon, 2)), '--r');
set(gca, 'FontSize', 22)
xlabel('\epsilon_{0}','FontSize', 24)
ylabel('Network Throughput (Mbps)','FontSize',24)
axis([min(initialEpsilon) max(initialEpsilon) 0 1.1 * optimal_max_min])
xticks(initialEpsilon)
legend({'Mean agg. throughput', 'Optimal (max. prop. fairness)'})
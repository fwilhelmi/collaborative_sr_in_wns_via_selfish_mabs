% FILE DESCRIPTION:
% Script to plot the results of experiment 2.3 (Adversarial Issues in WLANs)
% This script plots article's figures 11b and 11c 

clc
clear all

disp('***********************************************************************')
disp('*         Potential and Pitfalls of Multi-Armed Bandits for           *')
disp('*               Decentralized Spatial Reuse in WLANs                  *')
disp('*                                                                     *')
disp('* Submission to Journal on Network and Computer Applications          *')
disp('* Authors:                                                            *')
disp('*   - Francesc Wilhelmi (francisco.wilhelmi@upf.edu)                  *')
disp('*   - Sergio Barrachina-Muñoz  (sergio.barrachina@upf.edu)            *')
disp('*   - Boris Bellalta (boris.bellalta@upf.edu)                         *')
disp('*   - Cristina Cano (ccanobs@uoc.edu)                                 *')
disp('*   - Anders Jonsson (anders.jonsson@upf.edu)                         *')
disp('*   - Gergely Neu (gergely.neu@upf.edu)                               *')
disp('* Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi         *')
disp('* Repository:                                                         *')
disp('*  https://github.com/fwilhelmi/potential_pitfalls_mabs_spatial_reuse *')
disp('***********************************************************************')

disp('----------------------------------------------')
disp('PLOT RESULTS OF EXPERIMENT 1.0')
disp('----------------------------------------------')

constants

% Set font type
set(0,'defaultUicontrolFontName','Times New Roman');
set(0,'defaultUitableFontName','Times New Roman');
set(0,'defaultAxesFontName','Times New Roman');
set(0,'defaultTextFontName','Times New Roman');
set(0,'defaultUipanelFontName','Times New Roman');

% Load results from experiments in 2
load('meanAggregateThroughputEgreedy.mat');
load('meanThroughputExperiencedEgreedy.mat');

initialEpsilon = 0 : .1 : 1;
% Compute the average results found 
auxArray = zeros(1, size(initialEpsilon, 2));
auxArray2 = zeros(1, size(initialEpsilon, 2));

totalRepetitions = 100;

% Generate data structures to kindly perform calculations
aggregate_throughput = zeros(size(initialEpsilon, 2), totalRepetitions);
average_throughput = zeros(size(initialEpsilon, 2), totalRepetitions);
for e = 1 : size(initialEpsilon, 2)
    for r = 1 : totalRepetitions
        aggregate_throughput(e,r) = meanAggregateThroughputEgreedy{r}(e);
        average_throughput(e,r) = meanThroughputExperiencedEgreedy{r}(e);
    end
end

% Calculate the average values to be plotted
for e = 1 : size(initialEpsilon, 2)
    meanAggregateThroughputPerEpsilon(e) = mean(aggregate_throughput(e,:));
    stdAggregateThroughputPerEpsilon(e) = std(aggregate_throughput(e,:));
    meanAverageThroughputPerEpsilon(e) = mean(average_throughput(e,:));
    stdAverageThroughputPerEpsilon(e) = std(average_throughput(e,:));      
end

% Plot the results with error
l = {};
figure('pos',[450 400 500 350])
axes;
axis([1 20 30 70]);
errorbar(initialEpsilon, meanAggregateThroughputPerEpsilon, stdAggregateThroughputPerEpsilon, '-d');
hold on
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
errorbar(initialEpsilon, meanAverageThroughputPerEpsilon, stdAverageThroughputPerEpsilon, '-d');
hold on
grid on
plot(initialEpsilon, optimal_max_min * ones(1, size(initialEpsilon, 2)), '--r');
set(gca, 'FontSize', 22)
xlabel('\epsilon_{0}','FontSize', 24)
ylabel('Network Throughput (Mbps)','FontSize',24)
axis([min(initialEpsilon) max(initialEpsilon) 0 1.1 * optimal_max_min])
xticks(initialEpsilon)
legend({'Mean agg. throughput', 'Optimal (max. prop. fairness)'})
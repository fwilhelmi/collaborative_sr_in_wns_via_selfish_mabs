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
disp('PLOT RESULTS OF EXPERIMENT 2.0')
disp('----------------------------------------------')

constants

% Set font type
set(0,'defaultUicontrolFontName','Times New Roman');
set(0,'defaultUitableFontName','Times New Roman');
set(0,'defaultAxesFontName','Times New Roman');
set(0,'defaultTextFontName','Times New Roman');
set(0,'defaultUipanelFontName','Times New Roman');

% Load results from experiments in 2
load('aggregateThroughputEXP3.mat');
load('meanThroughputExperiencedEXP3.mat');

initialEta = 0 : .1 : 1;
gamma = 0;

% Compute the average results found 
auxArray = zeros(size(gamma, 2), size(initialEta, 2));
auxArray2 = zeros(size(gamma, 2), size(initialEta, 2));

totalRepetitions = 100;

% Generate data structures to kindly perform calculations
aggregate_throughput = zeros(size(gamma, 2), size(initialEta, 2), totalRepetitions);
average_throughput = zeros(size(gamma, 2), size(initialEta, 2), totalRepetitions);
for g = 1 : size(gamma, 2)     
    for e = 1 : size(initialEta, 2)
        for r = 1 : totalRepetitions
            aggregate_throughput(g,e,r) = aggregateThroughputEXP3{r}(g, e);
            average_throughput(g,e,r) = meanThroughputExperiencedEXP3{r}(g, e);
        end
    end
end

% Calculate the average values to be plotted
for g = 1 : size(gamma, 2)
    for e = 1 : size(initialEta, 2)
        meanAggregateThroughputPerEta(g, e) = mean(aggregate_throughput(g,e,:));
        stdAggregateThroughputPerEta(g, e) = std(aggregate_throughput(g,e,:));
        meanAverageThroughputPerEta(g, e) = mean(average_throughput(g,e,:));
        stdAverageThroughputPerEta(g, e) = std(average_throughput(g,e,:));      
    end
end

% Plot the results with error
l = {};
figure('pos',[450 400 500 350])
axes;
axis([1 20 30 70]);
for g = 1 : size(gamma, 2)   
    b2 = errorbar(initialEta, meanAggregateThroughputPerEta(g, :), stdAggregateThroughputPerEta(g, :), '-d');
    hold on
    l = [l ['\gamma = ' num2str(gamma(g))]];
end
grid on
plot(initialEta, agg_tpt_optimal_prop_fairness * ones(1, size(initialEta, 2)), '--r');
set(gca, 'FontSize', 22)
xlabel('\eta_{0}','FontSize', 24)
ylabel('Network Throughput (Mbps)','FontSize',24)
axis([min(initialEta) max(initialEta) 700 1.1 * agg_tpt_optimal_prop_fairness])
xticks(initialEta)
legend({'Mean agg. throughput', 'Optimal (max. prop. fairness)'})

for g = 1 : size(gamma, 2)   
    b2 = errorbar(initialEta, meanAggregateThroughputPerEta(g, :), stdAggregateThroughputPerEta(g, :), '-d');
    hold on
    l = [l ['\gamma = ' num2str(gamma(g))]];
end
h2 = plot(initialEta, agg_tpt_optimal_prop_fairness * ones(1, size(initialEta, 2)), '--r');
legend([b2,h2],{'eta_0', 'Optimal (prop. fairness)'})
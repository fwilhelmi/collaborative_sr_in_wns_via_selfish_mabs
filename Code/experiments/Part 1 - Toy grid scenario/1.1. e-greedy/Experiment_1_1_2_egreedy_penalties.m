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
%%% By using a simple grid of 4 WLANs sharing 2 channels, we show the
%%% individual performance of TS. We display i) the actions probabilities, 
%%% ii) the temporal aggregate throughput, iii) the temporal individual 
%%% throughput, iv) the average throughput.

%%% This Script generates the output shown in the article:
%%% - Section 5.1.5 Performance of the Thompson sampling policy
%%% - Figure 15
%%% - Figure 16
%%% - Figure 17

clc
clear all

disp('-----------------------')
disp('SIM 1_2: e-greedy with penalties')
disp('-----------------------')

% Generate constants from 'constants.m'
constants

initialEpsilon = 1;

alpha = 0:.1:1;

% Setup the scenario: generate WLANs and initialize states and actions
wlans = generate_network_3D(nWlans, 'grid', 2, drawMap); % SAFE CONFIGURATION

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

% Compute the throughput experienced per WLAN at each iteration
for i = 1 : size(alpha, 2)
    [tpt_evolution_per_wlan_peg{i}, times_arm_has_been_played_peg{i}, regret_per_wlan_peg{i}] = ...
        egreedy_with_penalty( wlans, initialEpsilon, upperBoundThroughputPerWlan, alpha(i) );
end

for i = 1 : size(alpha, 2)
   mean_tpt(i) = mean(mean(tpt_evolution_per_wlan_peg{i})); 
   std_tpt(i) = mean(std(tpt_evolution_per_wlan_peg{i})); 
end

figure('pos', [450 400 500 350])
axes;
axis([1 20 30 70]);
errorbar(alpha, mean_tpt, std_tpt, '-s')
hold on
xticks(alpha)
% Plot the optimal agg_tpt_max_pf
plot(alpha, agg_tpt_max_pf * ones(1, size(alpha, 2)), '--', 'linewidth',2);
set(gca, 'FontSize', 22)
%legend(l)
ylabel('Network Throughput (Mbps)', 'FontSize', 24)
xlabel('\alpha', 'FontSize', 24)
axis([min(alpha) max(alpha) 0 140])
legend({'Mean agg. throughput', 'Optimal (max. PF)'})

% Save the workspace
save('./Output/simulation_1_2_workspace.mat')
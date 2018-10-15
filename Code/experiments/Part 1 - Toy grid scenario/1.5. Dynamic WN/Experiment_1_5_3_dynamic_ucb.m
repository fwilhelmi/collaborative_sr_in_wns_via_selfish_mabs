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
%%% individual performance of UCB. We display i) the actions probabilities, 
%%% ii) the temporal aggregate throughput, iii) the temporal individual 
%%% throughput, iv) the average throughput.

%%% This Script generates the output shown in the article:
%%% - Section 5.1.4 Performance of the UCB policy
%%% - Figure 12
%%% - Figure 13
%%% - Figure 14

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
disp('SIM_1_3: UCB')
disp('-----------------------')

% Generate constants from 'constants.m'
constants

% Setup the scenario: generate WLANs and initialize states and actions
wlans = generate_network_3D(nWlans, 'grid', 2, 0); % SAFE CONFIGURATION

% Compute the maximum achievable throughput per WLAN
upperBoundThroughputPerWlan = compute_max_selfish_throughput( wlans );

load('workspace_throughput_all_combinations.mat')
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
[tpt_evolution_per_wlan_ucb, times_arm_has_been_played_ucb, regret_per_wlan_ucb] = ...
    ucb(wlans, upperBoundThroughputPerWlan);
% [tpt_evolution_per_wlan_oucb, times_arm_has_been_played_oucb, regret_per_wlan_oucb] = ...
%     ordered_ucb(wlans, upperBoundThroughputPerWlan);
[tpt_evolution_per_wlan_cucb, times_arm_has_been_played_cucb, regret_per_wlan_cucb] = ...
    ordered_ucb_cumulative(wlans, upperBoundThroughputPerWlan);

% Plot the results
if plotResults
    display_results_individual_performance(wlans, tpt_evolution_per_wlan_ucb, ...
        times_arm_has_been_played_ucb, max_max_min, agg_tpt_max_pf, 'UCB');
%     display_results_individual_performance(wlans, tpt_evolution_per_wlan_oucb, ...
%         times_arm_has_been_played_oucb, upperBoundThroughputPerWlan, max_max_min, 'OUCB');
    display_results_individual_performance(wlans, tpt_evolution_per_wlan_cucb, ...
        times_arm_has_been_played_cucb, max_max_min, agg_tpt_max_pf, 'CUCB');
end

% Save the workspace
save('./Output/simulation_1_3_workspace.mat')
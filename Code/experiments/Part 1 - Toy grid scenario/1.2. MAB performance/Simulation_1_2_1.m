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
%%% By using a simple grid of 4 WLANs sharing n channels, we compute the
%%% performance achieved by applying e-greedy.

%%% This Script generates data to be displayed in Sections 5.1.2 and 5.1.3 in the article

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

disp('-----------------------')
disp('SIM 1_2_1: e-greedy (Toy scenario)')
disp('-----------------------')

% Generate constants from 'constants.m'
constants

initialEpsilon = 1;

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

% Compute the throughput experienced per WLAN at each iteration (concurrent)
[tpt_evolution_per_wlan_concurrent_eg, times_arm_has_been_played_concurrent_eg, ~ , ~] = ...
    concurrent_egreedy( wlans, initialEpsilon, upperBoundThroughputPerWlan );
% Compute the throughput experienced per WLAN at each iteration (sequential)
[tpt_evolution_per_wlan_sequential_eg, times_arm_has_been_played_sequential_eg, ~] = ...
    sequential_egreedy( wlans, initialEpsilon, upperBoundThroughputPerWlan );

% Plot the results
if plotResults
    display_results_individual_performance(wlans, tpt_evolution_per_wlan_concurrent_eg, ...
        times_arm_has_been_played_concurrent_eg, max_max_min, agg_tpt_max_pf, 'EG_concurrent');
    display_results_individual_performance(wlans, tpt_evolution_per_wlan_sequential_eg, ...
        times_arm_has_been_played_sequential_eg, upperBoundThroughputPerWlan, max_max_min, 'EG_sequential');
end

% Save the workspace
save('./Output/simulation_1_2_1_workspace.mat')
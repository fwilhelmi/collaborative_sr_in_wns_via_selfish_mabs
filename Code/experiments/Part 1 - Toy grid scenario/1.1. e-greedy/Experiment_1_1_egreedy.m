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
disp('SIM 1_1: e-greedy')
disp('-----------------------')

% Generate constants from 'constants.m'
constants

initialEpsilon = 1;

% Setup the scenario: generate WLANs and initialize states and actions
wlans = generate_network_3D(nWlans, 'grid', 2, drawMap); % SAFE CONFIGURATION

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
[tpt_evolution_per_wlan_eg, times_arm_has_been_played_eg, regret_per_wlan_eg , meanRewardPerAction] = ...
    egreedy( wlans, initialEpsilon, upperBoundThroughputPerWlan );
% [tpt_evolution_per_wlan_oeg, times_arm_has_been_played_oeg, regret_per_wlan_oeg] = ...
%     ordered_egreedy( wlans, initialEpsilon, upperBoundThroughputPerWlan );
[tpt_evolution_per_wlan_ceg, times_arm_has_been_played_ceg, regret_per_wlan_ceg] = ...
    ordered_egreedy_cumulative( wlans, initialEpsilon, upperBoundThroughputPerWlan );
% [tpt_evolution_per_wlan_peg, times_arm_has_been_played_peg, regret_per_wlan_peg] = ...
%     egreedy_with_penalty( wlans, initialEpsilon, upperBoundThroughputPerWlan, 0.1 );

% Plot the results
if plotResults
    display_results_individual_performance(wlans, tpt_evolution_per_wlan_eg, ...
        times_arm_has_been_played_eg, max_max_min, agg_tpt_max_pf, 'EG');
%     display_results_individual_performance(wlans, tpt_evolution_per_wlan_oeg, ...
%         times_arm_has_been_played_oeg, upperBoundThroughputPerWlan, max_max_min, 'OEG');
%     display_results_individual_performance(wlans, tpt_evolution_per_wlan_ceg, ...
%         times_arm_has_been_played_ceg, max_max_min, agg_tpt_max_pf, 'CEG');
%     display_results_individual_performance(wlans, tpt_evolution_per_wlan_peg, ...
%         times_arm_has_been_played_peg, upperBoundThroughputPerWlan, max_max_min, 'PEG');
end

% Save the workspace
save('./Output/simulation_1_1_workspace.mat')
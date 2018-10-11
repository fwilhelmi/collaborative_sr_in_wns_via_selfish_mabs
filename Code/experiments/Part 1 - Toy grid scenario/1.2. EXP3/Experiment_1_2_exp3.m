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
%%% individual performance of EXP3 for eta_0 = 1. We display i) the
%%% actions probabilities, ii) the temporal aggregate throughput, iii) the
%%% temporal individual throughput, iv) the average throughput.

%%% This Script generates the output shown in the article:
%%% - Section 5.1.3 Performance of the EXP3 policy
%%% - Figure 8
%%% - Figure 9
%%% - Figure 10
%%% - Figure 11

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
disp('Sim 1_2: EXP3')
disp('-----------------------')

constants

% Define EXP3 parameters
initialEta = 0.6;
gamma = 0;

% Setup the scenario: generate WLANs and initialize states and actions
wlans = generate_network_3D(nWlans, 'grid', 2, 0); % SAFE CONFIGURATION

% Compute the maximum achievable throughput per WLAN
powerMatrix = power_matrix(wlans);     
upperBoundThroughputPerWlan = compute_max_bound_throughput(wlans, ...
    powerMatrix, NOISE_DBM, max(txPowerActions));

load('workspace_throughput_all_combinations.mat')

% Compute the throughput experienced per WLAN at each iteration
[tpt_evolution_per_wlan_exp3, times_arm_has_been_played_exp3, regret_per_wlan_exp3]  = exp3(wlans, gamma, initialEta, upperBoundThroughputPerWlan);
%[tpt_evolution_per_wlan_oexp3, times_arm_has_been_played_oexp3, regret_per_wlan_oexp3]  = ordered_exp3(wlan, gamma, initialEta, upperBoundThroughputPerWlan);

% Plot the results
%if plotResults
    display_results_individual_performance(wlans, tpt_evolution_per_wlan_exp3, ...
        times_arm_has_been_played_exp3, upperBoundThroughputPerWlan, max_max_min, 'EXP3');
%    display_results_individual_performance(wlan, tpt_evolution_per_wlan_oexp3, ...
%        times_arm_has_been_played_oexp3, upperBoundThroughputPerWlan, max_max_min, 'OEXP3');
%end

% Save the workspace
save('./output/simulation_1_2_workspace.mat')
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
disp('UCB: Throughput Evolution')
disp('-----------------------')

% Generate constants from 'constants.m'
constants

% Setup the scenario: generate WLANs and initialize states and actions
wlans = generate_network_3D(nWlans, 'grid', 2, 0); % SAFE CONFIGURATION
    
policy = UCB_POLICY;
% Compute the throughput experienced per WLAN at each iteration
[tpt_evolution_per_wlan_ucb, times_arm_has_been_played_ts, regret_per_wlan_ucb] = ucb(wlans);

% Plot the results
if plotResults
    display_results_individual_performance(wlans, tpt_evolution_per_wlan_ucb, times_arm_has_been_played_ts, 'UCB');
end

% Save the workspace
save('./Output/simulation_3_workspace.mat')
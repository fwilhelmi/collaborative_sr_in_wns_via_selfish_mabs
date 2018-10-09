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

% Add paths to methods folders
addpath(genpath('framework_throughput_calculation/power_management_methods/'));
addpath(genpath('framework_throughput_calculation/throughput_calculation_methods/'));
addpath(genpath('framework_throughput_calculation/network_generation_methods/'));
addpath(genpath('framework_throughput_calculation/auxiliary_methods/'));
addpath(genpath('reinforcement_learning_methods/'));
addpath(genpath('reinforcement_learning_methods/action_selection_methods/'));

disp('-----------------------')
disp('SIM 1_1: e-greedy')
disp('-----------------------')

% Generate constants from 'constants.m'
constants

initialEpsilon = 1;
policy = EG_POLICY;

% Setup the scenario: generate WLANs and initialize states and actions
wlans = generate_network_3D(nWlans, 'grid', 2, drawMap); % SAFE CONFIGURATION
    
% Compute the throughput experienced per WLAN at each iteration
[tpt_evolution_per_wlan_eg, times_arm_has_been_played_eg, regret_per_wlan_eg] = egreedy( wlans, initialEpsilon );
[tpt_evolution_per_wlan_oeg, times_arm_has_been_played_oeg, regret_per_wlan_oeg] = ordered_egreedy( wlans, initialEpsilon );

% Plot the results
if plotResults
    display_results_individual_performance(wlans, tpt_evolution_per_wlan_eg, times_arm_has_been_played_eg, 'EG');
    display_results_individual_performance(wlans, tpt_evolution_per_wlan_oeg, times_arm_has_been_played_oeg, 'OEG');
end

% Save the workspace
save('./Output/simulation_1_1_workspace.mat')
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
disp('SIM_1_4: Thompson Sampling')
disp('-----------------------')

% Generate constants from 'constants.m'
constants

load('throughput_per_configuration_cochannel_interference_on.mat')
%load('throughput_per_configuration_cochannel_interference_off.mat')
% Find the best configuration for each WLAN and display it
for i = 1 : size(throughputPerConfiguration, 1)
    agg_tpt(i) = sum(throughputPerConfiguration(i,:));
    fairness(i) = jains_fairness(throughputPerConfiguration(i,:));
    prop_fairness(i) = sum(log(throughputPerConfiguration(i,:)));
    max_min(i) = min(throughputPerConfiguration(i,:));
end    

% Proportional fairness
[val, ix] = max(prop_fairness);
max_pf = agg_tpt(ix);    
% Aggregate throughput
[max_agg, ix2] = max(agg_tpt);
% Max-min throughput
[max_max_min, ix3] = max(max_min);

% Setup the scenario: generate WLANs and initialize states and actions
wlans = generate_network_3D(nWlans, 'grid', 2, 0); % SAFE CONFIGURATION

% Compute the maximum achievable throughput per WLAN
upperBoundThroughputPerWlan = compute_max_selfish_throughput( wlans );
    
% Compute the throughput experienced per WLAN at each iteration
[tpt_evolution_per_wlan_ts, times_arm_has_been_played_ts, regret_per_wlan_ts] = ...
    thompson_sampling(wlans, upperBoundThroughputPerWlan);
[tpt_evolution_per_wlan_ots, times_arm_has_been_played_ots, regret_per_wlan_ots] = ...
    ordered_thompson_sampling(wlans, upperBoundThroughputPerWlan);

% Plot the results
if plotResults
display_results_individual_performance(wlans, tpt_evolution_per_wlan_ts, ...
    times_arm_has_been_played_ts, upperBoundThroughputPerWlan, max_max_min, 'TS');
display_results_individual_performance(wlans, tpt_evolution_per_wlan_ots, ...
    times_arm_has_been_played_ots, upperBoundThroughputPerWlan, max_max_min, 'OTS');
end

% Save the workspace
save('./Output/simulation_1_4_workspace.mat')
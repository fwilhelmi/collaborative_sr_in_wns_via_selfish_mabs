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
%%% The script computes, given the 4-grid WN, the configurations that 
%%% provide the optimal values of i) the aggregate throughput, and 
%%% ii) the proportional fairness.

%%% This Script generates the output shown in the article:
%%% - Section 5.1.1 Optimal Solution

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
disp('4 WNs grid: Optimal Configuration')
disp('-----------------------')

% Generate constants from 'constants.m'
constants

wlans = generate_network_3D(nWlans, 'grid', 2, 0); % SAFE CONFIGURATION

% Compute the optimal configuration to compare the approaches
maximumAchievableThroughput = compute_throughput_all_combinations...
    (wlans, channelActions, ccaActions, txPowerActions, NOISE_DBM);
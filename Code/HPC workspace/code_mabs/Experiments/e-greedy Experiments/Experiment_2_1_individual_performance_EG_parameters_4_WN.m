%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exploiting Spatial Reuse in Wireless Networks through Decentralised MABs
% F. Wilhelmi, B. Bellalta, A. Jonsson, C. Cano, G. Neu, S. Barrachina
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% EXPERIMENT EXPLANATION:
% By using a simple grid of 4 WLANs sharing 2 channels, we want to test the
% e-greedy method if using different numbers of iterations. We fix alpha,
% gamma and initial epsilon to the values that generated better results in
% terms of proportional fairness in the Experiment_1

clc
clear all

% Add paths to methods folders
addpath(genpath('Power Management Methods/'));
addpath(genpath('Throughput Calculation Methods/'));
addpath(genpath('Network Generation Methods/'));
addpath(genpath('Reinforcement Learning Methods/'));
addpath(genpath('Reinforcement Learning Methods/Action Selection Methods/'));
addpath(genpath('Auxiliary Methods/'));

disp('-----------------------')
disp('e-greedy: Throughput Evolution')
disp('-----------------------')

% Generate constants from 'constants.m'
constants

initialEpsilon = .1;

policy = EG_POLICY;

% Setup the scenario: generate WLANs and initialize states and actions
wlans = generate_network_3D(nWlans, 'grid', 2, 0); % SAFE CONFIGURATION
   
% Compute the throughput experienced per WLAN at each iteration
% [tpt_evolution_per_wlan_eg, times_arm_has_been_played]  = eGreedyMethod(wlan, MAX_CONVERGENCE_TIME, ...
%     MAX_LEARNING_ITERATIONS, initial_epsilon, updateMode, actions_ch, actions_cca, actions_tpc, noise, printInfo);

[tptEvolutionPerWlan, timesArmHasBeenPlayed] = egreedy( wlans, initialEpsilon );

% Plot the results
display_results_individual_performance(wlans, tptEvolutionPerWlan, timesArmHasBeenPlayed, 'e-greedy');

% Save the workspace
save('./Output/eg_exp2_workspace.mat')
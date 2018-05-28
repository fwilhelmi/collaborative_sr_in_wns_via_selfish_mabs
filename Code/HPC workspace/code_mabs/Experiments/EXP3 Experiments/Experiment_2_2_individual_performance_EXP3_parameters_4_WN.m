%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exploiting Spatial Reuse in Wireless Networks through Decentralised MABs
% F. Wilhelmi, B. Bellalta, A. Jonsson, C. Cano, G. Neu, S. Barrachina
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% EXPERIMENT EXPLANATION:
% By using a simple grid of 4 WLANs sharing 2 channels, we want to test the
% EXP3 method if using different numbers of iterations. We fix eta to the 
% value that generated better results in terms of proportional fairness in 
% the Experiment_1

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
disp('EXP3: Throughput Evolution')
disp('-----------------------')

constants

% Define EXP3 parameters
eta = .1;
gamma = 0;

% Setup the scenario: generate WLANs and initialize states and actions
wlan = generate_network_3D(nWlans, 'grid', 2, 0); % SAFE CONFIGURATION
    
% Compute the throughput experienced per WLAN at each iteration
[tpt_evolution_per_wlan_exp3, times_arm_has_been_played]  = exp3(wlan, gamma, eta);

% Plot the results
display_results_individual_performance(wlan, tpt_evolution_per_wlan_exp3, ...
    times_arm_has_been_played, 'EXP3');

% Save the workspace
save('./Output/exp3_exp2_workspace.mat')
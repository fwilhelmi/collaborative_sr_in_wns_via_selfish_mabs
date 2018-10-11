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
disp('SIM 1_1_0: e-greedy')
disp('-----------------------')

% Generate constants from 'constants.m'
constants

initialEpsilon = 1;
policy = EG_POLICY;

initialEta = 0.6;
gamma = 0;

% Setup the scenario: generate WLANs and initialize states and actions
wlans = generate_network_3D(nWlans, 'grid', 2, drawMap); % SAFE CONFIGURATION
    
nChannels = 4;
txPowerActions = {};
txPowerActions{1} = [5 20];
txPowerActions{2} = [5 10 15 20];
txPowerActions{3} = 2:2:20;
txPowerActions{4} = 1:20;

tpt_evolution_per_wlan_eg = {};
times_arm_has_been_played_eg = {};
regret_per_wlan_eg = {};

tpt_evolution_per_wlan_exp3 = {};
times_arm_has_been_played_exp3 = {};
regret_per_wlan_exp3 = {};

tpt_evolution_per_wlan_ucb = {};
times_arm_has_been_played_ucb = {};
regret_per_wlan_ucb = {};

tpt_evolution_per_wlan_ts = {};
times_arm_has_been_played_ts = {};
regret_per_wlan_ts = {};

% Compute the throughput experienced per WLAN at each iteration
for i = 1 : 4 
    [tpt_evolution_per_wlan_eg{i}, times_arm_has_been_played_eg{i}, regret_per_wlan_eg{i}] = ...
        egreedy( wlans, initialEpsilon, nChannels, ccaActions, txPowerActions{i} );
    [tpt_evolution_per_wlan_exp3{i}, times_arm_has_been_played_exp3{i}, regret_per_wlan_exp3{i}] = ...
        exp3( wlans, gamma, initialEta, nChannels, ccaActions, txPowerActions{i} );
    [tpt_evolution_per_wlan_ucb{i}, times_arm_has_been_played_ucb{i}, regret_per_wlan_ucb{i}] = ...
        ucb( wlans, nChannels, ccaActions, txPowerActions{i} );
    [tpt_evolution_per_wlan_ts{i}, times_arm_has_been_played_ts{i}, regret_per_wlan_ts{i}] = ...
        thompson_sampling( wlans, nChannels, ccaActions, txPowerActions{i} );
    % Plot the results
    if plotResults
        display_results_individual_performance(wlans, tpt_evolution_per_wlan_eg{i}, ...
            times_arm_has_been_played_eg{i}, ['EG_' num2str(i) '_tx_power']);
    end
end

for i = 1 : 4 
    mean_tpt_num_channels_eg(i) = mean(mean(tpt_evolution_per_wlan_eg{i}));
    mean_tpt_num_channels_exp3(i) = mean(mean(tpt_evolution_per_wlan_exp3{i}));
    mean_tpt_num_channels_ucb(i) = mean(mean(tpt_evolution_per_wlan_ucb{i}));
    mean_tpt_num_channels_ts(i) = mean(mean(tpt_evolution_per_wlan_ts{i}));
    mean_std_num_channels_eg(i) = mean(std(tpt_evolution_per_wlan_eg{i}));
    mean_std_num_channels_exp3(i) = mean(std(tpt_evolution_per_wlan_exp3{i}));
    mean_std_num_channels_ucb(i) = mean(std(tpt_evolution_per_wlan_ucb{i}));
    mean_std_num_channels_ts(i) = mean(std(tpt_evolution_per_wlan_ts{i}));
end

figure
plot(1:4, mean_tpt_num_channels_eg, '-x', 'LineWidth', 2, 'MarkerSize', 10);
hold on
plot(1:4, mean_tpt_num_channels_exp3, '-o', 'LineWidth', 2, 'MarkerSize', 10);
plot(1:4, mean_tpt_num_channels_ucb, '--s', 'LineWidth', 2, 'MarkerSize', 10);
plot(1:4, mean_tpt_num_channels_ts, '--d', 'LineWidth', 2, 'MarkerSize', 10);
axis([1 4 0 1000])
legend({'e-greedy', 'EXP3', 'UCB', 'TS'})
set(gca,'FontSize', 22)
ylabel('Mean throughput (Mbps)')
xlabel('TxPowerLevels') 

figure
plot(1:4, mean_std_num_channels_eg, '-x', 'LineWidth', 2, 'MarkerSize', 10);
hold on
plot(1:4, mean_std_num_channels_exp3, '-o', 'LineWidth', 2, 'MarkerSize', 10);
plot(1:4, mean_std_num_channels_ucb, '--s', 'LineWidth', 2, 'MarkerSize', 10);
plot(1:4, mean_std_num_channels_ts, '--d', 'LineWidth', 2, 'MarkerSize', 10);
axis([1 4 0 300])
legend({'e-greedy', 'EXP3', 'UCB', 'TS'})
set(gca,'FontSize', 22)
ylabel('Mean std (Mbps)')
xlabel('TxPowerLevels') 

% Save the workspace
save('./Output/simulation_0_1_workspace.mat')
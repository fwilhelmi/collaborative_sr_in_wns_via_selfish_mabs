clc
clear all

disp('-----------------------')
disp('SIM 1_5_1: dynamic e-greedy')
disp('-----------------------')

% Generate constants from 'constants.m'
constants

initialEpsilon = 1;

% Setup the scenario: generate WLANs and initialize states and actions
wlans = generate_network_3D(nWlans, 'grid', 2, drawMap); % SAFE CONFIGURATION

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

% Define the WLANs objects for each stage 
%   - Stage 1: WLANs A and B are active
wlans_stage_1 = wlans;
wlans_stage_1(4) = [];
wlans_stage_1(3) = [];
%   - Stage 2: WLANs A, B and C are active
wlans_stage_2 = wlans;
wlans_stage_2(4) = [];
%   - Stage 3: All WLANs are active
wlans_stage_3 = wlans;

%% STAGE 1
rewardPerArm = zeros(nWlans, K);
% Compute the maximum achievable throughput per WLAN
upperBoundThroughputPerWlanStage1 = compute_max_selfish_throughput( wlans_stage_1 );
% Compute the throughput experienced per WLAN at each iteration
[tpt_evolution_per_wlan_eg_stage_1, times_arm_has_been_played_eg_stage_1, ...
    regret_per_wlan_eg_stage_1 , meanRewardPerAction_stage_1, rewardPerArmStage1] = ...
    egreedy_with_memory( wlans_stage_1, initialEpsilon, upperBoundThroughputPerWlanStage1, rewardPerArm, 1, 2500 );
tpt_evolution_per_wlan_eg_stage_1 = [tpt_evolution_per_wlan_eg_stage_1 zeros(2500,1) zeros(2500,1)];
%% STAGE 2
% Compute the maximum achievable throughput per WLAN
upperBoundThroughputPerWlanStage2 = compute_max_selfish_throughput( wlans_stage_2 );
% Compute the throughput experienced per WLAN at each iteration
[tpt_evolution_per_wlan_eg_stage_2, times_arm_has_been_played_eg_stage_2, ...
    regret_per_wlan_eg_stage_2 , meanRewardPerAction_stage_2, rewardPerArmStage2] = ...
    egreedy_with_memory( wlans_stage_2, initialEpsilon, upperBoundThroughputPerWlanStage2, rewardPerArmStage1, 2500, 5000 );
tpt_evolution_per_wlan_eg_stage_2 = [tpt_evolution_per_wlan_eg_stage_2 zeros(2501,1)];
%% STAGE 3
% Compute the maximum achievable throughput per WLAN
upperBoundThroughputPerWlanStage3 = compute_max_selfish_throughput( wlans_stage_3 );
% Compute the throughput experienced per WLAN at each iteration
[tpt_evolution_per_wlan_eg_stage_3, times_arm_has_been_played_eg_stage_3, ...
    regret_per_wlan_eg_stage_3 , meanRewardPerAction_stage_3, rewardPerArmStage3] = ...
    egreedy_with_memory( wlans_stage_3, initialEpsilon, upperBoundThroughputPerWlanStage3, rewardPerArmStage2, 5000, 10000 );

times_arm_has_been_played_eg_stage_1 = [times_arm_has_been_played_eg_stage_1; zeros(1, K); zeros(1,K)];
times_arm_has_been_played_eg_stage_2 = [times_arm_has_been_played_eg_stage_2; zeros(1, K)];
% Plot the results
if plotResults
    
    tpt_evolution_per_wlan_eg = [tpt_evolution_per_wlan_eg_stage_1; ...
        tpt_evolution_per_wlan_eg_stage_2; tpt_evolution_per_wlan_eg_stage_3]; 
    times_arm_has_been_played_eg = times_arm_has_been_played_eg_stage_1 + ...
        times_arm_has_been_played_eg_stage_2 + times_arm_has_been_played_eg_stage_3; 
    
    display_results_individual_performance(wlans, tpt_evolution_per_wlan_eg, ...
        times_arm_has_been_played_eg, max_max_min, agg_tpt_max_pf, 'EG');
    
end

% Save the workspace
save('./Output/simulation_1_5_1_workspace.mat')
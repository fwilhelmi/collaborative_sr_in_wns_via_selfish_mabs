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
%%% By using a simple grid of 4 WLANs sharing n channels, we compute the
%%% performance achieved by applying e-greedy in a dynamic scenario.

%%% This Script generates data to be displayed in Section 5.1.4 in the article

clc
clear all

disp('************************************************************************')
disp('* Collaborative Spatial Reuse in Wireless Networks via Selfish MABs    *')
disp('* Author: Francesc Wilhelmi (francesc.wilhelmi@upf.edu)                *')
disp('* Co-authors: C. Cano, G. Neu, B. Bellalta, A. Jonsson & S. Barrachina *')
disp('* Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi          *')
disp('* GitHub repository:                                                   *')
disp('*   https://github.com/wn-upf/Collaborative_SR_in_WNs_via_Selfish_MABs *')
disp('* More info on https://www.upf.edu/en/web/fwilhelmi                    *')
disp('************************************************************************')

disp('-----------------------------------------')
disp('SIM 1_3_2_1: dynamic e-greedy (sequential)')
disp('-----------------------------------------')

% Generate constants from 'constants.m'
constants

initialEpsilon = 1;

% Setup the scenario: generate WLANs and initialize states and actions
wlans = generate_network_3D(nWlans, 'grid', 2, drawMap); % SAFE CONFIGURATION

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
epsilon = initialEpsilon * ones(1, nWlans);
iteration_per_wlan = ones(1, nWlans);
cumulative_reward = zeros(1, nWlans);
% Compute the maximum achievable throughput per WLAN
upperBoundThroughputPerWlanStage1 = compute_max_selfish_throughput( wlans_stage_1 );
% Compute the throughput experienced per WLAN at each iteration
[tpt_evolution_per_wlan_eg_stage_1, times_arm_has_been_played_eg_stage_1, regret_per_wlan_eg_stage_1, ...
    rewardPerArmStage1, epsilonStage1, iterationPerWlanStage1, cumulativeRewardStage1] = ...
    sequential_egreedy_with_memory( wlans_stage_1, epsilon, upperBoundThroughputPerWlanStage1, ...
    rewardPerArm, cumulative_reward, 1, 2500, iteration_per_wlan );
tpt_evolution_per_wlan_eg_stage_1 = [tpt_evolution_per_wlan_eg_stage_1 zeros(2500,1) zeros(2500,1)];

%% STAGE 2
% Compute the maximum achievable throughput per WLAN
upperBoundThroughputPerWlanStage2 = compute_max_selfish_throughput( wlans_stage_2 );
% Compute the throughput experienced per WLAN at each iteration
[tpt_evolution_per_wlan_eg_stage_2, times_arm_has_been_played_eg_stage_2, ...
    regret_per_wlan_eg_stage_2, rewardPerArmStage2, epsilonStage2, iterationPerWlanStage2, cumulativeRewardStage2] = ...
    sequential_egreedy_with_memory( wlans_stage_2, epsilon, upperBoundThroughputPerWlanStage2, rewardPerArmStage1, cumulative_reward, 2500, 5000, iterationPerWlanStage1 );
tpt_evolution_per_wlan_eg_stage_2 = [tpt_evolution_per_wlan_eg_stage_2 zeros(2501,1)];

%% STAGE 3
% Compute the maximum achievable throughput per WLAN
upperBoundThroughputPerWlanStage3 = compute_max_selfish_throughput( wlans_stage_3 );
% Compute the throughput experienced per WLAN at each iteration
[tpt_evolution_per_wlan_eg_stage_3, times_arm_has_been_played_eg_stage_3, ...
    regret_per_wlan_eg_stage_3, rewardPerArmStage3, epsilonStage3, iterationPerWlanStage3, cumulativeRewardStage3] = ...
    sequential_egreedy_with_memory( wlans_stage_3, epsilon, upperBoundThroughputPerWlanStage3, rewardPerArmStage2, cumulative_reward, 5000, 10000, iterationPerWlanStage2 );

times_arm_has_been_played_eg_stage_1 = [times_arm_has_been_played_eg_stage_1; zeros(1, K); zeros(1,K)];
times_arm_has_been_played_eg_stage_2 = [times_arm_has_been_played_eg_stage_2; zeros(1, K)];
% Plot the results
tpt_evolution_per_wlan_eg = [tpt_evolution_per_wlan_eg_stage_1; ...
    tpt_evolution_per_wlan_eg_stage_2; tpt_evolution_per_wlan_eg_stage_3]; 
times_arm_has_been_played_eg = times_arm_has_been_played_eg_stage_1 + ...
    times_arm_has_been_played_eg_stage_2 + times_arm_has_been_played_eg_stage_3; 

% Set font type
set(0,'defaultUicontrolFontName','Times New Roman');
set(0,'defaultUitableFontName','Times New Roman');
set(0,'defaultAxesFontName','Times New Roman');
set(0,'defaultTextFontName','Times New Roman');
set(0,'defaultUipanelFontName','Times New Roman');

%% Compute the optimal PF in each stage
% - Stage 1
load('throughputPerConfigurationStage1.mat')
%throughputPerConfigurationStage1 = compute_throughput_all_combinations( wlans_stage_1 );
[~, ix_max_pf] = max(sum(log(throughputPerConfigurationStage1)'));
AggTptPFStage1 = sum(throughputPerConfigurationStage1(ix_max_pf,:));
% - Stage 2
load('throughputPerConfigurationStage2.mat')
%throughputPerConfigurationStage2 = compute_throughput_all_combinations( wlans_stage_2 );
[~, ix_max_pf] = max(sum(log(throughputPerConfigurationStage2)'));
AggTptPFStage2 = sum(throughputPerConfigurationStage2(ix_max_pf,:));
% - Stage 3
load('throughputPerConfigurationStage3.mat')
%throughputPerConfigurationStage3 = compute_throughput_all_combinations( wlans_stage_3 );
[~, ix_max_pf] = max(sum(log(throughputPerConfigurationStage3)'));
AggTptPFStage3 = sum(throughputPerConfigurationStage3(ix_max_pf,:));
% Merge the results in order to plot them
optimal_agg_plot = [sum(AggTptPFStage1)*ones(1, 2500) ...
    sum(AggTptPFStage2)*ones(1, 2500) sum(AggTptPFStage3)*ones(1, 5000)];

%% Aggregated throughput experienced for each iteration
figure('pos',[450 400 500 350]);
axes;
axis([1 20 30 70]);
agg_tpt_per_iteration = sum(tpt_evolution_per_wlan_eg(1:totalIterations, :), 2);
plot(1 : totalIterations, agg_tpt_per_iteration)
set(gca,'FontSize', 22)
xlabel(['EG iteration'], 'fontsize', 24)
ylabel('Network Throughput (Mbps)', 'fontsize', 24)
axis([1 totalIterations 0 1.1 * max(optimal_agg_plot)])    
hold on
h1 = plot(1 : totalIterations, optimal_agg_plot, 'r--', 'linewidth',2);
%legend(h1, {'Optimal (Max. Prop. Fairness)'});
legend({'Temporal throughput', 'Optimal (Max. Prop. Fairness)'});
%text(totalIterations * 0.5 , max_pf * 1.1, 'Optimal (Max. Prop. Fairness)', 'fontsize', 24)
% Save Figure
fig_name = ['temporal_aggregate_tpt_dynamic_scenario_ordered_EG'];
savefig(['./Output/' fig_name '.fig'])
saveas(gcf,['./Output/' fig_name],'png')
    
% display_results_individual_performance(wlans, tpt_evolution_per_wlan_eg, ...
%     times_arm_has_been_played_eg, max_max_min, agg_tpt_max_pf, 'EG');
   
% Save the workspace
save('./Output/simulation_1_4_2_1_workspace.mat')
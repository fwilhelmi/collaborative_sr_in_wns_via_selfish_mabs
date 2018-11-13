%%% ************************************************************************
%%% * Collaborative Spatial Reuse in Wireless Networks via Selfish MABs    *
%%% * Author: Francesc Wilhelmi (francesc.wilhelmi@upf.edu)                *
%%% * Co-authors: C. Cano, G. Neu, B. Bellalta, A. Jonsson & S. Barrachina *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi          *
%%% * GitHub repository:                                                   *
%%% *   https://github.com/wn-upf/Collaborative_SR_in_WNs_via_Selfish_MABs *
%%% * More info on https://www.upf.edu/en/web/fwilhelmi                    *
%%% ************************************************************************

% FILE DESCRIPTION:
% Script to plot the results of experiment 1.3 (Dynamic scenario)
% This script plots article's Figure 7

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

disp('--------------------------------------------------------------')
disp('PLOT RESULTS OF PART 1_3: TOY GRID SCENARIO (dynamic scenario)')
disp('--------------------------------------------------------------')

constants

% Set font type
set(0,'defaultUicontrolFontName','Times New Roman');
set(0,'defaultUitableFontName','Times New Roman');
set(0,'defaultAxesFontName','Times New Roman');
set(0,'defaultTextFontName','Times New Roman');
set(0,'defaultUipanelFontName','Times New Roman');

%% Compute the optimal PF in each stage
% - Stage 1
try
    load('throughputPerConfigurationStage1.mat')
catch
    throughputPerConfigurationStage1 = compute_throughput_all_combinations( wlans_stage_1 );
end
[~, ix_max_pf] = max(sum(log(throughputPerConfigurationStage1)'));
AggTptPFStage1 = sum(throughputPerConfigurationStage1(ix_max_pf,:));
% - Stage 2
try
    load('throughputPerConfigurationStage2.mat')
catch
    throughputPerConfigurationStage2 = compute_throughput_all_combinations( wlans_stage_2 );
end
[~, ix_max_pf] = max(sum(log(throughputPerConfigurationStage2)'));
AggTptPFStage2 = sum(throughputPerConfigurationStage2(ix_max_pf,:));
% - Stage 3
try
    load('throughputPerConfigurationStage3.mat')
catch
    throughputPerConfigurationStage3 = compute_throughput_all_combinations( wlans_stage_3 );
end
load('throughputPerConfigurationStage3.mat')
[~, ix_max_pf] = max(sum(log(throughputPerConfigurationStage3)'));
AggTptPFStage3 = sum(throughputPerConfigurationStage3(ix_max_pf,:));
% Merge the results in order to plot them
optimal_agg_plot = [sum(AggTptPFStage1)*ones(1, 2500) ...
    sum(AggTptPFStage2)*ones(1, 2500) sum(AggTptPFStage3)*ones(1, 5000)];

%% Aggregated throughput experienced for each iteration

% Load results from experiments in part 1_3_1_4
load('simulation_1_3_1_4_workspace.mat');
tpt_evolution_per_wlan_ts_concurrent = [tpt_evolution_per_wlan_ts_stage_1; ...
    tpt_evolution_per_wlan_ts_stage_2; tpt_evolution_per_wlan_ts_stage_3];

figure('pos',[450 400 500 350]);
axes;
axis([1 20 30 70]);
agg_tpt_per_iteration = sum(tpt_evolution_per_wlan_ts(1:totalIterations, :), 2);
plot(1 : totalIterations, agg_tpt_per_iteration)
set(gca,'FontSize', 22)
xlabel(['TS iteration'], 'fontsize', 24)
ylabel('Network Throughput (Mbps)', 'fontsize', 24)
axis([1 totalIterations 0 1.1 * max(optimal_agg_plot)])    
hold on
h1 = plot(1 : totalIterations, optimal_agg_plot, 'r--', 'linewidth',2);
legend({'Temporal throughput', 'Optimal (Max. Prop. Fairness)'});
% Save Figure
fig_name = ['temporal_aggregate_tpt_dynamic_scenario_concurrent_TS'];
savefig(['./Output/' fig_name '.fig'])
saveas(gcf,['./Output/' fig_name],'png')

% Load results from experiments in part 1_3_2_4
load('simulation_1_3_2_4_workspace.mat');
tpt_evolution_per_wlan_ts_sequential = [tpt_evolution_per_wlan_ts_stage_1; ...
    tpt_evolution_per_wlan_ts_stage_2; tpt_evolution_per_wlan_ts_stage_3];

figure('pos',[450 400 500 350]);
axes;
axis([1 20 30 70]);
agg_tpt_per_iteration = sum(tpt_evolution_per_wlan_ts(1:totalIterations, :), 2);
plot(1 : totalIterations, agg_tpt_per_iteration)
set(gca,'FontSize', 22)
xlabel(['TS iteration'], 'fontsize', 24)
ylabel('Network Throughput (Mbps)', 'fontsize', 24)
axis([1 totalIterations 0 1.1 * max(optimal_agg_plot)])    
hold on
h1 = plot(1 : totalIterations, optimal_agg_plot, 'r--', 'linewidth',2);
legend({'Temporal throughput', 'Optimal (Max. Prop. Fairness)'});
% Save Figure
fig_name = ['temporal_aggregate_tpt_dynamic_scenario_sequential_TS'];
savefig(['./Output/' fig_name '.fig'])
saveas(gcf,['./Output/' fig_name],'png')

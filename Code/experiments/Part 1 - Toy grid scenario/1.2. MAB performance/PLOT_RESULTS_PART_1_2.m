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
% Script to plot the results of experiment 1.2 (MABs performance)
% This script plots article's Figures 4, 5 & 6

clc
clear all

disp('***********************************************************************')
disp('*         Potential and Pitfalls of Multi-Armed Bandits for           *')
disp('*               Decentralized Spatial Reuse in WLANs                  *')
disp('*                                                                     *')
disp('* Submission to Journal on Network and Computer Applications          *')
disp('* Authors:                                                            *')
disp('*   - Francesc Wilhelmi (francisco.wilhelmi@upf.edu)                  *')
disp('*   - Sergio Barrachina-Muñoz  (sergio.barrachina@upf.edu)            *')
disp('*   - Boris Bellalta (boris.bellalta@upf.edu)                         *')
disp('*   - Cristina Cano (ccanobs@uoc.edu)                                 *')
disp('*   - Anders Jonsson (anders.jonsson@upf.edu)                         *')
disp('*   - Gergely Neu (gergely.neu@upf.edu)                               *')
disp('* Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi         *')
disp('* Repository:                                                         *')
disp('*  https://github.com/fwilhelmi/potential_pitfalls_mabs_spatial_reuse *')
disp('***********************************************************************')

disp('-------------------------------------------------------------')
disp('PLOT RESULTS OF PART 1_2: TOY GRID SCENARIO (MABs performance)')
disp('-------------------------------------------------------------')

constants

% Set font type
set(0,'defaultUicontrolFontName','Times New Roman');
set(0,'defaultUitableFontName','Times New Roman');
set(0,'defaultAxesFontName','Times New Roman');
set(0,'defaultTextFontName','Times New Roman');
set(0,'defaultUipanelFontName','Times New Roman');

% Load results from experiments in part 1_2
load('simulation_1_2_1_workspace.mat');
load('simulation_1_2_2_workspace.mat');
load('simulation_1_2_3_workspace.mat');
load('simulation_1_2_4_workspace.mat');

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

nWlans = 4;

% e-greedy
permanent_throughput_egreedy = tpt_evolution_per_wlan_eg(permanentInterval, :);
mean_tpt_per_wlan_egreedy = mean(permanent_throughput_egreedy);
std_per_wlan_egreedy = std(permanent_throughput_egreedy);
% ordered e-greedy
permanent_throughput_cegreedy = tpt_evolution_per_wlan_ceg(permanentInterval, :);
mean_tpt_per_wlan_cegreedy = mean(permanent_throughput_cegreedy);
std_per_wlan_cegreedy = std(permanent_throughput_cegreedy);

% EXP3
permanent_throughput_exp3 = tpt_evolution_per_wlan_exp3(permanentInterval, :);
mean_tpt_per_wlan_exp3 = mean(permanent_throughput_exp3);
std_per_wlan_exp3 = std(permanent_throughput_exp3);
% ordered EXP3
permanent_throughput_cexp3 = tpt_evolution_per_wlan_cexp3(permanentInterval, :);
mean_tpt_per_wlan_cexp3 = mean(permanent_throughput_cexp3);
std_per_wlan_cexp3 = std(permanent_throughput_cexp3);

% UCB
permanent_throughput_ucb = tpt_evolution_per_wlan_ucb(permanentInterval, :);
mean_tpt_per_wlan_ucb = mean(permanent_throughput_ucb);
std_per_wlan_ucb = std(permanent_throughput_ucb);
% ordered UCB
permanent_throughput_cucb = tpt_evolution_per_wlan_cucb(permanentInterval, :);
mean_tpt_per_wlan_cucb = mean(permanent_throughput_cucb);
std_per_wlan_cucb = std(permanent_throughput_cucb);

% Thompson sampling
permanent_throughput_ts = tpt_evolution_per_wlan_ts(permanentInterval, :);
mean_tpt_per_wlan_ts = mean(permanent_throughput_ts);
std_per_wlan_ts = std(permanent_throughput_ts);
% ordered Thompson sampling
permanent_throughput_cts = tpt_evolution_per_wlan_cts(permanentInterval, :);
mean_tpt_per_wlan_cts = mean(permanent_throughput_cts);
std_per_wlan_cts = std(permanent_throughput_cts);

%% Average throughput experienced per WLAN - Default
fig = figure('pos',[450 400 500 350]);
axes;
axis([1 20 30 70]);    
title('Default')
ctrs = 1 : nWlans;
data = [mean_tpt_per_wlan_egreedy(:) mean_tpt_per_wlan_exp3(:)...
    mean_tpt_per_wlan_ucb(:) mean_tpt_per_wlan_ts(:)];
figure(1)
hBar = bar(ctrs, data);
for k1 = 1 : size(data, 2)
    ctr(k1,:) = bsxfun(@plus, hBar(1).XData, [hBar(k1).XOffset]');
    ydt(k1,:) = hBar(k1).YData;
end
hold on
errorbar(ctr', ydt', [std_per_wlan_egreedy(:) std_per_wlan_exp3(:)...
    std_per_wlan_ucb(:) std_per_wlan_ts(:)], '.r')      
xlabel('WN id','fontsize', 24)
ylabel('Mean throughput (Mbps)','fontsize', 24)
set(gca,'FontSize', 22)
axis([0 nWlans+1 0 2 * max(max_max_min)])
h2 = plot(0 : nWlans+1, max_max_min * ones(1, nWlans+2), 'k--', 'linewidth',2);
legend([hBar, h2],{'\epsilon-greedy', 'EXP3', 'UCB', 'TS', 'Optimal (PF)'});
% Save Figure
figName = 'results_part_1_mean_tpt_default';
savefig(['./output/' figName '.fig'])
saveas(gcf,['./output/' figName],'png')
close 

% %% Average throughput experienced per WLAN - Ordered
% fig = figure('pos',[450 400 500 350]);
% axes;
% axis([1 20 30 70]);    
% title('Ordered')
% ctrs = 1 : nWlans;
% data = [mean_tpt_per_wlan_cegreedy(:) mean_tpt_per_wlan_cexp3(:)...
%     mean_tpt_per_wlan_cucb(:) mean_tpt_per_wlan_cts(:)];
% figure(1)
% hBar = bar(ctrs, data);
% for k1 = 1 : size(data, 2)
%     ctr(k1,:) = bsxfun(@plus, hBar(1).XData, [hBar(k1).XOffset]');
%     ydt(k1,:) = hBar(k1).YData;
% end
% hold on
% errorbar(ctr', ydt', [std_per_wlan_egreedy(:) std_per_wlan_exp3(:)...
%     std_per_wlan_ucb(:) std_per_wlan_ts(:)], '.r')      
% xlabel('WN id','fontsize', 24)
% ylabel('Mean throughput (Mbps)','fontsize', 24)
% set(gca,'FontSize', 22)
% axis([0 nWlans+1 0 2 * max(max_max_min)])
% h2 = plot(0 : nWlans+1, max_max_min * ones(1, nWlans+2), 'k--', 'linewidth',2);
% legend([hBar, h2],{'\epsilon-greedy', 'EXP3', 'UCB', 'TS', 'Optimal (PF)'});
% % Save Figure
% figName = 'results_part_1_mean_tpt_ordered';
% savefig(['./output/' figName '.fig'])
% saveas(gcf,['./output/' figName],'png')
% close 

% %% Throughput experienced by WLAN A - Default
% fig = figure('pos',[450 400 500 350]);
% axes;
% axis([1 20 30 70]);
% title('Default')
% subplot(2,2,1)
% plot(1 : totalIterations, tpt_evolution_per_wlan_eg(:,1));
% title('\epsilon-greedy')
% xlabel('Iteration','fontsize', 24)
% set(gca,'FontSize', 22)
% subplot(2,2,2)
% plot(1 : totalIterations, tpt_evolution_per_wlan_exp3(:,1));
% title('EXP3')
% xlabel('Iteration','fontsize', 24)
% set(gca,'FontSize', 22)
% subplot(2,2,3)
% plot(1 : totalIterations, tpt_evolution_per_wlan_ucb(:,1));
% title('UCB')
% xlabel('Iteration','fontsize', 24)
% set(gca,'FontSize', 22)
% subplot(2,2,4)
% plot(1 : totalIterations, tpt_evolution_per_wlan_ts(:,1));
% title('TS')
% set(gca,'FontSize', 22)
% xlabel('Iteration','fontsize', 24)
% hold on
% ylabel('Throughput WN_{A} (Mbps)','fontsize', 24)
% % Save Figure
% figName = 'results_part_1_variability_default';
% savefig(['./output/' figName '.fig'])
% saveas(gcf,['./output/' figName],'png')
% close
% 
% %% Throughput experienced by WLAN A - Ordered
% fig = figure('pos',[450 400 500 350]);
% axes;
% axis([1 20 30 70]);
% title('Ordered')
% subplot(2,2,1)
% plot(1 : totalIterations, tpt_evolution_per_wlan_ceg(:,1));
% title('\epsilon-greedy')
% xlabel('Iteration','fontsize', 24)
% set(gca,'FontSize', 22)
% subplot(2,2,2)
% plot(1 : totalIterations, tpt_evolution_per_wlan_cexp3(:,1));
% title('EXP3')
% xlabel('Iteration','fontsize', 24)
% set(gca,'FontSize', 22)
% subplot(2,2,3)
% plot(1 : totalIterations, tpt_evolution_per_wlan_cucb(:,1));
% title('UCB')
% xlabel('Iteration','fontsize', 24)
% set(gca,'FontSize', 22)
% subplot(2,2,4)
% plot(1 : totalIterations, tpt_evolution_per_wlan_cts(:,1));
% title('TS')
% set(gca,'FontSize', 22)
% xlabel('Iteration','fontsize', 24)
% hold on
% ylabel('Throughput WN_{A} (Mbps)','fontsize', 24)
% % Save Figure
% figName = 'results_part_1_variability_ordered';
% savefig(['./Output/' figName '.fig'])
% saveas(gcf,['./Output/' figName],'png')
% close


% %% Agg. Throughput - Default
% fig = figure('pos',[450 400 500 350]);
% axes;
% axis([1 20 30 70]);
% title('Default')
% % e-greedy
% subplot(2,2,1)
% plot(1 : totalIterations, sum(tpt_evolution_per_wlan_eg'));
% hold on
% plot(1 : totalIterations, agg_tpt_max_pf * ones(1, totalIterations), 'r--', 'linewidth',2);
% set(gca,'FontSize', 22)
% xlabel('Iteration','fontsize', 24)
% title('\epsilon-greedy')
% axis([1 totalIterations 0 1.2*agg_tpt_max_pf])
% % exp3
% subplot(2,2,2)
% plot(1 : totalIterations, sum(tpt_evolution_per_wlan_exp3'));
% hold on
% plot(1 : totalIterations, agg_tpt_max_pf * ones(1, totalIterations), 'r--', 'linewidth',2);
% axis([1 totalIterations 0 1.2*agg_tpt_max_pf])
% title('EXP3')
% xlabel('Iteration','fontsize', 24)
% set(gca,'FontSize', 22)
% axis([1 totalIterations 0 1.2*agg_tpt_max_pf])
% % UCB
% subplot(2,2,3)
% plot(1 : totalIterations, sum(tpt_evolution_per_wlan_ucb'));
% hold on
% plot(1 : totalIterations, agg_tpt_max_pf * ones(1, totalIterations), 'r--', 'linewidth',2);
% axis([1 totalIterations 0 1.2*agg_tpt_max_pf])
% title('UCB')
% xlabel('Iteration','fontsize', 24)
% set(gca,'FontSize', 22)
% axis([1 totalIterations 0 1.2*agg_tpt_max_pf])
% % TS
% subplot(2,2,4)
% plot(1 : totalIterations, sum(tpt_evolution_per_wlan_ts'));
% hold on
% title('TS')
% set(gca,'FontSize', 22)
% xlabel('Iteration','fontsize', 24)
% axis([1 totalIterations 0 1.2*agg_tpt_max_pf])
% plot(1 : totalIterations, agg_tpt_max_pf * ones(1, totalIterations), 'r--', 'linewidth',2);
% axis([1 totalIterations 0 1.2*agg_tpt_max_pf])
% %legend(h2,'Optimal (max. PF)')
% ylabel('Network Throughput (Mbps)','fontsize', 24)
% % Save Figure
% figName = 'results_part_1_agg_variability_default';
% savefig(['./Output/' figName '.fig'])
% saveas(gcf,['./Output/' figName],'png')
% close
% 
% %% Agg. Throughput - Ordered
% fig = figure('pos',[450 400 500 350]);
% axes;
% axis([1 20 30 70]);
% title('Ordered')
% % e-greedy
% subplot(2,2,1)
% plot(1 : totalIterations, sum(tpt_evolution_per_wlan_ceg'));
% hold on
% plot(1 : totalIterations, agg_tpt_max_pf * ones(1, totalIterations), 'r--', 'linewidth',2);
% set(gca,'FontSize', 22)
% xlabel('Iteration','fontsize', 24)
% title('\epsilon-greedy')
% axis([1 totalIterations 0 1.2*agg_tpt_max_pf])
% % exp3
% subplot(2,2,2)
% plot(1 : totalIterations, sum(tpt_evolution_per_wlan_cexp3'));
% hold on
% plot(1 : totalIterations, agg_tpt_max_pf * ones(1, totalIterations), 'r--', 'linewidth',2);
% axis([1 totalIterations 0 1.2*agg_tpt_max_pf])
% title('EXP3')
% xlabel('Iteration','fontsize', 24)
% set(gca,'FontSize', 22)
% axis([1 totalIterations 0 1.2*agg_tpt_max_pf])
% % UCB
% subplot(2,2,3)
% plot(1 : totalIterations, sum(tpt_evolution_per_wlan_cucb'));
% hold on
% plot(1 : totalIterations, agg_tpt_max_pf * ones(1, totalIterations), 'r--', 'linewidth',2);
% axis([1 totalIterations 0 1.2*agg_tpt_max_pf])
% title('UCB')
% xlabel('Iteration','fontsize', 24)
% set(gca,'FontSize', 22)
% axis([1 totalIterations 0 1.2*agg_tpt_max_pf])
% % TS
% subplot(2,2,4)
% plot(1 : totalIterations, sum(tpt_evolution_per_wlan_cts'));
% hold on
% title('TS')
% set(gca,'FontSize', 22)
% xlabel('Iteration','fontsize', 24)
% axis([1 totalIterations 0 1.2*agg_tpt_max_pf])
% plot(1 : totalIterations, agg_tpt_max_pf * ones(1, totalIterations), 'r--', 'linewidth',2);
% axis([1 totalIterations 0 1.2*agg_tpt_max_pf])
% %legend(h2,'Optimal (max. PF)')
% ylabel('Network Throughput (Mbps)','fontsize', 24)
% % Save Figure
% figName = 'results_part_1_agg_variability_ordered';
% savefig(['./output/' figName '.fig'])
% saveas(gcf,['./output/' figName],'png')
% close

%% Asynchronous vs Synchronous learning (mean tpt)
data1 = [mean(mean_tpt_per_wlan_egreedy) mean(mean_tpt_per_wlan_exp3) ...
    mean(mean_tpt_per_wlan_ucb) mean(mean_tpt_per_wlan_ts)];
data2 = [mean(mean_tpt_per_wlan_cegreedy) mean(mean_tpt_per_wlan_cexp3) ...
    mean(mean_tpt_per_wlan_cucb) mean(mean_tpt_per_wlan_cts)];
fig = figure('pos',[450 400 500 350]);
axes;
axis([1 20 30 70]);
bar(1:4, [data1; data2]')
set(gca,'FontSize', 22)
xticks = 1:4;
xticklabels({'\epsilon-greedy', 'EXP3', 'UCB', 'TS'});
xlabel('Method','fontsize', 24)
ylabel('Mean Throughput (Mbps)','fontsize', 24)
legend({'Asynchronous', 'Synchronous'})
% Save Figure
figName = 'results_part_1_async_vs_sync';
savefig(['./output/' figName '.fig'])
saveas(gcf,['./output/' figName],'png')
close

%% Asynchronous vs Synchronous learning (variability)
fig = figure('pos',[450 400 500 350]);
axes;
axis([1 20 30 70]);
% Concurrent
subplot(2,1,1)
plot(1 : totalIterations, tpt_evolution_per_wlan_ts(:,4));
%plot(1 : totalIterations, mean(tpt_evolution_per_wlan_ts'));
hold on
h2 = plot(1 : totalIterations, max_max_min * ones(1, totalIterations), 'r--', 'linewidth',2);
%axis([1 totalIterations 0 1.2*max_max_min])
title('Concurrent')
set(gca,'FontSize', 22)
xlabel('Iteration','fontsize', 24)
legend(h2, {'Optimal (PF)'})
% Sequential
subplot(2,1,2)
plot(1 : totalIterations, tpt_evolution_per_wlan_cts(:,4));
%plot(1 : totalIterations, mean(tpt_evolution_per_wlan_cts'));
hold on
h2 = plot(1 : totalIterations, max_max_min * ones(1, totalIterations), 'r--', 'linewidth',2);
%axis([1 totalIterations 0 1.2*max_max_min])
title('Sequential')
set(gca,'FontSize', 22)
xlabel('Iteration','fontsize', 24)
legend(h2, {'Optimal (PF)'})
ylabel('Throughput WN_{4} (Mbps)','fontsize', 24)
% Save Figure
figName = 'results_part_1_async_vs_sync_variability';
savefig(['./output/' figName '.fig'])
saveas(gcf,['./output/' figName],'png')
close
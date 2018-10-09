% FILE DESCRIPTION:
% Script to plot the results of Part 1 (Toy grid scenario)
% This script plots article's figures ... (Section 5.1)

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

disp('----------------------------------------------')
disp('PLOT RESULTS OF PART 1: TOY GRID SCENARIO (default vs sync. algs.)')
disp('----------------------------------------------')

constants

% Set font type
set(0,'defaultUicontrolFontName','Times New Roman');
set(0,'defaultUitableFontName','Times New Roman');
set(0,'defaultAxesFontName','Times New Roman');
set(0,'defaultTextFontName','Times New Roman');
set(0,'defaultUipanelFontName','Times New Roman');

% Load results from experiments in part 1
load('simulation_1_1_workspace.mat');
load('simulation_1_2_workspace.mat');
load('simulation_1_3_workspace.mat');
load('simulation_1_4_workspace.mat');

num_wlans = 4;

% e-greedy
permanent_throughput_egreedy = tpt_evolution_per_wlan_eg(permanentInterval, :);
mean_tpt_per_wlan_egreedy = mean(permanent_throughput_egreedy);
std_per_wlan_egreedy = std(permanent_throughput_egreedy);
% ordered e-greedy
permanent_throughput_oegreedy = tpt_evolution_per_wlan_oeg(permanentInterval, :);
mean_tpt_per_wlan_oegreedy = mean(permanent_throughput_oegreedy);
std_per_wlan_oegreedy = std(permanent_throughput_oegreedy);

% EXP3
permanent_throughput_exp3 = tpt_evolution_per_wlan_exp3(permanentInterval, :);
mean_tpt_per_wlan_exp3 = mean(permanent_throughput_exp3);
std_per_wlan_exp3 = std(permanent_throughput_exp3);
% ordered EXP3
permanent_throughput_oexp3 = tpt_evolution_per_wlan_oexp3(permanentInterval, :);
mean_tpt_per_wlan_oexp3 = mean(permanent_throughput_oexp3);
std_per_wlan_oexp3 = std(permanent_throughput_oexp3);

% UCB
permanent_throughput_ucb = tpt_evolution_per_wlan_ucb(permanentInterval, :);
mean_tpt_per_wlan_ucb = mean(permanent_throughput_ucb);
std_per_wlan_ucb = std(permanent_throughput_ucb);
% ordered UCB
permanent_throughput_oucb = tpt_evolution_per_wlan_oucb(permanentInterval, :);
mean_tpt_per_wlan_oucb = mean(permanent_throughput_oucb);
std_per_wlan_oucb = std(permanent_throughput_oucb);

% Thompson sampling
permanent_throughput_ts = tpt_evolution_per_wlan_ts(permanentInterval, :);
mean_tpt_per_wlan_ts = mean(permanent_throughput_ts);
std_per_wlan_ts = std(permanent_throughput_ts);
% ordered Thompson sampling
permanent_throughput_ots = tpt_evolution_per_wlan_ots(permanentInterval, :);
mean_tpt_per_wlan_ots = mean(permanent_throughput_ots);
std_per_wlan_ots = std(permanent_throughput_ots);

%% HISTOGRAM - Default
fig = figure('pos',[450 400 500 350]);
axes;
axis([1 20 30 70]);   
title('Default')
subplot(2,2,1)
hist(permanent_throughput_egreedy(:), 50)
set(gca,'FontSize', 22)
axis([0 700 0 5000])
title('\epsilon-greedy')
hold on
subplot(2,2,2)
hist(permanent_throughput_exp3(:), 50)
set(gca,'FontSize', 22)
axis([0 700 0 5000])
title('EXP3')
subplot(2,2,3)
hist(permanent_throughput_ucb(:), 50)
set(gca,'FontSize', 22)
axis([0 700 0 5000])
title('UCB')
subplot(2,2,4)
hist(permanent_throughput_ts(:), 50)
set(gca,'FontSize', 22)
axis([0 700 0 5000])
title('TS')
% Add labels
xlabel('Throughput (Mbps)','fontsize', 26)
ylabel('Frequency','fontsize', 26)
% Save Figure
figName = 'results_part_1_hist_throughput_default';
savefig(['./Output/' figName '.fig'])
saveas(gcf,['./Output/' figName],'png')
close

%% HISTOGRAM - Ordererd
fig = figure('pos',[450 400 500 350]);
axes;
axis([1 20 30 70]);   
title('Ordered')
subplot(2,2,1)
hist(permanent_throughput_oegreedy(:), 50)
set(gca,'FontSize', 22)
axis([0 700 0 5000])
title('\epsilon-greedy')
hold on
subplot(2,2,2)
hist(permanent_throughput_oexp3(:), 50)
set(gca,'FontSize', 22)
axis([0 700 0 5000])
title('EXP3')
subplot(2,2,3)
hist(permanent_throughput_oucb(:), 50)
set(gca,'FontSize', 22)
axis([0 700 0 5000])
title('UCB')
subplot(2,2,4)
hist(permanent_throughput_ots(:), 50)
set(gca,'FontSize', 22)
axis([0 700 0 5000])
title('TS')
% Add labels
xlabel('Throughput (Mbps)','fontsize', 26)
ylabel('Frequency','fontsize', 26)
% Save Figure
figName = 'results_part_1_hist_throughput_ordered';
savefig(['./Output/' figName '.fig'])
saveas(gcf,['./Output/' figName],'png')
close

%% BOXPLOT - Default
fig = figure('pos',[450 400 500 350]);
axes;
axis([1 20 30 70]);    
boxplot([permanent_throughput_egreedy(:) permanent_throughput_exp3(:)...
    permanent_throughput_exp3(:) permanent_throughput_ts(:)])
ylabel('Throughput (Mbps)','fontsize', 24)
xlabel('Method','fontsize', 24)
xticks([1 2 3 4])
xticklabels({'e-greedy', 'EXP3', 'UCB', 'TS'})
title('Default')
set(gca,'FontSize', 22)
% Save Figure
figName = 'results_part_1_boxplot_default';
savefig(['./Output/' figName '.fig'])
saveas(gcf,['./Output/' figName],'png')
close

%% BOXPLOT - Ordered
fig = figure('pos',[450 400 500 350]);
axes;
axis([1 20 30 70]);    
boxplot([permanent_throughput_oegreedy(:) permanent_throughput_oexp3(:)...
    permanent_throughput_oexp3(:) permanent_throughput_ots(:)])
ylabel('Throughput (Mbps)','fontsize', 24)
xlabel('Method','fontsize', 24)
title('Ordered')
xticks([1 2 3 4])
xticklabels({'e-greedy', 'EXP3', 'UCB', 'TS'})
set(gca,'FontSize', 22)
% Save Figure
figName = 'results_part_1_boxplot_ordered';
savefig(['./Output/' figName '.fig'])
saveas(gcf,['./Output/' figName],'png')
close

%% Average throughput experienced per WLAN - Default
fig = figure('pos',[450 400 500 350]);
axes;
axis([1 20 30 70]);    
title('Default')
ctrs = 1 : num_wlans;
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
axis([0 num_wlans+1 0 2 * max(ind_tpt_optimal_prop_fairness)])
h2 = plot(0 : num_wlans+1, ind_tpt_optimal_prop_fairness * ones(1, num_wlans+2), 'k--', 'linewidth',2);
legend([hBar, h2],{'\epsilon-greedy', 'EXP3', 'UCB', 'TS', 'Optimal (PF)'});
% Save Figure
figName = 'results_part_1_mean_tpt_default';
savefig(['./Output/' figName '.fig'])
saveas(gcf,['./Output/' figName],'png')
close 

%% Average throughput experienced per WLAN - Ordered
fig = figure('pos',[450 400 500 350]);
axes;
axis([1 20 30 70]);    
title('Ordered')
ctrs = 1 : num_wlans;
data = [mean_tpt_per_wlan_oegreedy(:) mean_tpt_per_wlan_oexp3(:)...
    mean_tpt_per_wlan_oucb(:) mean_tpt_per_wlan_ots(:)];
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
axis([0 num_wlans+1 0 2 * max(ind_tpt_optimal_prop_fairness)])
h2 = plot(0 : num_wlans+1, ind_tpt_optimal_prop_fairness * ones(1, num_wlans+2), 'k--', 'linewidth',2);
legend([hBar, h2],{'\epsilon-greedy', 'EXP3', 'UCB', 'TS', 'Optimal (PF)'});
% Save Figure
figName = 'results_part_1_mean_tpt_ordered';
savefig(['./Output/' figName '.fig'])
saveas(gcf,['./Output/' figName],'png')
close 

%% Throughput experienced by WLAN A - Default
fig = figure('pos',[450 400 500 350]);
axes;
axis([1 20 30 70]);
title('Default')
subplot(2,2,1)
plot(1 : totalIterations, tpt_evolution_per_wlan_eg(:,1));
title('\epsilon-greedy')
xlabel('Iteration','fontsize', 24)
set(gca,'FontSize', 22)
subplot(2,2,2)
plot(1 : totalIterations, tpt_evolution_per_wlan_exp3(:,1));
title('EXP3')
xlabel('Iteration','fontsize', 24)
set(gca,'FontSize', 22)
subplot(2,2,3)
plot(1 : totalIterations, tpt_evolution_per_wlan_ucb(:,1));
title('UCB')
xlabel('Iteration','fontsize', 24)
set(gca,'FontSize', 22)
subplot(2,2,4)
plot(1 : totalIterations, tpt_evolution_per_wlan_ts(:,1));
title('TS')
set(gca,'FontSize', 22)
xlabel('Iteration','fontsize', 24)
hold on
ylabel('Throughput WN_{A} (Mbps)','fontsize', 24)
% Save Figure
figName = 'results_part_1_variability_default';
savefig(['./Output/' figName '.fig'])
saveas(gcf,['./Output/' figName],'png')
close

%% Throughput experienced by WLAN A - Ordered
fig = figure('pos',[450 400 500 350]);
axes;
axis([1 20 30 70]);
title('Ordered')
subplot(2,2,1)
plot(1 : totalIterations, tpt_evolution_per_wlan_oeg(:,1));
title('\epsilon-greedy')
xlabel('Iteration','fontsize', 24)
set(gca,'FontSize', 22)
subplot(2,2,2)
plot(1 : totalIterations, tpt_evolution_per_wlan_oexp3(:,1));
title('EXP3')
xlabel('Iteration','fontsize', 24)
set(gca,'FontSize', 22)
subplot(2,2,3)
plot(1 : totalIterations, tpt_evolution_per_wlan_oucb(:,1));
title('UCB')
xlabel('Iteration','fontsize', 24)
set(gca,'FontSize', 22)
subplot(2,2,4)
plot(1 : totalIterations, tpt_evolution_per_wlan_ots(:,1));
title('TS')
set(gca,'FontSize', 22)
xlabel('Iteration','fontsize', 24)
hold on
ylabel('Throughput WN_{A} (Mbps)','fontsize', 24)
% Save Figure
figName = 'results_part_1_variability_ordered';
savefig(['./Output/' figName '.fig'])
saveas(gcf,['./Output/' figName],'png')
close

% %% Regret
% fig = figure('pos',[450 400 500 350]);
% axes;
% axis([1 20 30 70]);
% plot(1 : totalIterations, cumsum(mean(regret_per_wlan_egreedy, 2)));
% hold on
% plot(1 : totalIterations, cumsum(mean(regret_per_wlan_exp3, 2)));
% plot(1 : totalIterations, cumsum(mean(regret_per_wlan_ucb, 2)));
% plot(1 : totalIterations, cumsum(mean(regret_per_wlan_ts, 2)));
% ylabel('Regret','fontsize', 24)
% xlabel('Iteration','fontsize', 24)
% set(gca,'FontSize', 22)
% legend({'\epsilon-greedy', 'EXP3', 'UCB', 'TS'});
% % Save Figure
% figName = 'results_part_1_regret';
% savefig(['./Output/' figName '.fig'])
% saveas(gcf,['./Output/' figName],'png')
% close 
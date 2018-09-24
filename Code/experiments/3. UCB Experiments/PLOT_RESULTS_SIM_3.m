% FILE DESCRIPTION:
% Script to plot the results of experiment 2.3 (Adversarial Issues in WLANs)
% This script plots article's figures 11b and 11c 

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
disp('PLOT RESULTS OF EXPERIMENT 3')
disp('----------------------------------------------')

constants

% Set font type
set(0,'defaultUicontrolFontName','Times New Roman');
set(0,'defaultUitableFontName','Times New Roman');
set(0,'defaultAxesFontName','Times New Roman');
set(0,'defaultTextFontName','Times New Roman');
set(0,'defaultUipanelFontName','Times New Roman');

% Load results from experiments in 2
load('tpt_evolution_per_wlan_ucb.mat');

num_wlans = size(tpt_evolution_per_wlan_ucb, 2);
permanent_throughput = tpt_evolution_per_wlan_ucb(permanentInterval,:);
mean_tpt_per_wlan = mean(permanent_throughput);
std_per_wlan = std(permanent_throughput);


%% HISTOGRAM
fig = figure('pos',[450 400 500 350]);
axes;
axis([1 20 30 70]);    
hist(permanent_throughput(:), 50)
xlabel('Throughput (Mbps)','fontsize', 24)
ylabel('Freq.','fontsize', 24)
set(gca,'FontSize', 22)
axis([0 700 0 5000])
% Save Figure
figName = 'experiment_3_hist_throughput';
savefig(['./Output/' figName '.fig'])
saveas(gcf,['./Output/' figName],'png')
close

%% BOXPLOT
fig = figure('pos',[450 400 500 350]);
axes;
axis([1 20 30 70]);    
boxplot(permanent_throughput(:))
ylabel('Throughput (Mbps)','fontsize', 24)
xlabel('UCB','fontsize', 24)
set(gca,'FontSize', 22)
% Save Figure
figName = 'experiment_3_boxplot';
savefig(['./Output/' figName '.fig'])
saveas(gcf,['./Output/' figName],'png')
close

%% Average throughput experienced per WLAN 
fig = figure('pos',[450 400 500 350]);
axes;
axis([1 20 30 70]);    
ctrs = 1 : num_wlans;
data = [mean_tpt_per_wlan(:)];
figure(1)
hBar = bar(ctrs, data);
for k1 = 1 : size(data, 2)
    ctr(k1,:) = bsxfun(@plus, hBar(1).XData, [hBar(k1).XOffset]');
    ydt(k1,:) = hBar(k1).YData;
end
hold on
errorbar(ctr', ydt', [std_per_wlan(:)], '.r')      
xlabel('WLAN id','fontsize', 24)
ylabel('Mean throughput (Mbps)','fontsize', 24)
set(gca,'FontSize', 22)
axis([0 num_wlans+1 0 2 * max(ind_tpt_optimal_prop_fairness)])
%b2 = bar(1 : num_wlans, [selfish_upper_bound; shared_upper_bound; selfish_upper_bound; shared_upper_bound]', 0.5, 'LineStyle', '--', ...
%     'FaceColor', 'none', 'EdgeColor', 'red', 'LineWidth', 1.5); % 
h2 = plot(0 : num_wlans+1, ind_tpt_optimal_prop_fairness * ones(1, num_wlans+2), 'k--', 'linewidth',2);
legend([hBar, h2],{'UCB', 'Optimal (PF)'});
% Save Figure
figName = 'experiment_3_mean_tpt';
savefig(['./Output/' figName '.fig'])
saveas(gcf,['./Output/' figName],'png')
close 

% Throughput experienced by WLAN A
fig = figure('pos',[450 400 500 350]);
axes;
axis([1 20 30 70]);
plot(1 : totalIterations, tpt_evolution_per_wlan_ucb(:,1));
hold on
xlabel('Iteration','fontsize', 24)
set(gca,'FontSize', 22)
ylabel('Throughput WLAN_{A} (Mbps)','fontsize', 24)
% Save Figure
figName = 'experiment_3_variability';
savefig(['./Output/' figName '.fig'])
saveas(gcf,['./Output/' figName],'png')
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
% Script to plot the results of experiment 2 (Random scenarios)
% This script plots article's Figures 8 and 9

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
disp('PLOT RESULTS OF PART 2: RANDOM SCENARIOS')
disp('-----------------------------------------')

constants

 % Load constatns
load('constants.mat')

% Set font type
set(0,'defaultUicontrolFontName','Times New Roman');
set(0,'defaultUitableFontName','Times New Roman');
set(0,'defaultAxesFontName','Times New Roman');
set(0,'defaultTextFontName','Times New Roman');
set(0,'defaultUipanelFontName','Times New Roman');   

% Variables to store final data to be plotted
plot_agg_tpt = [];          % Mean agg. throughput experienced
plot_std_agg_tpt = [];      % Std of the mean agg. throughput experienced
plot_fairness = [];         % Mean fairness experienced
plot_std_fairness = [];     % Std of the mean fairness experienced
% Variables to store final data to be plotted
plot_agg_tpt_ordered = [];          % Mean agg. throughput experienced
plot_std_agg_tpt_ordered = [];      % Std of the mean agg. throughput experienced
plot_fairness_ordered = [];         % Mean fairness experienced
plot_std_fairness_ordered = [];     % Std of the mean fairness experienced


load('simulation_2_1_workspace.mat')
throughputEvolutionPerWlanEgreedyDefault = throughputEvolutionPerWlanEgreedy;
throughputEvolutionPerWlanExp3Default = throughputEvolutionPerWlanExp3;
throughputEvolutionPerWlanUcbDefault = throughputEvolutionPerWlanUcb;
throughputEvolutionPerWlanTsDefault = throughputEvolutionPerWlanTs;

load('simulation_2_2_workspace.mat')
throughputEvolutionPerWlanEgreedyOrdered = throughputEvolutionPerWlanOEgreedy;
throughputEvolutionPerWlanExp3Ordered = throughputEvolutionPerWlanOExp3;
throughputEvolutionPerWlanUcbOrdered = throughputEvolutionPerWlanOUcb;
throughputEvolutionPerWlanTsOrdered = throughputEvolutionPerWlanOTs;

wlansSizes = [2 4 6 8];

%% COMPUTE THE AV. TPT IN INTERVALS
intervals = [100 500 1000 2500 10000];    
for i = 1 : size(wlansSizes, 2)        
    lastInterval = 0;
    for k = 1 : size(intervals,2)
        for j = 1 : totalScenarios
            % Av. throughput
            mean_average_throughput_per_scenario_egreedy(i,j,k) = ...
                mean(mean(throughputEvolutionPerWlanEgreedyDefault{i,j}(lastInterval+1:intervals(k),:)));
            mean_average_throughput_per_scenario_oegreedy(i,j,k) = ...
                mean(mean(throughputEvolutionPerWlanEgreedyOrdered{i,j}(lastInterval+1:intervals(k),:)));
            mean_average_throughput_per_scenario_exp3(i,j,k) = ...
                mean(mean(throughputEvolutionPerWlanExp3Default{i,j}(lastInterval+1:intervals(k),:)));
            mean_average_throughput_per_scenario_oexp3(i,j,k) = ...
                mean(mean(throughputEvolutionPerWlanExp3Ordered{i,j}(lastInterval+1:intervals(k),:)));
            mean_average_throughput_per_scenario_ucb(i,j,k) = ...
                mean(mean(throughputEvolutionPerWlanUcbDefault{i,j}(lastInterval+1:intervals(k),:)));
            mean_average_throughput_per_scenario_oucb(i,j,k) = ...
                mean(mean(throughputEvolutionPerWlanUcbOrdered{i,j}(lastInterval+1:intervals(k),:)));
            mean_average_throughput_per_scenario_ts(i,j,k) = ...
                mean(mean(throughputEvolutionPerWlanTsDefault{i,j}(lastInterval+1:intervals(k),:)));
            mean_average_throughput_per_scenario_ots(i,j,k) = ...
                mean(mean(throughputEvolutionPerWlanTsOrdered{i,j}(lastInterval+1:intervals(k),:)));
            % Fairness
            std_average_throughput_per_scenario_egreedy(i,j,k) = ...
                mean(std(throughputEvolutionPerWlanEgreedyDefault{i,j}(lastInterval+1:intervals(k),:)'));
            std_average_throughput_per_scenario_oegreedy(i,j,k) = ...
                mean(std(throughputEvolutionPerWlanEgreedyOrdered{i,j}(lastInterval+1:intervals(k),:)'));
            std_average_throughput_per_scenario_exp3(i,j,k) = ...
                mean(std(throughputEvolutionPerWlanExp3Default{i,j}(lastInterval+1:intervals(k),:)'));
            std_average_throughput_per_scenario_oexp3(i,j,k) = ...
                mean(std(throughputEvolutionPerWlanExp3Ordered{i,j}(lastInterval+1:intervals(k),:)'));
            std_average_throughput_per_scenario_ucb(i,j,k) = ...
                mean(std(throughputEvolutionPerWlanUcbDefault{i,j}(lastInterval+1:intervals(k),:)'));
            std_average_throughput_per_scenario_oucb(i,j,k) = ...
                mean(std(throughputEvolutionPerWlanUcbOrdered{i,j}(lastInterval+1:intervals(k),:)'));
            std_average_throughput_per_scenario_ts(i,j,k) = ...
                mean(std(throughputEvolutionPerWlanTsDefault{i,j}(lastInterval+1:intervals(k),:)'));
            std_average_throughput_per_scenario_ots(i,j,k) = ...
                mean(std(throughputEvolutionPerWlanTsOrdered{i,j}(lastInterval+1:intervals(k),:)'));
            % Variability
            var_per_scenario_egreedy(i,j,k) = ...
                mean(std(throughputEvolutionPerWlanEgreedyDefault{i,j}(lastInterval+1:intervals(k),:)));
            var_per_scenario_oegreedy(i,j,k) = ...
                mean(std(throughputEvolutionPerWlanEgreedyOrdered{i,j}(lastInterval+1:intervals(k),:)));
            var_per_scenario_exp3(i,j,k) = ...
                mean(std(throughputEvolutionPerWlanExp3Default{i,j}(lastInterval+1:intervals(k),:)));
            var_per_scenario_oexp3(i,j,k) = ...
                mean(std(throughputEvolutionPerWlanExp3Ordered{i,j}(lastInterval+1:intervals(k),:)));
            var_per_scenario_ucb(i,j,k) = ...
                mean(std(throughputEvolutionPerWlanUcbDefault{i,j}(lastInterval+1:intervals(k),:)));
            var_per_scenario_oucb(i,j,k) = ...
                mean(std(throughputEvolutionPerWlanUcbOrdered{i,j}(lastInterval+1:intervals(k),:)));
            var_per_scenario_ts(i,j,k) = ...
                mean(std(throughputEvolutionPerWlanTsDefault{i,j}(lastInterval+1:intervals(k),:)));
            var_per_scenario_ots(i,j,k) = ...
                mean(std(throughputEvolutionPerWlanTsOrdered{i,j}(lastInterval+1:intervals(k),:)));            
            
        end      
        lastInterval = intervals(k);            
    end        
end

% PLOT
for i = 1 : size(wlansSizes, 2)
    for k = 1 : size(intervals,2)
        % MEAN THROUGHPUT
        % e-greedy (default)
        plot_mean_egreedy(i, k) = mean(mean_average_throughput_per_scenario_egreedy(i,:,k)');
        plot_std_egreedy(i, k) = std(mean_average_throughput_per_scenario_egreedy(i,:,k)'); 
        % exp3 (default)
        plot_mean_exp3(i, k) = mean(mean_average_throughput_per_scenario_exp3(i,:,k)');
        plot_std_exp3(i, k) = std(mean_average_throughput_per_scenario_exp3(i,:,k)'); 
        % ucb (default)
        plot_mean_ucb(i, k) = mean(mean_average_throughput_per_scenario_ucb(i,:,k)');
        plot_std_ucb(i, k) = std(mean_average_throughput_per_scenario_ucb(i,:,k)'); 
        % ts (defaul)
        plot_mean_ts(i, k) = mean(mean_average_throughput_per_scenario_ts(i,:,k)');
        plot_std_ts(i, k) = std(mean_average_throughput_per_scenario_ts(i,:,k)');         
        % e-greedy (ordered)
        plot_mean_oegreedy(i, k) = mean(mean_average_throughput_per_scenario_oegreedy(i,:,k)');
        plot_std_oegreedy(i, k) = std(mean_average_throughput_per_scenario_oegreedy(i,:,k)'); 
        % exp3 (ordered)
        plot_mean_oexp3(i, k) = mean(mean_average_throughput_per_scenario_oexp3(i,:,k)');
        plot_std_oexp3(i, k) = std(mean_average_throughput_per_scenario_oexp3(i,:,k)'); 
        % ucb (ordered)
        plot_mean_oucb(i, k) = mean(mean_average_throughput_per_scenario_oucb(i,:,k)');
        plot_std_oucb(i, k) = std(mean_average_throughput_per_scenario_oucb(i,:,k)'); 
        % ts (ordered)
        plot_mean_ots(i, k) = mean(mean_average_throughput_per_scenario_ots(i,:,k)');
        plot_std_ots(i, k) = std(mean_average_throughput_per_scenario_ots(i,:,k)'); 
        % FAIRNESS
        % e-greedy (default)
        plot_std_egreedy(i, k) = mean(std_average_throughput_per_scenario_egreedy(i,:,k)');
        plot_std_std_egreedy(i, k) = std(std_average_throughput_per_scenario_egreedy(i,:,k)'); 
        % exp3 (default)
        plot_std_exp3(i, k) = mean(std_average_throughput_per_scenario_exp3(i,:,k)');
        plot_std_std_exp3(i, k) = std(std_average_throughput_per_scenario_exp3(i,:,k)'); 
        % ucb (default)
        plot_std_ucb(i, k) = mean(std_average_throughput_per_scenario_ucb(i,:,k)');
        plot_std_std_ucb(i, k) = std(std_average_throughput_per_scenario_ucb(i,:,k)'); 
        % ts (defaul)
        plot_std_ts(i, k) = mean(std_average_throughput_per_scenario_ts(i,:,k)');
        plot_std_std_ts(i, k) = std(std_average_throughput_per_scenario_ts(i,:,k)');         
        % e-greedy (ordered)
        plot_std_oegreedy(i, k) = mean(std_average_throughput_per_scenario_oegreedy(i,:,k)');
        plot_std_std_oegreedy(i, k) = std(std_average_throughput_per_scenario_oegreedy(i,:,k)'); 
        % exp3 (ordered)
        plot_std_oexp3(i, k) = mean(std_average_throughput_per_scenario_oexp3(i,:,k)');
        plot_std_std_oexp3(i, k) = std(std_average_throughput_per_scenario_oexp3(i,:,k)'); 
        % ucb (ordered)
        plot_std_oucb(i, k) = mean(std_average_throughput_per_scenario_oucb(i,:,k)');
        plot_std_std_oucb(i, k) = std(std_average_throughput_per_scenario_oucb(i,:,k)'); 
        % ts (ordered)
        plot_std_ots(i, k) = mean(std_average_throughput_per_scenario_ots(i,:,k)');
        plot_std_std_ots(i, k) = std(std_average_throughput_per_scenario_ots(i,:,k)');
        
        % VARIABILITY
        % e-greedy (default)
        plot_var_egreedy(i, k) = mean(var_per_scenario_egreedy(i,:,k));
        plot_std_var_egreedy(i, k) = std(var_per_scenario_egreedy(i,:,k)); 
        % exp3 (default)
        plot_var_exp3(i, k) = mean(var_per_scenario_exp3(i,:,k));
        plot_std_var_exp3(i, k) = std(var_per_scenario_exp3(i,:,k)); 
        % ucb (default)
        plot_var_ucb(i, k) = mean(var_per_scenario_ucb(i,:,k));
        plot_std_var_ucb(i, k) = std(var_per_scenario_ucb(i,:,k)); 
        % ts (defaul)
        plot_var_ts(i, k) = mean(var_per_scenario_ts(i,:,k));
        plot_std_var_ts(i, k) = std(var_per_scenario_ts(i,:,k));         
        % e-greedy (ordered)
        plot_var_oegreedy(i, k) = mean(var_per_scenario_oegreedy(i,:,k));
        plot_std_var_oegreedy(i, k) = std(var_per_scenario_oegreedy(i,:,k)); 
        % exp3 (ordered)
        plot_var_oexp3(i, k) = mean(var_per_scenario_oexp3(i,:,k));
        plot_std_var_oexp3(i, k) = std(var_per_scenario_oexp3(i,:,k)); 
        % ucb (ordered)
        plot_var_oucb(i, k) = mean(var_per_scenario_oucb(i,:,k));
        plot_std_var_oucb(i, k) = std(var_per_scenario_oucb(i,:,k)); 
        % ts (ordered)
        plot_var_ots(i, k) = mean(var_per_scenario_ots(i,:,k));
        plot_std_var_ots(i, k) = std(var_per_scenario_ots(i,:,k));
        
    end
end

%% Mean average throughput
fig = figure('pos',[800 700 900 600]);
axes;
axis([1 20 30 70]);  
static_results = [104.6279   93.4101   88.8247   83.2425];
for i = 1 : size(wlansSizes, 2)
    subplot(2,2,i)    
    % e-greedy
    plot(1 : size(intervals,2), plot_mean_egreedy(i, :), 's-r', 'LineWidth', 2,'MarkerSize', 10) 
    hold on
    plot(1 : size(intervals,2), plot_mean_oegreedy(i, :), 's--r', 'LineWidth', 2,'MarkerSize', 10) 
    % EXP3
    plot(1 : size(intervals,2), plot_mean_exp3(i, :), 'd-b', 'LineWidth', 2,'MarkerSize', 10) 
    plot(1 : size(intervals,2), plot_mean_oexp3(i, :), 'd--b', 'LineWidth', 2,'MarkerSize', 10) 
    % UCB
    plot(1 : size(intervals,2), plot_mean_ucb(i, :), 'x-g', 'LineWidth', 2,'MarkerSize', 10) 
    plot(1 : size(intervals,2), plot_mean_oucb(i, :), 'x--g', 'LineWidth', 2,'MarkerSize', 10)
    % TS
    plot(1 : size(intervals,2), plot_mean_ts(i, :), 'o-c', 'LineWidth', 2,'MarkerSize', 10) 
    plot(1 : size(intervals,2), plot_mean_ots(i, :), 'o--c', 'LineWidth', 2,'MarkerSize', 10) 
    % Static
    plot(1 : size(intervals,2), static_results(i)*ones(1, size(intervals,2)), 'k--','LineWidth', 3)
    title(['N = ' num2str(wlansSizes(i))])
    xlabel('Learning interval')       
    ylabel('Mean av. throughput (Mbps)')     
    set(gca,'FontSize', 20)
    xticks([1 3 5])
    set(gca,'xticklabel',{'1-100','501-1000','2500-10000'})    
end
legend({'\epsilon-greedy (concurrent)','\epsilon-greedy (sequential)', ...
    'EXP3 (concurrent)', 'EXP3 (sequential)',...
    'UCB (concurrent)', 'UCB (sequential)', ...
    'Thompson s. (concurrent)','Thompson s. (sequential)','Static'})
figName = ['random_scenarios_results'];
savefig(['./Output/' figName '.fig'])
saveas(gcf,['./Output/' figName],'png')

%% Mean variability
fig = figure('pos',[800 700 900 600]);
axes;
axis([1 20 30 70]);  
for i = 1 : size(wlansSizes, 2)
    subplot(2,2,i)    
    % e-greedy
    plot(1 : size(intervals,2), plot_std_egreedy(i, :), 's-r', 'LineWidth', 2,'MarkerSize', 10) 
    hold on
    plot(1 : size(intervals,2), plot_std_oegreedy(i, :), 's--r', 'LineWidth', 2,'MarkerSize', 10) 
    % EXP3
    plot(1 : size(intervals,2), plot_std_exp3(i, :), 'd-b', 'LineWidth', 2,'MarkerSize', 10) 
    plot(1 : size(intervals,2), plot_std_oexp3(i, :), 'd--b', 'LineWidth', 2,'MarkerSize', 10) 
    % UCB
    plot(1 : size(intervals,2), plot_std_ucb(i, :), 'x-g', 'LineWidth', 2,'MarkerSize', 10) 
    plot(1 : size(intervals,2), plot_std_oucb(i, :), 'x--g', 'LineWidth', 2,'MarkerSize', 10)
    % TS
    plot(1 : size(intervals,2), plot_std_ts(i, :), 'o-c', 'LineWidth', 2,'MarkerSize', 10) 
    plot(1 : size(intervals,2), plot_std_ots(i, :), 'o--c', 'LineWidth', 2,'MarkerSize', 10) 
    % Static
    %plot(1 : size(intervals,2), static_results(i)*ones(1, size(intervals,2)), 'k--','LineWidth', 3)
    title(['N = ' num2str(wlansSizes(i))])
    xlabel('Learning interval')       
    ylabel('Mean fairness (Mbps)')     
    set(gca,'FontSize', 20)
    xticks([1 3 5])
    set(gca,'xticklabel',{'1-100','501-1000','2500-10000'})    
end
legend({'\epsilon-greedy (concurrent)','\epsilon-greedy (sequential)', ...
    'EXP3 (concurrent)', 'EXP3 (sequential)',...
    'UCB (concurrent)', 'UCB (sequential)', ...
    'Thompson s. (concurrent)','Thompson s. (sequential)'})
figName = ['random_scenarios_results_variability'];
savefig(['./Output/' figName '.fig'])
saveas(gcf,['./Output/' figName],'png')


%% Mean variability
fig = figure('pos',[800 700 900 600]);
axes;
axis([1 20 30 70]);  
for i = 1 : size(wlansSizes, 2)
    subplot(2,2,i)    
    % e-greedy
    plot(1 : size(intervals,2), plot_var_egreedy(i, :), 's-r', 'LineWidth', 2,'MarkerSize', 10) 
    hold on
    plot(1 : size(intervals,2), plot_var_oegreedy(i, :), 's--r', 'LineWidth', 2,'MarkerSize', 10) 
    % EXP3
    plot(1 : size(intervals,2), plot_var_exp3(i, :), 'd-b', 'LineWidth', 2,'MarkerSize', 10) 
    plot(1 : size(intervals,2), plot_var_oexp3(i, :), 'd--b', 'LineWidth', 2,'MarkerSize', 10) 
    % UCB
    plot(1 : size(intervals,2), plot_var_ucb(i, :), 'x-g', 'LineWidth', 2,'MarkerSize', 10) 
    plot(1 : size(intervals,2), plot_var_oucb(i, :), 'x--g', 'LineWidth', 2,'MarkerSize', 10)
    % TS
    plot(1 : size(intervals,2), plot_var_ts(i, :), 'o-c', 'LineWidth', 2,'MarkerSize', 10) 
    plot(1 : size(intervals,2), plot_var_ots(i, :), 'o--c', 'LineWidth', 2,'MarkerSize', 10) 
    % Static
    %plot(1 : size(intervals,2), static_results(i)*ones(1, size(intervals,2)), 'k--','LineWidth', 3)
    title(['N = ' num2str(wlansSizes(i))])
    xlabel('Learning interval')       
    ylabel('Mean variability (Mbps)')     
    set(gca,'FontSize', 20)
    xticks([1 3 5])
    set(gca,'xticklabel',{'1-100','501-1000','2500-10000'})    
end
legend({'\epsilon-greedy (concurrent)','\epsilon-greedy (sequential)', ...
    'EXP3 (concurrent)', 'EXP3 (sequential)',...
    'UCB (concurrent)', 'UCB (sequential)', ...
    'Thompson s. (concurrent)','Thompson s. (sequential)'})
figName = ['random_scenarios_results_variability'];
savefig(['./Output/' figName '.fig'])
saveas(gcf,['./Output/' figName],'png')
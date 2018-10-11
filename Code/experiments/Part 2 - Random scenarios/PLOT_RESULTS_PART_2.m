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
disp('PLOT RESULTS OF PART 2: RANDOM SCENARIO (default vs sync. algs.)')
disp('----------------------------------------------')

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


load('simulation_2_1_workspace')
throughputEvolutionPerWlanEgreedyDefault = throughputEvolutionPerWlanEgreedy;
throughputEvolutionPerWlanExp3Default = throughputEvolutionPerWlanExp3;
throughputEvolutionPerWlanUcbDefault = throughputEvolutionPerWlanUcb;
throughputEvolutionPerWlanTsDefault = throughputEvolutionPerWlanTs;

load('simulation_2_2_workspace')
throughputEvolutionPerWlanEgreedyOrdered = throughputEvolutionPerWlanOEgreedy;
throughputEvolutionPerWlanExp3Ordered = throughputEvolutionPerWlanOExp3;
throughputEvolutionPerWlanUcbOrdered = throughputEvolutionPerWlanOUcb;
throughputEvolutionPerWlanTsOrdered = throughputEvolutionPerWlanOTs;

wlansSizes = [2 4 6 8];

% For each size of wlans, process data to be plotted
for s = 1 : size(wlansSizes, 2)
    for r = 1 : totalScenarios
        % Agg tpt - default
        meanAggTptSingleSimulationEgreedy(r) = mean(sum(throughputEvolutionPerWlanEgreedyDefault{s, r}(permanentInterval, :)'));
        meanAggTptSingleSimulationExp3(r) = mean(sum(throughputEvolutionPerWlanExp3Default{s, r}(permanentInterval, :)'));
        meanAggTptSingleSimulationUcb(r) = mean(sum(throughputEvolutionPerWlanUcbDefault{s, r}(permanentInterval, :)'));
        meanAggTptSingleSimulationTs(r) = mean(sum(throughputEvolutionPerWlanTsDefault{s, r}(permanentInterval, :)'));
        % Fairness - default
        meanFairnessSingleSimulationEgreedy(r) = mean(jains_fairness(throughputEvolutionPerWlanEgreedyDefault{s, r}(permanentInterval, :)));
        meanFairnessSingleSimulationExp3(r) = mean(jains_fairness(throughputEvolutionPerWlanExp3Default{s, r}(permanentInterval, :)));
        meanFairnessSingleSimulationUcb(r) = mean(jains_fairness(throughputEvolutionPerWlanUcbDefault{s, r}(permanentInterval, :)));
        meanFairnessSingleSimulationTs(r) = mean(jains_fairness(throughputEvolutionPerWlanTsDefault{s, r}(permanentInterval, :)));
        % Agg tpt - ordered
        meanAggTptSingleSimulationOEgreedy(r) = mean(sum(throughputEvolutionPerWlanEgreedyOrdered{s, r}(permanentInterval, :)'));
        meanAggTptSingleSimulationOExp3(r) = mean(sum(throughputEvolutionPerWlanExp3Ordered{s, r}(permanentInterval, :)'));
        meanAggTptSingleSimulationOUcb(r) = mean(sum(throughputEvolutionPerWlanUcbOrdered{s, r}(permanentInterval, :)'));
        meanAggTptSingleSimulationOTs(r) = mean(sum(throughputEvolutionPerWlanTsOrdered{s, r}(permanentInterval, :)'));
        % Fairness - ordered
        meanFairnessSingleSimulationOEgreedy(r) = mean(jains_fairness(throughputEvolutionPerWlanEgreedyOrdered{s, r}(permanentInterval, :)));
        meanFairnessSingleSimulationOExp3(r) = mean(jains_fairness(throughputEvolutionPerWlanExp3Ordered{s, r}(permanentInterval, :)));
        meanFairnessSingleSimulationOUcb(r) = mean(jains_fairness(throughputEvolutionPerWlanUcbOrdered{s, r}(permanentInterval, :)));
        meanFairnessSingleSimulationOTs(r) = mean(jains_fairness(throughputEvolutionPerWlanTsOrdered{s, r}(permanentInterval, :)));

    end

    % Default
    meanAggTptTotalRepetitionsEgreedy(s) = mean(meanAggTptSingleSimulationEgreedy);
    meanAggTptTotalRepetitionsExp3(s) = mean(meanAggTptSingleSimulationExp3);
    meanAggTptTotalRepetitionsUcb(s) = mean(meanAggTptSingleSimulationUcb);
    meanAggTptTotalRepetitionsTs(s) = mean(meanAggTptSingleSimulationTs);

    stdAggTptTotalRepetitionsEgreedy(s) = std(meanAggTptSingleSimulationEgreedy);
    stdAggTptTotalRepetitionsExp3(s) = std(meanAggTptSingleSimulationExp3);
    stdAggTptTotalRepetitionsUcb(s) = std(meanAggTptSingleSimulationUcb);
    stdAggTptTotalRepetitionsTs(s) = std(meanAggTptSingleSimulationTs);

    meanFairnessTotalRepetitionsEgreedy(s) = mean(meanFairnessSingleSimulationEgreedy);
    meanFairnessTotalRepetitionsExp3(s) = mean(meanFairnessSingleSimulationExp3);
    meanFairnessTotalRepetitionsUcb(s) = mean(meanFairnessSingleSimulationUcb);
    meanFairnessTotalRepetitionsTs(s) = mean(meanFairnessSingleSimulationTs);

    stdFairnessTotalRepetitionsEgreedy(s) = std(meanFairnessSingleSimulationEgreedy);
    stdFairnessTotalRepetitionsExp3(s) = std(meanFairnessSingleSimulationExp3);
    stdFairnessTotalRepetitionsUcb(s) = std(meanFairnessSingleSimulationUcb);
    stdFairnessTotalRepetitionsTs(s) = std(meanFairnessSingleSimulationTs);
    
    plot_agg_tpt = [plot_agg_tpt; [...
        meanAggTptTotalRepetitionsEgreedy(s) meanAggTptTotalRepetitionsExp3(s) ...
        meanAggTptTotalRepetitionsUcb(s) meanAggTptTotalRepetitionsTs(s)]];

    plot_std_agg_tpt = [plot_std_agg_tpt; [...
        stdAggTptTotalRepetitionsEgreedy(s) stdAggTptTotalRepetitionsExp3(s) ...
        stdAggTptTotalRepetitionsUcb(s) stdAggTptTotalRepetitionsTs(s)]];

    plot_fairness = [plot_fairness; [...
        meanFairnessTotalRepetitionsEgreedy(s) meanFairnessTotalRepetitionsExp3(s) ...
        meanFairnessTotalRepetitionsUcb(s) meanFairnessTotalRepetitionsTs(s)]];

    plot_std_fairness = [plot_std_fairness; [...
        stdFairnessTotalRepetitionsEgreedy(s) stdFairnessTotalRepetitionsExp3(s) ...
        stdFairnessTotalRepetitionsUcb(s) stdFairnessTotalRepetitionsTs(s)]];
    
    % Ordered
    meanAggTptTotalRepetitionsOEgreedy(s) = mean(meanAggTptSingleSimulationOEgreedy);
    meanAggTptTotalRepetitionsOExp3(s) = mean(meanAggTptSingleSimulationOExp3);
    meanAggTptTotalRepetitionsOUcb(s) = mean(meanAggTptSingleSimulationOUcb);
    meanAggTptTotalRepetitionsOTs(s) = mean(meanAggTptSingleSimulationOTs);

    stdAggTptTotalRepetitionsOEgreedy(s) = std(meanAggTptSingleSimulationOEgreedy);
    stdAggTptTotalRepetitionsOExp3(s) = std(meanAggTptSingleSimulationOExp3);
    stdAggTptTotalRepetitionsOUcb(s) = std(meanAggTptSingleSimulationOUcb);
    stdAggTptTotalRepetitionsOTs(s) = std(meanAggTptSingleSimulationOTs);

    meanFairnessTotalRepetitionsOEgreedy(s) = mean(meanFairnessSingleSimulationOEgreedy);
    meanFairnessTotalRepetitionsOExp3(s) = mean(meanFairnessSingleSimulationOExp3);
    meanFairnessTotalRepetitionsOUcb(s) = mean(meanFairnessSingleSimulationOUcb);
    meanFairnessTotalRepetitionsOTs(s) = mean(meanFairnessSingleSimulationOTs);

    stdFairnessTotalRepetitionsOEgreedy(s) = std(meanFairnessSingleSimulationOEgreedy);
    stdFairnessTotalRepetitionsOExp3(s) = std(meanFairnessSingleSimulationOExp3);
    stdFairnessTotalRepetitionsOUcb(s) = std(meanFairnessSingleSimulationOUcb);
    stdFairnessTotalRepetitionsOTs(s) = std(meanFairnessSingleSimulationOTs);

    plot_agg_tpt_ordered = [plot_agg_tpt_ordered; [...
        meanAggTptTotalRepetitionsOEgreedy(s) meanAggTptTotalRepetitionsOExp3(s) ...
        meanAggTptTotalRepetitionsOUcb(s) meanAggTptTotalRepetitionsOTs(s)]];

    plot_std_agg_tpt_ordered = [plot_std_agg_tpt_ordered; [...
        stdAggTptTotalRepetitionsOEgreedy(s) stdAggTptTotalRepetitionsOExp3(s) ...
        stdAggTptTotalRepetitionsOUcb(s) stdAggTptTotalRepetitionsOTs(s)]];

    plot_fairness_ordered = [plot_fairness_ordered; [...
        meanFairnessTotalRepetitionsOEgreedy(s) meanFairnessTotalRepetitionsOExp3(s) ...
        meanFairnessTotalRepetitionsOUcb(s) meanFairnessTotalRepetitionsOTs(s)]];

    plot_std_fairness_ordered = [plot_std_fairness_ordered; [...
        stdFairnessTotalRepetitionsOEgreedy(s) stdFairnessTotalRepetitionsOExp3(s) ...
        stdFairnessTotalRepetitionsOUcb(s) stdFairnessTotalRepetitionsOTs(s)]];     

end

%% PLOT HISTOGRAM AVERAGE INDIVIDUAL THROUGHPUT LAST 5000 ITERATIONS (ONLY 8 WNs)
%meanThroughputPerWlanRandomConcat = cell(1, size(wlansSizes, 2));
meanThroughputPerWlanEgreedyConcat = cell(1, size(wlansSizes, 2));
meanThroughputPerWlanExp3Concat = cell(1, size(wlansSizes, 2));
meanThroughputPerWlanUcbConcat = cell(1, size(wlansSizes, 2));
meanThroughputPerWlanTsConcat = cell(1, size(wlansSizes, 2));

meanThroughputPerWlanOEgreedyConcat = cell(1, size(wlansSizes, 2));
meanThroughputPerWlanOExp3Concat = cell(1, size(wlansSizes, 2));
meanThroughputPerWlanOUcbConcat = cell(1, size(wlansSizes, 2));
meanThroughputPerWlanOTsConcat = cell(1, size(wlansSizes, 2));

% Std of the experienced throughput for each WN in the last iterations and for each repetition
%stdForEachRepetitionRandom = cell(1, size(wlansSizes, 2));
stdForEachRepetitionEg = cell(1, size(wlansSizes, 2));
stdForEachRepetitionEXP3 = cell(1, size(wlansSizes, 2));
stdForEachRepetitionUCB = cell(1, size(wlansSizes, 2));
stdForEachRepetitionTS = cell(1, size(wlansSizes, 2));

stdForEachRepetitionOEg = cell(1, size(wlansSizes, 2));
stdForEachRepetitionOEXP3 = cell(1, size(wlansSizes, 2));
stdForEachRepetitionOUCB = cell(1, size(wlansSizes, 2));
stdForEachRepetitionOTS = cell(1, size(wlansSizes, 2));

for s = 1 : size(wlansSizes, 2)

    for r = 1 : totalScenarios
        % DEFAULT
        % e-greedy
        meanThroughputPerWlanEgreedyConcat{s}(r, :) = ...
            mean(throughputEvolutionPerWlanEgreedyDefault{s, r}(permanentInterval, :));
        stdForEachRepetitionEg{s}(r, :) = ...
            std(throughputEvolutionPerWlanEgreedyDefault{s, r}(permanentInterval, :));
        % EXP3
        meanThroughputPerWlanExp3Concat{s}(r, :) = ...
            mean(throughputEvolutionPerWlanExp3Default{s, r}(permanentInterval, :));
        stdForEachRepetitionEXP3{s}(r, :) = ...
            std(throughputEvolutionPerWlanExp3Default{s, r}(permanentInterval, :));
        % UCB
        meanThroughputPerWlanUcbConcat{s}(r, :) = ...
            mean(throughputEvolutionPerWlanUcbDefault{s, r}(permanentInterval, :));
        stdForEachRepetitionUCB{s}(r, :) = ...
            std(throughputEvolutionPerWlanUcbDefault{s, r}(permanentInterval, :));
        % TS
        meanThroughputPerWlanTsConcat{s}(r, :) = ...
            mean(throughputEvolutionPerWlanTsDefault{s, r}(permanentInterval, :));
        stdForEachRepetitionTS{s}(r, :) = ...
            std(throughputEvolutionPerWlanTsDefault{s, r}(permanentInterval, :));
        
        % ORDERED
        % e-greedy
        meanThroughputPerWlanOEgreedyConcat{s}(r, :) = ...
            mean(throughputEvolutionPerWlanEgreedyOrdered{s, r}(permanentInterval, :));
        stdForEachRepetitionEg{s}(r, :) = ...
            std(throughputEvolutionPerWlanEgreedyOrdered{s, r}(permanentInterval, :));
        % EXP3
        meanThroughputPerWlanOExp3Concat{s}(r, :) = ...
            mean(throughputEvolutionPerWlanExp3Ordered{s, r}(permanentInterval, :));
        stdForEachRepetitionEXP3{s}(r, :) = ...
            std(throughputEvolutionPerWlanExp3Ordered{s, r}(permanentInterval, :));
        % UCB
        meanThroughputPerWlanOUcbConcat{s}(r, :) = ...
            mean(throughputEvolutionPerWlanUcbOrdered{s, r}(permanentInterval, :));
        stdForEachRepetitionUCB{s}(r, :) = ...
            std(throughputEvolutionPerWlanUcbOrdered{s, r}(permanentInterval, :));
        % TS
        meanThroughputPerWlanOTsConcat{s}(r, :) = ...
            mean(throughputEvolutionPerWlanTsOrdered{s, r}(permanentInterval, :));
        stdForEachRepetitionTS{s}(r, :) = ...
            std(throughputEvolutionPerWlanTsOrdered{s, r}(permanentInterval, :));
    end

end

%size_ix = 4;

%% Throughput experienced by each WLAN for each iteration
for i = 1 : size(wlansSizes, 2)
    h_eg = hist(meanThroughputPerWlanEgreedyConcat{i}(:), 30);
    h_exp3 = hist(meanThroughputPerWlanExp3Concat{i}(:), 30);
    h_ucb = hist(meanThroughputPerWlanUcbConcat{i}(:), 30);
    h_ts = hist(meanThroughputPerWlanTsConcat{i}(:), 30);
    
    h_oeg = hist(meanThroughputPerWlanOEgreedyConcat{i}(:), 30);
    h_oexp3 = hist(meanThroughputPerWlanOExp3Concat{i}(:), 30);
    h_oucb = hist(meanThroughputPerWlanOUcbConcat{i}(:), 30);
    h_ots = hist(meanThroughputPerWlanOTsConcat{i}(:), 30);

    max_counts = max(max(max([h_eg h_exp3 h_ucb h_ts])), max(max([h_oeg h_oexp3 h_oucb h_ots]))); 

    max_tpt = max(max([meanThroughputPerWlanEgreedyConcat{i}(:) ...
        meanThroughputPerWlanExp3Concat{i}(:), ...
        meanThroughputPerWlanUcbConcat{i}(:), ...
        meanThroughputPerWlanTsConcat{i}(:), ...
        meanThroughputPerWlanOEgreedyConcat{i}(:) ...
        meanThroughputPerWlanOExp3Concat{i}(:), ...
        meanThroughputPerWlanOUcbConcat{i}(:), ...
        meanThroughputPerWlanOTsConcat{i}(:)]));

    fig = figure('pos',[450 400 500 350]);
    axes;
    axis([1 20 30 70]);
    set(gca, 'FontSize', 18)

    subplot(2, 2, 1)
    hist(meanThroughputPerWlanEgreedyConcat{i}(:), 30);
    h = findobj(gca,'Type','patch');
    set(h,'FaceColor','r','facealpha',1)
    hold on;
    hist(meanThroughputPerWlanOEgreedyConcat{i}(:), 30, 'r', 'FaceAlpha', 0.5);  
    h2 = findobj(gca,'Type','patch');
    set(h2,'EdgeColor','w','facealpha',0.5);
    title('\epsilon-greedy')
    set(gca, 'FontSize', 18)
    axis([0 max_tpt * 1.1 0 max_counts * 1.1])

    % EXP3
    subplot(2, 2, 2)        
    hist(meanThroughputPerWlanExp3Concat{i}(:), 30);   
    h = findobj(gca,'Type','patch');
    set(h,'FaceColor','r','facealpha',1) 
    hold on;
    hist(meanThroughputPerWlanOExp3Concat{i}(:), 30, 'r', 'FaceAlpha', 0.5); 
    h2 = findobj(gca,'Type','patch');
    set(h2,'EdgeColor','w','facealpha',0.5);
    title('EXP3')
    set(gca, 'FontSize', 18)
    axis([0 max_tpt * 1.1 0 max_counts * 1.1])

    % UCB
    subplot(2, 2, 3)
    hist(meanThroughputPerWlanUcbConcat{i}(:), 30);
    h = findobj(gca,'Type','patch');
    set(h,'FaceColor','r','EdgeColor','w','facealpha',1) 
    hold on;
    hist(meanThroughputPerWlanOUcbConcat{i}(:), 30);  
    h2 = findobj(gca,'Type','patch');
    set(h2,'EdgeColor','w','facealpha',0.5);
    title('UCB')
    set(gca, 'FontSize', 18)
    axis([0 max_tpt * 1.1 0 max_counts * 1.1])

    % TS
    subplot(2, 2, 4)
    hist(meanThroughputPerWlanTsConcat{i}(:), 30);
    h = findobj(gca,'Type','patch');
    set(h,'FaceColor','r','facealpha',1)
    hold on;
    hist(meanThroughputPerWlanOTsConcat{i}(:), 30, 'r', 'FaceAlpha', 0.5); 
    h2 = findobj(gca,'Type','patch');
    set(h2,'EdgeColor','w','facealpha',0.5);
    title('Thompson s.')
    set(gca, 'FontSize', 18) 
    axis([0 max_tpt * 1.1 0 max_counts * 1.1])

    % Legend
    legend('Async.','Sync.')
    %legend('Default','More actions')
    % Set Axes labels
    AxesH    = findobj(fig, 'Type', 'Axes');       
    % Y-label
    YLabelHC = get(AxesH, 'YLabel');
    YLabelH  = [YLabelHC{:}];
    set(YLabelH, 'String', 'Counts')
    % X-label
    XLabelHC = get(AxesH, 'XLabel');
    XLabelH  = [XLabelHC{:}];
    set(XLabelH, 'String', 'Throughput (Mbps)') 
    % Save Figure
    fig_name = ['hist_mean_tpt_' num2str(wlansSizes(i)) '_WNs'];
    savefig(['./Output/' fig_name '.fig'])
    saveas(gcf,['./Output/' fig_name],'epsc') 
end

% STD of the temporal throughput per WN    
for s = 1 : size(wlansSizes, 2)

    %std_temporal_tpt_random = [];    
    std_temporal_tpt_eg = [];
    std_temporal_tpt_exp3 = [];
    std_temporal_tpt_ucb = [];
    std_temporal_tpt_ts = [];
    
    std_temporal_tpt_oeg = [];
    std_temporal_tpt_oexp3 = [];
    std_temporal_tpt_oucb = [];
    std_temporal_tpt_ots = [];

    for r = 1 : totalScenarios

        %std_temporal_tpt_random = [std_temporal_tpt_random; std(throughputEvolutionPerWlanRandom{s, r})];
        std_temporal_tpt_eg = [std_temporal_tpt_eg; std(throughputEvolutionPerWlanEgreedyDefault{s, r})];
        std_temporal_tpt_exp3 = [std_temporal_tpt_exp3; std(throughputEvolutionPerWlanExp3Default{s, r})];
        std_temporal_tpt_ucb = [std_temporal_tpt_ucb; std(throughputEvolutionPerWlanUcbDefault{s, r})];
        std_temporal_tpt_ts = [std_temporal_tpt_ts; std(throughputEvolutionPerWlanTsDefault{s, r})];
        
        std_temporal_tpt_oeg = [std_temporal_tpt_oeg; std(throughputEvolutionPerWlanEgreedyOrdered{s, r})];
        std_temporal_tpt_oexp3 = [std_temporal_tpt_oexp3; std(throughputEvolutionPerWlanExp3Ordered{s, r})];
        std_temporal_tpt_oucb = [std_temporal_tpt_oucb; std(throughputEvolutionPerWlanUcbOrdered{s, r})];
        std_temporal_tpt_ots = [std_temporal_tpt_ots; std(throughputEvolutionPerWlanTsOrdered{s, r})];

    end

%         mean_std_random = mean(std_temporal_tpt_random)
%         mean_mean_std_random = mean(mean(std_temporal_tpt_random))

    disp('DEFAULT')
    mean_std_eg = mean(std_temporal_tpt_eg)
    mean_mean_std_eg = mean(mean(std_temporal_tpt_eg))

    mean_std_exp3 = mean(std_temporal_tpt_exp3)
    mean_mean_std_exp3 = mean(mean(std_temporal_tpt_exp3))

    mean_std_ucb = mean(std_temporal_tpt_ucb)
    mean_mean_std_ucb = mean(mean(std_temporal_tpt_ucb))


    mean_std_ts = mean(std_temporal_tpt_ts)
    mean_mean_std_ts = mean(mean(std_temporal_tpt_ts))
    
    disp('ORDERED')
    mean_std_oeg = mean(std_temporal_tpt_oeg)
    mean_mean_std_oeg = mean(mean(std_temporal_tpt_oeg))

    mean_std_oexp3 = mean(std_temporal_tpt_oexp3)
    mean_mean_std_oexp3 = mean(mean(std_temporal_tpt_oexp3))

    mean_std_oucb = mean(std_temporal_tpt_oucb)
    mean_mean_std_oucb = mean(mean(std_temporal_tpt_oucb))


    mean_std_ots = mean(std_temporal_tpt_ots)
    mean_mean_std_ots = mean(mean(std_temporal_tpt_ots))

end
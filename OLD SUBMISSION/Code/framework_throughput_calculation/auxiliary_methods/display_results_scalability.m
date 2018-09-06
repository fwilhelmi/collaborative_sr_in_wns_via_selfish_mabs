%%% ************************************************************************
%%% * Collaborative Spatial Reuse in Wireless Networks via Selfish MABs    *
%%% * Author: Francesc Wilhelmi (francesc.wilhelmi@upf.edu)                *
%%% * Co-authors: C. Cano, G. Neu, B. Bellalta, A. Jonsson & S. Barrachina *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi          *
%%% * GitHub repository:                                                   *
%%% *   https://github.com/wn-upf/Collaborative_SR_in_WNs_via_Selfish_MABs *
%%% * More info on https://www.upf.edu/en/web/fwilhelmi                    *
%%% ************************************************************************

function [] = display_results_scalability( wlansSizes, throughputEvolutionPerWlanEgreedy, ...
    throughputEvolutionPerWlanExp3, throughputEvolutionPerWlanUcb, throughputEvolutionPerWlanTs)
% display_results_scalability displays the results of
% "Experiment_1_Performance_Comparison_Random_Network.m"
%   INPUT: 
%       * wlansSizes - array containing each size of WLANs (e.g. [2 4 6 8])
%       * throughputEvolutionPerWlanEgreedy - cell containing, for each
%       repetition, the results of applying the "e-greedy" strategy
%       * throughputEvolutionPerWlanExp3 - cell containing, for each
%       repetition, the results of applying the "EXP3" strategy
%       * throughputEvolutionPerWlanUcb - cell containing, for each
%       repetition, the results of applying the "UCB" strategy
%       * throughputEvolutionPerWlanTs - cell containing, for each
%       repetition, the results of applying the "TS" strategy

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
        
    % For each size of wlans, process data to be plotted
    for s = 1 : size(wlansSizes, 2)
        
        for r = 1 : totalRepetitions

            %meanAggTptSingleSimulationRandom(r) = mean(sum(throughputEvolutionPerWlanRandom{s, r}(permanentInterval, :)'));
            meanAggTptSingleSimulationEgreedy(r) = mean(sum(throughputEvolutionPerWlanEgreedy{s, r}(permanentInterval, :)'));
            meanAggTptSingleSimulationExp3(r) = mean(sum(throughputEvolutionPerWlanExp3{s, r}(permanentInterval, :)'));
            meanAggTptSingleSimulationUcb(r) = mean(sum(throughputEvolutionPerWlanUcb{s, r}(permanentInterval, :)'));
            meanAggTptSingleSimulationTs(r) = mean(sum(throughputEvolutionPerWlanTs{s, r}(permanentInterval, :)'));
            
            %meanFairnessSingleSimulationRandom(r) = mean(jains_fairness(throughputEvolutionPerWlanRandom{s, r}(permanentInterval, :)));
            meanFairnessSingleSimulationEgreedy(r) = mean(jains_fairness(throughputEvolutionPerWlanEgreedy{s, r}(permanentInterval, :)));
            meanFairnessSingleSimulationExp3(r) = mean(jains_fairness(throughputEvolutionPerWlanExp3{s, r}(permanentInterval, :)));
            meanFairnessSingleSimulationUcb(r) = mean(jains_fairness(throughputEvolutionPerWlanUcb{s, r}(permanentInterval, :)));
            meanFairnessSingleSimulationTs(r) = mean(jains_fairness(throughputEvolutionPerWlanTs{s, r}(permanentInterval, :)));

        end
        
        %meanAggTptTotalRepetitionsRandom(s) = mean(meanAggTptSingleSimulationRandom);
        meanAggTptTotalRepetitionsEgreedy(s) = mean(meanAggTptSingleSimulationEgreedy);
        meanAggTptTotalRepetitionsExp3(s) = mean(meanAggTptSingleSimulationExp3);
        meanAggTptTotalRepetitionsUcb(s) = mean(meanAggTptSingleSimulationUcb);
        meanAggTptTotalRepetitionsTs(s) = mean(meanAggTptSingleSimulationTs);
        
        %stdAggTptTotalRepetitionsRandom(s) = std(meanAggTptSingleSimulationRandom);
        stdAggTptTotalRepetitionsEgreedy(s) = std(meanAggTptSingleSimulationEgreedy);
        stdAggTptTotalRepetitionsExp3(s) = std(meanAggTptSingleSimulationExp3);
        stdAggTptTotalRepetitionsUcb(s) = std(meanAggTptSingleSimulationUcb);
        stdAggTptTotalRepetitionsTs(s) = std(meanAggTptSingleSimulationTs);
        
        %meanFairnessTotalRepetitionsRandom(s) = mean(meanFairnessSingleSimulationRandom);
        meanFairnessTotalRepetitionsEgreedy(s) = mean(meanFairnessSingleSimulationEgreedy);
        meanFairnessTotalRepetitionsExp3(s) = mean(meanFairnessSingleSimulationExp3);
        meanFairnessTotalRepetitionsUcb(s) = mean(meanFairnessSingleSimulationUcb);
        meanFairnessTotalRepetitionsTs(s) = mean(meanFairnessSingleSimulationTs);
        
        %stdFairnessTotalRepetitionsRandom(s) = std(meanFairnessSingleSimulationRandom);
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
        
    end
      
    %% PLOT HISTOGRAM AVERAGE INDIVIDUAL THROUGHPUT LAST 5000 ITERATIONS (ONLY 8 WNs)
    %meanThroughputPerWlanRandomConcat = cell(1, size(wlansSizes, 2));
    meanThroughputPerWlanEgreedyConcat = cell(1, size(wlansSizes, 2));
    meanThroughputPerWlanExp3Concat = cell(1, size(wlansSizes, 2));
    meanThroughputPerWlanUcbConcat = cell(1, size(wlansSizes, 2));
    meanThroughputPerWlanTsConcat = cell(1, size(wlansSizes, 2));
    
    % Std of the experienced throughput for each WN in the last iterations and for each repetition
    %stdForEachRepetitionRandom = cell(1, size(wlansSizes, 2));
    stdForEachRepetitionEg = cell(1, size(wlansSizes, 2));
    stdForEachRepetitionEXP3 = cell(1, size(wlansSizes, 2));
    stdForEachRepetitionUCB = cell(1, size(wlansSizes, 2));
    stdForEachRepetitionTS = cell(1, size(wlansSizes, 2));
    
    for s = 1 : size(wlansSizes, 2)
        
        for r = 1 : totalRepetitions
            % Random
            %meanThroughputPerWlanRandomConcat{s}(r, :) = ...
            %    mean(throughputEvolutionPerWlanRandom{s, r}(permanentInterval, :));
            %stdForEachRepetitionRandom{s}(r, :) = ...
            %     std(throughputEvolutionPerWlanRandom{s, r}(permanentInterval, :));
            % e-greedy
            meanThroughputPerWlanEgreedyConcat{s}(r, :) = ...
                mean(throughputEvolutionPerWlanEgreedy{s, r}(permanentInterval, :));
            stdForEachRepetitionEg{s}(r, :) = ...
                std(throughputEvolutionPerWlanEgreedy{s, r}(permanentInterval, :));
            % EXP3
            meanThroughputPerWlanExp3Concat{s}(r, :) = ...
                mean(throughputEvolutionPerWlanExp3{s, r}(permanentInterval, :));
            stdForEachRepetitionEXP3{s}(r, :) = ...
                std(throughputEvolutionPerWlanExp3{s, r}(permanentInterval, :));
            % UCB
            meanThroughputPerWlanUcbConcat{s}(r, :) = ...
                mean(throughputEvolutionPerWlanUcb{s, r}(permanentInterval, :));
            stdForEachRepetitionUCB{s}(r, :) = ...
                std(throughputEvolutionPerWlanUcb{s, r}(permanentInterval, :));
            % TS
            meanThroughputPerWlanTsConcat{s}(r, :) = ...
                mean(throughputEvolutionPerWlanTs{s, r}(permanentInterval, :));
            stdForEachRepetitionTS{s}(r, :) = ...
                std(throughputEvolutionPerWlanTs{s, r}(permanentInterval, :));
        end
        
    end
    
    %size_ix = 4;
    
    %% Throughput experienced by each WLAN for each iteration

    for i = 1 : size(wlansSizes, 2)
        h_eg = hist(meanThroughputPerWlanEgreedyConcat{i}(:), 30);
        h_exp3 = hist(meanThroughputPerWlanExp3Concat{i}(:), 30);
        h_ucb = hist(meanThroughputPerWlanUcbConcat{i}(:), 30);
        h_ts = hist(meanThroughputPerWlanTsConcat{i}(:), 30);
        
        max_counts = max(max([h_eg h_exp3 h_ucb h_ts])); 
        
        max_tpt = max(max([meanThroughputPerWlanEgreedyConcat{i}(:) ...
            meanThroughputPerWlanExp3Concat{i}(:), ...
            meanThroughputPerWlanUcbConcat{i}(:), ...
            meanThroughputPerWlanTsConcat{i}(:)]));

        fig = figure('pos',[450 400 500 350]);
        axes;
        axis([1 20 30 70]);
        set(gca, 'FontSize', 18)
        
        subplot(2, 2, 1)
        hist(meanThroughputPerWlanEgreedyConcat{i}(:), 30);       
        hold on;
        title('e-greedy')
        set(gca, 'FontSize', 18)
        axis([0 max_tpt * 1.1 0 max_counts * 1.1])
               
        % EXP3
        subplot(2, 2, 2)        
        hist(meanThroughputPerWlanExp3Concat{i}(:), 30);   
        hold on;
        title('EXP3')
        set(gca, 'FontSize', 18)
        axis([0 max_tpt * 1.1 0 max_counts * 1.1])
        
        % UCB
        subplot(2, 2, 3)
        hist(meanThroughputPerWlanUcbConcat{i}(:), 30);
        hold on;
        title('UCB')
        set(gca, 'FontSize', 18)
        axis([0 max_tpt * 1.1 0 max_counts * 1.1])
        
        % TS
        subplot(2, 2, 4)
        hist(meanThroughputPerWlanTsConcat{i}(:), 30);
        hold on;
        title('Thompson s.')
        set(gca, 'FontSize', 18) 
        axis([0 max_tpt * 1.1 0 max_counts * 1.1])
                
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

        for r = 1 : totalRepetitions

            %std_temporal_tpt_random = [std_temporal_tpt_random; std(throughputEvolutionPerWlanRandom{s, r})];
            std_temporal_tpt_eg = [std_temporal_tpt_eg; std(throughputEvolutionPerWlanEgreedy{s, r})];
            std_temporal_tpt_exp3 = [std_temporal_tpt_exp3; std(throughputEvolutionPerWlanExp3{s, r})];
            std_temporal_tpt_ucb = [std_temporal_tpt_ucb; std(throughputEvolutionPerWlanUcb{s, r})];
            std_temporal_tpt_ts = [std_temporal_tpt_ts; std(throughputEvolutionPerWlanTs{s, r})];

        end

%         mean_std_random = mean(std_temporal_tpt_random)
%         mean_mean_std_random = mean(mean(std_temporal_tpt_random))

        mean_std_eg = mean(std_temporal_tpt_eg)
        mean_mean_std_eg = mean(mean(std_temporal_tpt_eg))

        mean_std_exp3 = mean(std_temporal_tpt_exp3)
        mean_mean_std_exp3 = mean(mean(std_temporal_tpt_exp3))

        mean_std_ucb = mean(std_temporal_tpt_ucb)
        mean_mean_std_ucb = mean(mean(std_temporal_tpt_ucb))


        mean_std_ts = mean(std_temporal_tpt_ts)
        mean_mean_std_ts = mean(mean(std_temporal_tpt_ts))
        
    end
    
    
    save('./Output/scalability_results.mat')
       
end
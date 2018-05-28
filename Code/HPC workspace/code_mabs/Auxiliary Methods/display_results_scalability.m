[%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exploiting Spatial Reuse in Wireless Networks through Decentralised MABs
% F. Wilhelmi, B. Bellalta, A. Jonsson, C. Cano, G. Neu, S. Barrachina
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = display_results_scalability( wlansSizes, throughputEvolutionPerWlanRandom, ...
    throughputEvolutionPerWlanEgreedy, throughputEvolutionPerWlanExp3, ...
    throughputEvolutionPerWlanUcb, throughputEvolutionPerWlanTs)

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

            meanAggTptSingleSimulationRandom(r) = mean(sum(throughputEvolutionPerWlanRandom{s, r}(permanentInterval, :)'));
            meanAggTptSingleSimulationEgreedy(r) = mean(sum(throughputEvolutionPerWlanEgreedy{s, r}(permanentInterval, :)'));
            meanAggTptSingleSimulationExp3(r) = mean(sum(throughputEvolutionPerWlanExp3{s, r}(permanentInterval, :)'));
            meanAggTptSingleSimulationUcb(r) = mean(sum(throughputEvolutionPerWlanUcb{s, r}(permanentInterval, :)'));
            meanAggTptSingleSimulationTs(r) = mean(sum(throughputEvolutionPerWlanTs{s, r}(permanentInterval, :)'));
            
            meanFairnessSingleSimulationRandom(r) = mean(jains_fairness(throughputEvolutionPerWlanRandom{s, r}(permanentInterval, :)));
            meanFairnessSingleSimulationEgreedy(r) = mean(jains_fairness(throughputEvolutionPerWlanEgreedy{s, r}(permanentInterval, :)));
            meanFairnessSingleSimulationExp3(r) = mean(jains_fairness(throughputEvolutionPerWlanExp3{s, r}(permanentInterval, :)));
            meanFairnessSingleSimulationUcb(r) = mean(jains_fairness(throughputEvolutionPerWlanUcb{s, r}(permanentInterval, :)));
            meanFairnessSingleSimulationTs(r) = mean(jains_fairness(throughputEvolutionPerWlanTs{s, r}(permanentInterval, :)));

        end
        
        meanAggTptTotalRepetitionsRandom(s) = mean(meanAggTptSingleSimulationRandom);
        meanAggTptTotalRepetitionsEgreedy(s) = mean(meanAggTptSingleSimulationEgreedy);
        meanAggTptTotalRepetitionsExp3(s) = mean(meanAggTptSingleSimulationExp3);
        meanAggTptTotalRepetitionsUcb(s) = mean(meanAggTptSingleSimulationUcb);
        meanAggTptTotalRepetitionsTs(s) = mean(meanAggTptSingleSimulationTs);
        
        stdAggTptTotalRepetitionsRandom(s) = std(meanAggTptSingleSimulationRandom);
        stdAggTptTotalRepetitionsEgreedy(s) = std(meanAggTptSingleSimulationEgreedy);
        stdAggTptTotalRepetitionsExp3(s) = std(meanAggTptSingleSimulationExp3);
        stdAggTptTotalRepetitionsUcb(s) = std(meanAggTptSingleSimulationUcb);
        stdAggTptTotalRepetitionsTs(s) = std(meanAggTptSingleSimulationTs);
        
        meanFairnessTotalRepetitionsRandom(s) = mean(meanFairnessSingleSimulationRandom);
        meanFairnessTotalRepetitionsEgreedy(s) = mean(meanFairnessSingleSimulationEgreedy);
        meanFairnessTotalRepetitionsExp3(s) = mean(meanFairnessSingleSimulationExp3);
        meanFairnessTotalRepetitionsUcb(s) = mean(meanFairnessSingleSimulationUcb);
        meanFairnessTotalRepetitionsTs(s) = mean(meanFairnessSingleSimulationTs);
        
        stdFairnessTotalRepetitionsRandom(s) = std(meanFairnessSingleSimulationRandom);
        stdFairnessTotalRepetitionsEgreedy(s) = std(meanFairnessSingleSimulationEgreedy);
        stdFairnessTotalRepetitionsExp3(s) = std(meanFairnessSingleSimulationExp3);
        stdFairnessTotalRepetitionsUcb(s) = std(meanFairnessSingleSimulationUcb);
        stdFairnessTotalRepetitionsTs(s) = std(meanFairnessSingleSimulationTs);
        
        plot_agg_tpt = [plot_agg_tpt; [meanAggTptTotalRepetitionsRandom(s) ...
            meanAggTptTotalRepetitionsEgreedy(s) meanAggTptTotalRepetitionsExp3(s) ...
            meanAggTptTotalRepetitionsUcb(s) meanAggTptTotalRepetitionsTs(s)]];
        
        plot_std_agg_tpt = [plot_std_agg_tpt; [stdAggTptTotalRepetitionsRandom(s) ...
            stdAggTptTotalRepetitionsEgreedy(s) stdAggTptTotalRepetitionsExp3(s) ...
            stdAggTptTotalRepetitionsUcb(s) stdAggTptTotalRepetitionsTs(s)]];
        
        plot_fairness = [plot_fairness; [meanFairnessTotalRepetitionsRandom(s) ...
            meanFairnessTotalRepetitionsEgreedy(s) meanFairnessTotalRepetitionsExp3(s) ...
            meanFairnessTotalRepetitionsUcb(s) meanFairnessTotalRepetitionsTs(s)]];
        
        plot_std_fairness = [plot_std_fairness; [stdFairnessTotalRepetitionsRandom(s) ...
            stdFairnessTotalRepetitionsEgreedy(s) stdFairnessTotalRepetitionsExp3(s) ...
            stdFairnessTotalRepetitionsUcb(s) stdFairnessTotalRepetitionsTs(s)]];   
        
    end
    
%     %% PLOT AGGREGATED THROUGHPUT PER APPROACH AND SIZE OF OBSS
%     figure('pos', [450 400 500 350])
%     axes;
%     axis([1 20 30 70]);
%     h = bar(plot_agg_tpt);
%     set(h,'BarWidth',1);    % The bars will now touch each other
%     set(gca,'YGrid','on')
%     set(gca,'GridLineStyle','-')
%     hold on;
%     numgroups = size(plot_agg_tpt, 1); 
%     numbars = size(plot_agg_tpt, 2); 
%     groupwidth = min(0.8, numbars/(numbars+1.5));
%     for i = 1:numbars
%           % Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
%           x = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
%           errorbar(x, plot_agg_tpt(:,i), plot_std_agg_tpt(:,i), 'k', 'linestyle', 'none');
%     end
%     legend({'Random', '\epsilon-greedy', 'EXP3', 'UCB', 'Thompson s.'}, 'fontsize', 20, 'FontName', 'Times New Roman')
%     xticks(1:4)
%     xticklabels({'N = 2', 'N = 4', 'N = 6', 'N = 8'})
%     xt = get(gca, 'XTick');
%     set(gca, 'FontSize', 24)
%     ylabel('Network Throughput (Mbps)', 'fontsize', 28)
%     fig_name = ['mean_aggregate_tpt_per_scenario'];
%     savefig(['./Output/' fig_name '.fig'])
%     saveas(gcf,['./Output/' fig_name],'epsc')
% 
%     %% PLOT FAIRNESS PER APPROACH AND SIZE OF OBSS
%     figure('pos', [450 400 500 350])
%     axes;
%     axis([1 20 30 70]);
%     h = bar(plot_fairness);
%     set(h,'BarWidth',1);    % The bars will now touch each other
%     set(gca,'YGrid','on')
%     set(gca,'GridLineStyle','-')
%     hold on;
%     numgroups = size(plot_fairness, 1); 
%     numbars = size(plot_fairness, 2); 
%     groupwidth = min(0.8, numbars/(numbars+1.5));
%     for i = 1:numbars
%           % Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
%           x = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
%           errorbar(x, plot_fairness(:,i), plot_std_fairness(:,i), 'k', 'linestyle', 'none');        
%     end
%     xticks(1:4)
%     xticklabels({'N = 2', 'N = 4', 'N = 6', 'N = 8'})
%     xt = get(gca, 'XTick');
%     set(gca, 'FontSize', 24)
%     ylabel('Fairness', 'fontsize', 32)
%     axis([0 5 0 1.1])
%     fig_name = 'mean_fairness_per_scenario';
%     savefig(['./Output/' fig_name '.fig'])
%     saveas(gcf, ['./Output/' fig_name],'epsc')
  
    %% PLOT HISTOGRAM AVERAGE INDIVIDUAL THROUGHPUT LAST 5000 ITERATIONS (ONLY 8 WNs)
    meanThroughputPerWlanRandomConcat = cell(1, size(wlansSizes, 2));
    meanThroughputPerWlanEgreedyConcat = cell(1, size(wlansSizes, 2));
    meanThroughputPerWlanExp3Concat = cell(1, size(wlansSizes, 2));
    meanThroughputPerWlanUcbConcat = cell(1, size(wlansSizes, 2));
    meanThroughputPerWlanTsConcat = cell(1, size(wlansSizes, 2));
    
    % Std of the experienced throughput for each WN in the last iterations and for each repetition
    stdForEachRepetitionRandom = cell(1, size(wlansSizes, 2));
    stdForEachRepetitionEg = cell(1, size(wlansSizes, 2));
    stdForEachRepetitionEXP3 = cell(1, size(wlansSizes, 2));
    stdForEachRepetitionUCB = cell(1, size(wlansSizes, 2));
    stdForEachRepetitionTS = cell(1, size(wlansSizes, 2));
    
    for s = 1 : size(wlansSizes, 2)
        
        for r = 1 : totalRepetitions
            % Random
            meanThroughputPerWlanRandomConcat{s}(r, :) = ...
                mean(throughputEvolutionPerWlanRandom{s, r}(permanentInterval, :));
            stdForEachRepetitionRandom{s}(r, :) = ...
                 std(throughputEvolutionPerWlanRandom{s, r}(permanentInterval, :));
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
%         % Random
%         subplot(2, 2, 1)
%         h1 = hist(meanThroughputPerWlanRandomConcat{i}(:), 30);
%         hist(meanThroughputPerWlanRandomConcat{i}(:), 30);        
%         title('Random policy');
%         set(gca, 'FontSize', 18)
        % e-greedy
        
%         h_eg = hist(throughputEvolutionPerWlanEgreedy{i}(:), 30);
%         h_exp3 = hist(throughputEvolutionPerWlanExp3{i}(:), 30);
%         h_ucb = hist(throughputEvolutionPerWlanUcb{i}(:), 30);
%         h_ts = hist(throughputEvolutionPerWlanTs{i}(:), 30);
        h_eg = hist(meanThroughputPerWlanEgreedyConcat{i}(:), 30);
        h_exp3 = hist(meanThroughputPerWlanExp3Concat{i}(:), 30);
        h_ucb = hist(meanThroughputPerWlanUcbConcat{i}(:), 30);
        h_ts = hist(meanThroughputPerWlanTsConcat{i}(:), 30);
        
        max_counts = max(max([h_eg h_exp3 h_ucb h_ts])); 
%         max_tpt = max(max([throughputEvolutionPerWlanEgreedy{i}(:) ...
%             throughputEvolutionPerWlanExp3{i}(:), ...
%             throughputEvolutionPerWlanUcb{i}(:), ...
%             throughputEvolutionPerWlanTs{i}(:)]));
        
        max_tpt = max(max([meanThroughputPerWlanEgreedyConcat{i}(:) ...
            meanThroughputPerWlanExp3Concat{i}(:), ...
            meanThroughputPerWlanUcbConcat{i}(:), ...
            meanThroughputPerWlanTsConcat{i}(:)]));

        fig = figure('pos',[450 400 500 350]);
        axes;
        axis([1 20 30 70]);
        set(gca, 'FontSize', 18)
        
        subplot(2, 2, 1)
        %hist(throughputEvolutionPerWlanEgreedy{i}(:), 30);
        hist(meanThroughputPerWlanEgreedyConcat{i}(:), 30);       
        hold on;
        title('e-greedy')
        set(gca, 'FontSize', 18)
        axis([0 max_tpt * 1.1 0 max_counts * 1.1])
               
        % EXP3
        subplot(2, 2, 2)        
        %hist(throughputEvolutionPerWlanExp3{i}(:), 30);   
        hist(meanThroughputPerWlanExp3Concat{i}(:), 30);   
        hold on;
        title('EXP3')
        set(gca, 'FontSize', 18)
        axis([0 max_tpt * 1.1 0 max_counts * 1.1])
        
        % UCB
        subplot(2, 2, 3)
        %hist(throughputEvolutionPerWlanUcb{i}(:), 30);
        hist(meanThroughputPerWlanUcbConcat{i}(:), 30);
        hold on;
        title('UCB')
        set(gca, 'FontSize', 18)
        axis([0 max_tpt * 1.1 0 max_counts * 1.1])
        
        % TS
        subplot(2, 2, 4)
        %hist(throughputEvolutionPerWlanTs{i}(:), 30);
        hist(meanThroughputPerWlanTsConcat{i}(:), 30);
        hold on;
        title('Thompson s.')
        set(gca, 'FontSize', 18) 
        axis([0 max_tpt * 1.1 0 max_counts * 1.1])
                
        
        %axis([0 max(throughputEvolutionPerWlanEgreedy{i}(:))* 1.1 0 max(h) * 1.1])
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
    
    

    
    
%     % RANDOM
%     figure('pos', [450 400 500 350])
%     axes;
%     axis([1 20 30 70]);
%     h = hist(meanThroughputPerWlanRandomConcat{size_ix}(:), 30);
%     hist(meanThroughputPerWlanRandomConcat{size_ix}(:), 30);
%     xlim([0 max(meanThroughputPerWlanRandomConcat{size_ix}(:))])
% 	ylim([0 round(1.1*max(h))])  
%     set(gca,'YGrid','on')
%     set(gca,'GridLineStyle','-')
%     hold on;
%     set(gca, 'FontSize', 24)
%     ylabel('Counts', 'fontsize', 28)
%     xlabel('Mean Throughput (Mbps)', 'fontsize', 28)
%     title('Random policy')
%     axis([0 800 0 120])
%     fig_name = ['hist_mean_throughput_random'];
%     savefig(['./Output/' fig_name '.fig'])
%     saveas(gcf,['./Output/' fig_name],'epsc')
%     
%     % EGREEDY
%     figure('pos', [450 400 500 350])
%     axes;
%     axis([1 20 30 70]);
%     h = hist(meanThroughputPerWlanEgreedyConcat{size_ix}(:), 30);
%     hist(meanThroughputPerWlanEgreedyConcat{size_ix}(:), 30);
%     xlim([0 max(meanThroughputPerWlanEgreedyConcat{size_ix}(:))])
% 	ylim([0 round(1.1*max(h))])  
%     set(gca,'YGrid','on')
%     set(gca,'GridLineStyle','-')
%     hold on;
%     set(gca, 'FontSize', 24)
%     ylabel('Counts', 'fontsize', 28)
%     xlabel('Mean Throughput (Mbps)', 'fontsize', 28)
%     title('e-greedy policy')
%     axis([0 800 0 120])
%     fig_name = ['hist_mean_throughput_egreedy'];
%     savefig(['./Output/' fig_name '.fig'])
%     saveas(gcf,['./Output/' fig_name],'epsc')
%     
%     % EXP3
%     figure('pos', [450 400 500 350])
%     axes;
%     axis([1 20 30 70]);
%     h = hist(meanThroughputPerWlanExp3Concat{size_ix}(:), 30);
%     hist(meanThroughputPerWlanExp3Concat{size_ix}(:), 30);
%     xlim([0 max(meanThroughputPerWlanExp3Concat{size_ix}(:))])
% 	ylim([0 round(1.1*max(h))])    
%     set(gca,'YGrid','on')
%     set(gca,'GridLineStyle','-')
%     hold on;
%     set(gca, 'FontSize', 24)
%     ylabel('Counts', 'fontsize', 28)
%     xlabel('Mean Throughput (Mbps)', 'fontsize', 28)
%     title('EXP3 policy')
%     axis([0 800 0 120])
%     fig_name = ['hist_mean_throughput_exp3'];
%     savefig(['./Output/' fig_name '.fig'])
%     saveas(gcf,['./Output/' fig_name],'epsc')
%     
%     % UCB
%     figure('pos', [450 400 500 350])
%     axes;
%     axis([1 20 30 70]);
%     h = hist(meanThroughputPerWlanUcbConcat{size_ix}(:), 30);
%     hist(meanThroughputPerWlanUcbConcat{size_ix}(:), 30);
%     xlim([0 max(meanThroughputPerWlanUcbConcat{size_ix}(:))])
% 	ylim([0 round(1.1*max(h))])
%     set(gca,'YGrid','on')
%     set(gca,'GridLineStyle','-')
%     hold on;
%     set(gca, 'FontSize', 24)
%     ylabel('Counts', 'fontsize', 28)
%     xlabel('Mean Throughput (Mbps)', 'fontsize', 28)
%     title('UCB policy')
%     axis([0 800 0 120])
%     fig_name = 'hist_mean_throughput_ucb';
%     savefig(['./Output/' fig_name '.fig'])
%     saveas(gcf,['./Output/' fig_name],'epsc')
%     
%     % TS
%     figure('pos', [450 400 500 350])
%     axes;
%     axis([1 20 30 70]);
%     h = hist(meanThroughputPerWlanTsConcat{size_ix}(:), 30);
%     hist(meanThroughputPerWlanTsConcat{size_ix}(:), 30);
%     xlim([0 max(meanThroughputPerWlanTsConcat{size_ix}(:))])
% 	ylim([0 round(1.1*max(h))])
%     set(gca,'YGrid','on')
%     set(gca,'GridLineStyle','-')
%     hold on;
%     set(gca, 'FontSize', 24)
%     ylabel('Counts', 'fontsize', 28)
%     xlabel('Mean Throughput (Mbps)', 'fontsize', 28)
%     title('Thompson s. policy')
%     axis([0 800 0 120])
%     fig_name = 'hist_mean_throughput_ts';
%     savefig(['./Output/' fig_name '.fig'])
%     saveas(gcf,['./Output/' fig_name],'epsc')
%     
%     %% HISTOGRAM OF ALL THE IND. THROUGHPUT VALUES    
%     % RANDOM
%     figure('pos', [450 400 500 350])
%     axes;
%     axis([1 20 30 70]);
%     h = hist(throughputEvolutionPerWlanRandom{size_ix}(:), 30);
%     hist(throughputEvolutionPerWlanRandom{size_ix}(:), 30);
%     xlim([0 max(throughputEvolutionPerWlanRandom{size_ix}(:))])
% 	ylim([0 round(1.1*max(h))])  
%     set(gca,'YGrid','on')
%     set(gca,'GridLineStyle','-')
%     hold on;
%     set(gca, 'FontSize', 24)
%     ylabel('Counts', 'fontsize', 28)
%     xlabel('Inidividual Throughput (Mbps)', 'fontsize', 28)
%     title('Random policy')
%     axis([0 800 0 21000])
%     fig_name = 'hist_individual_throughput_random';
%     savefig(['./Output/' fig_name '.fig'])
%     saveas(gcf,['./Output/' fig_name],'epsc')
%     
%     % EGREEDY
%     figure('pos', [450 400 500 350])
%     axes;
%     axis([1 20 30 70]);
%     h = hist(throughputEvolutionPerWlanEgreedy{size_ix}(:), 30);
%     hist(throughputEvolutionPerWlanEgreedy{size_ix}(:), 30);
%     xlim([0 max(throughputEvolutionPerWlanEgreedy{size_ix}(:))])
% 	ylim([0 round(1.1*max(h))])  
%     set(gca,'YGrid','on')
%     set(gca,'GridLineStyle','-')
%     hold on;
%     set(gca, 'FontSize', 24)
%     ylabel('Counts', 'fontsize', 28)
%     xlabel('Inidividual Throughput (Mbps)', 'fontsize', 28)
%     title('e-greedy policy')
%     axis([0 800 0 21000])
%     fig_name = 'hist_individual_throughput_egreedy';
%     savefig(['./Output/' fig_name '.fig'])
%     saveas(gcf,['./Output/' fig_name],'epsc')
%     
%     % EXP3
%     figure('pos', [450 400 500 350])
%     axes;
%     axis([1 20 30 70]);
%     h = hist(throughputEvolutionPerWlanExp3{size_ix}(:), 30);
%     hist(throughputEvolutionPerWlanExp3{size_ix}(:), 30);
%     xlim([0 max(throughputEvolutionPerWlanExp3{size_ix}(:))])
% 	ylim([0 round(1.1*max(h))])    
%     set(gca,'YGrid','on')
%     set(gca,'GridLineStyle','-')
%     hold on;
%     set(gca, 'FontSize', 24)
%     ylabel('Counts', 'fontsize', 28)
%     xlabel('Inidividual Throughput (Mbps)', 'fontsize', 28)
%     title('EXP3 policy')
%     axis([0 800 0 21000])
%     fig_name = 'hist_individual_throughput_exp3';
%     savefig(['./Output/' fig_name '.fig'])
%     saveas(gcf,['./Output/' fig_name],'epsc')
%     
%     % UCB
%     figure('pos', [450 400 500 350])
%     axes;
%     axis([1 20 30 70]);
%     h = hist(throughputEvolutionPerWlanUcb{size_ix}(:), 30);
%     hist(throughputEvolutionPerWlanUcb{size_ix}(:), 30);
%     xlim([0 max(throughputEvolutionPerWlanUcb{size_ix}(:))])
% 	ylim([0 round(1.1*max(h))])
%     set(gca,'YGrid','on')
%     set(gca,'GridLineStyle','-')
%     hold on;
%     set(gca, 'FontSize', 24)
%     ylabel('Counts', 'fontsize', 28)
%     xlabel('Inidividual Throughput (Mbps)', 'fontsize', 28)
%     title('UCB policy')
%     axis([0 800 0 21000])
%     fig_name = 'hist_individual_throughput_ucb';
%     savefig(['./Output/' fig_name '.fig'])
%     saveas(gcf,['./Output/' fig_name],'epsc')
%     
%     % TS
%     figure('pos', [450 400 500 350])
%     axes;
%     axis([1 20 30 70]);
%     h = hist(throughputEvolutionPerWlanTs{size_ix}(:), 30);
%     hist(throughputEvolutionPerWlanTs{size_ix}(:), 30);
%     xlim([0 max(throughputEvolutionPerWlanTs{size_ix}(:))])
% 	ylim([0 round(1.1*max(h))])
%     set(gca,'YGrid','on')
%     set(gca,'GridLineStyle','-')
%     hold on;
%     set(gca, 'FontSize', 24)
%     ylabel('Counts', 'fontsize', 28)
%     xlabel('Inidividual Throughput (Mbps)', 'fontsize', 28)
%     title('Thompson s. policy')
%     axis([0 800 0 21000])
%     fig_name = 'hist_individual_throughput_ts';
%     savefig(['./Output/' fig_name '.fig'])
%     saveas(gcf,['./Output/' fig_name],'epsc')
    
    
    %% DISPLAY THE STD
    
%     % Random
%     % std of the experienced throughput of each WN in each of the repetitions
%     disp(['Mean std for each WN last ' num2str(totalIterations-minimumIterationToConsider) ' iterations (random policy):'])
%     disp(mean(stdForEachRepetitionRandom{size_ix}))
%     % Mean of the individual std
%     disp(['Average std last ' num2str(totalIterations-minimumIterationToConsider) ' iterations (random policy):'])
%     disp(mean(mean(stdForEachRepetitionRandom{size_ix})))
% 
%     % e-greedy
%     disp(['Mean std for each WN last ' num2str(totalIterations-minimumIterationToConsider) ' iterations (e-greedy policy):'])
%     disp(mean(stdForEachRepetitionEg{size_ix}))
%         disp(['Average std last ' num2str(totalIterations-minimumIterationToConsider) ' iterations (e-greedy policy):'])
%     disp(mean(mean(stdForEachRepetitionEg{size_ix})))
% 
%     % EXP3
%     disp(['Mean std for each WN last ' num2str(totalIterations-minimumIterationToConsider) ' iterations (EXP3 policy):'])
%     disp(mean(stdForEachRepetitionEXP3{size_ix}))
%         disp(['Average std last ' num2str(totalIterations-minimumIterationToConsider) ' iterations (EXP3 policy):'])
%     disp(mean(mean(stdForEachRepetitionEXP3{size_ix})))
% 
%     % UCB
%     disp(['Mean std for each WN last ' num2str(totalIterations-minimumIterationToConsider) ' iterations (UCB policy):'])
%     disp(mean(stdForEachRepetitionUCB{size_ix}))
%         disp(['Average std last ' num2str(totalIterations-minimumIterationToConsider) ' iterations (UCB policy):'])
%     disp(mean(mean(stdForEachRepetitionUCB{size_ix})))
% 
%     % Thompson sampling
%     disp(['Mean std for each WN last ' num2str(totalIterations-minimumIterationToConsider) ' iterations (TS policy):'])
%     disp(mean(stdForEachRepetitionTS{size_ix}))
%     disp(['Average std last ' num2str(totalIterations-minimumIterationToConsider) ' iterations (TS policy):'])
%     disp(mean(mean(stdForEachRepetitionTS{size_ix}))) 
%     
   
    
    % STD of the temporal throughput per WN
    
    for s = 1 : size(wlansSizes, 2)
    
            std_temporal_tpt_random = [];    
        std_temporal_tpt_eg = [];
        std_temporal_tpt_exp3 = [];
        std_temporal_tpt_ucb = [];
        std_temporal_tpt_ts = [];

        for r = 1 : totalRepetitions

            std_temporal_tpt_random = [std_temporal_tpt_random; std(throughputEvolutionPerWlanRandom{s, r})];
            std_temporal_tpt_eg = [std_temporal_tpt_eg; std(throughputEvolutionPerWlanEgreedy{s, r})];
            std_temporal_tpt_exp3 = [std_temporal_tpt_exp3; std(throughputEvolutionPerWlanExp3{s, r})];
            std_temporal_tpt_ucb = [std_temporal_tpt_ucb; std(throughputEvolutionPerWlanUcb{s, r})];
            std_temporal_tpt_ts = [std_temporal_tpt_ts; std(throughputEvolutionPerWlanTs{s, r})];

        end

        mean_std_random = mean(std_temporal_tpt_random)
        mean_mean_std_random = mean(mean(std_temporal_tpt_random))

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
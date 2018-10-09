%%% ************************************************************************
%%% * Collaborative Spatial Reuse in Wireless Networks via Selfish MABs    *
%%% * Author: Francesc Wilhelmi (francesc.wilhelmi@upf.edu)                *
%%% * Co-authors: C. Cano, G. Neu, B. Bellalta, A. Jonsson & S. Barrachina *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi          *
%%% * GitHub repository:                                                   *
%%% *   https://github.com/wn-upf/Collaborative_SR_in_WNs_via_Selfish_MABs *
%%% * More info on https://www.upf.edu/en/web/fwilhelmi                    *
%%% ************************************************************************

function [] = display_results_individual_performance( wlans, tptEvolutionPerWlan, ...
    timesArmHasBeenPlayed, method_name )
% display_results_individual_performance displays the results of experiments for
% individual performance of each policy (e.g., "Experiment_2_1_individual_performance_EG_parameters_4_WN.m")
%   INPUT: 
%       * wlans - object containing wlans information
%       * tptEvolutionPerWlan - array containing the throughput experienced
%       by each WN for each of the experiment iterations
%       * timesArmHasBeenPlayed - array containing information about the
%       number of plays that each WN has done for each action
%       * method_name - name of the policy used (e.g., "e-greedy")

    % Load constatns
    load('constants.mat')

    % Set font type
    set(0,'defaultUicontrolFontName','Times New Roman');
    set(0,'defaultUitableFontName','Times New Roman');
    set(0,'defaultAxesFontName','Times New Roman');
    set(0,'defaultTextFontName','Times New Roman');
    set(0,'defaultUipanelFontName','Times New Roman');
    
    agg_tpt_optimal_prop_fairness = 891.0714;    % Mbps
    ind_tpt_optimal_prop_fairness = 222.7678;    % Mbps    

    % Compute data to be plotted
    mean_agg_tpt_entire_simulation = mean(sum(tptEvolutionPerWlan(1:totalIterations, :), 2));
    % 
    std_agg_tpt_entire_simulation = std(sum(tptEvolutionPerWlan(1:totalIterations, :), 2));
    mean_std_ind_tpt_entire_simulation = mean(std(tptEvolutionPerWlan(1:totalIterations, :)));    
    mean_fairness_entire_simulation = mean(jains_fairness(tptEvolutionPerWlan(1:totalIterations, :)));
    mean_prop_fairness_entire_simulation = mean(sum(log(tptEvolutionPerWlan(1:totalIterations, :)),2));
    mean_agg_tpt_comparison_optimal_entire_simulation = ...
        mean_agg_tpt_entire_simulation / agg_tpt_optimal_prop_fairness;
    mean_ind_tpt_comparison_optimal_entire_simulation = ...
        mean(mean(tptEvolutionPerWlan(1:totalIterations, :),2)) / ind_tpt_optimal_prop_fairness;
    
    % Plot results of the entire simulation
    disp(['------------' newline 'Results (entire simulation):' newline '------------'])
    disp(['Mean aggregate throughput in ' method_name ' (entire simulation): ' num2str(mean_agg_tpt_entire_simulation)])
    disp(['Std agg. tpt in ' method_name ' (entire simulation): ' num2str(std_agg_tpt_entire_simulation)])
    disp(['Mean std ind. tpt in ' method_name ' (entire simulation): ' num2str(mean_std_ind_tpt_entire_simulation)])
    disp(['Mean fairness in ' method_name ' (entire simulation): ' num2str(mean_fairness_entire_simulation)])
    disp(['Mean Prop. fairness in ' method_name ' (entire simulation): ' num2str(mean_prop_fairness_entire_simulation)])   
    disp(['Mean agg. throughput / Optimal throughput (entire simulation): ' num2str(mean_agg_tpt_comparison_optimal_entire_simulation)])   
    disp(['Mean ind. throughput / Optimal throughput (entire simulation): ' num2str(mean_ind_tpt_comparison_optimal_entire_simulation)])   
    
    % Plot results for the last considered iterations
    if totalIterations > minimumIterationToConsider
        
        % Mean aggregate tpt. experienced in all the iterations
        mean_agg_tpt_last_iterations = mean(sum(tptEvolutionPerWlan(minimumIterationToConsider:totalIterations, :),2));
        % Std of the mean aggregate tpt.
        std_agg_tpt_last_iterations = std(sum(tptEvolutionPerWlan(minimumIterationToConsider:totalIterations, :), 2));
        % Mean std suffered in each iterations from individual throughputs
        mean_std_ind_tpt_last_iterations = mean(std(tptEvolutionPerWlan(minimumIterationToConsider:totalIterations, :)));    
        % Mean fairness experienced in all the iterations
        mean_fairness_last_iterations = mean(jains_fairness(tptEvolutionPerWlan(minimumIterationToConsider:totalIterations, :)));
        % Mean proportional fairness experienced in all the iterations
        mean_prop_fairness_last_iterations = mean(sum(log(tptEvolutionPerWlan(minimumIterationToConsider:totalIterations, :)),2));
        % Mean aggregate tpt. / Aggregate throughput (optimal prop. fairness)
        mean_agg_tpt_comparison_optimal_last_iterations = ...
            mean_agg_tpt_last_iterations / agg_tpt_optimal_prop_fairness;
        % Mean average tpt. / individual throughput (optimal prop. fairness)
        mean_ind_tpt_comparison_optimal_last_iterations = ...
            mean(mean(tptEvolutionPerWlan(minimumIterationToConsider:totalIterations, :),2)) / ind_tpt_optimal_prop_fairness;
                
        disp(['------------' newline 'Results (last iterations):' newline '------------'])

        disp(['Mean aggregate throughput in ' method_name ' (last ' ...
            num2str(totalIterations-minimumIterationToConsider) ' iterations): ' ...
            num2str(mean_agg_tpt_last_iterations)])        
        disp(['Std agg. tpt in ' method_name ' (last ' ...
            num2str(totalIterations-minimumIterationToConsider) ' iterations): ' ...
            num2str(std_agg_tpt_last_iterations)])
        disp(['Mean std ind. tpt in ' method_name ' (last ' ...
            num2str(totalIterations-minimumIterationToConsider) ' iterations): ' ...
            num2str(mean_std_ind_tpt_last_iterations)])        
        disp(['Mean fairness in ' method_name ' (last ' ...
            num2str(totalIterations-minimumIterationToConsider) ...
            ' iterations): ' num2str(mean_fairness_last_iterations)])
        disp(['Mean Prop. fairness in ' method_name ' (last ' ...
            num2str(totalIterations-minimumIterationToConsider) ' iterations): '...
            num2str(mean_prop_fairness_last_iterations)])
        disp(['Mean agg. throughput / Optimal throughput (last ' ...
            num2str(totalIterations-minimumIterationToConsider) ' iterations): ' ...
            num2str(mean_agg_tpt_comparison_optimal_last_iterations)])   
        disp(['Mean ind. throughput / Optimal throughput (last ' ...
            num2str(totalIterations-minimumIterationToConsider) ' iterations): ' ...
            num2str(mean_ind_tpt_comparison_optimal_last_iterations)])   
        
    end

    n_wlans = size(wlans, 2);
    
    %% Aggregated throughput experienced for each iteration
    figure('pos',[450 400 500 350]);
    axes;
    axis([1 20 30 70]);
    agg_tpt_per_iteration = sum(tptEvolutionPerWlan(1:totalIterations, :), 2);
    plot(1:totalIterations, agg_tpt_per_iteration)
    set(gca,'FontSize', 22)
    xlabel([method_name ' iteration'], 'fontsize', 24)
    ylabel('Network Throughput (Mbps)', 'fontsize', 24)
    axis([1 totalIterations 0 1.1 * max(agg_tpt_per_iteration)])    
    hold on
    h1 = plot(1 : totalIterations, agg_tpt_optimal_prop_fairness * ones(1, totalIterations), 'r--', 'linewidth',2);
    %legend(h1, {'Optimal (Max. Prop. Fairness)'});
    legend({'Temporal throughput', 'Optimal (Max. Prop. Fairness)'});
    %text(totalIterations * 0.5 , agg_tpt_optimal_prop_fairness * 1.1, 'Optimal (Max. Prop. Fairness)', 'fontsize', 24)
    % Save Figure
    fig_name = ['temporal_aggregate_tpt_' method_name];
    savefig(['./Output/' fig_name '.fig'])
    saveas(gcf,['./Output/' fig_name],'epsc')
    
    %% Throughput experienced by each WLAN for each iteration
    fig = figure('pos',[450 400 500 350]);
    axes;
    axis([1 20 30 70]);
    for i = 1:n_wlans
        subplot(n_wlans/2, n_wlans/2, i)
        tpt_per_iteration = tptEvolutionPerWlan(1:totalIterations, i);
        plot(1:totalIterations, tpt_per_iteration);
        hold on
        plot(1 : totalIterations, ind_tpt_optimal_prop_fairness * ones(1, totalIterations), 'r--', 'linewidth',2);
        title(['WN ' num2str(i)]);
        set(gca, 'FontSize', 18)
        axis([1 totalIterations 0 1.1 * max(tpt_per_iteration)])
    end
    % Set Axes labels
    AxesH    = findobj(fig, 'Type', 'Axes');       
    % Y-label
    YLabelHC = get(AxesH, 'YLabel');
    YLabelH  = [YLabelHC{:}];
    set(YLabelH, 'String', 'Throughput (Mbps)')
    % X-label
    XLabelHC = get(AxesH, 'XLabel');
    XLabelH  = [XLabelHC{:}];
    set(XLabelH, 'String', [method_name ' iteration']) 
    % Save Figure
    fig_name = ['temporal_individual_tpt_' method_name];
    savefig(['./Output/' fig_name '.fig'])
    saveas(gcf,['./Output/' fig_name],'epsc')
    
    %% Average tpt experienced per WLAN
    mean_tpt_per_wlan = mean(tptEvolutionPerWlan(minimumIterationToConsider:totalIterations,:),1);
    std_per_wlan = std(tptEvolutionPerWlan(minimumIterationToConsider:totalIterations,:),1);
    figure('pos',[450 400 500 350])
    axes;
    axis([1 20 30 70]);
    bar(mean_tpt_per_wlan, 0.5)
    set(gca, 'FontSize', 22)
    xlabel('WN id','fontsize', 24)
    ylabel('Mean throughput (Mbps)','fontsize', 24)
    hold on
    errorbar(mean_tpt_per_wlan, std_per_wlan, '.r');
    plot(0 : nWlans + 1, ind_tpt_optimal_prop_fairness * ones(1, nWlans + 2), 'r--', 'linewidth',2);
    % Save Figure
    fig_name = ['mean_tpt_' method_name];
    savefig(['./Output/' fig_name '.fig'])
    saveas(gcf,['./Output/' fig_name],'epsc')
    
    %% Actions probability
    fig = figure('pos',[450 400 500 350]);
    axes;
    axis([1 20 30 70]);  
    % Print the preferred action per wlan
    for i=1:n_wlans             
        K = size(timesArmHasBeenPlayed, 2);
        subplot(2,2,i);
        bar(1:K, timesArmHasBeenPlayed(i, :)/totalIterations);
        hold on
        title(['WN' num2str(i)])
        axis([0 9 0 1])
        xticks(1:8)
        xticklabels(1:8)
        set(gca, 'FontSize', 22)
        % xticklabels({'ch=1/tpc=5','ch=2/tpc=5','ch=1/tpc=10','ch=2/tpc=10','ch=1/tpc=15','ch=2/tpc=15','ch=1/tpc=20','ch=2/tpc=20'})
    end
    % Set Axes labels
    AxesH    = findobj(fig, 'Type', 'Axes');       
    % Y-label
    YLabelHC = get(AxesH, 'YLabel');
    YLabelH  = [YLabelHC{:}];
    set(YLabelH, 'String', 'Action prob.', 'fontsize', 24)
    % X-label
    XLabelHC = get(AxesH, 'XLabel');
    XLabelH  = [XLabelHC{:}];
    set(XLabelH, 'String', 'Action index', 'fontsize', 24) 
    % Save Figure
    fig_name = ['actions_probability_' method_name];
    savefig(['./Output/' fig_name '.fig'])
    saveas(gcf,['./Output/' fig_name],'epsc')
    
    %% Histogram experienced throughput (single simulation)
    figure('pos',[450 400 500 350]);
    axes;
    axis([1 20 30 70]);
    tptEvolutionPerWlanConcat = [tptEvolutionPerWlan(:,1); ...
        tptEvolutionPerWlan(:,2); tptEvolutionPerWlan(:,3); tptEvolutionPerWlan(:,4);];
    h = hist(tptEvolutionPerWlanConcat,20);
    hist(tptEvolutionPerWlanConcat,20);
    set(gca,'FontSize', 22)
    xlabel('Individual experienced throughput (Mbps)', 'fontsize', 24)
    ylabel('Counts', 'fontsize', 24)
    axis([0 max(max(tptEvolutionPerWlanConcat)) 0 max(h)*1.1])
    hold on
    pl = plot(ind_tpt_optimal_prop_fairness * ones(1, round(1.1*max(h))), 1 : round(1.1*max(h)), 'r--', 'linewidth',2);
    legend(pl, {['Optimal (Max. ' newline 'Prop. Fairness)']});
    %text(totalIterations * 0.5 , agg_tpt_optimal_prop_fairness * 1.1, 'Optimal (Max. Prop. Fairness)', 'fontsize', 24)
    % Save Figure
    fig_name = ['histogram_individual_throughput_' method_name];
    savefig(['./Output/' fig_name '.fig'])
    saveas(gcf,['./Output/' fig_name],'epsc')
    
end
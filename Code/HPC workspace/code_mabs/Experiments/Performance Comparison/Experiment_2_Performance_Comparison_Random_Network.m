%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exploiting Spatial Reuse in Wireless Networks through Decentralised MABs
% F. Wilhelmi, B. Bellalta, A. Jonsson, C. Cano, G. Neu, S. Barrachina
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% EXPERIMENT EXPLANATION:
% By using a simple grid of 4 WLANs sharing 2 channels, we want to find the
% optimal configurations that mazimizes the aggregated throughput and the
% proportional fairness, respectively

%%
clc
clear all

disp('-----------------------')
disp('FINAL COMPARISON: RANDOM SCENARIO & DIFFERENT DENSITIES')
disp('-----------------------')

constants

% Update the nWlans variable to define an array
nWlans = [2 4 6 8];
NOISE_DBM = -100;                   % Floor NOISE_DBM in dBm

% Initialize variable to store results
throughputEvolutionPerWlanRandom = cell(1, totalRepetitions);
throughputEvolutionPerWlanEgreedy = cell(1, totalRepetitions);
throughputEvolutionPerWlanExp3 = cell(1, totalRepetitions);
throughputEvolutionPerWlanUcb = cell(1, totalRepetitions);
throughputEvolutionPerWlanTs = cell(1, totalRepetitions);

fairness_evolution_random_transitory = cell(1, totalRepetitions);
fairness_evolution_random_permanent = cell(1, totalRepetitions);
aggregate_tpt_random_transitory = cell(1, totalRepetitions);
aggregate_tpt_random_permanent = cell(1, totalRepetitions);

fairness_evolution_eg_transitory = cell(1, totalRepetitions);
fairness_evolution_eg_permanent = cell(1, totalRepetitions);
aggregate_tpt_eg_transitory = cell(1, totalRepetitions);
aggregate_tpt_eg_permanent = cell(1, totalRepetitions);

fairness_evolution_exp3_transitory = cell(1, totalRepetitions);
fairness_evolution_exp3_permanent = cell(1, totalRepetitions);
aggregate_tpt_exp3_transitory = cell(1, totalRepetitions);
aggregate_tpt_exp3_permanent = cell(1, totalRepetitions);

fairness_evolution_ucb_transitory = cell(1, totalRepetitions);
fairness_evolution_ucb_permanent = cell(1, totalRepetitions);
aggregate_tpt_ucb_transitory = cell(1, totalRepetitions);
aggregate_tpt_ucb_permanent = cell(1, totalRepetitions);

fairness_evolution_ts_transitory = cell(1, totalRepetitions);
fairness_evolution_ts_permanent = cell(1, totalRepetitions);
aggregate_tpt_ts_transitory = cell(1, totalRepetitions);
aggregate_tpt_ts_permanent = cell(1, totalRepetitions);

for s = 1:size(nWlans, 2)    
    
    disp('------------------------------------')
    disp(['  Number of WLANs = ' num2str(nWlans(s))])
    disp('------------------------------------')
        
    for iter = 1:totalRepetitions
    
        disp('++++++++++++++++')
        disp(['ROUND ' num2str(iter) '/' num2str(totalRepetitions)])
        disp('++++++++++++++++')

        nChannels = nWlans(s)/2;              % Number of available channels (from 1 to NumChannels)
        channelActions = 1 : nChannels;
        ccaActions = [-82];                 % CCA levels (dBm)
        txPowerActions = [5 10 15 20];      % Transmit power levels (dBm)
                
        % Each state represents an [i,j,k] combination for indexes on "channels", "CCA" and "TxPower"
        possibleActions = 1:(size(channelActions, 2) * ...
            size(ccaActions, 2) * size(txPowerActions, 2));
        % Total number of actions
        K = size(possibleActions, 2);
        % All the possible combinations of configurations for the entire scenario
        possibleComb = allcomb(possibleActions, possibleActions, possibleActions, possibleActions);
        % Setup the scenario: generate WLANs and initialize states and actions
        wlans = generate_random_network_3D(nWlans(s), nChannels, 0); % RANDOM CONFIGURATION
        
        % RANDOM APPROACH
        throughputEvolutionPerWlanRandom{iter} = random_action(wlans, nChannels, ccaActions, txPowerActions);

        fairness_evolution_random_transitory{iter}(s, :) = JainsFairness(throughputEvolutionPerWlanRandom{iter}(1:minimumIterationToConsider, :));
        fairness_evolution_random_permanent{iter}(s, :) = JainsFairness(throughputEvolutionPerWlanRandom{iter}(minimumIterationToConsider+1:totalIterations, :));   
        aggregate_tpt_random_transitory{iter}(s,:) = sum(throughputEvolutionPerWlanRandom{iter}(1:minimumIterationToConsider, :), 2);
        aggregate_tpt_random_permanent{iter}(s,:) = sum(throughputEvolutionPerWlanRandom{iter}(minimumIterationToConsider+1:totalIterations, :), 2);
                       
        % E-GREEDY APPROACH
        initialEpsilon = 1; % Initial Exploration coefficient
        throughputEvolutionPerWlanEgreedy{iter}  = ...
            egreedy(wlans, initialEpsilon, nChannels, ccaActions, txPowerActions);

        fairness_evolution_eg_transitory{iter}(s, :) = JainsFairness(throughputEvolutionPerWlanEgreedy{iter}(1:minimumIterationToConsider, :));
        fairness_evolution_eg_permanent{iter}(s, :) = JainsFairness(throughputEvolutionPerWlanEgreedy{iter}(minimumIterationToConsider+1:totalIterations, :));   
        aggregate_tpt_eg_transitory{iter}(s,:) = sum(throughputEvolutionPerWlanEgreedy{iter}(1:minimumIterationToConsider, :), 2);
        aggregate_tpt_eg_permanent{iter}(s,:) = sum(throughputEvolutionPerWlanEgreedy{iter}(minimumIterationToConsider+1:totalIterations, :), 2);

        % EXP3 APPROACH
        gamma = 0;
        eta = .01;
        throughputEvolutionPerWlanExp3{iter}  = ...
            exp3(wlans, gamma, eta, nChannels, ccaActions, txPowerActions);
            
        fairness_evolution_exp3_transitory{iter}(s, :) = JainsFairness(throughputEvolutionPerWlanExp3{iter}(1:minimumIterationToConsider, :));
        fairness_evolution_exp3_permanent{iter}(s, :) = JainsFairness(throughputEvolutionPerWlanExp3{iter}(minimumIterationToConsider+1:totalIterations, :));   
        aggregate_tpt_exp3_transitory{iter}(s,:) = sum(throughputEvolutionPerWlanExp3{iter}(1:minimumIterationToConsider, :), 2);
        aggregate_tpt_exp3_permanent{iter}(s,:) = sum(throughputEvolutionPerWlanExp3{iter}(minimumIterationToConsider+1:totalIterations, :), 2);

        % UCB APPROACH
        throughputEvolutionPerWlanUcb{iter}  = ...
            ucb(wlans, nChannels, ccaActions, txPowerActions);
            
        fairness_evolution_ucb_transitory{iter}(s, :) = JainsFairness(throughputEvolutionPerWlanUcb{iter}(1:minimumIterationToConsider, :));
        fairness_evolution_ucb_permanent{iter}(s, :) = JainsFairness(throughputEvolutionPerWlanUcb{iter}(minimumIterationToConsider+1:totalIterations, :));   
        aggregate_tpt_ucb_transitory{iter}(s,:) = sum(throughputEvolutionPerWlanUcb{iter}(1:minimumIterationToConsider, :), 2);
        aggregate_tpt_ucb_permanent{iter}(s,:) = sum(throughputEvolutionPerWlanUcb{iter}(minimumIterationToConsider+1:totalIterations, :), 2);
        
        % TS APPROACH
        throughputEvolutionPerWlanTs{iter}  = ...
            thompson_sampling(wlans, nChannels, ccaActions, txPowerActions);
            
        fairness_evolution_ts_transitory{iter}(s, :) = JainsFairness(throughputEvolutionPerWlanTs{iter}(1:minimumIterationToConsider, :));
        fairness_evolution_ts_permanent{iter}(s, :) = JainsFairness(throughputEvolutionPerWlanTs{iter}(minimumIterationToConsider+1:totalIterations, :));   
        aggregate_tpt_ts_transitory{iter}(s,:) = sum(throughputEvolutionPerWlanTs{iter}(1:minimumIterationToConsider, :), 2);
        aggregate_tpt_ts_permanent{iter}(s,:) = sum(throughputEvolutionPerWlanTs{iter}(minimumIterationToConsider+1:totalIterations, :), 2);      
        
    end
    
end

for s = 1:size(nWlans,2)
    
    agg_tpt_cat_random = [];
    fairness_cat_random = [];
    
    agg_tpt_cat_eg = [];
    fairness_cat_eg = [];

    agg_tpt_cat_exp3 = [];
    fairness_cat_exp3 = [];

    agg_tpt_cat_ucb = [];
    fairness_cat_ucb = [];
    
    agg_tpt_cat_ts = [];
    fairness_cat_ts = [];
    
    for i = 1 : totalRepetitions
        
        agg_tpt_cat_random = [agg_tpt_cat_random; aggregate_tpt_random_permanent{i}(s,:)];
        fairness_cat_random = [fairness_cat_random; fairness_evolution_random_permanent{i}(s,:)];
        
        agg_tpt_cat_eg = [agg_tpt_cat_eg; aggregate_tpt_eg_permanent{i}(s,:)];
        fairness_cat_eg = [fairness_cat_eg; fairness_evolution_eg_permanent{i}(s,:)];
        
        agg_tpt_cat_exp3 = [agg_tpt_cat_exp3; aggregate_tpt_exp3_permanent{i}(s,:)];
        fairness_cat_exp3 = [fairness_cat_exp3; fairness_evolution_exp3_permanent{i}(s,:)];
        
        agg_tpt_cat_ucb = [agg_tpt_cat_ucb; aggregate_tpt_ucb_permanent{i}(s,:)];
        fairness_cat_ucb = [fairness_cat_ucb; fairness_evolution_ucb_permanent{i}(s,:)];
        
        agg_tpt_cat_ts = [agg_tpt_cat_ts; aggregate_tpt_ts_permanent{i}(s,:)];
        fairness_cat_ts = [fairness_cat_ts; fairness_evolution_ts_permanent{i}(s,:)];
        
    end
    
    mean_agg_tpt_random(s) = mean(mean(agg_tpt_cat_random, 2));
    std_agg_tpt_random(s) = std(mean(agg_tpt_cat_random, 2));
    mean_fairness_random(s) = mean(mean(fairness_cat_random, 2));
    std_fairness_random(s) = std(mean(fairness_cat_random, 2));

    mean_agg_tpt_eg(s) = mean(mean(agg_tpt_cat_eg, 2));
    std_agg_tpt_eg(s) = std(mean(agg_tpt_cat_eg, 2));
    mean_fairness_eg(s) = mean(mean(fairness_cat_eg, 2));
    std_fairness_eg(s) = std(mean(fairness_cat_eg, 2));
    
    mean_agg_tpt_exp3(s) = mean(mean(agg_tpt_cat_exp3, 2));
    std_agg_tpt_exp3(s) = std(mean(agg_tpt_cat_exp3, 2));
    mean_fairness_exp3(s) = mean(mean(fairness_cat_exp3, 2));
    std_fairness_exp3(s) = std(mean(fairness_cat_exp3, 2));
    
    mean_agg_tpt_ucb(s) = mean(mean(agg_tpt_cat_ucb, 2));
    std_agg_tpt_ucb(s) = std(mean(agg_tpt_cat_ucb, 2));
    mean_fairness_ucb(s) = mean(mean(fairness_cat_ucb, 2));
    std_fairness_ucb(s) = std(mean(fairness_cat_ucb, 2));    
    
    mean_agg_tpt_ts(s) = mean(mean(agg_tpt_cat_ts, 2));
    std_agg_tpt_ts(s) = std(mean(agg_tpt_cat_ts, 2));
    mean_fairness_ts(s) = mean(mean(fairness_cat_ts, 2));
    std_fairness_ts(s) = std(mean(fairness_cat_ts, 2)); 
%     mean_agg_tpt_random(s) = mean(mean(cat(totalRepetitions, aggregate_tpt_random{:}(s,:))));
%     mean_fairness_random = mean(JainsFairness(cat(totalRepetitions, aggregate_tpt_random{:})));
%     std_agg_tpt_random(s) = mean(std(cat(totalRepetitions, aggregate_tpt_random{:}(s,:))));
end

%% PLOT THE RESULTS

plot_agg_tpt = [];
plot_std_agg_tpt = [];
plot_fairness = [];
plot_std_fairness = [];

for s = 1:size(nWlans,2)    
    plot_agg_tpt = [plot_agg_tpt; [mean_agg_tpt_random(s) mean_agg_tpt_eg(s) mean_agg_tpt_exp3(s) mean_agg_tpt_ucb(s) mean_agg_tpt_ts(s)]];
    plot_std_agg_tpt = [plot_std_agg_tpt; [std_agg_tpt_random(s) std_agg_tpt_eg(s) std_agg_tpt_exp3(s) std_agg_tpt_ucb(s) std_agg_tpt_ts(s)]];
    plot_fairness = [plot_fairness; [mean_fairness_random(s) mean_fairness_eg(s) mean_fairness_exp3(s) mean_fairness_ucb(s) mean_fairness_ts(s)]];
    plot_std_fairness = [plot_std_fairness; [std_fairness_random(s) std_fairness_eg(s) std_fairness_exp3(s) std_fairness_ucb(s) std_fairness_ts(s)]];    
end

disp('plot_agg_tpt')
disp(plot_agg_tpt)
disp('plot_std_agg_tpt')
disp(plot_std_agg_tpt)
disp('plot_fairness')
disp(plot_fairness)
disp('plot_std_fairness')
disp(plot_std_fairness)

% bar(plot_agg_tpt)
% hold on
% errorbar(1:size(plot_agg_tpt,2), plot_agg_tpt, plot_std_agg_tpt, '.')
% legend({'Random', 'Q-learning', 'MAB (\epsilon-greedy)', 'MAB (EXP3)', 'MAB (UCB)'})
% xticks(1:4)
% xticklabels({'nWLANs = 2', 'nWLANs = 4', 'nWLANs = 6', 'nWLANs = 8'})


%% PLOT AGGREGATED THROUGHPUT PER APPROACH AND SIZE OF OBSS

% Set font type
set(0,'defaultUicontrolFontName','Times New Roman');
set(0,'defaultUitableFontName','Times New Roman');
set(0,'defaultAxesFontName','Times New Roman');
set(0,'defaultTextFontName','Times New Roman');
set(0,'defaultUipanelFontName','Times New Roman');

figure('pos', [450 400 500 350])
axes;
axis([1 20 30 70]);
h = bar(plot_agg_tpt);
set(h,'BarWidth',1);    % The bars will now touch each other
set(gca,'YGrid','on')
set(gca,'GridLineStyle','-')
hold on;
numgroups = size(plot_agg_tpt, 1); 
numbars = size(plot_agg_tpt, 2); 
groupwidth = min(0.8, numbars/(numbars+1.5));
for i = 1:numbars
      % Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
      x = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
      errorbar(x, plot_agg_tpt(:,i), plot_std_agg_tpt(:,i), 'k', 'linestyle', 'none');
end
legend({'Random', '\epsilon-greedy', 'EXP3', 'UCB', 'Thompson Sampling'}, 'fontsize', 20, 'FontName', 'Times New Roman')
xticks(1:4)
xticklabels({'N = 2', 'N = 4', 'N = 6', 'N = 8'})
xt = get(gca, 'XTick');
set(gca, 'FontSize', 24)
ylabel('Network Throughput (Mbps)', 'fontsize', 28)

    
%% PLOT FAIRNESS PER APPROACH AND SIZE OF OBSS

figure('pos', [450 400 500 350])
axes;
axis([1 20 30 70]);
h = bar(plot_fairness);
set(h,'BarWidth',1);    % The bars will now touch each other
set(gca,'YGrid','on')
set(gca,'GridLineStyle','-')
hold on;
numgroups = size(plot_fairness, 1); 
numbars = size(plot_fairness, 2); 
groupwidth = min(0.8, numbars/(numbars+1.5));
for i = 1:numbars
      % Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
      x = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
      errorbar(x, plot_fairness(:,i), plot_std_fairness(:,i), 'k', 'linestyle', 'none');        
end
xticks(1:4)
xticklabels({'N = 2', 'N = 4', 'N = 6', 'N = 8'})
xt = get(gca, 'XTick');
set(gca, 'FontSize', 24)
ylabel('Fairness', 'fontsize', 32)
axis([0 5 0 1.1])

save('./Output/final_comparison_workspace.mat')
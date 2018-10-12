clc
clear all

% Generate constants from 'constants.m'
constants

initialEpsilon = 1;
% Define EXP3 parameters
initialEta = 0.6;
gamma = 0;

% Setup the scenario: generate WLANs and initialize states and actions
wlans = generate_network_3D(nWlans, 'grid', 2, drawMap); % SAFE CONFIGURATION

% Compute the maximum achievable throughput per WLAN
upperBoundThroughputPerWlan = compute_max_selfish_throughput( wlans );

load('workspace_throughput_all_combinations_toy_scenario.mat')
% JFI
[max_f, ix_max_f] = max(jains_fairness(throughputPerConfiguration));
% Proportional fairness
[max_pf, ix_max_pf] = max(sum(log(throughputPerConfiguration)'));
agg_tpt_max_pf = sum(throughputPerConfiguration(ix_max_pf,:));
% Aggregate throughput
[max_agg, ix_max_agg] = max(sum(throughputPerConfiguration'));
% Max-min throughput
[max_max_min, ix_max_min] = max(min(throughputPerConfiguration'));

% Compute the throughput experienced per WLAN at each iteration
[tpt_evolution_per_wlan_eg, times_arm_has_been_played_eg, regret_per_wlan_eg , meanRewardPerAction] = ...
    egreedy( wlans, initialEpsilon, upperBoundThroughputPerWlan );
[tpt_evolution_per_wlan_exp3, times_arm_has_been_played_exp3, regret_per_wlan_exp3]  = ...
    exp3(wlans, gamma, initialEta, upperBoundThroughputPerWlan);
[tpt_evolution_per_wlan_ucb, times_arm_has_been_played_ucb, regret_per_wlan_ucb] = ...
    ucb(wlans, upperBoundThroughputPerWlan);
[tpt_evolution_per_wlan_ts, times_arm_has_been_played_ts, regret_per_wlan_ts] = ...
    thompson_sampling(wlans, upperBoundThroughputPerWlan);


%% Throughput experienced by each WLAN for each iteration
fig = figure('pos',[450 400 500 350]);
axes;
axis([1 20 30 70]);
for i = 1 : nWlans
    subplot(nWlans/2, nWlans/2, i)
    tpt_per_iteration = tpt_evolution_per_wlan_eg(1:totalIterations, i);
    plot(1:totalIterations, tpt_per_iteration);
    hold on
    plot(1 : totalIterations, max_max_min * ones(1, totalIterations), 'r--', 'linewidth',2);
    title(['WN ' num2str(i)]);
    set(gca, 'FontSize', 18)
    axis([1 totalIterations 0 1.1 * max_max_min])
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
set(XLabelH, 'String', ['EG iteration']) 

%% Throughput experienced by each WLAN for each iteration
fig = figure('pos',[450 400 500 350]);
axes;
axis([1 20 30 70]);
for i = 1 : nWlans
    subplot(nWlans/2, nWlans/2, i)
    tpt_per_iteration = tpt_evolution_per_wlan_exp3(1:totalIterations, i);
    plot(1:totalIterations, tpt_per_iteration);
    hold on
    plot(1 : totalIterations, max_max_min * ones(1, totalIterations), 'r--', 'linewidth',2);
    title(['WN ' num2str(i)]);
    set(gca, 'FontSize', 18)
    axis([1 totalIterations 0 1.1 * max_max_min])
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
set(XLabelH, 'String', ['EXP3 iteration']) 

%% Throughput experienced by each WLAN for each iteration
fig = figure('pos',[450 400 500 350]);
axes;
axis([1 20 30 70]);
for i = 1 : nWlans
    subplot(nWlans/2, nWlans/2, i)
    tpt_per_iteration = tpt_evolution_per_wlan_ucb(1:totalIterations, i);
    plot(1:totalIterations, tpt_per_iteration);
    hold on
    plot(1 : totalIterations, max_max_min * ones(1, totalIterations), 'r--', 'linewidth',2);
    title(['WN ' num2str(i)]);
    set(gca, 'FontSize', 18)
    axis([1 totalIterations 0 1.1 * max_max_min])
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
set(XLabelH, 'String', ['UCB iteration']) 

%% Throughput experienced by each WLAN for each iteration
fig = figure('pos',[450 400 500 350]);
axes;
axis([1 20 30 70]);
for i = 1 : nWlans
    subplot(nWlans/2, nWlans/2, i)
    tpt_per_iteration = tpt_evolution_per_wlan_ts(1:totalIterations, i);
    plot(1:totalIterations, tpt_per_iteration);
    hold on
    plot(1 : totalIterations, max_max_min * ones(1, totalIterations), 'r--', 'linewidth',2);
    title(['WN ' num2str(i)]);
    set(gca, 'FontSize', 18)
    axis([1 totalIterations 0 1.1 * max_max_min])
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
set(XLabelH, 'String', ['TS iteration']) 

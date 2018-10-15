clc
clear all

disp('-----------------------')
disp('SIM: PENALTIES')
disp('-----------------------')

% Generate constants from 'constants.m'
constants

initialEpsilon = 1;
initialEta = 0.1;
gamma = 0;

alpha = 0:.1:1;

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
for i = 1 : size(alpha, 2)
    [tpt_evolution_per_wlan_peg{i}, times_arm_has_been_played_peg{i}, regret_per_wlan_peg{i}] = ...
        egreedy_with_penalty( wlans, initialEpsilon, upperBoundThroughputPerWlan, alpha(i) );
    [tpt_evolution_per_wlan_pexp3{i}, times_arm_has_been_played_pexp3{i}, regret_per_wlan_pexp3{i}] = ...
        exp3_with_penalty( wlans, gamma, initialEta, upperBoundThroughputPerWlan, alpha(i) );
    [tpt_evolution_per_wlan_pucb{i}, times_arm_has_been_played_pucb{i}, regret_per_wlan_pucb{i}] = ...
        ucb_with_penalty( wlans, upperBoundThroughputPerWlan, alpha(i) );
    [tpt_evolution_per_wlan_pts{i}, times_arm_has_been_played_pts{i}, regret_per_wlan_pts{i}] = ...
        thompson_sampling_with_penalty( wlans, upperBoundThroughputPerWlan, alpha(i) );
end

for i = 1 : size(alpha, 2)
   mean_tpt_eg(i) = mean(mean(tpt_evolution_per_wlan_peg{i})); 
   std_tpt_eg(i) = mean(std(tpt_evolution_per_wlan_peg{i})); 
   mean_tpt_exp3(i) = mean(mean(tpt_evolution_per_wlan_pexp3{i})); 
   std_tpt_exp3(i) = mean(std(tpt_evolution_per_wlan_pexp3{i})); 
   mean_tpt_ucb(i) = mean(mean(tpt_evolution_per_wlan_pucb{i})); 
   std_tpt_ucb(i) = mean(std(tpt_evolution_per_wlan_pucb{i})); 
   mean_tpt_ts(i) = mean(mean(tpt_evolution_per_wlan_pts{i})); 
   std_tpt_ts(i) = mean(std(tpt_evolution_per_wlan_pts{i})); 
end

figure('pos', [450 400 500 350])
axes;
axis([1 20 30 70]);
errorbar(alpha, mean_tpt_eg, std_tpt_eg, '-s')
hold on
errorbar(alpha, mean_tpt_exp3, std_tpt_exp3, '-s')
errorbar(alpha, mean_tpt_ucb, std_tpt_ucb, '-s')
errorbar(alpha, mean_tpt_ts, std_tpt_ts, '-s')
xticks(alpha)
% Plot the optimal agg_tpt_max_pf
plot(alpha, agg_tpt_max_pf * ones(1, size(alpha, 2)), '--', 'linewidth',2);
set(gca, 'FontSize', 22)
legend({'\epsilon-greedy', 'EXP3', 'UCB', 'Thompson s.'})
ylabel('Network Throughput (Mbps)', 'FontSize', 24)
xlabel('\alpha', 'FontSize', 24)
axis([min(alpha) max(alpha) 0 140])

% Save the workspace
save('./Output/penalties.mat')
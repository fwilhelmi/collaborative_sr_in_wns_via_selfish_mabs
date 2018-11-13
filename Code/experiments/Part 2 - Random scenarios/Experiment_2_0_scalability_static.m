%%% ************************************************************************
%%% * Collaborative Spatial Reuse in Wireless Networks via Selfish MABs    *
%%% * Author: Francesc Wilhelmi (francesc.wilhelmi@upf.edu)                *
%%% * Co-authors: C. Cano, G. Neu, B. Bellalta, A. Jonsson & S. Barrachina *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi          *
%%% * GitHub repository:                                                   *
%%% *   https://github.com/wn-upf/Collaborative_SR_in_WNs_via_Selfish_MABs *
%%% * More info on https://www.upf.edu/en/web/fwilhelmi                    *
%%% ************************************************************************

%%% EXPERIMENT EXPLANATION:
%%% The script computes the performance of applying e-greedy, EXP3, UCB and
%%% Thompson sampling in random scenarios. At the end, histograms of the 
%%% average throughput experienced are displayed for each policy.

%%% This Script generates the data to generate Figures 8 and 9 in the article

%%
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

disp('------------------------------------------')
disp('SIM_2_0: Random scenarios (static approach)')
disp('------------------------------------------')

% Load constants
%constants
constants
% Update the nWlans variable to define an array
nWlans = [2 4 6 8];

load('wlans')

% Repeat for each number of WNs in the scenario
for s = 1 : size(nWlans, 2)    
    
    disp('------------------------------------')
    disp(['  Number of WLANs = ' num2str(nWlans(s))])
    disp('------------------------------------')
        
    % Repeat for each number of repetitions (averaging purposes)
    for scenario = 1 : totalScenarios
    
        disp('++++++++++++++++')
        disp(['Scenario ' num2str(scenario) '/' num2str(totalScenarios)])
        disp('++++++++++++++++')
        
        for w_ix = 1 : size (wlans{s,scenario}, 2)
            wlans{s,scenario}(w_ix).Channel = 1;
            wlans{s,scenario}(w_ix).TxPower = max(txPowerActions);
        end
        
        throughput_static{s}(scenario,:) = compute_throughput_from_sinr(wlans{s,scenario}, NOISE_DBM);  % bps          
            
    end
    
end

% Compute the average throughput for each network size
for s = 1 : size(nWlans, 2)
    average_throughput_per_scenario(s) = mean(mean(throughput_static{s}'));
end

% Save the workspace
save('./Output/simulation_2_0_workspace.mat')
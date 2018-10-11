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

%%% This Script generates the output shown in the article:
%%% - Figure 18

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

disp('-----------------------')
disp('FINAL COMPARISON: RANDOM SCENARIO & DIFFERENT DENSITIES')
disp('-----------------------')

% Load constants
%constants
constants
% Update the nWlans variable to define an array
nWlans = [2 4 6 8];

% % Initialize variables to store results:
% % - Each cell contains the throughput evolution experienced with each policy
% % - We store the tpt. evolution for each number of WNs and for each repetition
throughputEvolutionPerWlanEgreedy = cell(size(nWlans, 2), totalScenarios);
throughputEvolutionPerWlanExp3 = cell(size(nWlans, 2), totalScenarios);
throughputEvolutionPerWlanUcb = cell(size(nWlans, 2), totalScenarios);
throughputEvolutionPerWlanTs = cell(size(nWlans, 2), totalScenarios);

load('wlans_default')
%load('wlans_realistic')

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

        % Number of available channels (from 1 to NumChannels)
        nChannels = nWlans(s)/2;      
        txPowerActions = [5 10 15 20];
        
        % Compute the throughput evolution for the E-GREEDY APPROACH
        initialEpsilon = 1;            % Initial Exploration coefficient
        throughputEvolutionPerWlanEgreedy{s, scenario}  = ...
            egreedy(wlans{s,scenario}, initialEpsilon, nChannels, ccaActions, txPowerActions);

        % Compute the throughput evolution for the EXP3 APPROACH
        gamma = 0;
        initialEta = .6;
        throughputEvolutionPerWlanExp3{s, scenario}  = ...
            exp3(wlans{s,scenario}, gamma, initialEta, nChannels, ccaActions, txPowerActions);

        % Compute the throughput evolution for the UCB APPROACH
        throughputEvolutionPerWlanUcb{s, scenario}  = ...
            ucb(wlans{s,scenario}, nChannels, ccaActions, txPowerActions);

        % Compute the throughput evolution for the TS APPROACH
        throughputEvolutionPerWlanTs{s, scenario}  = ...
            thompson_sampling(wlans{s,scenario}, nChannels, ccaActions, txPowerActions);
            
    end
    
end

%% Display the results
% display_results_scalability(nWlans, throughputEvolutionPerWlanEgreedy, throughputEvolutionPerWlanExp3, ...
%     throughputEvolutionPerWlanUcb, throughputEvolutionPerWlanTs);

% Save the workspace
save('./Output/simulation_2_0_workspace.mat')
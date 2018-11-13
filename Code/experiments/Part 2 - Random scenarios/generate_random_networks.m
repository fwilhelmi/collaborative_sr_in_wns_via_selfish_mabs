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
%%% The script generates random scenarios to be used in SIM_2

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

disp('--------------------------')
disp('GENERATE RANDOM SCENARIOS')
disp('--------------------------')

% Load constants
%constants_more_actions
constants

% Update the nWlans variable to define an array
network_sizes = [2 4 6 8];

wlans = {};

% Repeat for each number of WNs in the scenario
for num_wlans_ix = 1 : size(network_sizes, 2)            
    % Repeat for each number of repetitions (averaging purposes)
    for scenario = 1 : totalScenarios    
        % Number of available channels (from 1 to NumChannels)
        nChannels = network_sizes(num_wlans_ix)/2;%3;              
        % Update the possible actions 
        possibleActions = 1:(size(channelActions, 2) * ...
            size(ccaActions, 2) * size(txPowerActions, 2));
        % Update the total number of actions
        K = size(possibleActions, 2);
        % Update the possible combinations of configurations
        possibleComb = allcomb(possibleActions, possibleActions, possibleActions, possibleActions);       
        % Generate a random scenario for the given number of WNs
        wlans{num_wlans_ix, scenario} = generate_random_network_3D(network_sizes(num_wlans_ix), ...
            nChannels, txPowerActions, ccaActions, 0); % RANDOM CONFIGURATION
    end
end

% Save the workspace
save('wlans', 'wlans')
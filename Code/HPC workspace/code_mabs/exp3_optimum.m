%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exploiting Spatial Reuse in Wireless Networks through Decentralised MABs
% F. Wilhelmi, B. Bellalta, A. Jonsson, C. Cano, G. Neu, S. Barrachina
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% EXPERIMENT EXPLANATION:
% By using a simple grid of 4 WLANs sharing 2 channels, we want to test several values of
% eta to evaluate the performance of EXP3 for each of them. We compare the obtained 
% results with the optimal configurations in terms of proportional fairness and aggregate
% throughput.

clc
clear all

% Add paths to methods folders
addpath(genpath('Power Management Methods/'));
addpath(genpath('Throughput Calculation Methods/'));
addpath(genpath('Network Generation Methods/'));
addpath(genpath('Reinforcement Learning Methods/'));
addpath(genpath('Reinforcement Learning Methods/Action Selection Methods/'));
addpath(genpath('Auxiliary Methods/'));

disp('-----------------------')
disp('EXP3: finding the best parameters')
disp('-----------------------')

nWorkers = 2;
parpool('local', nWorkers)

constants

% Define EXP3 parameters
initialEta = 0 : .1 : 1;
gamma = 0;

% Setup the scenario: generate WLANs and initialize states and actions
wlans = generate_network_3D(nWlans, 'grid', 2, 0); % SAFE CONFIGURATION

% Initialize variables for storing the output
throughputEvolutionPerWlan = cell(1, totalRepetitions);
meanThroughputEvolutionPerWlan = cell(1, totalRepetitions);
fairnessEvolution = cell(1, totalRepetitions);
meanThroughputExperienced = cell(1, totalRepetitions);
aggregateThroughput = cell(1, totalRepetitions);

%% ITERATE FOR NUMBER OF REPETITIONS (TO TAKE THE AVERAGE)

parfor (r = 1 : totalRepetitions, nWorkers)
    disp('------------------------------------')
    disp(['ROUND ' num2str(r) '/' num2str(totalRepetitions) ...
        ' (' num2str(totalIterations) ' iterations)'])
    disp('------------------------------------')
    % Iterate for each gamma
    for g = 1 : size(gamma, 2)
        % Iterate for each eta
        for e = 1 : size(initialEta, 2)         
            [throughputEvolutionPerWlan{r}, actionsProbability] = exp3(wlans, gamma(g), initialEta(e));
            for iteration=1:totalIterations
                meanThroughputEvolutionPerWlan{r}(iteration) = mean(throughputEvolutionPerWlan{r}(iteration,:));
            end
            meanThroughputExperienced{r}(g, e) = ...
                mean(meanThroughputEvolutionPerWlan{r});            
            aggregateThroughput{r}(g, e) = ...
                mean(sum(throughputEvolutionPerWlan{r}, 2));        
        end        
    end
end

delete(gcp('nocreate'))

save('exp3_analysis.mat')
clc
clear all

constants

% Setup the scenario: generate WLANs and initialize states and actions
wlans = generate_network_3D(nWlans, 'grid', 2, drawMap); % SAFE CONFIGURATION

% Compute the maximum achievable throughput per WLAN
upperBoundThroughputPerWlan = compute_max_selfish_throughput( wlans )

%throughputPerWlan = compute_throughput_from_sinr( wlans, NOISE_DBM );

% throughput = zeros(20, 4);
% 
% % Compute the throughput experienced per WLAN at each iteration
% for i = 1 : 20
%     for w = 1 : 4
%         wlans(1).TxPower = i;
%     end
%     throughput(i,:) = compute_throughput_from_sinr(wlans);
% end
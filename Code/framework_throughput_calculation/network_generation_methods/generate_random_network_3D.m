%%% ************************************************************************
%%% * Collaborative Spatial Reuse in Wireless Networks via Selfish MABs    *
%%% * Author: Francesc Wilhelmi (francesc.wilhelmi@upf.edu)                *
%%% * Co-authors: C. Cano, G. Neu, B. Bellalta, A. Jonsson & S. Barrachina *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi          *
%%% * GitHub repository:                                                   *
%%% *   https://github.com/wn-upf/Collaborative_SR_in_WNs_via_Selfish_MABs *
%%% * More info on https://www.upf.edu/en/web/fwilhelmi                    *
%%% ************************************************************************

function wlan = generate_random_network_3D( N_WLANs, NumChannels, TxPowerLevels, ccaLevels, printMap )
    % DrawNetwork3D  Calculate interferences on WLANs.
    %   Inputs:
    %       * N_WLANs: number of WLANs on the studied environment
    %       * NumChannels: number of available channels
    %       * B: bandwidth available per WLAN (Hz)
    %   Output:
    %       * wlan: object containing the information of each wlan drawn
        
    % Dimensions of the 3D map
    MaxX=10;
    MaxY=5; 
    MaxZ=10;
    % Maximum range for a STA
    MaxRangeX = 1;
    MaxRangeY = 1;
    MaxRangeZ = 1;
%     % AP density
%     disp('Density of APs');
%     disp(N_WLANs / (MaxX * MaxY * MaxZ));
 
    %% Locate elements on the map randomly
    for j=1:N_WLANs    
        % Assign Tx Power and CCA on the WLAN
        wlan(j).TxPower = max(TxPowerLevels);
        wlan(j).CCA = min(ccaLevels);
        % Assign channel to the AP randomly
        wlan(j).Channel = ceil(NumChannels*rand());
        % Assign location to the AP on the 3D map
        wlan(j).x = MaxX*rand();
        wlan(j).y = MaxY*rand();
        wlan(j).z = MaxZ*rand();  
        % Build arrays of locations for each AP
        x(j)=wlan(j).x;
        y(j)=wlan(j).y;
        z(j)=wlan(j).z;
        % Assign a STA to each AP for throughput analysis
        if(rand() < 0.5), xc = MaxRangeX.*rand();   %dnode*rand(); %what xc represents ? B: Is just an auxiliary variable to fix the position of the node around the AP, see below
        else xc = -MaxRangeX.*rand();
        end
        if(rand() < 0.5), yc = MaxRangeY.*rand();
        else yc = -MaxRangeY.*rand();
        end
        if(rand() < 0.5), zc = MaxRangeZ.*rand();
        else zc = -MaxRangeZ.*rand();
        end
        wlan(j).xn = min(abs(wlan(j).x+xc), MaxX);  
        wlan(j).yn = min(abs(wlan(j).y+yc), MaxY);
        wlan(j).zn = min(abs(wlan(j).z+zc), MaxZ);
        xn(j)=wlan(j).xn; %what is xn(j) B: the "x" position of node j
        yn(j)=wlan(j).yn;
        zn(j)=wlan(j).zn;        
        wlan(j).BW = 20e6; 
    end

   %% Plot map of APs and STAs
   if printMap == 1
        disp('Channels selected per WLAN')
        for i=1:N_WLANs
            channels(i) = wlan(i).channel;       
        end
        for i=1:NumChannels
            sumChannels(i) = sum(channels==i);
        end
        disp(channels)
        disp('Times a channel is occupied')
        disp(sumChannels)
        DrawNetwork3D(wlan);
   end
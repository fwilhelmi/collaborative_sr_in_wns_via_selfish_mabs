%%% ************************************************************************
%%% * Collaborative Spatial Reuse in Wireless Networks via Selfish MABs    *
%%% * Author: Francesc Wilhelmi (francesc.wilhelmi@upf.edu)                *
%%% * Co-authors: C. Cano, G. Neu, B. Bellalta, A. Jonsson & S. Barrachina *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi          *
%%% * GitHub repository:                                                   *
%%% *   https://github.com/wn-upf/Collaborative_SR_in_WNs_via_Selfish_MABs *
%%% * More info on https://www.upf.edu/en/web/fwilhelmi                    *
%%% ************************************************************************
function wlans = generate_network_3D(nWlans, topology, stasPosition, printMap)
% GenerateNetwork3D - Generates a 3D network 
%   OUTPUT: 
%       * wlan - contains information of each WLAN in the map. For instance,
%       wlan(1) corresponds to the first one, so that it has unique
%       parameters (x,y,z,BW,CCA,etc.)
%   INPUT: 
%       * nWlans: number of WLANs on the studied environment
%       * nChannels: number of available channels
%       * topology: topology of the network ('ring', 'line' or 'grid')
%       * stas_position: way STAs are placed (1 - "random", 2 - "safe" or 3 - "exposed")
%       * printMap: flag for calling DrawNetwork3D at the end

    load('constants.mat')
    
    if (topology == 'ring')
        x0 = MaxX/2;
        y0 = MaxY/2;
        r = (MaxY-1)/2;
        n=nWlans;
        tet=linspace(-pi,pi,n+1);                
        posX = r*cos(tet)+x0;
        posY = r*sin(tet)+y0;
    end
    
    gridPositions4 = [
    (MaxX)/nWlans (MaxY)/nWlans MaxZ/2;
    (MaxX)/nWlans 3*(MaxY)/nWlans MaxZ/2;
    3*(MaxX)/nWlans (MaxY)/nWlans MaxZ/2;
    3*(MaxX)/nWlans 3*(MaxY)/nWlans MaxZ/2;
    ];
             
    gridPositions8 = [
    (MaxX)/(nWlans/2) (MaxY)/(nWlans/2) MaxZ/(nWlans/2);
    (MaxX)/(nWlans/2) 3*(MaxY)/(nWlans/2) MaxZ/(nWlans/2);
    3*(MaxX)/(nWlans/2) (MaxY)/(nWlans/2) MaxZ/(nWlans/2);
    3*(MaxX)/(nWlans/2) 3*(MaxY)/(nWlans/2) MaxZ/(nWlans/2);
    (MaxX)/(nWlans/2) (MaxY)/(nWlans/2) 3*MaxZ/(nWlans/2);
    (MaxX)/(nWlans/2) 3*(MaxY)/(nWlans/2) 3*MaxZ/(nWlans/2);
    3*(MaxX)/(nWlans/2) (MaxY)/(nWlans/2) 3*MaxZ/(nWlans/2);
    3*(MaxX)/(nWlans/2) 3*(MaxY)/(nWlans/2) 3*MaxZ/(nWlans/2);
    ];
  
    gridPositions12 = [
    (MaxX)/(nWlans/3) (MaxY)/(nWlans/3) MaxZ/(nWlans/3);
    (MaxX)/(nWlans/3) 3*(MaxY)/(nWlans/3) MaxZ/(nWlans/3);
    3*(MaxX)/(nWlans/3) (MaxY)/(nWlans/3) MaxZ/(nWlans/3);
    3*(MaxX)/(nWlans/3) 3*(MaxY)/(nWlans/3) MaxZ/(nWlans/3);
    (MaxX)/(nWlans/3) (MaxY)/(nWlans/3) 2*MaxZ/(nWlans/3);
    (MaxX)/(nWlans/3) 3*(MaxY)/(nWlans/3) 2*MaxZ/(nWlans/3);
    3*(MaxX)/(nWlans/3) (MaxY)/(nWlans/3) 2*MaxZ/(nWlans/3);
    3*(MaxX)/(nWlans/3) 3*(MaxY)/(nWlans/3) 2*MaxZ/(nWlans/3);
    (MaxX)/(nWlans/3) (MaxY)/(nWlans/3) 3*MaxZ/(nWlans/3);
    (MaxX)/(nWlans/3) 3*(MaxY)/(nWlans/3) 3*MaxZ/(nWlans/3);
    3*(MaxX)/(nWlans/3) (MaxY)/(nWlans/3) 3*MaxZ/(nWlans/3);
    3*(MaxX)/(nWlans/3) 3*(MaxY)/(nWlans/3) 3*MaxZ/(nWlans/3);
    ];
    
    for j=1:nWlans 
        wlans(j).TxPower = datasample(txPowerActions, 1);       % Assign Tx Power
        wlans(j).CCA = datasample(ccaActions, 1);               % Assign CCA
        wlans(j).Channel = round((nChannels-1).*rand() + 1);    % mod(j,nChannels/2) + 1;   % Assign channels
        wlans(j).BW = 20e6; 
        if (topology == 'ring')
            wlans(j).x = posX(j);
            wlans(j).y = posY(j);
            wlans(j).z = MaxZ/2; 
        elseif (topology == 'line')
            wlans(j).x = j*((MaxX-2)/nWlans);
            wlans(j).y = MaxY/2;
            wlans(j).z = MaxZ/2; 
        elseif (topology == 'grid') 
            if(nWlans == 4)
                wlans(j).x = gridPositions4(j,1);
                wlans(j).y = gridPositions4(j,2);
                wlans(j).z = gridPositions4(j,3); 
            elseif(nWlans == 8)
                wlans(j).x = gridPositions8(j,1);
                wlans(j).y = gridPositions8(j,2);
                wlans(j).z = gridPositions8(j,3); 
            elseif(nWlans == 12)
                wlans(j).x = gridPositions12(j,1);
                wlans(j).y = gridPositions12(j,2);
                wlans(j).z = gridPositions12(j,3);  
            else
                disp('error, only 4, 8 and 12 WLANs allowed')
            end

        end
        
        % Build arrays of locations for each AP
        x(j)=wlans(j).x;
        y(j)=wlans(j).y;
        z(j)=wlans(j).z;   
        
        switch topology
            
            case 'grid'
                % Add the listening STA to each AP randomly
                if stasPosition == 1 % RANDOM
                    if(rand() < 0.5) 
                        wlans(j).xn = wlans(j).x + MaxRangeX.*rand();
                    else 
                        wlans(j).xn = wlans(j).x - MaxRangeX.*rand();
                    end

                    if(rand() < 0.5) 
                        wlans(j).yn = wlans(j).y + MaxRangeY.*rand();
                    else 
                        wlans(j).yn = wlans(j).y - MaxRangeY.*rand();
                    end

                    if(rand() < 0.5) 
                        wlans(j).zn = wlans(j).z + MaxRangeZ.*rand();
                    else 
                        wlans(j).zn = wlans(j).z - MaxRangeZ.*rand();
                    end
                elseif stasPosition == 2 % SAFE
                    if j == 1
                        wlans(j).xn = wlans(j).x - MaxRangeX;
                        wlans(j).yn = wlans(j).y - MaxRangeY;
                    elseif j == 2
                        wlans(j).xn = wlans(j).x - MaxRangeX;
                        wlans(j).yn = wlans(j).y + MaxRangeY;
                    elseif j == 3
                        wlans(j).xn = wlans(j).x + MaxRangeX;
                        wlans(j).yn = wlans(j).y - MaxRangeY;
                    elseif j == 4
                        wlans(j).xn = wlans(j).x + MaxRangeX;
                        wlans(j).yn = wlans(j).y + MaxRangeY;
                    end
                     wlans(j).zn = wlans(j).z;  
                elseif stasPosition == 3 % EXPOSED
                    if j == 1
                        wlans(j).xn = wlans(j).x + MaxRangeX;
                        wlans(j).yn = wlans(j).y + MaxRangeY;
                    elseif j == 2
                        wlans(j).xn = wlans(j).x + MaxRangeX;
                        wlans(j).yn = wlans(j).y - MaxRangeY;
                    elseif j == 3
                        wlans(j).xn = wlans(j).x - MaxRangeX;
                        wlans(j).yn = wlans(j).y + MaxRangeY;
                    elseif j == 4
                        wlans(j).xn = wlans(j).x - MaxRangeX;
                        wlans(j).yn = wlans(j).y - MaxRangeY;
                    end
                     wlans(j).zn = wlans(j).z;                         
                end
                
            case 'line'
                % Add the listening STA to each AP randomly
                if stasPosition == 1 % RANDOM
                    if(rand() < 0.5) 
                        wlans(j).xn = wlans(j).x + MaxRangeX.*rand();
                    else 
                        wlans(j).xn = wlans(j).x - MaxRangeX.*rand();
                    end

                    if(rand() < 0.5) 
                        wlans(j).yn = wlans(j).y + MaxRangeY.*rand();
                    else 
                        wlans(j).yn = wlans(j).y - MaxRangeY.*rand();
                    end

                    if(rand() < 0.5) 
                        wlans(j).zn = wlans(j).z + MaxRangeZ.*rand();
                    else 
                        wlans(j).zn = wlans(j).z - MaxRangeZ.*rand();
                    end
                elseif stasPosition == 2 % SAFE
                    wlans(j).xn = wlans(j).x;
                    wlans(j).yn = wlans(j).y + MaxRangeY;
                    wlans(j).zn = wlans(j).z;
                elseif stasPosition == 3 % EXPOSED
                    wlans(j).xn = wlans(j).x + ((MaxX-2)/nWlans)/2;
                    wlans(j).yn = wlans(j).y;
                    wlans(j).zn = wlans(j).z;                    
                end
                
            case 'ring'
                               % Add the listening STA to each AP randomly
                if stasPosition == 1 % RANDOM
                    if(rand() < 0.5) 
                        wlans(j).xn = wlans(j).x + MaxRangeX.*rand();
                    else 
                        wlans(j).xn = wlans(j).x - MaxRangeX.*rand();
                    end

                    if(rand() < 0.5) 
                        wlans(j).yn = wlans(j).y + MaxRangeY.*rand();
                    else 
                        wlans(j).yn = wlans(j).y - MaxRangeY.*rand();
                    end

                    if(rand() < 0.5) 
                        wlans(j).zn = wlans(j).z + MaxRangeZ.*rand();
                    else 
                        wlans(j).zn = wlans(j).z - MaxRangeZ.*rand();
                    end
                elseif stasPosition == 2 % SAFE
                    wlans(j).xn = wlans(j).x;
                    wlans(j).yn = wlans(j).y;
                    wlans(j).zn = wlans(j).z - MaxRangeZ;  
                elseif stasPosition == 3 % EXPOSED
                    if j == 1
                        wlans(j).xn = wlans(j).x + MaxRangeX;
                        wlans(j).yn = wlans(j).y + MaxRangeY;
                    elseif j == 2
                        wlans(j).xn = wlans(j).x + MaxRangeX;
                        wlans(j).yn = wlans(j).y - MaxRangeY;
                    elseif j == 3
                        wlans(j).xn = wlans(j).x - MaxRangeX;
                        wlans(j).yn = wlans(j).y + MaxRangeY;
                    elseif j == 4
                        wlans(j).xn = wlans(j).x - MaxRangeX;
                        wlans(j).yn = wlans(j).y - MaxRangeY;
                    end
                     wlans(j).zn = wlans(j).z;                         
                end
        end
        
        xn(j)=wlans(j).xn; %what is xn(j) B: the "x" position of node j
        yn(j)=wlans(j).yn;
        zn(j)=wlans(j).zn;
        
    end
   
    %% Plot map of APs and STAs
   if printMap == 1
        draw_network_3D(wlans);
   end
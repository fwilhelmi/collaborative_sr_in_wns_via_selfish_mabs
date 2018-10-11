%%% ************************************************************************
%%% * Collaborative Spatial Reuse in Wireless Networks via Selfish MABs    *
%%% * Author: Francesc Wilhelmi (francesc.wilhelmi@upf.edu)                *
%%% * Co-authors: C. Cano, G. Neu, B. Bellalta, A. Jonsson & S. Barrachina *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi          *
%%% * GitHub repository:                                                   *
%%% *   https://github.com/wn-upf/Collaborative_SR_in_WNs_via_Selfish_MABs *
%%% * More info on https://www.upf.edu/en/web/fwilhelmi                    *
%%% ************************************************************************

function draw_network_3D(wlans)
% DrawNetwork3D - Plots a 3D of the network 
%   INPUT: 
%       * wlan - contains information of each WLAN in the map. For instance,
%       wlan(1) corresponds to the first one, so that it has unique
%       parameters (x,y,z,BW,CCA,etc.)

    load('constants.mat')
    
    num_wlans = size(wlans, 2);
    
    for j = 1 : num_wlans
        x(j) = wlans(j).x;
        y(j) = wlans(j).y;
        z(j) = wlans(j).z;
    end
    
    figure
    axes;
    set(gca,'fontsize',16);
    labels = num2str((1:size(y' ))','%d');    
    for i = 1 : num_wlans
        scatter3(wlans(i).x, wlans(i).y, wlans(i).z, 70, [0 0 0], 'filled');
        hold on;   
        scatter3(wlans(i).xn, wlans(i).yn, wlans(i).zn, 30, [0 0 1], 'filled');
        line([wlans(i).x, wlans(i).xn], ...
            [wlans(i).y, wlans(i).yn], ...
            [wlans(i).z, wlans(i).zn], 'Color', [0.4, 0.4, 1.0], 'LineStyle', ':');        
    end
    text(x,y,z,labels,'horizontal','left','vertical','bottom') 
    xlabel('x [meters]','fontsize',14);
    ylabel('y [meters]','fontsize',14);
    zlabel('z [meters]','fontsize',14);
    axis([0 MaxX 0 MaxY 0 MaxZ])
end
%%% ************************************************************************
%%% * Collaborative Spatial Reuse in Wireless Networks via Selfish MABs    *
%%% * Author: Francesc Wilhelmi (francesc.wilhelmi@upf.edu)                *
%%% * Co-authors: C. Cano, G. Neu, B. Bellalta, A. Jonsson & S. Barrachina *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi          *
%%% * GitHub repository:                                                   *
%%% *   https://github.com/wn-upf/Collaborative_SR_in_WNs_via_Selfish_MABs *
%%% * More info on https://www.upf.edu/en/web/fwilhelmi                    *
%%% ************************************************************************

function ix = indexes2val(i,j,k,a,b)
% indexes2val provides the index ix from i, j, k (value for each variable)
%   OUTPUT: 
%       * ix - index of the (i,j,k) combination
%   INPUT: 
%       * i - index of the first element
%       * j - index of the second element
%       * k - index of the third element
%       * a - size of elements containing "i"
%       * b - size of elements containing "j"
%           (size of elements containing "k" is not necessary)

    ix = i + (j-1)*a + (k-1)*a*b;
    
end
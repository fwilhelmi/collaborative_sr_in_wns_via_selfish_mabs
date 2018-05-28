%%% ************************************************************************
%%% * Collaborative Spatial Reuse in Wireless Networks via Selfish MABs    *
%%% * Author: Francesc Wilhelmi (francesc.wilhelmi@upf.edu)                *
%%% * Co-authors: C. Cano, G. Neu, B. Bellalta, A. Jonsson & S. Barrachina *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi          *
%%% * GitHub repository:                                                   *
%%% *   https://github.com/wn-upf/Collaborative_SR_in_WNs_via_Selfish_MABs *
%%% * More info on https://www.upf.edu/en/web/fwilhelmi                    *
%%% ************************************************************************

function [i,j,k] = val2indexes(ix, a, b, c)
% val2indexes provides the indexes i,j,k from index ix
%   OUTPUT: 
%       * i - index of the first element
%       * j - index of the second element
%       * k - index of the third element
%   INPUT: 
%       * ix - index of the (i,j,k) combination
%       * a - size of elements containing "i"
%       * b - size of elements containing "j"
%       * c - size of elements containing "k"

    i = mod(ix, a); 
    if i == 0, i = a; end    
    y = mod(ix, (a * b));
    j = ceil(y/a);
    if j == 0, j = b; end 
    k = ceil(ix / (a * b)); 
    if k > c, k = c; end
    
end
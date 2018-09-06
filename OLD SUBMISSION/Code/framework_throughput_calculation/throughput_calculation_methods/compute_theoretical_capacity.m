%%% ************************************************************************
%%% * Collaborative Spatial Reuse in Wireless Networks via Selfish MABs    *
%%% * Author: Francesc Wilhelmi (francesc.wilhelmi@upf.edu)                *
%%% * Co-authors: C. Cano, G. Neu, B. Bellalta, A. Jonsson & S. Barrachina *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi          *
%%% * GitHub repository:                                                   *
%%% *   https://github.com/wn-upf/Collaborative_SR_in_WNs_via_Selfish_MABs *
%%% * More info on https://www.upf.edu/en/web/fwilhelmi                    *
%%% ************************************************************************

function C = compute_theoretical_capacity(B, sinr)
% Computes the theoretical capacity given a bandwidth and a SINR
%
% OUTPUT:
%   * C - capacity in bps
% INPUT:
%   * B - Available Bandwidth (Hz) 
%   * sinr - Signal to Interference plus Noise Ratio (-)

    C = B * log2(1 + sinr);

end
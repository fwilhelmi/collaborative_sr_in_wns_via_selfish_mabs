%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exploiting Spatial Reuse in Wireless Networks through Decentralised MABs
% F. Wilhelmi, B. Bellalta, A. Jonsson, C. Cano, G. Neu, S. Barrachina
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
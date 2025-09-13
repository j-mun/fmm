%fmm.eig.slab_te | 
%
%
%

function [V,W,D] = slab_te(ep,Kx)

N = size(Kx,1);
I = eye(N);
W = I;
Q = ep*I-diag(Kx.^2);
n = sqrt(ep);
iKz = -1i*sqrt(n+Kx).*sqrt(n-Kx);
% iKz = sqrt(-ep+Kx.^2);
D = iKz;
V = Q./D.';
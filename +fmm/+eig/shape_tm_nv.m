%fmm.eig.shape_tm_nv

function [V,W,D] = shape_tm_nv(E,recE,Kx)
N = size(Kx,1);
I = eye(N);
invE = inv(E);
P = I-Kx.*invE.*Kx.';
Q = -inv(recE);
[W,D] = eig(P*Q);
D = sqrt(diag(D));
V = Q*W./D.';
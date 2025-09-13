%fmm.eig.shape_tm

function [V,W,D] = shape_tm(E,Kx)
N = size(Kx,1);
I = eye(N);
invE = inv(E);
P = I-Kx.*invE.*Kx.';
Q = -E;
[W,D] = eig(P*Q);
D = sqrt(diag(D));
V = Q*W./D.';
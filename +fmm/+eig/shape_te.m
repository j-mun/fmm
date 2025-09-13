%fmm.eig.shape_te

function [V,W,D] = shape_te(E,Kx)
N = size(Kx,1);
I = eye(N);
P = -I;
Q = E-diag(Kx.^2);
[W,D] = eig(P*Q);
D = sqrt(diag(D));
V = Q*W./D.';
%fmm.eig.slab


function [V,W,D] = slab(ep,Kx,Ky)

N = size(Kx,1);
I = eye(N);
W = blkdiag(I,I);
Q = [diag(Kx.*Ky),ep*I-diag(Kx.^2);
    diag(Ky.^2)-ep*I,-diag(Kx.*Ky)];

n = sqrt(ep);
Kt = sqrt(Kx.^2+Ky.^2);
iKz = -1i*sqrt(n+Kt).*sqrt(n-Kt);


% iKz = conj(sqrt(-conj(eps)+Kx.^2+Ky.^2));
% Kz = sqrt(eps-Kx.^2-Ky.^2);

D = [iKz;iKz];
V = Q./D.';

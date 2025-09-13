%fmm.eig.shape


function [V,W,D] = shape(E,Kx,Ky)

N = size(Kx,1);
I = eye(N);
invE = inv(E);
P = [Kx.*invE.*Ky.', I-Kx.*invE.*Kx.';
    Ky.*invE.*Ky.'-I, -Ky.*invE.*Kx.'];
Q = [diag(Kx.*Ky), E-diag(Kx.^2);
    diag(Ky.^2)-E, -diag(Kx.*Ky)];
[W,D] = eig(P*Q);
D = sqrt(diag(D));
V = Q*W./D.';
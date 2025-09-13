%fmm.eig.shape_nv

function [V,W,D] = shape_nvm2(E,recE,Kx,Ky,Nxx,Nyy,Nxy)
N = size(Kx,1);
I = eye(N);
invE = inv(E);
invrecE = inv(recE);
delE = E-invrecE;
delExx = delE*Nxx;
delExy = delE*Nxy;
delEyy = delE*Nyy;
P = [Kx.*invE.*Ky.', I-Kx.*invE.*Kx.';
    Ky.*invE.*Ky.'-I, -Ky.*invE.*Kx.'];
Q = [diag(Kx.*Ky)-delExy, E-diag(Kx.^2)-delEyy;
    diag(Ky.^2)-E+delExx, -diag(Kx.*Ky)+delExy];
[W,D] = eig(P*Q);
D = sqrt(diag(D));
V = Q*W./D.';
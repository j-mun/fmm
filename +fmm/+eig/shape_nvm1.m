%fmm.eig.shape_nv

function [V,W,D] = shape_nvm1(E,recE,Kx,Ky,Nxx,Nyy,Nxy)
N = size(Kx,1);
I = eye(N);
invE = inv(E);
invrecE = inv(recE);
delE = E-invrecE;
delExx = 0.5*(delE*Nxx+Nxx*delE);
delExy = 0.5*(delE*Nxy+Nxy*delE);
delEyy = 0.5*(delE*Nyy+Nyy*delE);
P = [Kx.*invE.*Ky.', I-Kx.*invE.*Kx.';
    Ky.*invE.*Ky.'-I, -Ky.*invE.*Kx.'];
Q = [diag(Kx.*Ky)-delExy, E-diag(Kx.^2)-delEyy;
    diag(Ky.^2)-E+delExx, -diag(Kx.*Ky)+delExy];
[W,DD] = eig(P*Q);
D = sqrt(diag(DD));
V = Q*W./D.';
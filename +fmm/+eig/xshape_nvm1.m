%fmm.eig.xshape
% eigenmatrix for "anisotropic, nonmagnetic homogeneous layer"



function [V,W,D] = xshape_nvm1(Exx,Eyy,Ezz,recExx,recEyy,Kx,Ky,Nxx,Nyy,Nxy)
N = size(Kx,1);
I = eye(N);
invEzz = inv(Ezz);
invrecExx = inv(recExx);
invrecEyy = inv(recEyy);
dExx = Exx-invrecExx;
dEyy = Eyy-invrecEyy;


P = [Kx.*invEzz.*Ky.', I-Kx.*invEzz.*Kx.';
    Ky.*invEzz.*Ky.'-I, -Ky.*invEzz.*Kx.'];
Q = [diag(Kx.*Ky)-dExx*Nxy, Eyy-diag(Kx.^2)-dEyy*Nyy;
    diag(Ky.^2)-Exx+dExx*Nxx, -diag(Kx.*Ky)+dEyy*Nxy];
[W,D] = eig(P*Q);
D = sqrt(diag(D));
V = Q*W./D.';
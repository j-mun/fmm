%fmm.eig.xshape
% eigenmatrix for "anisotropic, nonmagnetic homogeneous layer"



function [V,W,D] = xshape(Exx,Eyy,Ezz,Kx,Ky)
N = size(Kx,1);
I = eye(N);
% dEzz = decomposition(Ezz);
% P = [Kx/dEzz*Ky.', I-Kx/dEzz*Kx.';
%     Ky/dEzz*Ky.'-I, -Ky/dEzz*Kx.'];
invEzz = inv(Ezz);
P = [Kx.*invEzz.*Ky.', I-Kx.*invEzz.*Kx.';
    Ky.*invEzz.*Ky.'-I, -Ky.*invEzz.*Kx.'];
Q = [diag(Kx.*Ky), Eyy-diag(Kx.^2);
    diag(Ky.^2)-Exx, -diag(Kx.*Ky)];
[W,D] = eig(P*Q);
D = sqrt(diag(D));
V = Q*W./D.';
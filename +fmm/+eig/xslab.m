%fmm.eig.xslab |
%
%
%


function [V,W,D] = xslab(epxx,epyy,epzz,Kx,Ky)

N = size(Kx,1);
I = eye(N);

if epxx==epyy % uniaxial 1
    W = [...
        I,diag(-Ky./Kx);
        diag(Kx.\Ky),I];
    Q = [...
        diag(Kx.*Ky),epxx*I-diag(Kx.*Kx);
        diag(Ky.^2)-epxx*I,diag(-Ky.*Kx)];
    D = [sqrt(epxx/epzz*(Kx.^2+Ky.^2-epzz));
        sqrt(Kx.^2+Ky.^2-epxx)];

elseif epxx==epzz % uniaxial 2
    W = [...
        I,diag(-Kx.*Ky./(epxx-Ky.^2));
        zeros(N),I];
    Q = [...
        diag(Kx.*Ky),epyy*I-diag(Kx.*Kx);
        diag(Ky.^2)-epxx*I,diag(-Ky.*Kx)];
    D = [sqrt(Kx.^2+Ky.^2-epxx);
        sqrt(Kx.^2+epyy/epxx*Ky.^2-epyy)];

elseif epyy==epzz % uniaxial 3
    W = [...
        I,diag(-Kx.*Ky./(epyy-Ky.^2));
        zeros(N),I];
    Q = [...
        diag(Kx.*Ky),epyy*I-diag(Kx.*Kx);
        diag(Ky.^2)-epxx*I,diag(-Ky.*Kx)];
    D = [sqrt(Kx.^2+epxx/epyy*Ky.^2-epxx);
        sqrt(Kx.^2+epxx/epyy*Ky.^2-epxx)];

else % biaxial
    P = [...
        diag(Kx.*Ky),epzz*I-diag(Kx.^2);
        diag(Ky.^2)-epzz*I,diag(-Ky.*Kx)]/epzz;
    Q = [...
        diag(Kx.*Ky),epyy*I-diag(Kx.*Kx);
        diag(Ky.^2)-epxx*I,diag(-Ky.*Kx)];
    [W,D] = eig(P*Q);
    D = sqrt(diag(D));
    
end
% D = conj(D);
V = Q*W./D.';









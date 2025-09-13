%fmm.layer.util.ifft
%
% cmn ->IFFT->s(x,y)



function [s] = ifft(cmn,nG)

[nSx,nSy] = size(cmn);

if nargin==2
    nx = (nSx-1)/4;
    ny = (nSy-1)/4;
    nGx = nG(1);
    nGy = nG(2);
    ix = 1+floor(nGx/2)+(-2*nx:2*nx);
    iy = 1+floor(nGy/2)+(-2*ny:2*ny);
    cmn1 = zeros(nGx,nGy);
    cmn1(ix,iy) = cmn;
    % s = conj((ifftn(ifftshift(conj(cmn1)))))*nGx*nGy;
    s = ifftn(ifftshift(cmn1)) * (nGx*nGy);
else
    % s = conj((ifftn(ifftshift(conj(cmn)))))*nSx*nSy;
    s = ifftn(ifftshift(cmn)) * (nSx*nSy);
end

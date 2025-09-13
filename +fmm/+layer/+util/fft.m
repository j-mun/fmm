%fmm.layer.util.fft | 
%
% s(x,y) ->FFT-> cmn
%


function [cmn] = fft(s,n)

[nGx,nGy] = size(s);
% cmn = conj(fftshift(fftn(conj(s))))/(nGx*nGy);
cmn = fftshift(fftn(s))/(nGx*nGy);

if nargin==2
    nx = n(1);
    ny = n(2);
    ix = 1+floor(nGx/2)+(-2*nx:2*nx);
    iy = 1+floor(nGy/2)+(-2*ny:2*ny);
    cmn = cmn(ix,iy);
end

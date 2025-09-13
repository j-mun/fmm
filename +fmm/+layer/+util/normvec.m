%fmm.layer.util.normvec | returns normal vector fields of an image
%
%>> [NVx,NVy] = fmm.util.normvec(s,[nx ny],[bx by],[nGx nGy]);

function [nvx,nvy] = normvec(s,n,b,nG)

%--
if nargin<4
    nG = size(s);
end

%-- 0D or 1D
if nG(2)==1
    nvx = ones(nG);
    nvy = zeros(nG);
    return
end


fmn = fmm.layer.util.fft(s,n);

% fmn = 0.5*(fmn+conj(flipud(fliplr(fmn))));


nx = n(1);
ny = n(2);
bx = b(1);
by = b(2);

ix = -2*nx:2*nx;
iy = -2*ny:2*ny;
[ix_,iy_] = ndgrid(ix,iy);
kmx = bx*ix_;
kny = by*iy_;

normN = sqrt(sum((abs(kmx).^2+abs(kny).^2).*abs(fmn).^2,'all'));
nvmnx = 1i*kmx.*fmn/normN;
nvmny = 1i*kny.*fmn/normN;
nvx = fmm.layer.util.ifft(nvmnx,nG);
nvy = fmm.layer.util.ifft(nvmny,nG);

%** real-ize
% nvx = real(nvx)+imag(nvx);
% nvy = real(nvy)+imag(nvy);

%** normalize
normnv = sqrt(abs(nvx).^2+abs(nvy).^2);
normnv(normnv==0) = 1;
nvx = nvx./normnv;
nvy = nvy./normnv;
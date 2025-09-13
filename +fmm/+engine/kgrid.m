%fmm.engine.kgrid | constructs k-space grids for fmm calculations

function [dat] = kgrid(p)


%-- preallocation
nx = p.nx;
ny = p.ny;
n1 = p.n1;
n2 = p.n2;
Kx = n1*p.n_k(1);
Ky = n1*p.n_k(2);
Bx = p.bx/p.k0;
By = p.by/p.k0;

%-- k-space grids
Gx = (Kx-(-nx:nx).'*Bx);
Gy = (Ky-(-ny:ny).'*By);
[Gxmn,Gymn] = ndgrid(Gx,Gy);
Gx = Gxmn(:);
Gy = Gymn(:);

%-- k-space grid truncation
[ix,iy] = ndgrid(-nx:1:nx,-ny:1:ny);
i_fsgt = true(2*nx+1,2*ny+1);
if p.fsgt~=-1
    i_fsgt(abs(ix/nx).^(2*p.fsgt)+abs(iy/ny).^(2*p.fsgt)>1) = false;
end
dat.ix = ix(i_fsgt);
dat.iy = iy(i_fsgt);
dat.i_fsgt = i_fsgt;

Gx = Gx(i_fsgt);
Gy = Gy(i_fsgt);
dat.Kx = Gx;
dat.Ky = Gy;

%-- convolution 
nFx = 2*nx+1;
nFy = 2*ny+1;
nSx = 4*nx+1;
ix = reshape(repmat((1:nFx)',1,nFy),[1,nFx*nFy]);
iy = reshape(repmat((1:nFy),nFx,1),[1,nFx*nFy]);
i_conv = (iy-iy'+nFy-1)*nSx+(ix-ix'+nFx);
i_conv = i_conv(i_fsgt(:).',i_fsgt(:).');
dat.i_conv = i_conv;


%-- longitudinal k grids
Gz1 = sqrt(n1.^2-Gx.^2-Gy.^2);
Gz2 = sqrt(n2.^2-Gx.^2-Gy.^2);
dGz1 = 1./Gz1;
dGz2 = 1./Gz2;
if any(~isfinite(dGz1)) || any(~isfinite(dGz2))
    p.lambda0 = p.lambda0+1E-11;
    dat = fmm.engine.kgrid(p);
    return
end

dat.Kz1 = Gz1;
dat.Kz2 = Gz2;
dat.dKz1 = dGz1;
dat.dKz2 = dGz2;





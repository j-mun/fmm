%fmm.tmx.power
%
%
% basis : polarization basis of output modes
%
%


function [out] = power(p,dat,basis)

%** preallocation
% NF = p.nF;
nFx = p.nFx;
nFy = p.nFy;
Kx = dat.Kx;
NF = size(Kx,1);
Ky = dat.Ky;
Kz1 = dat.Kz1;
Kz2 = dat.Kz2;
dKz1 = dat.dKz1;
dKz2 = dat.dKz2;

%** xyz basis
t = dat.t;
r = dat.r;
n1 = p.n1;
n2 = p.n2;
rx = r(1:NF,1);
ry = r(NF+1:2*NF,1);
tx = t(1:NF,1);
ty = t(NF+1:2*NF,1);
rz = -dKz1.*(Kx.*rx+Ky.*ry);
tz = -dKz2.*(Kx.*tx+Ky.*ty);


%** ps basis
theta = p.theta;
phi2 = atan2(Ky,Kx);
cos_phi2 = cos(phi2);
sin_phi2 = sin(phi2);
rs = cos_phi2.*ry-sin_phi2.*rx;
rp = (cos_phi2.*(Kz1.*rx-Kx.*rz)-sin_phi2.*(Ky.*rz-Kz1.*ry))./n1;
ts = cos_phi2.*ty-sin_phi2.*tx;
tp = (cos_phi2.*(Kz2.*tx-Kx.*tz)-sin_phi2.*(Ky.*tz-Kz2.*ty))./n2;
Rs = real(Kz1).*abs(rs).^2./(n1*cosd(theta));
Ts = real(Kz2).*abs(ts).^2./(n1*cosd(theta));
Rp = real(Kz1).*abs(rp).^2./(n1*cosd(theta));
Tp = real(Kz2).*abs(tp).^2./(n1*cosd(theta));
out.Ttotal = sum(Ts+Tp,1);
out.Rtotal = sum(Rs+Rp,1);

%** linear (ps) basis
if any(strcmp(basis,'ps'))
    % initialize
    out.tp = zeros(nFx,nFy);
    out.ts = zeros(nFx,nFy);
    out.rp = zeros(nFx,nFy);
    out.rs = zeros(nFx,nFy);
    out.Tp = zeros(nFx,nFy);
    out.Ts = zeros(nFx,nFy);
    out.Rp = zeros(nFx,nFy);
    out.Rs = zeros(nFx,nFy);

    % 
    out.tp(dat.i_fsgt) = tp;
    out.ts(dat.i_fsgt) = ts;
    out.rp(dat.i_fsgt) = rp;
    out.rs(dat.i_fsgt) = rs;
    out.Tp(dat.i_fsgt) = Tp;
    out.Ts(dat.i_fsgt) = Ts;
    out.Rp(dat.i_fsgt) = Rp;
    out.Rs(dat.i_fsgt) = Rs;
end

%** helicity basis
if any(strcmp(basis,'lr'))
    % initialize
    out.tl = zeros(nFx,nFy);
    out.tr = zeros(nFx,nFy);
    out.rl = zeros(nFx,nFy);
    out.rr = zeros(nFx,nFy);
    out.Tl = zeros(nFx,nFy);
    out.Tr = zeros(nFx,nFy);
    out.Rl = zeros(nFx,nFy);
    out.Rr = zeros(nFx,nFy);

    %
    tl = (tp-1i*ts)/sqrt(2);
    tr = (tp+1i*ts)/sqrt(2);
    rl = (rp-1i*rs)/sqrt(2);
    rr = (rp+1i*rs)/sqrt(2);
    out.tl(dat.i_fsgt) = tl;
    out.tr(dat.i_fsgt) = tr;
    out.rl(dat.i_fsgt) = rl;
    out.rr(dat.i_fsgt) = rr;
    out.Tl(dat.i_fsgt) = real(Kz2).*abs(tl).^2./(n1*cosd(theta));
    out.Tr(dat.i_fsgt) = real(Kz2).*abs(tr).^2./(n1*cosd(theta));
    out.Rl(dat.i_fsgt) = real(Kz1).*abs(rl).^2./(n1*cosd(theta));
    out.Rr(dat.i_fsgt) = real(Kz1).*abs(rr).^2./(n1*cosd(theta));
end

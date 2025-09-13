%fmm.engine.tmx.conical | enhanced transmittance matrix method (conical)




function [dat] = conical(p,dat,monitor)


%== parameter preallocation ==%
% NF = p.nF;
NL = p.NL;
% nx = p.nx;
% ny = p.ny;
% nFx = p.nFx;
% nFy = p.nFy;
% nSx = p.nSx;
% nSy = p.nSy;
% Kx = dat.Kx;
% Ky = dat.Ky;

Kx = dat.Kx;
Ky = dat.Ky;
Kz1 = dat.Kz1;
Kz2 = dat.Kz2;
dKz1 = dat.dKz1;
dKz2 = dat.dKz2;
NF = size(Kx,1);

% KxKx = tmp.KxKx;
% KyKy = tmp.KyKy;
% KxKy = tmp.KxKy;
mu1 = p.mu1;
d = dat.d;

%** incident fields
k0 = p.k0;
kx = p.k1.*p.n_k(1);
ky = p.k1.*p.n_k(2);
kz = p.k1.*p.n_k(3);
delta00 = zeros(NF,1);
% delta00(nx*nFy+ny+1) = 1;
delta00(dat.ix==0 & dat.iy==0) = 1;
ex = p.n_e(1);
ey = p.n_e(2);
ez = p.n_e(3);

%** super- sub-strate mode matrices

I = eye(NF);
O = zeros(NF);
W = dat.W;
V = dat.V;
D = dat.D;
M1 = [...
    I,O;
    O,I;
    1i*diag(Kx.*Ky.*dKz1), 1i*diag((Ky.^2+Kz1.^2).*dKz1);
    -1i*diag((Kx.^2+Kz1.^2).*dKz1), -1i*diag(Kx.*Ky.*dKz1)];
M2 = [...
    I,O;
    O,I;
    -1i*diag(Kx.*Ky.*dKz2), -1i*diag((Ky.^2+Kz2.^2).*dKz2);
    1i*diag((Kx.^2+Kz2.^2).*dKz2), 1i*diag(Kx.*Ky.*dKz2)];
Mi = [...
    ex*delta00;
    ey*delta00;
    -1i*(kz*ey-ky*ez)/k0*delta00/mu1; %
    -1i*(kx*ez-kz*ex)/k0*delta00/mu1]; %

%** construct global transfer matrix
X = cell(1,NL);
a = cell(1,NL);
b = cell(1,NL);
G = M2; % G_(L+1)
for mL=NL:-1:1
    F = [W{mL},W{mL};
        -V{mL},V{mL}];
    X{mL} = diag(exp(-k0*D{mL}*d(mL)));
    ab = F\G;
    a1 = ab(1:2*NF,:);
    b1 = ab(2*NF+1:4*NF,:);
    G = F*[eye(2*NF);X{mL}*b1/a1*X{mL}];
    a{mL} = a1;
    b{mL} = b1;
end

%** transmission reflection coefficients
r = zeros(2*NF,1);
t = zeros(2*NF,1);
rt = [-M1,G]\Mi;
r(:,1) = rt(1:2*NF,1);
t1 = zeros(2*NF,NL+1);
t1(:,1) = rt(2*NF+1:4*NF,1);
for mL=1:NL
    t1(:,mL+1) = a{mL}\X{mL}*t1(:,mL);
end
t(:,1) = t1(:,NL+1);
dat.r = r;
dat.t = t;

%** calculate and save mode amplitudes for field calculation
if nargin>2 && monitor
    c_p = zeros(2*NF,NL);
    c_n = zeros(2*NF,NL);
    for mL=1:NL
        c_p(:,mL) = t1(:,mL);
        c_n(:,mL) = b{mL}/a{mL}*X{mL}*t1(:,mL); % = b(:,:,mL)*t1(:,mL+1)
    end
    dat.c_p = c_p;
    dat.c_n = c_n;
end

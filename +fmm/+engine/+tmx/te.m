%fmm.engine.tmx.te | enhanced transmittance matrix method (TE)

function [tmp] = te(p,tmp,monitor)

%** preallocation
nF = p.nF;
nL = p.NL;
nx = p.nx;
ny = p.ny;
% nFx = p.nFx;
nFy = p.nFy;
% nSx = p.nSx;
% nSy = p.nSy;
% Kx = dat.Kx;
% Ky = dat.Ky;
Kz1 = tmp.Kz1;
Kz2 = tmp.Kz2;
% dKz1 = tmp.dKz1;
% dKz2 = tmp.dKz2;
% KxKx = tmp.KxKx;
% KyKy = tmp.KyKy;
% KxKy = tmp.KxKy;
mu1 = p.mu1;
d = tmp.d;

%** incident fields
k0 = p.k0;
kx = p.k1.*p.n_k(1);
ky = p.k1.*p.n_k(2);
kz = p.k1.*p.n_k(3);
delta00 = zeros(nF,1);
delta00(nx*nFy+ny+1) = 1;
% TE : psi = 90 -> ex = ez = 0
% ex = p.n_e(1); % ex = 0;
ey = p.n_e(2);
ez = p.n_e(3);

%** super- sub-strate mode matrices
I = eye(nF);
% O = zeros(N);
W = tmp.W;
V = tmp.V;
D = tmp.D;
M1 = [I;
    1i*diag(Kz1)];  % check
M2 = [I;
    -1i*diag(Kz2)];  % check
Mi = [ey*delta00;
    -1i*(kz*ey-ky*ez)/k0*delta00/mu1];

%** construct global matrix
X = cell(1,nL);
a = cell(1,nL);
b = cell(1,nL);
G = M2;
for mL=nL:-1:1
    F = [W{mL},W{mL};
        -V{mL},V{mL}];
    X{mL} = diag(exp(-k0*D{mL}*d(mL)));
    ab = F\G;
    a1 = ab(1:nF,:);
    b1 = ab(nF+1:2*nF,:);
    G = F*[I;X{mL}*b1/a1*X{mL}];
    a{mL} = a1;
    b{mL} = b1;
end

%** transmission reflection coefficients
ry = zeros(nF,1);
ty = zeros(nF,1);
rt1 = [-M1,G]\Mi;
ry(:,1) = rt1(1:nF,1);
ty1 = zeros(nF,nL+1);
ty1(:,1) = rt1(nF+1:2*nF,1);
for mL=1:nL
    ty1(:,mL+1) = a{mL}\X{mL}*ty1(:,mL);
end
ty(:,1) = ty1(:,nL+1);
rx = zeros(nF,1);
tx = zeros(nF,1);
tmp.r = [rx;ry];
tmp.t = [tx;ty];

%** calculate and save mode amplitudes for field calculation
if nargin<3
    monitor = false;
end
if monitor
    c_p = zeros(nF,nL);
    c_n = zeros(nF,nL);
    for mL=1:nL
        c_p(:,mL) = ty1(:,mL);
        c_n(:,mL) = b{mL}/a{mL}*X{mL}*ty1(:,mL); % = b(:,:,p)*t1(:,p+1)
    end
    tmp.c_p = c_p;
    tmp.c_n = c_n;
end







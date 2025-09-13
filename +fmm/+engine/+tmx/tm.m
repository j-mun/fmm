%fmm.engine.tmx.tm | enhanced transmittance matrix method (TM)


function [tmp] = tm(p,tmp,monitor)

%** preallocation
% NF = p.nF;
NL = p.NL;
% nx = p.nx;
% ny = p.ny;
% nFx = p.nFx;
% nFy = p.nFy;
% nSx = p.nSx;
% nSy = p.nSy;
Kx = tmp.Kx;
NF = size(Kx,1);
% Ky = tmp.Ky;
Kz1 = tmp.Kz1;
Kz2 = tmp.Kz2;
dKz1 = tmp.dKz1;
dKz2 = tmp.dKz2;
% KxKx = tmp.KxKx;
% KyKy = tmp.KyKy;
% KxKy = tmp.KxKy;
mu1 = p.mu1;
d = tmp.d;

%** incident fields
k0 = p.k0;
kx = p.k1.*p.n_k(1);
% ky = p.k1.*p.n_k(2); % ky = 0
kz = p.k1.*p.n_k(3);
delta00 = zeros(NF,1);
delta00(tmp.ix==0 & tmp.iy==0) = 1;
% TM : psi = 0, ey = 0
ex = p.n_e(1);
% ey = p.n_e(2); % ey = 0
ez = p.n_e(3);

%** super- sub-strate mode matrices
I = eye(NF);
W = tmp.W;
V = tmp.V;
D = tmp.D;
M1 = [I;
    -1i*diag((Kx.^2+Kz1.^2).*dKz1)];  % check
M2 = [I;
    1i*diag((Kx.^2+Kz2.^2).*dKz2)];  % check
Mi = [ex*delta00;
    -1i*(kx*ez-kz*ex)/k0*delta00/mu1];


%** construct global matrix
X = cell(1,NL);
a = cell(1,NL);
b = cell(1,NL);
G = M2;
for mL=NL:-1:1
    F = [W{mL},W{mL};
        -V{mL},V{mL}];
    X{mL} = diag(exp(-k0*D{mL}*d(mL)));
    ab = F\G;
    a1 = ab(1:NF,:);
    b1 = ab(NF+1:2*NF,:);
    G = F*[I;X{mL}*b1/a1*X{mL}];
    a{mL} = a1;
    b{mL} = b1;
end

%** transmission reflection coefficients
rx = zeros(NF,1);
tx = zeros(NF,1);
rt1 = [-M1,G]\Mi;
rx(:,1) = rt1(1:NF,:);
tx1 = zeros(NF,NL+1);
tx1(:,1) = rt1(NF+1:2*NF,:);
for mL=1:NL
    tx1(:,mL+1) = a{mL}\X{mL}*tx1(:,mL);
end
tx(:,1) = tx1(:,NL+1);
ry = zeros(NF,1);
ty = zeros(NF,1);
tmp.r = [rx;ry];
tmp.t = [tx;ty];

%** calculate and save mode amplitudes for field calculation
if nargin<3
    monitor = false;
end
if monitor
    c_p = zeros(NF,NL,1);
    c_n = zeros(NF,NL,1);
    for mL=1:NL
        c_p(:,mL) = tx1(:,mL);
        c_n(:,mL) = b{mL}/a{mL}*X{mL}*tx1(:,mL); % = b(:,:,p)*t1(:,p+1)
    end
    tmp.c_p = c_p;
    tmp.c_n = c_n;
end
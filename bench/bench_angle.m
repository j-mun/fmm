clear;clc;

%-- param
% lambda0 = [460e-9 543e-9 647e-9 620e-9];
lambda0 = 530e-9;
% nAu = emm.import('Au/Johnson',lambda0,'param','n');
nPDMS = 1.5;
nGrating = 3.5;

p = 220E-9; % pitch
w = 150E-9; % width
h = 60E-9; % height
t = 100E-9; % Au thickness
s = 0E-9; % Au side

theta = 30;
phi = 45;
psi = 0;
eta = 45;
et0 = 376.730313668;



c = fmm;
c.setopt('mode','conical')
c.set('lam0',lambda0, ...
    'theta',theta,'phi',phi,'psi',psi,'eta',eta)


%--
x = linspace(0,p,101);
z = linspace(0,2e-6,501);
[x_,z_ ] = ndgrid(x,z);
y_ = zeros(size(x_));

c.field('plane','custom','x',x_,'y',y_,'z',z_)




figure
pcolor(x*1e9,z*1e9,imag(c.out.Ex).')
shading flat
axis equal tight
colorbar
clim([-1 1])

colormap(jet)
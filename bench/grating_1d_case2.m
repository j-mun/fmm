

addpath('P:/matplot')
% addpath('~/code/rcwa_v22/')

addpath('P:/git/fmm')
% addpath('P:/git')



%% spectra
clear;clc;

Nf = 101;
lam0 = linspace(400e-9,600e-9,Nf);

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



c = fmm;
c.setopt('nvm',true,'verbose',true,'res',64,'parallel',true,'pardim',Nf)
c.set('lam0',lam0,'nh',[1.0,nPDMS],...
    'nx',20,'ax',p,...
    'theta',theta,'phi',phi,'psi',psi,'eta',eta)
c.add('layer','n',1.0+1E-10,'d',50E-9)
c.add('rect','x',p/2,'xspan',p-(w+2*s),'n',1.0,'nh',nGrating,'d',h)
c.add('layer','d',t-h,'n',nGrating)
c.add('rect','x',p/2,'xspan',p-w,'n',nGrating,'nh',nPDMS,'d',h)
c.add('layer','n',nPDMS+1E-10,'d',50E-9)
c.compute

T = c.fetch('Ttotal');
R = c.fetch('Rtotal');


figure
plot(lam0*1e9,T, ...
    lam0*1e9,R)






%% near-fields
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
phi = -45;
psi = 0;
eta = 45;
et0 = 376.730313668;

%-- boundary
xx1 = [0
    0.5*p-0.5*(p-w-2*s)
    0.5*p-0.5*(p-w-2*s)
    0.5*p+0.5*(p-w-2*s)
    0.5*p+0.5*(p-w-2*s)
    p]*1E9;
yy1 = [0
    0
    h
    h
    0
    0]*1E9;


xx2 = [0
    0.5*p-0.5*(p-w)
    0.5*p-0.5*(p-w)
    0.5*p+0.5*(p-w)
    0.5*p+0.5*(p-w)
    p]*1E9;
yy2 = [t
    t
    t+h
    t+h
    t
    t]*1E9;

t_buffer = 500e-9;



c = fmm;
c.setopt('mode','conical')
c.setopt('nvm',true,'verbose',true,'res',64)
c.set('lam0',lambda0,'nh',[1.0,nPDMS],...
    'nx',50,'ax',p,...
    'theta',theta,'phi',phi,'psi',psi,'eta',eta)
c.add('layer','n',1.0+1E-10,'d',t_buffer)
c.add('rect','x',p/2,'xspan',p-(w+2*s),'n',1.0,'nh',nGrating,'d',h)
c.add('layer','d',t-h,'n',nGrating)
c.add('rect','x',p/2,'xspan',p-w,'n',nGrating,'nh',nPDMS,'d',h)
c.add('layer','n',nPDMS+1E-10,'d',t_buffer)
c.field('dx',2e-9,'dz',2e-9,'y',0)


fx = c.out.x;
fz = c.out.z;

Ex = c.out.Ex;
Ey = c.out.Ey;
Ez = c.out.Ez;
E2 = abs(Ex).^2+abs(Ey).^2+abs(Ez).^2;

Hx = c.out.Hx;
Hy = c.out.Hy;
Hz = c.out.Hz;
H2 = abs(Hx).^2+abs(Hy).^2+abs(Hz).^2;

C = et0*imag(Ex.*conj(Hx)+Ey.*conj(Hy)+Ez.*conj(Hz));
normE = sqrt(E2);

figure
% set(gcf,'Units','centimeters','Position',[5 5 3.2 3.8])
%             pcolor(fx*1e9,fz*1e9-50,squeeze(et0^2*H2).')
pcolor(fx*1e9,fz*1e9,squeeze(real(Ez)).')
shading flat
hold on
plot(xx1,yy1+t_buffer*1e9,'Color','k')
plot(xx2,yy2+t_buffer*1e9,'Color','k')
set(gca,'YDir','normal')


%             xlabel('{\itx} (nm)')
%             ylabel('{\itz} (nm)')
axis tight equal
colormap(turbo)
%             set(gca,'ColorScale','log')
%             clim([1e-1 1e1])
%             clim([0 100])
set(gca,'Layer','top')
set(gca,'FontName','Helvetica','FontSize',6)
%             set(gca,'XTick',0:40:120)
%             xlim([0 120])
%             mp.clim(1)
clim([-1 1])
colorbar

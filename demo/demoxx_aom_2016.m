%   See Fig. 2d in "Metasurface reconfiguration through lithium ion
%   intercalculation in transition metal oxide",
%   Adv. Opt. Mater. (2016)

%%
clear;clc;

%-- parameters
Nf = 51;
lambda0 = linspace(1200e-9,1700e-9,Nf);

% material properties
epsOxide = 5; % non-dispersive
epsPt = -25 + 70i;
epsAl = -180 + 35i;
epsAir = 1;
nh = [sqrt(epsAir);sqrt(epsPt)];

% structure parameters
a = 850e-9; % lattice spacing

% computational parameters
nx = 10;
ny = 10;

%-- computation
c = fmm;
c.setopt('nvm',1,'parallel',true,'pardim',Nf)
c.set('lam0',lambda0,'theta',15,'phi',0,'psi',0,...
    'n1',nh(1),'n2',nh(2),'ax',a,'ay',a,...
    'nx',nx,'ny',ny)
c.add('rect','d',150e-9,'nh',sqrt(epsAir),'n',sqrt(epsAl),...
    'x span',510e-9,'x',a/2,'y span',270e-9,'y',a/2,'nvm',true)
c.add('layer','d',500e-9,'n',sqrt(epsOxide))
c.compute % compute
R1 = c.fetch('Rtotal');

c2 = fmm;
c2.setopt('nvm',1,'parallel',true,'pardim',Nf)
c2.set('lam0',lambda0,'theta',15,'phi',0,'psi',90,...
    'n1',nh(1),'n2',nh(2),'ax',a,'ay',a,...
    'nx',nx,'ny',ny)
c2.add('rect','d',150e-9,'nh',sqrt(epsAir),'n',sqrt(epsAl),...
    'x span',510e-9,'x',a/2,'y span',270e-9,'y',a/2,'nvm',true)
c2.add('layer','d',500e-9,'n',sqrt(epsOxide))
c2.compute % compute
R2 = c2.fetch('Rtotal');

%-- visualize
figure
set(gcf,'units','centimeters','position',[5 5 8 6])
plot(lambda0*1e9,R1,'k-',...
    lambda0*1e9,R2,'r-')
xlabel('Wavelength (nm)')
ylabel('Reflectance (a.u.)')
legend('Rs','Rp')

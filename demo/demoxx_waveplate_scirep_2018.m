%% Figure 2b
%   See Fig. 2b in "Polarization-sensitive tunable absorber 
%   in visible and near-infrared regimes",
%   Sci. Rep. (2018) by Dassol Lee
clear;clc;

%-- parameters
Nf = 71;
lambda0 = linspace(500e-9,1200e-9,Nf);
epsAu = emm.import('Au/Johnson',lambda0);
nAir = 1;
nSiO2 = 1.43;
a = 200e-9; % lattice spacing
nx = 50; % maximum Fourier order

%-- compute
% TE
c = fmm;
c.setopt('parallel',true,'pardim',Nf)
c.set('lam0',lambda0,'theta',0,'phi',0,'psi',90,... % psi = 90 for TE
    'n1',nSiO2,'n2',nAir,'ax',a,'nx',nx)
c.add('rect','d',100e-9,'nh',nAir,'ep',epsAu,...
    'xspan',100e-9,'x',a/2)
c.compute
R_te = c.fetch('Rtotal');


% TM
c = fmm;
c.setopt('parallel',true,'pardim',Nf)
c.set('lam0',lambda0,'theta',0,'phi',0,'psi',0,... % psi = 0 for TM
    'n1',nSiO2,'n2',nAir,'ax',a,'nx',nx)
c.add('rect','d',100e-9,'nh',nAir,'ep',epsAu,...
    'xspan',100e-9,'x',a/2)
c.compute
R_tm = c.fetch('Rtotal');

%-- visualize
figure
set(gcf,'units','centimeters','position',[5 5 8 6])
plot(lambda0*1e9,R_te,'k-',...
    lambda0*1e9,R_tm,'r-')
xlabel('Wavelength (nm)')
ylabel('R (Simulated)')
legend('TE','TM')
xlim([500 1200])

c.visualize
% c.testparm

%% Figure 5
%   See Fig. 5 in "Polarization-sensitive tunable absorber 
%   in visible and near-infrared regimes",
%   Sci. Rep. (2018) by Dassol Lee
clear;clc;

%-- parameters
lambda0 = 800e-9;

% material properties
epsAu = emm.import('Au/Johnson',lambda0);
epsCr = emm.import('Cr/Johnson',lambda0);
nAir = 1;
nSiO2 = 1.43;
nh = [nSiO2;nAir];

% structure parameters
a = 200e-9; % lattice spacing

% computational parameters
nx = 200;

%-- compute
% Figure 5(a): TE
c = fmm;
c.set('lam0',lambda0,'theta',0,'phi',0,'psi',90,...
    'n1',nSiO2,'n2',nAir,'ax',a,'nx',nx)
c.add('layer','d',200e-9,'n',nSiO2+1e-10)   % SiO2 substrate
c.add('layer','d',8e-9,'eps',epsCr)         % Cr 8 nm
c.add('layer','d',85e-9,'n',nSiO2)        % SiO2 85 nm
c.add('rect','d',100e-9,'nh',nAir,'ep',epsAu,...
    'x span',100e-9,'x',a/2)                % grating
c.add('layer','d',200e-9,'n',nAir+1e-10)    % air super-strate
c.field('dx',0.5e-9,'dz',0.5e-9) % field computation
x = c.out.x;
z = c.out.z;
E2 = squeeze(abs(c.out.Ey).^2);

%-- visualize
figure
imagesc(x,z,E2')
colormap(jet)
clim([0 3])
axis equal tight
set(gca,'YDir','normal')
colorbar
set(gcf,'units','centimeters','position',[5 5 8 10])

%-- compute
% Figure 5(b): TM
c = fmm;
c.set('lam0',lambda0,'theta',0,'phi',0,'psi',0,...
    'n1',nSiO2,'n2',nAir,'ax',a,'nx',nx)
c.add('layer','d',200e-9,'n',nSiO2+1e-10)   % SiO2 substrate
c.add('layer','d',8e-9,'eps',epsCr)         % Cr 8 nm
c.add('layer','d',85e-9,'n',nSiO2)        % SiO2 85 nm
c.add('rect','d',100e-9,'nh',nAir,'ep',epsAu,...
    'x span',100e-9,'x',a/2,'nvm',true)      % grating
c.add('layer','d',200e-9,'n',nAir+1e-10)    % air super-strate
c.field('dx',0.5e-9,'dz',0.5e-9) % field computation
x = c.out.x;
z = c.out.z;
E2 = squeeze(abs(c.out.Ex).^2+abs(c.out.Ez).^2);

%-- visualize
figure
imagesc(x,z,E2')
colormap(jet)
clim([0 3])
axis equal tight
set(gca,'YDir','normal')
colorbar
set(gcf,'units','centimeters','position',[5 5 8 10])

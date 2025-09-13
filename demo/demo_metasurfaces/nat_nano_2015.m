% convergence is very poor because of gold -> do not use rcwa for metallic
% structure


%% Figure 1f
%
%
clear;clc;

Nf = 30;
lam0 = linspace(600e-9,1400e-9,Nf);
epsAu = emm.import('Au/Johnson',lam0);
nSi = 3.5;
nMgF2 = 1.4;
ax = 300e-9;
ay = 300e-9;
nx = 15;
ny = 15;

%-- compute
c = fmm;
c.setopt('basis','lr','parallel',true,'pardim',Nf)
c.set('lam0',lam0,'psi',0,'n2',nSi,'ax',ax,'ay',ay,'nx',nx,'ny',ny,'eta',45)
c.add('rect','nh',1.0,'ep',epsAu,...
    'x',ax/2,'xspan',200e-9,'y',ay/2,'yspan',80e-9,'d',30e-9)
c.add('layer','n',nMgF2,'d',90e-9)
c.add('layer','eps',epsAu,'d',130e-9)
c.compute
Rr = c.fetch('Rr',[nx+1 ny+1]);
Rl = c.fetch('Rl',[nx+1 ny+1]);
rr = c.fetch('rr',[nx+1 ny+1]);


figure
plot(lam0*1e9,100*Rr,'k-',...
    lam0*1e9,100*Rl,'r-')
xlabel('Wavelength (nm)')
ylabel('Reflectivity (%)')
legend('cross-polarization','co-polarization')
ylim([0 100])

figure
plot(lam0*1e9,(1/pi)*(2*pi+unwrap(angle(rr))),'k-')
xlabel('Wavelength (nm)')
ylabel('Phase (rad)')
set(gca,'YTick',0:1:2,'YTickLabel',{'0','\pi','2\pi'})


%% Figure 1d
clear;clc;

Nf = 30;
lam0 = linspace(500e-9,1500e-9,Nf);
epsAu = emmImport('Au/Johnson',lam0);
nSi = 3.5;
nMgF2 = 1.4;
ax = 300e-9;
ay = 300e-9;
nx = 10;
ny = 10;

c = rcwa;
c.setopt('parallel',true,'pardim',Nf)
c.set('lam0',lam0,'psi',0,'n2',nSi,'ax',ax,'ay',ay,'nx',nx,'ny',ny)
c.add('rect','nh',1.0,'ep',epsAu,...
    'x',ax/2,'xspan',200e-9,'y',ay/2,'yspan',80e-9,'d',30e-9)
c.add('layer','n',nMgF2,'d',90e-9)
c.add('layer','ep',epsAu,'d',130e-9)
c.compute

c2 = rcwa;
c2.setopt('parallel',true,'pardim',Nf)
c2.set('lam0',lam0,'psi',90,'n2',nSi,'ax',ax,'ay',ay,'nx',nx,'ny',ny)
c2.add('rect','nh',1.0,'ep',epsAu,...
    'x',ax/2,'xspan',200e-9,'y',ay/2,'yspan',80e-9,'d',30e-9)
c2.add('layer','n',nMgF2,'d',90e-9)
c2.add('layer','ep',epsAu,'d',130e-9)
c2.compute

R1 = c.fetch('Rtotal');
R2 = c2.fetch('Rtotal');
figure
plot(lam0*1e9,R1,'k-',...
    lam0*1e9,R2,'r-')
xlabel('Wavelength (nm)')
ylabel('Reflectance')
legend('R_l','R_s')
ylim([0 1])
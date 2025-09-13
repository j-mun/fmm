

% addpath('P:/git/emm/')
addpath('D:\OneDrive - Rholab\code\emm')

%%
clear;clc;


%-- parameters
Nf = 51;
lam0 = linspace(500e-9,800e-9,Nf)';
% nCr = emm.import('Cr/CRC',lam0,'param','n');
nCr = emm.import('Cr/Johnson',lam0,'param','n');
nSiO2 = 1.43;
nSi = 3.5; 
nx = 6;
a = 300e-9; % period
w = 40e-9; % thickness
d = 160e-9; % diameter
h1 = 40e-9; % height
h2 = 60e-9; % spacer thickness
h3 = 150e-9; % backreflector thickness

%-- computation
c = fmm;
c.setopt('parallel',true,'pardim',Nf, ...
    'nvm',2,'fsgt',-1,'res',64)
c.set('lam0',lam0,...
    'nx',nx,'ax',a,'ny',nx,'ay',a, ...
    'n1',1.0,'n2',nSi)
c.add('multiptc','d',h1,'nvres',-1,...
    'circ',{'n',nCr,'radius',d/2,'x',a/2,'y',a/2},...
    'circ',{'n',1.0,'radius',d/2-w,'x',a/2,'y',a/2})
c.add('layer','d',h2,'n',nSiO2)
c.add('layer','d',h3,'n',nCr)
c.compute
T = c.fetch('Ttotal');
R = c.fetch('Rtotal');

%-- visualize
figure
set(gcf,'units','centimeters','position',[5 5 12 8])
plot(lam0*1e9,T,'k-',...
    lam0*1e9,R,'b-',...
    lam0*1e9,1-T-R,'r-')
xlabel('wavelength (nm)')
ylabel('')
legend('T','R','1-T-R',...
    'location','best')
ylim([0 1])
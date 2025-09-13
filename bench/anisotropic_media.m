

%%
clear;clc;

%-- parameters
Nf = 100;
lam0 = linspace(400e-9,900e-9,Nf);
nx = 5;
ny = 5;
n = 1.5+0.1i;


%-- isotropic
c = fmm;
c.setopt('parallel',true,'pardim',Nf)
c.set('lam0',lam0,'ax',500e-9,'ay',600e-9,'nx',nx,'ny',ny,...
    'theta',1,'phi',0,'psi',90)
c.add('rect','model',1,'d',300e-9, ...
    'n',n,'nh',1,...
    'x',250e-9,'xspan',200e-9,...
    'y',300e-9,'yspan',300e-9)
c.add('layer','model',1,'d',300e-9, ...
    'n',n)
c.compute
T = c.fetch('Ttotal');
R = c.fetch('Rtotal');

%-- anisotropic
c = fmm;
c.setopt('parallel',true,'pardim',Nf)
c.set('lam0',lam0,'ax',500e-9,'ay',600e-9,'nx',nx,'ny',ny,...
    'theta',1,'phi',0,'psi',90)
c.add('rect','model',2,'d',300e-9, ...
    'nxx',n,'nyy',n,'nzz',n,'nhxx',1,'nhyy',1,'nhzz',1,...
    'x',250e-9,'xspan',200e-9,...
    'y',300e-9,'yspan',300e-9)
c.add('layer','model',2,'d',300e-9, ...
    'nxx',n,'nyy',n,'nzz',n)
c.compute
T1 = c.fetch('Ttotal');
R1 = c.fetch('Rtotal');

%-- visualize
figure
set(gcf,'Position',[500 500 500 400])
plot(lam0*1e9,T,'k-', ...
    lam0*1e9,R,'r-', ...
    lam0*1e9,T1,'ko', ...
    lam0*1e9,R1,'ro')
ylim([0 1])

%%
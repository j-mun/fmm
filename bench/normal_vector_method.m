



%% Normal Vector Method (NVM) or Fast Fourier Factorization (FFF)
clear;clc;






%%



%% convergence test : metallic 1D grating
clear;clc;

%-- parameters
lam0 = 700e-9;
ax = 200e-9;
wx = 100e-9;
n_SiO2 = 1.43;
epr_Au = emm.import('Au/Johnson',lam0);

nx = [1:1:50];
nf = length(nx);

%-- nvm
T_nvm = zeros(nf,1);
R_nvm = zeros(nf,1);
tic
for mf=1:nf
    c = fmm;
    c.setopt('verbose',false,'nvm',1)
    c.set('n1',n_SiO2,'ax',ax,'nx',nx(mf),...
        'theta',0,'phi',0,'psi',0)
    c.add('rect','ep',epr_Au,'nh',1,'d',100e-9,...
        'xmin',ax/2-wx/2,'xmax',ax/2+wx/2)
    c.set('lam0',lam0)
    c.compute
    T_nvm(mf) = c.out.Ttotal;
    R_nvm(mf) = c.out.Rtotal;
end
toc

%-- classical
T = zeros(nf,1);
R = zeros(nf,1);
tic
for mf=1:nf
    c = fmm;
    c.setopt('verbose',false,'nvm',0)
    c.set('n1',n_SiO2,'ax',ax,'nx',nx(mf),...
        'theta',0,'phi',0,'psi',0)
    c.add('rect','ep',epr_Au,'nh',1,'d',100e-9,...
        'xmin',ax/2-wx/2,'xmax',ax/2+wx/2)
    c.set('lam0',lam0)
    c.compute
    T(mf) = c.out.Ttotal;
    R(mf) = c.out.Rtotal;
end
toc

%-- visualize
figure
set(gcf,'Position',[500 500 400 300])
plot(nx,T,'k.-', ...
    nx,T_nvm,'r.-')
ylim([0 1])
legend('classical','nvm','location','best')
xlabel('n_x')
ylabel('T')

%% convergence test : dielectric 1D grating
clear;clc;

%-- parameters
lam0 = 700e-9;
ax = 200e-9;
wx = 100e-9;
n_SiO2 = 1.43;
nx = [1:1:30];
nf = length(nx);

%-- nvm
T_nvm = zeros(nf,1);
R_nvm = zeros(nf,1);
tic
for mf=1:nf
    c = fmm;
    c.setopt('verbose',false,'nvm',true)
    c.set('n1',n_SiO2,'ax',ax,'nx',nx(mf),...
        'theta',0,'phi',0,'psi',0)
    c.add('rect','n',9,'nh',1,'d',100e-9,...
        'xmin',ax/2-wx/2,'xmax',ax/2+wx/2)
    c.set('lam0',lam0)
    c.compute
    T_nvm(mf) = c.out.Ttotal;
    R_nvm(mf) = c.out.Rtotal;
end
toc

%-- classical
T = zeros(nf,1);
R = zeros(nf,1);
tic
for mf=1:nf
    c = fmm;
    c.setopt('verbose',false,'nvm',false)
    c.set('n1',n_SiO2,'ax',ax,'nx',nx(mf),...
        'theta',0,'phi',0,'psi',0)
    c.add('rect','n',9,'nh',1,'d',100e-9,...
        'xmin',ax/2-wx/2,'xmax',ax/2+wx/2)
    c.set('lam0',lam0)
    c.compute
    T(mf) = c.out.Ttotal;
    R(mf) = c.out.Rtotal;
end
toc


%-- visualize
figure
set(gcf,'Position',[500 500 400 300])
plot(nx,T,'k.-', ...
    nx,T_nvm,'r.-')
ylim([0 1])
legend('classical','nvm','location','best')
xlabel('n_x')
ylabel('T')

%% convergence test : high-index dielectric 2D grating
clear;clc;

%-- parameters
ax = 200e-9;
ay = 200e-9;
wx = 100e-9;
wy = 100e-9;
lam0 = 700e-9;
ns = 3.0;

%-- visualize normvec
c = fmm;
c.setopt('nvm',true)
c.set('lam0',lam0, ...
    'ax',ax,'ay',ay,'nx',3,'ny',3,...
    'theta',0,'phi',0,'psi',90)
c.add('rect','n',ns,'nh',1,'d',300E-9,...
    'xmin',ax/2-wx/2,'xmax',ax/2+wx/2,...
    'ymin',ax/2-wx/2,'ymax',ax/2+wx/2)
c.add('layer','n',ns,'d',300E-9)
c.compute

%** visualize nv
c.visualize
hold on
quiver(c.layer{1}.nvy,c.layer{1}.nvx,'g')





%-- convergence test
nx = [1:1:10,15,20];
nf = length(nx);
T = zeros(nf,1);
R = zeros(nf,1);
Tnvm = zeros(nf,1);
Rnvm = zeros(nf,1);
tic
for mf=1:nf
    c = fmm;
    c.setopt('verbose',false,'nvm',false)
    c.set('ax',ax,'ay',ay,'nx',nx(mf),'ny',nx(mf),...
        'theta',0,'phi',0,'psi',90)
    c.set('lam0',lam0)
    c.add('rect','n',ns,'nh',1,'d',300E-9,...
        'xmin',ax/2-wx/2,'xmax',ax/2+wx/2,...
        'ymin',ay/2-wy/2,'ymax',ay/2+wy/2)
    c.add('layer','n',ns,'d',300E-9)

    c.compute
    T(mf) = c.out.Ttotal;
    R(mf) = c.out.Rtotal;
end
toc
tic
for mf=1:nf
    c = fmm;
    c.setopt('verbose',false,'nvm',true)
    c.set('ax',ax,'ay',ay,'nx',nx(mf),'ny',nx(mf),...
        'theta',0,'phi',0,'psi',90)
    c.set('lam0',lam0)
    c.add('rect','n',ns,'nh',1,'d',300e-9,...
        'xmin',ax/2-wx/2,'xmax',ax/2+wx/2,...
        'ymin',ay/2-wy/2,'ymax',ay/2+wy/2)
    c.add('layer','n',ns,'d',300E-9)

    c.compute
    Tnvm(mf) = c.out.Ttotal;
    Rnvm(mf) = c.out.Rtotal;
end
toc



%-- visualize
figure
set(gcf,'Position',[500 500 400 300])
plot(nx,T,'k.-', ...
    nx,Tnvm,'r.-', ...
    nx,R,'k.-', ...
    nx,Rnvm,'r.-')
ylim([0 1])
legend('T','T_{nvm}','R','R_{nvm}', ...
    'location','best')
xlabel('Maximum Fourier order')
ylabel('Convergence')


%% convergence test : high-index dielectric metasurface
clear;clc;

%-- parameters
ax = 300e-9;
ay = 300e-9;
wx1 = 50e-9;
wy1 = 200e-9;
wx2 = 50e-9;
wy2 = 200e-9;
g = 50e-9;
n_SiO2 = 1.43;
nh = [n_SiO2;1];
Nf = 101;
lam0 = linspace(450e-9,650e-9,Nf);
nx = 10;


%-- visualize
c = fmm;
c.setopt('verbose',false,'nvm',false)
c.set('n1',n_SiO2,'ax',ax,'ay',ay,'nx',nx,'ny',nx,...
    'theta',0,'phi',0,'psi',0)
c.add('multiparticle','nh',1,'d',200e-9,...
    'rect',{'n',3.5,'xmin',ax/2+g/2,'xmax',ax/2+g/2+wx1,'ymin',ax/2-wy1/2,'ymax',ax/2+wy1/2},...
    'rect',{'n',3.5,'xmin',ax/2-g/2-wx2,'xmax',ax/2-g/2,'ymin',ax/2-wy2/2,'ymax',ax/2+wy2/2})
c.visualize
c.visualize(false)



%** Compare nvm / non-nvm
Tnvm = zeros(Nf,1);
Rnvm = zeros(Nf,1);
T = zeros(Nf,1);
R = zeros(Nf,1);
parfor mf=1:Nf
    c = fmm;
    c.setopt('verbose',false,'nvm',false)
    c.set('n1',n_SiO2,'ax',ax,'ay',ay,'nx',nx,'ny',nx,...
        'theta',0,'phi',0,'psi',0)
    c.add('multiptc','nh',1,'d',200e-9,...
        'rect',{'n',3.5,'xmin',ax/2+g/2,'xmax',ax/2+g/2+wx1,'ymin',ax/2-wy1/2,'ymax',ax/2+wy1/2},...
        'rect',{'n',3.5,'xmin',ax/2-g/2-wx2,'xmax',ax/2-g/2,'ymin',ax/2-wy2/2,'ymax',ax/2+wy2/2})
    c.set('lam0',lam0(mf))
    c.compute
    T(mf) = c.out.Ttotal;
    R(mf) = c.out.Rtotal;
    
    c = fmm;
    c.setopt('verbose',false,'nvm',true)
    c.set('n1',n_SiO2,'ax',ax,'ay',ay,'nx',nx,'ny',nx,...
        'theta',0,'phi',0,'psi',0)
    c.add('multiptc','nh',1,'d',200e-9,...
        'rect',{'n',3.5,'xmin',ax/2+g/2,'xmax',ax/2+g/2+wx1,'ymin',ax/2-wy1/2,'ymax',ax/2+wy1/2},...
        'rect',{'n',3.5,'xmin',ax/2-g/2-wx2,'xmax',ax/2-g/2,'ymin',ax/2-wy2/2,'ymax',ax/2+wy2/2})
    c.set('lam0',lam0(mf))
    c.compute
    Tnvm(mf) = c.out.Ttotal;
    Rnvm(mf) = c.out.Rtotal;
end


Rfem = readmatrix('nvm_metasurf.xlsx','Range','B2:B102');
Tfem = readmatrix('nvm_metasurf.xlsx','Range','E2:E102');


figure
set(gcf,'units','centimeters','position',[5 5 16 7])
tiledlayout(1,2,'TileSpacing','compact','padding','compact')
nexttile
plot(lam0*1e9,Tfem,'k-',...
    lam0*1e9,T,'b-',...
    lam0*1e9,Tnvm,'r--')
xlabel('Wavelength (nm)')
ylabel('Transmission')
legend('COMSOL','RCWA','RCWA (NVM)',...
    'location','best')
nexttile
plot(lam0*1e9,Rfem,'k-',...
    lam0*1e9,R,'b-',...
    lam0*1e9,Rnvm,'r--')
xlabel('Wavelength (nm)')
ylabel('Reflection')
% copygraphics(gcf,'resolution',300,'contenttype','image')


%% convergence test : metasurfaces
clear;clc;

%-- parameters
ax = 300e-9;
ay = 300e-9;
wx1 = 50e-9;
wy1 = 200e-9;
wx2 = 50e-9;
wy2 = 200e-9;
g = 50e-9;
n_SiO2 = 1.43;


lam0 = 555e-9;      % select single wavelength
nx = [1:5,10,15,20];
nf = length(nx);
T = zeros(nf,1);
R = zeros(nf,1);
Tnvm = zeros(nf,1);
Rnvm = zeros(nf,1);

tic
for mf=1:nf
    c = fmm;
    c.setopt('verbose',false,'nvm',false)
    c.set('n1',n_SiO2,'ax',ax,'ay',ay,'nx',nx(mf),'ny',nx(mf),...
        'theta',0,'phi',0,'psi',0)
    c.add('multiptc','nh',1,'d',200e-9,...
        'rect',{'n',3.5,'xmin',ax/2+g/2,'xmax',ax/2+g/2+wx1,'ymin',ax/2-wy1/2,'ymax',ax/2+wy1/2},...
        'rect',{'n',3.5,'xmin',ax/2-g/2-wx2,'xmax',ax/2-g/2,'ymin',ax/2-wy2/2,'ymax',ax/2+wy2/2})
    c.set('lam0',lam0)
    c.compute
    T(mf) = c.out.Ttotal;
    R(mf) = c.out.Rtotal;
end
toc
tic
for mf=1:nf
    c = fmm;
    c.setopt('verbose',false,'nvm',true)
    c.set('n1',n_SiO2,'ax',ax,'ay',ay,'nx',nx(mf),'ny',nx(mf),...
        'theta',0,'phi',0,'psi',0)
    c.add('multiptc','nh',1,'d',200e-9,...
        'rect',{'n',3.5,'xmin',ax/2+g/2,'xmax',ax/2+g/2+wx1,'ymin',ax/2-wy1/2,'ymax',ax/2+wy1/2},...
        'rect',{'n',3.5,'xmin',ax/2-g/2-wx2,'xmax',ax/2-g/2,'ymin',ax/2-wy2/2,'ymax',ax/2+wy2/2})
    c.set('lam0',lam0)
    c.compute
    Tnvm(mf) = c.out.Ttotal;
    Rnvm(mf) = c.out.Rtotal;
end
toc

%** visualize
figure
set(gcf,'units','centimeters','position',[5 5 16 7])
tiledlayout(1,2,'TileSpacing','compact','padding','compact')
nexttile
plot(nx,T,'.-k',...
    nx,Tnvm,'.-r')
xlabel('n_x')
ylabel('Transmission')
legend('RCWA','RCWA (NVM)',...
    'location','best')
nexttile
plot(nx,R,'.-k',...
    nx,Rnvm,'.-r')
xlabel('n_x')
ylabel('Reflection')
% copygraphics(gcf,'resolution',300,'contenttype','image')

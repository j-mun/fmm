%% ACS Nano 2018, 12, 6421--6428


%% Figure 2, Design A
clear;clc;

%-- parameters
Nf = 50;
lambda0 = linspace(400e-9,700e-9,Nf);
naSi = emm.import('a-Si/a-Si-H',lambda0,'param','n');

%-- material
figure
plot(lambda0*1e9,real(naSi),'k-',...
    lambda0*1e9,imag(naSi),'r-',...
    'LineWidth',1)
set(gcf,'Units','centimeters','Position',[5 5 8 6])
xlabel('Wavelength (nm)')
ylabel('Refractive index')
legend('Re','Im')

%--
nx = 15;
ny = 10;

% Design A
L = 300e-9;
W = 100e-9;
G = 100e-9;
H = 300e-9;
P = 500e-9;


%_- compute
c = fmm;
c.setopt('basis','lr','parallel',true,'pardim',Nf)
c.set('lam0',lambda0,...
    'nx',nx,'ny',ny,...
    'ax',P,'ay',P,...
    'eta',45,...
    'n2',1.5)
c.add('multiptc','d',H,'nh',1,...
    'rect',{'n',naSi,'xmin',P/2+G/2,'xmax',P/2+G/2+W,'y',P/2,'yspan',L},...
    'rect',{'n',naSi,'xmin',P/2-G/2-W,'xmax',P/2-G/2,'y',P/2,'yspan',L})
c.compute
toc
Tr = c.fetch('Tr',[nx+1 ny+1]);
tr = c.fetch('tr',[nx+1 ny+1]);
R = c.fetch('Rtotal');


%-- visualize
figure
set(gcf,'units','centimeters','position',[5 5 18 5])
subplot(131)
plot(lambda0*1e9,100*Tr,'k.-')
xlabel('Wavelength (nm)')
ylabel('Conversion efficiency (%)')
subplot(132)
plot(lambda0*1e9,unwrap(angle(tr)),'k.-')
xlabel('Wavelength (nm)')
ylabel('Phase (rad)')
subplot(133)
plot(lambda0*1e9,100*R,'k.-')
xlabel('Wavelength (nm)')
ylabel('Reflectance (%)')
ylim([0 16])

c.visualize
c.visualize('index')



%% Design B
clear;clc;

%-- parameters
Nf = 50;
lambda0 = linspace(400e-9,700e-9,Nf);
naSi = emm.import('a-Si/a-Si-H',lambda0,'param','n');

nx = 15;
ny = 10;

L = 300e-9;
W = 50e-9;
G = 100e-9;
H = 300e-9;
P = 500e-9;

%-- compute
c = fmm;
c.setopt('basis','lr','parallel',true,'pardim',Nf)
c.set('lam0',lambda0,...
    'nx',nx,'ny',ny,...
    'ax',P,'ay',P,...
    'eta',45,...
    'n2',1.5)
c.add('multiptc','d',H,'nh',1,...
    'rect',{'n',naSi,'xmin',P/2+G/2,'xmax',P/2+G/2+W,'y',P/2,'yspan',L},...
    'rect',{'n',naSi,'xmin',P/2-G/2-W,'xmax',P/2-G/2,'y',P/2,'yspan',L})
c.compute
Tr = c.fetch('Tr',[nx+1 ny+1]);
tr = c.fetch('tr',[nx+1 ny+1]);
R = c.fetch('Rtotal');

%-- visualize
figure
set(gcf,'units','centimeters','position',[5 5 18 5])
subplot(131)
plot(lambda0*1e9,100*Tr,'k-',...
    'LineWidth',1.0)
xlabel('Wavelength (nm)')
ylabel('Conversion efficiency (%)')
subplot(132)
plot(lambda0*1e9,unwrap(angle(tr)),'k-',...
    'LineWidth',1.0)
xlabel('Wavelength (nm)')
ylabel('Phase (rad)')
subplot(133)
plot(lambda0*1e9,100*R,'k-',...
    'LineWidth',1.0)
xlabel('Wavelength (nm)')
ylabel('Reflectance (%)')
ylim([0 16])

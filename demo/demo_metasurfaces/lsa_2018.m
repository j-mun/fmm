%% LSA 2018, 7, 63

%% Figure 1g
clear;clc;


%-- parameters
Nf = 50;
lambda0 = linspace(400e-9,750e-9,Nf);
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
P = 300e-9; % period
L = 230e-9; % length
W = 124e-9; % width
H = 277e-9; % height
nx = 10;
ny = 10;


%-- compute
c = fmm;
c.setopt('basis','lr','parallel',true,'pardim',Nf,'fsgt',1)
c.set('lam0',lambda0,...
    'nx',nx,'ny',ny,...
    'ax',P,'ay',P,...
    'eta',45,... % LCP input (eta=45)
    'n2',1.43)
c.add('rect','d',H,'nh',1,...
    'n',naSi,'x',P/2,'y',P/2,'xspan',W,'yspan',L)
c.compute
Tr = c.fetch('Tr',[nx+1 ny+1]);
Tl = c.fetch('Tl',[nx+1 ny+1]);
Rr = c.fetch('Rr',[nx+1 ny+1]);
Rl = c.fetch('Rl',[nx+1 ny+1]);
tr = c.fetch('tr',[nx+1 ny+1]);

%-- visualize
figure
set(gcf,'units','centimeters','position',[5 5 8 6])
plot(lambda0*1e9,100*Tr,'r-',...
    lambda0*1e9,100*Tl,'k-',...
    lambda0*1e9,100*Rr,'m-',...
    lambda0*1e9,100*Rl,'b-')
xlabel('Wavelength (nm)')
ylabel('Conversion efficiency (%)')
legend('T_{cross}','T_{co}','R_{cross}','R_{co}',...
    'FontSize',8,'Box','off','color','none','location','best')
ylim([-5 55])
xlim([450 750])

figure
set(gcf,'units','centimeters','position',[5 5 8 6])
plot(lambda0*1e9,unwrap(angle(tr)),'k-')
xlabel('Wavelength (nm)')
ylabel('Phase (rad)')
xlim([450 750])
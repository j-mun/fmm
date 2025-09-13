

%% TR spectra
clear;clc;
nf = 301;
lam0 = linspace(200e-9,600e-9,nf);

c = fmm;
c.setopt('parallel',true,'pardim',nf)
c.set('lam0',lam0,'ax',300E-9,'nx',10,...
    'theta',20,'psi',90) % psi=0 (TM) psi=90 (TE)
c.add('rect','nh',1.0,'n',2.0,'d',300E-9,'x',150E-9,'xspan',100E-9)
c.compute

T = c.fetch('Ttotal');
R = c.fetch('Rtotal');


figure
plot(lam0*1e9,T,'k-',...
    lam0*1e9,R,'b-',...
    lam0*1e9,1-T-R,'r-')
xlabel('Wavleength (nm)')
ylim([-0.05 1.05])
legend('T','R','1-T-R','location','best')
set(gcf,'units','centimeters','position',[5 5 8 6])


c.visualize('index')
c.visualize(false)


%% Near-field distribution
clear;clc;
lam0 = 500e-9;

c = fmm;
c.set('lam0',lam0,'ax',300e-9,'nx',10)
c.set('n1',1,'n2',1,'theta',20,'phi',0,'psi',0) % psi=0 (TM) psi=90 (TE)
c.add('layer','n',1,'d',700e-9)
c.add('rect','nh',1.0,'n',2.0,'d',300e-9,'x',150e-9,'xspan',100e-9,'nvm',true)
c.add('layer','n',1+1e-10,'d',700e-9)

% field calculation
c.field('dz',1e-9,'dx',1e-9)
x = c.out.x;
z = c.out.z;

% Fx
figure
set(gcf,'units','centimeters','position',[5 5 4 6])
imagesc(x*1e9,z*1e9-700,squeeze(real(c.out.Ex))')
colormap(jet)
set(gca,'YDir','normal')
axis equal tight
tmp = max(abs(clim));
clim([-tmp tmp])
colorbar('eastoutside')
xlabel('x')
ylabel('z')

% Fz
figure
set(gcf,'units','centimeters','position',[5 5 4 6])
imagesc(x*1e9,z*1e9-700,squeeze(real(c.out.Ez))')
colormap(jet)
set(gca,'YDir','normal')
axis equal tight
tmp = max(abs(clim));
clim([-tmp tmp])
colorbar('eastoutside')
xlabel('x')
ylabel('z')

% Fy
figure
set(gcf,'units','centimeters','position',[5 5 4 6])
imagesc(x*1e9,z*1e9-700,squeeze(real(c.out.Ey))')
colormap(jet)
set(gca,'YDir','normal')
axis equal tight
tmp = max(abs(clim));
clim([-tmp tmp])
colorbar('eastoutside')
xlabel('x')
ylabel('z')
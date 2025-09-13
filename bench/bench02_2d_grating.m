

%% TR spectra
clear;clc;
nf = 201;
lam0 = linspace(600e-9,800e-9,nf);
nx = 5;
ny = 5;


c = fmm;
c.setopt('parallel',true,'pardim',nf)
c.set('lam0',lam0,'ax',500e-9,'ay',600e-9,'nx',nx,'ny',ny,...
    'theta',0,'phi',0,'psi',90)
% rcwa.add('layer','n',n1,'d',d)
c.add('rect','n',1.5,'nh',1,'d',300e-9,...
    'x',250e-9,'xspan',200e-9,...
    'y',300e-9,'yspan',300e-9)
c.add('layer','n',1.5,'d',300e-9)
c.compute

T = c.fetch('Ttotal');
R = c.fetch('Rtotal');

%**
figure
plot(lam0*1e9,T,'k-',...
    lam0*1e9,R,'b-')
ylim([0 1])


%% field
clear;clc;
lam0 = 700e-9;
nx = 5;
ny = 5;

c = fmm;
c.set('lam0',lam0)
c.set('n1',1,'n2',1,'ax',500e-9,'ay',600e-9,'nx',nx,'ny',ny,...
    'theta',0,'phi',0,'psi',90)
c.add('layer','n',1,'d',400e-9)
c.add('rect','nh',1,'n',1.5,'d',300e-9,...
    'x',250e-9,'xspan',200e-9,...
    'y',300e-9,'yspan',300e-9)
c.add('layer','n',1.5,'d',300e-9)
c.add('layer','n',1+1e-10,'d',400e-9)


c.field('plane','xz','y',300e-9)
x = c.out.x;
z = c.out.z;

% Ey
figure
set(gcf,'units','centimeters','position',[5 5 6 7])
imagesc(x,z,squeeze(real(c.out.Ey))')
colormap(jet)
set(gca,'YDir','normal')
colorbar
axis equal tight
tmp = max(abs(clim));
clim([-tmp tmp])


% Hx
figure
set(gcf,'units','centimeters','position',[5 5 6 7])
imagesc(x,z,squeeze(real(c.out.Hx))')
colormap(jet)
set(gca,'YDir','normal')
colorbar
axis equal tight
tmp = max(abs(clim));
clim([-tmp tmp])

% Hz
figure
set(gcf,'units','centimeters','position',[5 5 6 7])
imagesc(x,z,squeeze(real(c.out.Hz))')
colormap(jet)
set(gca,'YDir','normal')
colorbar
axis equal tight
tmp = max(abs(clim));
clim([-tmp tmp])

% xy-plane
c.field('plane','xy','z',400e-9+150e-9,'y',[])
x = c.out.x;
y = c.out.y;

figure
imagesc(x,y,squeeze(real(c.out.Ex))')
colormap(jet)
set(gca,'YDir','normal')
colorbar
axis equal tight
tmp = max(abs(clim));
clim([-tmp tmp])

figure
imagesc(x,y,squeeze(real(c.out.Ey))')
colormap(jet)
set(gca,'YDir','normal')
colorbar
axis equal tight
tmp = max(abs(clim));
clim([-tmp tmp])

figure
imagesc(x,y,squeeze(real(c.out.Ez))')
colormap(jet)
set(gca,'YDir','normal')
colorbar
axis equal tight
tmp = max(abs(clim));
clim([-tmp tmp])

figure
imagesc(x,y,squeeze(real(c.out.Hx))')
colormap(jet)
set(gca,'YDir','normal')
colorbar
axis equal tight
tmp = max(abs(clim));
clim([-tmp tmp])

figure
imagesc(x,y,squeeze(real(c.out.Hy))')
colormap(jet)
set(gca,'YDir','normal')
colorbar
axis equal tight
tmp = max(abs(clim));
clim([-tmp tmp])

figure
imagesc(x,y,squeeze(real(c.out.Hz))')
colormap(jet)
set(gca,'YDir','normal')
colorbar
axis equal tight
tmp = max(abs(clim));
clim([-tmp tmp])



% c.visualize




% xy-plane 2
c.field('monitor','xy','z',400e-9+300e-9+300e-9+200e-9,'y',[])
x = c.out.x;
y = c.out.y;

figure
imagesc(x,y,squeeze(real(c.out.Ex))')
colormap(jet)
set(gca,'YDir','normal')
colorbar
axis equal tight
tmp = max(abs(caxis));
caxis([-tmp tmp])
figure
imagesc(x,y,squeeze(real(c.out.Ey))')
colormap(jet)
set(gca,'YDir','normal')
colorbar
axis equal tight
tmp = max(abs(caxis));
caxis([-tmp tmp])
figure
imagesc(x,y,squeeze(real(c.out.Ez))')
colormap(jet)
set(gca,'YDir','normal')
colorbar
axis equal tight
tmp = max(abs(caxis));
caxis([-tmp tmp])
figure
imagesc(x,y,squeeze(real(c.out.Hx))')
colormap(jet)
set(gca,'YDir','normal')
colorbar
axis equal tight
tmp = max(abs(caxis));
caxis([-tmp tmp])
figure
imagesc(x,y,squeeze(real(c.out.Hy))')
colormap(jet)
set(gca,'YDir','normal')
colorbar
axis equal tight
tmp = max(abs(caxis));
caxis([-tmp tmp])
figure
imagesc(x,y,squeeze(real(c.out.Hz))')
colormap(jet)
set(gca,'YDir','normal')
colorbar
axis equal tight
tmp = max(abs(caxis));
caxis([-tmp tmp])

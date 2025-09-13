%% Nat. Nanotechnol. 2018, 13, 220-226


%% Figure 2d
clear;clc;
Nf = 20;
freq = linspace(400e12,700e12,Nf);
c = emm.const('c');
lambda0 = c./freq;

nx = 10;
ny = 10;

% Figure 2c
l1 = 250e-9;
w1 = 80e-9;
l2 = 250e-9;
w2 = 80e-9;
g = 60e-9;
h = 600e-9;
p = 400e-9;

%-- compute
c = fmm;
c.setopt('basis','lr','parallel',true,'pardim',Nf, ...
    'nvm',1,'fsgt',5)
c.set('lam0',lambda0,...
    'nx',nx,'ny',ny,...
    'ax',p,'ay',p,...
    'eta',45,...
    'n1',1.4,'n2',1.0)
c.add('multiptc','d',h,'nh',1,...
    'rect',{'n',2.4,'xmin',p/2+g/2,'xmax',p/2+g/2+w1,'y',p/2,'yspan',l1},...
    'rect',{'n',2.4,'xmin',p/2-g/2-w2,'xmax',p/2-g/2,'y',p/2,'yspan',l2})
c.compute
tr = c.fetch('tr',[nx+1 ny+1]);
Tr = c.fetch('Tr',[nx+1 ny+1]);


%** visualize
figure
set(gcf,'units','centimeters','position',[5 5 8 6])
plot(freq*1e-12,unwrap(angle(tr))-2*pi,'k.-')
xlabel('Frequency (THz)')
ylabel('Phase (rad)')
ax1 = gca;
ax1_pos = ax1.Position;
ax2 = axes('Position',ax1_pos,...
    'XAxisLocation','top',...
    'YAxisLocation','right',...
    'Color','none');
ax2.XDir = 'reverse';
ax2.XLim = [min(lambda0) max(lambda0)]*1e9;
ax2.YTick = [];
xlabel(ax2,'Wavelength (nm)')

figure
set(gcf,'units','centimeters','position',[5 5 8 6])
plot(freq*1e-12,100*Tr,'b.-')
xlabel('Frequency (THz)')
ylabel('Conversion efficiency (%)')


%% Figure 2d
clear;clc;
Nf = 20;
freq = linspace(400e12,700e12,Nf);
c = emm.const('c');
lambda0 = c./freq;

nx = 10;
ny = 10;

l1 = 200e-9;
w1 = 80e-9;
l2 = 200e-9;
w2 = 80e-9;
g = 60e-9;
h = 600e-9;
p = 400e-9;

%-- compute
c = fmm;
c.setopt('basis','lr','parallel',true,'pardim',Nf)
c.set('lam0',lambda0,...
    'nx',nx,'ny',ny,...
    'ax',p,'ay',p,...
    'eta',45,...
    'n1',1.4,'n2',1.0)
c.add('multiptc','d',h,'nh',1,...
    'rect',{'n',2.4,'xmin',p/2+g/2,'xmax',p/2+g/2+w1,'y',p/2,'yspan',l1},...
    'rect',{'n',2.4,'xmin',p/2-g/2-w2,'xmax',p/2-g/2,'y',p/2,'yspan',l2})
c.compute
tr = c.fetch('tr',[nx+1 ny+1]);
Tr = c.fetch('Tr',[nx+1 ny+1]);

figure
set(gcf,'units','centimeters','position',[5 5 8 6])
plot(freq*1e-12,unwrap(angle(tr))-2*pi,'k.-')
xlabel('Frequency (THz)')
ylabel('Phase (rad)')
ax1 = gca;
ax1_pos = ax1.Position;
ax2 = axes('Position',ax1_pos,...
    'XAxisLocation','top',...
    'YAxisLocation','right',...
    'Color','none');
ax2.XDir = 'reverse';
ax2.XLim = [min(lambda0) max(lambda0)]*1e9;
ax2.YTick = [];
xlabel(ax2,'Wavelength (nm)')

figure
set(gcf,'units','centimeters','position',[5 5 8 6])
plot(freq*1e-12,100*Tr,'g.-')
xlabel('Frequency (THz)')
ylabel('Conversion efficiency (%)')

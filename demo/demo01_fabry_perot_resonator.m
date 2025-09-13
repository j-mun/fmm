

%% TR spectra
clear;clc;

%-- parameters
Nf = 901;
lam0 = linspace(100e-9,1000e-9,Nf);

%-- compute
c = fmm;
c.setopt('verbose',false,'parallel',true,'pardim',Nf)
c.set('lam0',lam0,'n1',1,'n2',1,'ax',100e-9,'theta',0,'phi',0,'psi',0)
c.add('layer','n',2.0,'d',300e-9)
c.compute
T = c.fetch('Ttotal');
R = c.fetch('Rtotal');


%-- visualize
figure
set(gcf,'units','centimeters','position',[5 5 8 6])
plot(lam0*1e9,T,'g-',...
    lam0*1e9,R,'b-',...
    lam0*1e9,T+R,'r-',...
    lam0*1e9,1-T-R,'c-')
ylim([-0.1 1.1])
xlabel('Wavelength (nm)')
legend('T','R','T+R','1-T-R','location','best')
xlim([100 1000])

%% Near-field distribution
clear;clc;

%-- parameters
lam0 = 600e-9;

%-- compute
c = fmm;
c.set('lam0',lam0)
c.set('n1',1,'n2',1,'ax',10e-9,'theta',0,'phi',0,'psi',0)
c.add('layer','n',1,'d',1000e-9)
c.add('layer','n',2.0,'d',300e-9)
c.add('layer','n',1+1e-10,'d',1000e-9)

%-- field calculation
c.field('dz',1e-9)
x = c.out.x;
z = c.out.z;

%-- visualize
figure
set(gcf,'units','centimeters','position',[5 5 8 6])
plot(z*1e9-1000,squeeze(real(c.out.Ex)),'b-',...
    z*1e9-1000,squeeze(imag(c.out.Ex)),'g-',...
    z*1e9-1000,squeeze(abs(c.out.Ex)),'r-')
xlim([-500 800])
xlabel('z (nm)')
legend('Re(Ex)','Im(Ex)','|Ex|','location','best')
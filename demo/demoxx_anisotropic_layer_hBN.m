%
%
%
%


%% hBN modeling
clear;clc;

nf = 1000;
w = linspace(500,2500,nf); % [1/cm]
lam0 = 1./(100*w); % [m]
eprz_hBN = 4.10+3.26E5*(783^2-w.^2-1i*8*w).^-1+1.04E6*(1510^2-w.^2-1i*80*w).^-1;
eprt_hBN = 4.95+1.23E5*(767^2-w.^2-1i*35*w).^-1+3.49E6*(1367^2-w.^2-1i*29*w).^-1;





figure
set(gcf,'units','centimeters','position',[5 5 8 12])
subplot(211)
plot(w,real(eprz_hBN),'k-',...
    w,imag(eprz_hBN),'r-')
legend('Re($\varepsilon_\parallel$)','Im($\varepsilon_\parallel$)',...
    'Interpreter','latex')
set(gca,'FontSize',10)
ylim([-20 40])
subplot(212)
plot(w,real(eprt_hBN),'k-',...
    w,imag(eprt_hBN),'r-')
legend('Re($\varepsilon_\perp$)','Im($\varepsilon_\perp$)',...
    'Interpreter','latex')
xlabel('Wavenumber / cm^{-1}')
set(gca,'FontSize',10)
ylim([-20 40])




%% anisotropic layer
ax = inf;
nx = 0;
ny = 0;
d = 1e-3;


c = fmm;
c.setopt('parallel',true,'pardim',nf)
c.set('ax',ax,'nx',nx,'ny',ny,...
    'lam0',lam0,'theta',0,'phi',1e-10,'psi',90)
c.add('slab','model',2, ...
    'd',d,'epxx',eprt_hBN,'epyy',eprz_hBN,'epzz',eprt_hBN)
c.compute
T_te = c.fetch('Ttotal');
R_te = c.fetch('Rtotal');

c = fmm;
c.setopt('parallel',true,'pardim',nf)
c.set('ax',ax,'nx',nx,'ny',ny,...
    'lam0',lam0,'theta',0,'phi',1e-10,'psi',0)
c.add('slab','model',2, ...
    'd',d,'epxx',eprt_hBN,'epyy',eprz_hBN,'epzz',eprt_hBN)
c.compute
T_tm = c.fetch('Ttotal');
R_tm = c.fetch('Rtotal');

figure
plot(w,R_te,...
    w,R_tm)


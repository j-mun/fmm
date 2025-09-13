


%% Bragg mirror
clear;clc;

%-- parameters
Nf = 501;
lam0 = linspace(800e-9,1300e-9,Nf);
theta = 67.77;
phi = 0;
psi = 90;
n_SiO2 = 1.44;
n_HfO2 = 1.87;
d_SiO2 = 247e-9;
d_HfO2 = 163e-9;
N = 20;

%-- compute
c = fmm;
c.setopt('parallel',true,'pardim',Nf)
c.set('lam0',lam0)
c.set('n1',1.0,'n2',n_SiO2,'theta',theta,'phi',phi,'psi',psi)
for i=1:N
    c.add('layer','d',d_SiO2,'n',n_SiO2)
    c.add('layer','d',d_HfO2,'n',n_HfO2)
end
c.compute
T = c.fetch('Ttotal');
R = c.fetch('Rtotal');

%--visualize
figure
set(gcf,'units','centimeters','position',[5 5 8 6])
plot(lam0*1e9,T,'k-',...
    lam0*1e9,R,'r-')
ylim([0 1])
legend('T','R',...
    'location','best')
xlabel('Wavelength (nm)')

% c.visualize
% c.visualize(false)
% c.index('plane','xz','y',0)

%% multilayer dielectric grating (MLDG)
clear;clc;

%-- parameters
Nf = 501;
lam0 = linspace(800e-9,1300e-9,Nf);
period = 575e-9;
nx = 10;
theta = 67.77;
phi = 0;
psi = 90; % TE
n_SiO2 = 1.44;
n_HfO2 = 1.87;
d_SiO2 = 247e-9;
d_HfO2 = 163e-9;
nh = [1;n_SiO2];
N = 20;
d_grating = 630e-9;
w_grating = 172e-9;
d_match = 450e-9;

%-- compute
c = fmm;
c.setopt('parallel',true,'pardim',Nf)
c.set('lam0',lam0, ...
    'n1',nh(1),'n2',nh(2),'nx',nx,'ax',period,...
    'theta',theta,'phi',phi,'psi',psi)
c.setopt('verbose',false)
c.add('rect','d',d_grating,'x span',w_grating,'x',period/2,'n',n_SiO2)
c.add('layer','d',d_match,'n',n_SiO2)
c.add('layer','d',d_HfO2,'n',n_HfO2)
for i=1:N
    c.add('layer','d',d_SiO2,'n',n_SiO2)
    c.add('layer','d',d_HfO2,'n',n_HfO2)
end
c.compute
T = c.fetch('Ttotal');
R = c.fetch('Rtotal');
Rs = zeros(Nf,3);
for i=1:3
    Rs(:,i) = c.fetch('Rs',nx+i-1);
end

%-- visualize
figure
set(gcf,'units','centimeters','position',[5 5 8 5])
plot(lam0*1e9,T,...
    lam0*1e9,R,...
    lam0*1e9,Rs(:,1),...
    lam0*1e9,Rs(:,2),...
    lam0*1e9,Rs(:,3))
ylim([0 1])
xlabel('Wavelength (nm)')
legend('T','R','R_{-1}','R_{0}','R_{+1}', ...
    'Location','northwest','FontSize',6)


%% BIC
%
% see [Science 360, 6393, 1105-1109 (2018)]
% doi: 10.1126/science.aas9768

clear;clc;

%-- parameters
Nf = 100;
k = linspace(1300,1800,Nf);
lam0 = 1./(k*100);
ns = 3.5;
S = 1.2;
Px = S*3.92e-6;
Py = S*2.26e-6;
theta = 20;
nx = 5;

%-- computation
c = fmm;
c.setopt('verbose',true,'nvm',2,'parallel',true,'pardim',Nf)
c.set('lam0',lam0,'n1',1.0,'n2',1.0,...
    'nx',2*nx,'ax',Px,...
    'ny',nx,'ay',Py,...
    'theta',0,'phi',0,'psi',0,'eta',0)
c.add('multiparticle','nh',1,'d',0.7e-6,...
    'circ',{'n',3.5,'radius',S*0.5e-6,'x',Px/4,'y',Py/2,'fx',0.96,'fy',1.96,'theta',theta},...
    'circ',{'n',3.5,'radius',S*0.5e-6,'x',Px*3/4,'y',Py/2,'fx',0.96,'fy',1.96,'theta',-theta})
c.compute
T = c.fetch('Ttotal');
R = c.fetch('Rtotal');

%-- visualize
figure
set(gcf,'units','centimeters','position',[5 5 8 6])
plot(k,T,'k-',...
    k,R,'b-',...
    k,1-T-R,'r-')
xlabel('wavenumber (cm-1)')
ylabel('')
legend('T','R','1-T-R',...
    'location','best')

c.visualize
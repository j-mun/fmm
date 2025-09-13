

%% verbose
% returns some messages...
clear;clc;



disp('running fmm with verbose')
c = fmm;
c.set('lam0',1e-6)
c.setopt('verbose',true)
c.add('layer','n',1.2,'d',100e-9)
c.compute
disp('completed!')

disp('running fmm without verbose')
c = fmm;
c.set('lam0',1e-6)
c.setopt('verbose',false) % (default = true)
c.add('layer','n',1.2,'d',100e-9)
c.compute
disp('completed!')

%% discretization resolution
% disc: whether to use analytically calculated Fourier coefficient or
%       fourier transformed one from generated discretized image
%       this option only applies to 'rect' (default = false)
% res: resolution of the generated discretized image (default = 64)

clear;clc;
tic
c = fmm;
c.setopt('res',1)
c.set('nx',15,'ny',15,'ax',500e-9,'ay',500e-9)
c.add('rect',...
    'nh',1,... % refractive index of host media (default = 1)
    'n',2,...  % refractive index of rectangle (default = 1)
    'x',250e-9,...      % center of rectangle [m]
    'y',250e-9,...      % 
    'xspan',200e-9,...  % side length [m]
    'yspan',200e-9,...  %
    'd',100e-9,...      % thickness [m]
    'theta',30)         % rotation [deg] (default = 0)
c.visualize('index')
toc

tic
c = fmm;
c.setopt('res',256)
c.set('nx',15,'ny',15,'ax',500e-9,'ay',500e-9)
c.add('rect',...
    'nh',1,... % refractive index of host media (default = 1)
    'n',2,...  % refractive index of rectangle (default = 1)
    'x',250e-9,...      % center of rectangle [m]
    'y',250e-9,...      % 
    'xspan',200e-9,...  % side length [m]
    'yspan',200e-9,...  %
    'd',100e-9,...      % thickness [m]
    'theta',30)         % rotation [deg] (default = 0)
c.visualize('index')
toc

%% Fourier Space Grid Truncation (FSGT)
% fsgt: whether to use Fourier space grid truncation (default = false)

%% Normal Vector Method (NVM)
% nvm: whether to use normal vector method (default = false)

%% parallel sweep: wavelength
clear;clc;
Nf = 30;
lambda0 = linspace(400e-9,600e-9,Nf);
nx = 6;
ny = 6;
n = lambda0./300e-9;

%* case 1, typical for-loop
tic
T = zeros(Nf,1);
for i=1:Nf
    c = fmm;
    c.set('lam0',lambda0(i),'n1',2.0,...
        'nx',nx,'ax',500e-9,'ny',ny,'ay',500e-9,...
        'theta',0,'phi',0,'psi',0)
    c.add('rect','x',250e-9,'xspan',100e-9,'y',250e-9,'yspan',100e-9,'nh',1,'n',n(i),'d',100e-9)
    c.compute
    T(i) = c.out.Ttotal;
end
toc

%* case 2, parfor
c = fmm;
c.setopt('parallel',true,'pardim',Nf) 
c.set('lam0',lambda0,'n1',2.0,... % lambda0 is sweeped
    'nx',nx,'ax',500e-9,'ny',ny,'ay',500e-9,...
    'theta',0,'phi',0,'psi',0)
c.add('rect','x',250e-9,'xspan',100e-9,'y',250e-9,'yspan',100e-9,...
    'nh',1,'n',n,'d',100e-9) % n is sweeped
c.compute
T2 = c.fetch('Ttotal'); % use fetch function to get sweeped result

figure
set(gcf,'Position',[500 500 400 350])
plot(lambda0*1E9,T,'k-',...
    lambda0*1E9,T2,'r--')
xlabel('Wavelength (nm)')
ylabel('Transmittance (a.u.)')

%% parallel sweep: structure
clear;clc;
nx = 6;
ny = 6;

Nf = 30;
ax = linspace(300E-9,600E-9,Nf);
lambda0 = 400E-9;

c = fmm;
c.setopt('parallel',true,'pardim',Nf)
c.set('lam0',lambda0,'n1',2.0,...
    'nx',nx,'ax',ax,'ny',ny,'ay',500e-9,...
    'theta',0,'phi',0,'psi',0)
c.add('rect','x',0.5*ax,'xspan',0.5*ax,... % {x, xspan} are sweeped
    'y',250e-9,'yspan',100e-9,'nh',1,'n',1.5,'d',100e-9)
c.compute

c.visualize

T = c.fetch('Ttotal');

figure
set(gcf,'Position',[500 500 400 350])
plot(ax*1E9,T,'k-')
xlabel('Period (nm)')
ylabel('Transmittance (a.u.)')


%% parallel sweep: multi-dimensional parametric sweep
clear;clc;
nx = 6;
ny = 6;

%** which variables are sweeped?
lam0 = linspace(400E-9,900E-9,50);
ax = linspace(300E-9,600E-9,5);

%** create muulti-dimensional variables
[lam0_,ax_] = ndgrid(lam0,ax);
pardim = size(lam0_);

c = fmm('parallel',true,'pardim',pardim);
c.set('lam0',lam0_,'n1',2.0,... % {lambda0} is sweeped
    'nx',nx,'ax',ax_,'ny',ny,'ay',500e-9,... % ax is sweeped
    'theta',0,'phi',0,'psi',0)
c.add('rect','x',0.5*ax_,'xspan',0.5*ax_,... % {x, xspan} are sweeped
    'y',250e-9,'yspan',100e-9,'nh',1,'n',1.5,'d',100e-9)
c.compute

c.visualize

T = c.fetch('Ttotal'); % [50 x 5] dimension 

figure
set(gcf,'Position',[500 500 400 350])
plot(lam0*1E9,T,'-')
legend(num2str(ax'*1E9),'Location','best')
xlabel('Wavelength (nm)')
ylabel('Transmittance (a.u.)')


%% parallel sweep: very-large sweep
% if you need to run a very large parametric sweep, it may be better to use
% parfor externally
clear;clc;

Nf = 10000;

T = zeros(Nf,1);
parfor mf=1:Nf  % the number of variable for parfor should be large (Nf>>1)
    c = rcwa;
    c.set('lam0',lam0(mf))
    % ...
    c.compute
    T(mf) = c.out.Ttotal;
end


%% addpath
% addpath `fmm` root directory before using the package
addpath('P:/git/fmm/')


%% system parameters and incident fields
c = fmm;               % initialize "rcwa" class
c.set('lam0',1e-6,...   % freespace wavelength [m]
    'n1',1,...          % substrate refractive index
    'n2',1,...          % superstrate refractive index
    'nx',10,...         % maximum Fourier order (x-direction)
    'ax',500e-9,...     % periodicity [m] (x-direction)
    'ny',10,...         % maximum Fourier order (y-direction)
    'ay',500e-9,...     % periodicity [m] (y-direction)
    'theta',30,...      % incident inclination angle [deg]
    'psi',40,...        % incident polarization angle [deg]
    'phi',50,...        % incident azimuthal angle [deg]
    'eta',60)           % ellipticity [deg]
c.initialize

c.param             % check initialized system parameters
c.param.n_e         % check incident fields


% < 2D system >
% TM/TE modes for 2D system can be used for faster calculations
% {eta = 0, phi = 0, psi = 0} => TM (Ey=0)
% {eta = 0, phi = 0, psi = 90} => TE (Ex=Ez=0)
% {ny=0} for 1D system


% < incident fields >
% some useful set of incident fields are given as...
% {theta = 0, phi = 0, psi = 0, eta = 0} => Ex = 1 (x-polarized incident)
% {theta = 0, phi = 90, psi = 90, eta = 0} => Ex = 1 (x-polarized incident)
% {theta = 0, phi = 0, psi = 90, eta = 0} => Ey = 1 (y-polarized incident)
% {theta = 0, phi = 90, psi = 0, eta = 0} => Ey = 1 (y-polarized incident)
% {theta = 0, phi = 0, psi = 0, eta = 45} => LCP
% {theta = 0, phi = 0, psi = 0, eta = -45} => RCP

%% homogeneous layer/slab
clear;clc;

c = fmm;
c.set('nx',10,'ny',10,'ax',500e-9,'ay',500e-9)
c.add('layer',...
    'n',2,...   % refractive index of homogeneous layer
    'd',100e-9) % thickness of layer

c.visualize('simple')
c.visualize('index')
c.visualize('fft')

%% rectangle
clear;clc;

c = fmm;
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

c.visualize('simple')
c.visualize('index')
c.visualize('fft')


% Notes
% 'nh' can be replaced by 'eph'
% 'n' can be replaced by 'ep'
% {'x','xspan'} can be replaced by {'xmin','xmax'}
% {'y','yspan'} can be replaced by {'ymin','ymax'}


%% circle, ellipse
clear;clc;

c = fmm;
c.set('nx',15,'ny',15,'ax',500e-9,'ay',500e-9)
c.add('circ',...
    'nh',1,...
    'd',100e-9,...
    'n',2,...
    'x',250e-9,...      % center coordinate x [m]
    'y',250e-9,...      % center coordinate y [m]
    'radius',100e-9,... % radius of circle [m]
    'fx',1,...          % asymmetry factor (default = 1)
    'fy',0.5,...        %
    'theta',30)         % rotation [deg] (default = 0)


c.visualize('simple')
c.visualize('index')
c.visualize('fft')

%% poly1 | 
clear;clc;

c = fmm;
c.set('nx',15,'ny',15,'ax',500e-9,'ay',500e-9)
c.add('poly1',...
    'nh',1,...
    'd',100e-9,...
    'n',2,...
    'x',250e-9,...
    'y',250e-9,...
    'radius',100e-9,... %
    'N',3,...           % number of
    'theta',10)         % rotation [deg] (default = 0)

c.visualize('simple')
c.visualize('index')
c.visualize('fft')


%% poly2
clear;

c = fmm;
c.set('nx',15,'ny',15,'ax',500e-9,'ay',500e-9)
c.add('poly2',...
    'nh',1,...
    'd',100e-9,...
    'n',2,...
    'xv',[100e-9,200e-9,300e-9],... % x-coordinates
    'yv',[100e-9,100e-9,300e-9])    % y-coordinates

c.visualize('simple')
c.visualize('index')
c.visualize('fft')

%% multiparticle
clear;clc;

c = fmm;
c.set('nx',20,'ny',20,'ax',500e-9,'ay',500e-9)
c.add('multiptc',...
    'nh',1,...
    'd',100e-9,...
    'rect',{'n',1.3,'x',300e-9,'y',300e-9,'xspan',200e-9,'yspan',50e-9,'theta',30},...
    'rect',{'n',1.5,'x',400e-9,'y',100e-9,'xspan',50e-9,'yspan',100e-9,'theta',0},...
    'circ',{'n',1.7,'x',200e-9,'y',400e-9,'radius',50e-9,'fx',2,'fy',1,'theta',30})

c.visualize('simple')
c.visualize('index')
c.visualize('fft')

% Notes
% the structures are added in order; i.e., rect -> rect -> circ
% overlapped regions are overwritten

%% multiparticle < cross
clear;clc;

c = fmm;
c.set('nx',20,'ny',20,'ax',500e-9,'ay',500e-9)
c.add('multiptc',...
    'nh',1,...
    'd',100e-9,...
    'rect',{'n',1.5,'x',250e-9,'y',250e-9,'xspan',200e-9,'yspan',50e-9,'theta',0},...
    'rect',{'n',1.5,'x',250e-9,'y',250e-9,'xspan',50e-9,'yspan',200e-9,'theta',0})

c.visualize('simple')
c.visualize('index')
c.visualize('fft')

%% multiparticle < holed particle
clear;clc;

c = fmm;
c.set('nx',20,'ny',20,'ax',500e-9,'ay',500e-9)
c.add('multiparticle',...
    'nh',1,...
    'd',100e-9,...
    'rect',{'n',2.0,'x',250e-9,'y',250e-9,'xspan',200e-9,'yspan',200e-9,'theta',0},...
    'rect',{'n',1.0,'x',250e-9,'y',250e-9,'xspan',100e-9,'yspan',100e-9,'theta',0})

c.visualize('simple')
c.visualize('index')
c.visualize('fft')

%% multiparticle < hexagonal rod
clear;clc;

L = 100e-9;
ax = 500e-9;
ay = 500e-9;

c = fmm;
c.set('nx',20,'ny',20,'ax',500e-9,'ay',500e-9)
c.add('multiparticle',...
    'nh',1,...
    'd',100e-9,...
    'rect',{'n',2.0,'x',ax/2,'y',ay/2,'xspan',L,'yspan',L*sqrt(3),'theta',0},...
    'rect',{'n',2.0,'x',ax/2,'y',ay/2,'xspan',L,'yspan',L*sqrt(3),'theta',120},...
    'rect',{'n',2.0,'x',ax/2,'y',ay/2,'xspan',L,'yspan',L*sqrt(3),'theta',240})

c.visualize('simple')
c.visualize('index')
c.visualize('fft')


%% pixelated image
clear;clc;

% make image
x = linspace(0,500e-9,100);
y = linspace(0,500e-9,100);
[xx,yy] = ndgrid(x,y);
S = 1*ones(size(xx));
S(xx>=100e-9 & xx<=200e-9 & yy>=100e-9 & yy<=300e-9) = 2;


figure
set(gcf,'units','centimeters','position',[5 5 8 6])
imagesc(x,y,S')
set(gca,'YDir','normal')
title('Generated bitmap image',...
    'FontWeight','normal')

c = fmm;
c.set('nx',20,'ny',20,'ax',500e-9,'ay',500e-9)
c.add('pixel','d',100e-9,'n',S)

c.visualize('simple')
c.visualize('index')
c.visualize('fft')




%% (11-2) random pixelated image
clear;clc;

nx = 20;
ny = 20;
nGx = 8;
nGy = 8;

% make image
S = 1+randi([0,1],[nGx nGy]);
S = mat2cell(S,ones(nGx,1),ones(1,nGy));
S = cellfun(@(x)x*ones(2*nx,2*ny),S,'UniformOutput',false);
S = cell2mat(S);

% S = interp2(S,4);

figure
set(gcf,'units','centimeters','position',[5 5 8 6])
imagesc(S')
set(gca,'YDir','normal')
title('Generated bitmap image',...
    'FontWeight','normal')

c = fmm;
c.set('nx',nx,'ny',ny,'ax',500e-9,'ay',500e-9)
c.add('pixel','d',100e-9,'n',S)

c.visualize('simple')
c.visualize('index')
c.visualize('fft')


%% (11-3) random pixelated image 2
clear;clc;

nx = 5;
ny = 5;
nGx = 8;
nGy = 8;

% make image
S = 1+randi([0,1],[nGx nGy]);
S = mat2cell(S,ones(nGx,1),ones(1,nGy));
S = cellfun(@(x)x*ones(2*nx,2*ny),S,'UniformOutput',false);
S = cell2mat(S);

figure
set(gcf,'units','centimeters','position',[5 5 8 6])
imagesc(S')
set(gca,'YDir','normal')
title('Generated bitmap image',...
    'FontWeight','normal')

%** smooth
idx = [(2*nx)*(0:2:nGx-1).'+(1:2*nx)].';
S(:,idx(:)) = circshift(S(:,idx(:)),[nx 0]);
S = interp2(S,4);

figure
set(gcf,'units','centimeters','position',[5 5 8 6])
imagesc(S')
set(gca,'YDir','normal')
title('Smoothed bitmap image',...
    'FontWeight','normal')

%--
c = fmm;
c.set('nx',nx,'ny',ny,'ax',500e-9,'ay',500e-9)
c.add('pixel','d',100e-9,'n',S)


c.visualize('simple')
c.visualize('index')
title('Inserted bitmap image',...
    'FontWeight','normal')


c.visualize('fft')
title('Fourier-transformed image',...
    'FontWeight','normal')

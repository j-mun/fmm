



%% Fourier Space Grid Truncation (FSGT)
clear;clc;

%-- parameters
ax = 300e-9;
ay = 300e-9;
wx1 = 50e-9;
wy1 = 200e-9;
wx2 = 50e-9;
wy2 = 200e-9;
g = 50e-9;
n_SiO2 = 1.43;
lam0 = 555e-9;
nx = 15;

fsgt = [-1,0.2:0.1:2];
N = numel(fsgt);
time = zeros(N,1);
T = zeros(N,1);
R = zeros(N,1);

for i=1:N
    tic
    c = fmm;
    c.setopt('verbose',false,'nvm',false,'fsgt',fsgt(i))
    c.set('n1',n_SiO2,'ax',ax,'ay',ay,'nx',nx,'ny',nx,...
        'theta',0,'phi',0,'psi',0)
    c.add('multiptc','nh',1,'d',200e-9,...
        'rect',{'n',3.5,'xmin',ax/2+g/2,'xmax',ax/2+g/2+wx1,'ymin',ax/2-wy1/2,'ymax',ax/2+wy1/2},...
        'rect',{'n',3.5,'xmin',ax/2-g/2-wx2,'xmax',ax/2-g/2,'ymin',ax/2-wy2/2,'ymax',ax/2+wy2/2})
    c.set('lam0',lam0)
    c.compute
    T(i) = c.out.Ttotal;
    R(i) = c.out.Rtotal;
    time(i) = toc;
end

fsgt(1) = 0;
figure
set(gcf,'Position',[500 500 700 300])
tiledlayout(1,2,'TileSpacing','compact','Padding','compact')
nexttile
plot(fsgt,time,'ro')
xlabel('fsgt parameter')
ylabel('Calculatiom time (s)')
nexttile
plot(fsgt,T,'ko', ...
    fsgt,R,'ro')
legend('T','R','Location','best')
xlabel('fsgt parameter')
ylabel('Result')


%%




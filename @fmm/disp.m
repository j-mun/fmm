%fmm.disp | display fmm information

function [] = disp(o)

if o.opt.parallel
    p = o.param{1};
else
    p = o.param;
end
disp('===================================================================')
disp('  # fmm parameters...');
fprintf('    (nx,ny): (%d,%d)\n',p.nx,p.ny);
fprintf('    (ax,ay): (%e,%e) [m]\n',p.ax,p.ay);
fprintf('    lambda0: %e [m]\n',p.lambda0);
fprintf('    (theta,phi,psi,eta): (%f,%f,%f,%f) [deg]\n',p.theta,p.phi,p.psi,p.eta);
fprintf('    (ex,ey,ez): (%f,%f,%f)\n',p.n_e(1),p.n_e(2),p.n_e(3));
fprintf('    (kx,ky,kz): (%f,%f,%f)\n',p.n_k(1),p.n_k(2),p.n_k(3));
fprintf('    (n1,n2): (%f,%f)\n',p.n1,p.n2);
fprintf('    dim = %d\n',p.dim)
fprintf('    mode = %s\n',p.mode)

opt = o.opt;
fprintf('  # fmm options...\n');
fprintf('    nvm\t\t\t%d\n',opt.nvm);
fprintf('    fsgt\t\t%d\n',opt.fsgt);
fprintf('    basis\t\t%s\n',opt.basis);
fprintf('    res\t\t\t%d\n',opt.res);
fprintf('    parallel\t%d\n',opt.parallel);
fprintf('    pardim\t\t%d\n',opt.pardim);
disp('===================================================================')
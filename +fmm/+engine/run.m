%fmm.engine.run | 
%
%
%
%
%



function [tmp] = run(p,layer,opt)

%** options
% method = opt.method;
% mode = opt.mode;
monitor = opt.monitor;
% fsgt = opt.fsgt;

%** global matrices
tmp = fmm.engine.kgrid(p);

%** layer thickness
tmp.d = cellfun(@(x)x.thick,layer).';

%** generate Fourier coefficients
cellfun(@(x)x.fft([p.nx p.ny]),layer)

if monitor
    for mL=1:p.NL
        tmp.epmnxx{mL} = layer{mL}.epmnxx;
        tmp.epmnyy{mL} = layer{mL}.epmnyy;
        tmp.epmnzz{mL} = layer{mL}.epmnzz;
    end
end

%** generate reciprocal Fourier coefficients
cellfun(@(x)x.ifft([p.nx p.ny]),layer)

%** generate normal vectors
cellfun(@(x)x.normvec([p.nx p.ny],[p.bx p.by]),layer) % ,[p.nSx p.nSy]

%** calculate eigenmatrices {V, W, D}
[tmp.V,tmp.W,tmp.D] = cellfun(@(x)x.eig(tmp.Kx,tmp.Ky,tmp.i_conv),layer,...
    'UniformOutput',false);

%** compute
if opt.method==1 % t-matrix
    if opt.mode==1 % general
        tmp = fmm.engine.tmx.conical(p,tmp,monitor);
    elseif opt.mode==2 % 2d-fmm, te
        tmp = fmm.engine.tmx.te(p,tmp,monitor);
    elseif opt.mode==3 % 2d-fmm, tm
        tmp = fmm.engine.tmx.tm(p,tmp,monitor);
    end
elseif opt.method==2 % s-matrix
    if opt.mode==1
        % tmp = fmm.engine.smx.conical
    elseif opt.mode==2
        % tmp = fmm.engine.smx.te
    elseif opt.mode==3
        % tmp = fmm.engine.smx.tm
    end
end


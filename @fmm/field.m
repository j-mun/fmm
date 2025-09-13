%fmm.util.field | fmm field monitor

function [] = field(o,varargin)
parallel = o.opt.parallel;

o.progmsg(0,'  # fmm/field monitor...\n'); t0=tic;

%** non-parallel case
if parallel
    error('fmm/field not supported for <parallel=true>')
end

%** run/skip fmm calculation
if o.opt.monitor
    o.progmsg(0,'  * compute skipped...\n');
else
    o.opt.monitor = true;
    o.compute
end

%** field calculation

% mode = o.opt.mode;
% method = o.opt.method;
if o.opt.method==1 % t-matrix
    if o.opt.mode==1 % general
        o.out = fmm.engine.field.conical(o.param,o.tmp,varargin{:});
    elseif o.opt.mode==2 % 2d-fmm, te
        o.out = fmm.engine.field.te(o.param,o.tmp,varargin{:});
    elseif o.opt.mode==3 % 2d-fmm, tm
        o.out = fmm.engine.field.tm(o.param,o.tmp,varargin{:});
    end
elseif o.opt.method==2 % s-matrix
    if o.opt.mode==1 % general

    elseif o.opt.mode==2 % 2d-fmm, te

    elseif o.opt.mode==3 % 2d-fmm, tm

    end
end

o.progmsg(0,['  * completed! (',sprintf('%.3f',toc(t0)),' s)\n']);
end

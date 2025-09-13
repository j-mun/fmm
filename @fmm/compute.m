%fmm.compute





function [] = compute(o)

o.progmsg(0,'  # fmm/compute...\n');

%** initialize
o.progmsg(0,'  * initialize...');t0=tic;
o.initialize
o.progmsg(0,['completed! (',sprintf('%.3f',toc(t0)),' s)\n']);

%** preallocation
parallel = o.opt.parallel;
pardim = o.opt.pardim;
parnum = o.opt.parnum;

opt.method = o.opt.method;
opt.mode = o.opt.mode;
opt.monitor = o.opt.monitor;
opt.fsgt = o.opt.fsgt;
basis = o.opt.basis;

%** computation
if parallel
    o.progmsg(0,'  * parallel compute...');t1=tic;
    param = o.param;
    layer = o.layer;
    out = cell(1,parnum);
    parfor i=1:parnum
        tmp = fmm.engine.run(param{i},layer(:,i),opt);
        out{i} = fmm.engine.power(param{i},tmp,basis);
    end
    o.out = reshape(out,pardim);
else
    o.progmsg(0,'  * compute...');t1=tic;
    o.tmp = fmm.engine.run(o.param,o.layer,opt);
    o.out = fmm.engine.power(o.param,o.tmp,basis);
end
o.progmsg(0,['completed! (',sprintf('%.3f',toc(t1)),' s)\n']);
o.progmsg(0,['  * total runtime :',' ',sprintf('%.3f',toc(t0)),' s\n']);
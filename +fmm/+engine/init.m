%fmm.engine.init | 
%
%
%
%
%


function [] = init(o)
% parallel = o.opt.parallel;
% pardim = o.opt.pardim;

% mode = o.opt.mode;

%** check options / parameters
if o.opt.parallel && ~o.opt.parnum
    error('fmm : <pardim> should be given if <parallel=true>')
end

%** polarization mode
if o.opt.mode==-1
    o.opt.mode = o.param.mode;
    for i=1:o.param.NL
        o.layer{i}.mode = o.opt.mode;
    end
end

%** fsgt
o.param.fsgt = o.opt.fsgt;

%** parallel solver
if o.opt.parallel
    parnum = o.opt.parnum;

    %** copy fmm.param
    p = cell(1,parnum);
    for i=1:parnum
        p{i} = copy(o.param);
    end

    %** copy parallel variables
    pvar = {'lambda0','ax','ay','ep1','ep2','mu1','mu2',...
        'theta','phi','psi','eta'};
    for i=1:numel(pvar)
        nvar = numel(o.param.(pvar{i}));
        if nvar==parnum
            tmpval = o.param.(pvar{i})(:);
            for j=1:parnum
                p{j}.(pvar{i}) = tmpval(j);
            end
        elseif nvar~=parnum && nvar~=1
            error('fmm : check the dimension of <%s>',pvar{i})
        end
    end
    o.param = p;
    
    %** initialize layers
    for i=1:o.param{1}.NL
        o.layer(i,1:parnum) = o.layer{i}.init(o.param);
    end
else
    %** 
    for i=1:o.param.NL
        o.layer{i} = o.layer{i}.init(o.param);
    end
end

%fmm.add | add layersswt.
%
%Structures:
% <a href="matlab:help fmm.layer.slab">homogeneous slab</a>
%>> c.add('slab',...
%
% <a href="matlab:help fmm.layer.rect">rectangle</a>
%>> c.add('rect',...
%
% <a href="matlab:help fmm.layer.circ">circle</a>
%>> c.add('circ',...
%
% <a href="matlab:help fmm.layer.poly1">N-sided regular polygon</a>
%>> c.add('poly1',...
%
% <a href="matlab:help fmm.layer.poly2">general polygon</a>
%>> c.add('poly2',...
%
% <a href="matlab:help fmm.layer.multiptc">multiple geometriesn</a>
%>> c.add('multiptc',...
%
%Material models:
% Isotropic permittivity (simple dielectric)
%>> c.add(... 'model',1,... (default)
%
% Anisotropic permittivity
%>> c.add(... 'model',2,...
%
% Todo: magnetic
%>> c.add(... 'model',3,...
%--------------------------------------------------------------------------

function [] = add(o,type,varargin)

if nargin==1
    help fmm.add
    return
end

%** flush all layers
if strcmp(type,'flush')
    o.param.NL = 0;
    o.layer = {};
    o.progmsg(0,'  + flushed all existing layers\n');
    return
end

%**
mL = o.param.NL+1;
dopt = {};
if o.opt.nvm~=-1
    dopt = [dopt,'nvm',o.opt.nvm];
end
if o.opt.res~=-1
    dopt = [dopt,'res',o.opt.res];
end


switch type
    case {'slab','layer','homo'}
        o.layer{mL,1} = fmm.layer.slab(dopt{:},varargin{:});
    case {'circ','circle'}
        o.layer{mL,1} = fmm.layer.circ(dopt{:},varargin{:});
    case {'rect'}
        o.layer{mL,1} = fmm.layer.rect(dopt{:},varargin{:});
    case {'multiptc','multiparticle'}
        o.layer{mL,1} = fmm.layer.multiptc(dopt{:},varargin{:});
    case {'poly1'}
        o.layer{mL,1} = fmm.layer.poly1(dopt{:},varargin{:});
    case {'poly2'}
        o.layer{mL,1} = fmm.layer.poly2(dopt{:},varargin{:});

    case {'pixel'}
        o.layer{mL,1} = fmm.layer.pixel(dopt{:},varargin{:});
    case {'custom'}
        o.layer{mL,1} = fmm.layer.custom(dopt{:},varargin{:});
    case {'xslab','x-slab','x-layer','x-homo'}
        o.layer{mL,1} = fmm.layer.xslab(dopt{:},varargin{:});
    case {'x-rect'}
        o.layer{mL,1} = fmm.layer.anisotropicrect(dopt{:},varargin{:});
    case {'m-homo'}
        o.layer{mL,1} = fmm.layer.magneticslab(dopt{:},varargin{:});
    otherwise
        error('fmm/add::check layer name')
end
o.progmsg(0,'  + added a structure : ',class(o.layer{mL}),'\n');
o.param.NL = mL;







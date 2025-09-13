%fmm.index | 
%
%
% monitor: 'xy'(default),'xz','yz','??'
%
%
%






function [] = index(o,varargin)

%** input parser
ip = inputParser;
addParameter(ip,'plane','xy')
addParameter(ip,'x',[])
addParameter(ip,'y',[])
addParameter(ip,'z',[])
addParameter(ip,'dx',10e-9)
addParameter(ip,'dy',10e-9)
addParameter(ip,'dz',10e-9)
addParameter(ip,'squeeze',false)
parse(ip,varargin{:})
ip = ip.Results;

switch ip.plane
    case {'xy','yx'}
        if ~isscalar(ip.z)
            error('xy/yz-plane monitor should have scalar z')
        end
    case {'yz','zy'}
        if ~isscalar(ip.x)
            error('yz/zy-plane monitor should have scalar x')
        end
    case {'xz','zx'}
        if ~isscalar(ip.y)
            error('xz/zx-plane monitor should have scalar y')
        end
    case {'custom'}
        if numel(ip.x)~=numel(ip.y) || numel(ip.x)~=numel(ip.z)
            error('custom monitor should have (x,y,z) of same size')
        end
end


%** construct grids for non-custom plane monitors
o.initialize
p = o.param;
d = cellfun(@(x)x.thick,o.layer).'; % thickness of each layer
[zmin,zmax] = fmm.layer.util.interface(d); % interface coordinates
dtotal = zmax(end); % total thickness of layers
ax = p.ax;
ay = p.ay;
if strcmp(ip.plane,'custom')
    Nxyz = size(ip.x);
    x_ = ip.x(:).';
    y_ = ip.y(:).';
    z_ = ip.z(:).';
else
    if isempty(ip.x)
        Nx = round(ax/ip.dx);
        x = linspace(0,ax,Nx);
    else
        x = ip.x;
        Nx = numel(x);
    end
    if isempty(ip.y)
        Ny = round(ay/ip.dy);
        y = linspace(0,ay,Ny);
    else
        y = ip.y;
        Ny = numel(y);
    end
    if isempty(ip.z)
        Nz = round(dtotal/ip.dz);
        z = linspace(0,dtotal,Nz);
    else
        z = ip.z;
        Nz = numel(z);
    end
    Nxyz = [Nx Ny Nz];
    [x_,y_,z_] = ndgrid(x,y,z);
    x_ = x_(:).';
    y_ = y_(:).';
    z_ = z_(:).';
end
NG = prod(Nxyz);
NL = p.NL;
i_ = fmm.layer.util.index(z_,[zmin dtotal]);

%* initialize index
ep = zeros(1,NG);

%*
for mL=1:NL
    ii = find(i_==mL+1);
    if ~isempty(ii)
        xx = x_(ii);
        yy = y_(ii);

        if isa(o.layer{mL},'fmm.layer.slab')
            ep(ii) = o.layer{mL}.epzz;
        else
            epzz = o.layer{mL}.epzz;
            [gx_,gy_] = fmm.layer.util.grid(size(epzz),[ax ay]);
            ep(ii) = interp2(gx_.',gy_.',epzz.',xx,yy);
        end
    end
end

%* substrate-region
ii = find(i_==1);
if ~isempty(ii)
    ep(ii) = p.ep1;
end

ii = find(i_==NL+2);
if ~isempty(ii)
    ep(ii) = p.ep2;
end

%* squeeze
if ip.squeeze && numel(Nxyz)>2
    for i=numel(Nxyz):-1:1
        if Nxyz(i)==1
            Nxyz(i) = [];
        end
    end
end

%* save output
o.out.index.ep = reshape(ep,Nxyz);
o.out.index.x_ = reshape(x_,Nxyz);
o.out.index.y_ = reshape(y_,Nxyz);
o.out.index.z_ = reshape(z_,Nxyz);
if ~strcmp(ip.plane,'custom')
    o.out.index.x = x;
    o.out.index.y = y;
    o.out.index.z = z;
end

end


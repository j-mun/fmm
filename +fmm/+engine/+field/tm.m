%fmm.engine.field.tm | 


function [out] = tm(p,tmp,varargin)

%** input parser
ip = inputParser;
addParameter(ip,'x',[])
addParameter(ip,'z',[])
addParameter(ip,'dx',10e-9)
addParameter(ip,'dz',10e-9)
parse(ip,varargin{:})

%** construct grid
ax = p.ax;
d = tmp.d; % thickness of each layer
[zmin,zmax] = fmm.layer.util.interface(d); % interface coordinates
dtotal = zmax(end); % total thickness of layers
if isempty(ip.Results.x) % absolute x coordinate
    mesh_dx = ip.Results.dx;
    mesh_nx = round(ax/mesh_dx);
    x = linspace(0,ax,mesh_nx);
else
    x = ip.Results.x;
end
if isempty(ip.Results.z) % absolute z coordinate
    mesh_dz = ip.Results.dz;
    mesh_nz = round(dtotal/mesh_dz);
    z = linspace(0,dtotal,mesh_nz);
else
    z = ip.Results.z;
end
nL = p.NL;
nF = p.nF;

%** mode amplitudes
c_p = tmp.c_p;
c_n = tmp.c_n;

% 
x = reshape(x,[],1); % [Nx x 1]
z = reshape(z,[],1); % [Nz x 1]
Nx = numel(x);
Nz = numel(z);
Ex = zeros(Nx,Nz);
Ey = zeros(Nx,Nz);
Ez = zeros(Nx,Nz);
Hx = zeros(Nx,Nz);
Hy = zeros(Nx,Nz);
Hz = zeros(Nx,Nz);
H0 = 1/p.et0;
k0 = p.k0;
Kx = tmp.Kx;
D = tmp.D;
W = tmp.W;
V = tmp.V;
P = exp(1i*k0*(x).*reshape(Kx,[1 nF])); % [Nx x N x Nf]
E = cell(1,nL);
for mL=1:nL
    E{mL} = tmp.epmnzz{mL}(tmp.i_conv);
end
lz = 1;
for mL=1:nL
    % relative z coordinate
    if mL==nL
        nz1 = find(z>=zmin(mL),1);
        nz2 = find(z<=zmax(mL),1,'last');
    else
        nz1 = find(z>=zmin(mL),1);
        nz2 = find(z<zmax(mL),1,'last');
    end
    if nz1<=nz2
        zz = z(nz1:nz2)-zmin(mL);
    else
        zz = [];
    end
    
    for mz=1:numel(zz)
        Sx = W{mL}...
            *(expm(-diag(D{mL})*k0*zz(mz))*c_p(:,mL)...
            +expm(diag(D{mL})*k0*(zz(mz)-d(mL)))*c_n(:,mL));
        Uy = V{mL}...
            *(-expm(-diag(D{mL})*k0*zz(mz))*c_p(:,mL)...
            +expm(diag(D{mL})*k0*(zz(mz)-d(mL)))*c_n(:,mL));
        Ex(:,lz) = (P*Sx);
        Sz = 1i*(E{mL}\diag(Kx)*Uy);
        Ez(:,lz) = P*Sz;
        Hy(:,lz) = -1i*H0*(P*Uy);
        lz = lz+1;
    end
end

out.Ex = Ex;
out.Ey = Ey;
out.Ez = Ez;
out.Hx = Hx;
out.Hy = Hy;
out.Hz = Hz;
out.x = x;
out.z = z;

end


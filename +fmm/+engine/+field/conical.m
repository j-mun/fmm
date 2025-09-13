%fmm.engine.field.conical



function [out] = conical(p,tmp,varargin)

%** input parser
ip = inputParser;
addParameter(ip,'plane','xz')
addParameter(ip,'x',[])
addParameter(ip,'y',[])
addParameter(ip,'z',[])
addParameter(ip,'dx',10e-9)
addParameter(ip,'dy',10e-9)
addParameter(ip,'dz',10e-9)
addParameter(ip,'magnetic',true)
addParameter(ip,'squeeze',false)
addParameter(ip,'intensity',false)
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
d = tmp.d; % thickness of each layer
[zmin,zmax] = fmm.layer.util.interface(d); % interface coordinates
dtotal = zmax(end); % total thickness of layers
if strcmp(ip.plane,'custom')
    Nxyz = size(ip.x);
    x_ = ip.x(:).';
    y_ = ip.y(:).';
    z_ = ip.z(:).';
else
    ax = p.ax;
    ay = p.ay;
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
NF = size(tmp.Kx,1);

%* initializing fields
Ex = zeros(1,NG);
Ey = zeros(1,NG);
Ez = zeros(1,NG);
Hx = zeros(1,NG);
Hy = zeros(1,NG);
Hz = zeros(1,NG);

%*
i_ = fmm.layer.util.index(z_,[zmin dtotal]);
H0 = -1i/p.et0;
k0 = p.k0;
Kx = tmp.Kx;
Ky = tmp.Ky;
for mL = 1:NL
    ii = find(i_==mL+1);
    if ~isempty(ii)
        xx = x_(ii);
        yy = y_(ii);
        zz = z_(ii)-zmin(mL);

        D = tmp.D{mL};
        W = tmp.W{mL};
        V = tmp.V{mL};
        c_p = tmp.c_p(:,mL);
        c_n = tmp.c_n(:,mL);

        exy = W*( ...
            exp(-k0*D.*zz).*c_p ...
            +exp(k0*D.*(zz-d(mL))).*c_n    );
        hxy = V*( ...
            -exp(-k0*D.*zz).*c_p ...
            +exp(k0*D.*(zz-d(mL))).*c_n    );
        P = exp(1i*k0*(xx.*Kx+yy.*Ky));
        Ex(ii) = sum(P.*exy(1:NF,:),1);
        Ey(ii) = sum(P.*exy(NF+1:2*NF,:),1);
        Hx(ii) = H0*sum(P.*hxy(1:NF,:),1);
        Hy(ii) = H0*sum(P.*hxy(NF+1:2*NF,:),1);

        E = tmp.epmnzz{mL}(tmp.i_conv);
        ez = -1i*E\(Kx.*hxy(NF+1:2*NF,:)-Ky.*hxy(1:NF,:)); % Note: 1i*inv(E) -> -1i*E\ 
        Ez(ii) = sum(P.*ez,1);
        hz = 1i*(Kx.*exy(NF+1:2*NF,:)-Ky.*exy(1:NF,:));
        Hz(ii) = H0*sum(P.*hz,1);
    end
end

%* substrate-region (reflection-side)
ii = find(i_==1);
if ~isempty(ii)
    xx = x_(ii);
    yy = y_(ii);
    zz = z_(ii);
    
    [V,W,D] = fmm.eig.slab(p.ep1,Kx,Ky);
    c_n = tmp.r; % reflection
    exy = W*( ...
        exp(k0*D.*zz).*c_n    );
    hxy = V*( ...
        exp(k0*D.*zz).*c_n    );
    P = exp(1i*k0*(xx.*Kx+yy.*Ky));
    Ex(ii) = sum(P.*exy(1:NF,:),1);
    Ey(ii) = sum(P.*exy(NF+1:2*NF,:),1);
    Hx(ii) = H0*sum(P.*hxy(1:NF,:),1);
    Hy(ii) = H0*sum(P.*hxy(NF+1:2*NF,:),1);

    invE = p.ep1^-1;
    ez = 1i*invE*(Kx.*hxy(NF+1:2*NF,:)-Ky.*hxy(1:NF,:)); % Note: 1i*inv(E) -> -1i*E\ 
    Ez(ii) = sum(P.*ez,1);
    hz = 1i*(Kx.*exy(NF+1:2*NF,:)-Ky.*exy(1:NF,:));
    Hz(ii) = H0*sum(P.*hz,1);

    % incident fields
    n_e = p.n_e;
    n_k = p.n_k;
    k1 = p.k1;
    exp_ikr = exp(1i*k1*(n_k(1)*xx+n_k(2)*yy+n_k(3)*zz));
    Ex(ii) = Ex(ii) ...
        +n_e(1)*exp_ikr;
    Ey(ii) = Ey(ii) ...
        +n_e(2)*exp_ikr;
    Ez(ii) = Ez(ii) ...
        +n_e(3)*exp_ikr;

    n_h = cross(n_k,n_e);
    H1 = 1/p.et1/p.et0;
    Hx(ii) = Hx(ii) ...
        +H1*n_h(1)*exp_ikr;
    Hy(ii) = Hy(ii) ...
        +H1*n_h(2)*exp_ikr;
    Hz(ii) = Hz(ii) ...
        +H1*n_h(3)*exp_ikr;
end

%* superstrate-region (transmission-side)
% ii = find(i_==NL+2);
ii = find(z_>=dtotal);
if ~isempty(ii)
    xx = x_(ii);
    yy = y_(ii);
    zz = z_(ii)-dtotal;

    [V,W,D] = fmm.eig.slab(p.ep2,Kx,Ky);
    c_p = tmp.t;
    exy = W*( ...
        exp(-k0*D.*zz).*c_p    );
    hxy = V*( ...
        -exp(-k0*D.*zz).*c_p    );

    P = exp(1i*k0*(xx.*Kx+yy.*Ky));
    Ex(ii) = sum(P.*exy(1:NF,:),1);
    Ey(ii) = sum(P.*exy(NF+1:2*NF,:),1);
    Hx(ii) = H0*sum(P.*hxy(1:NF,:),1);
    Hy(ii) = H0*sum(P.*hxy(NF+1:2*NF,:),1);
    
    invE = p.ep2^-1;
    ez = 1i*invE*(Kx.*hxy(NF+1:2*NF,:)-Ky.*hxy(1:NF,:)); % Note: 1i*inv(E) -> -1i*E\ 
    Ez(ii) = sum(P.*ez,1);
    hz = 1i*(Kx.*exy(NF+1:2*NF,:)-Ky.*exy(1:NF,:));
    Hz(ii) = H0*sum(P.*hz,1);
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
out.Ex = reshape(Ex,Nxyz);
out.Ey = reshape(Ey,Nxyz);
out.Ez = reshape(Ez,Nxyz);
out.Hx = reshape(Hx,Nxyz);
out.Hy = reshape(Hy,Nxyz);
out.Hz = reshape(Hz,Nxyz);
out.x_ = reshape(x_,Nxyz);
out.y_ = reshape(y_,Nxyz);
out.z_ = reshape(z_,Nxyz);
if ip.intensity
    out.E2 = abs(out.Ex).^2+abs(out.Ey).^2+abs(out.Ez).^2;
end
if ~strcmp(ip.plane,'custom')
    out.x = x;
    out.y = y;
    out.z = z;
end

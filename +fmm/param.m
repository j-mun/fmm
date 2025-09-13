%fmm.param | class for storing fmm system parameters


classdef param < handle & matlab.mixin.Copyable
    
    %** numerics
    properties
        nx = 0          % the maximum Fourier order
        ny = 0
        nFx
        nFy
        nF
        nSx
        nSy
        NL = uint16(0)  % the total number of layers
        NP = uint32(0)  % the number of parallel simulations
        fsgt = -1
    end

    %** system parameters
    properties
        ax = inf        % the lattice constant [m]
        ay = inf
        bx              % the reciprocal lattice constant [rad/m]
        by 
        ep1 = 1         % relative permittivity
        ep2 = 1
        mu1 = 1         % relative permeability
        mu2 = 1
        n1              % refractive index
        n2
        et1             % relative wave impedance
        et2
    end
    
    %** incident fields
    properties
        lambda0         % vacuum wavelength [m]
        k0              % vacuum wavenumber [rad/m]
        theta = 0       % inclination angle [deg]            
        phi = 0         % azimuthal angle [deg]
        psi = 0         % polarization angle [deg]
        eta = 0         % ellipticity [deg]
        n_e
        n_k
        k1              % wavenumber in substrate [rad/m]
        k2              % wavenumber in superstrate [rad/m]
    end
    
    %** system
    properties
        dim     % system dimension
        mode    % polarization mode
    end

    %** constants
    properties (Constant)
        ep0 = 8.854187817E-12   % vacuum permittivity [F/m]
        mu0 = 1.25663706212E-6  % vacuum permeability [H/m]
        c   = 299792458         % speed of light [m/s]
        et0 = 376.73031346177   % vacuum wave impedance [Ohm]
    end
    
    
    %** setter functions
    methods

        function set(o,varargin)
            for i = 1:2:nargin-1
                switch varargin{i}
                    case  {'lam0'}
                        o.set('lambda0',varargin{i+1})
                    case {'n1'}
                        o.set('ep1',varargin{i+1}.^2)
                    case {'n2'}
                        o.set('ep2',varargin{i+1}.^2)
                    case {'nh'}
                        if size(varargin{i+1},2)==2
                            o.set('ep1',varargin{i+1}(:,1).^2)
                            o.set('ep2',varargin{i+1}(:,2).^2)
                        else
                            error('fmm : nh = [n1(:),n2(:)]')
                        end
                    case {'a'}
                        if numel(varargin{i+1})==2
                            o.ax = varargin{i+1}(1);
                            o.ay = varargin{i+1}(2);
                        else
                            error('a = [ax,ay]')
                        end
                    case {'lambda0','ep1','ep2','mu1','mu2'}
                        o.(varargin{i}) = varargin{i+1}(:);
                    otherwise
                        o.(varargin{i}) = varargin{i+1};
                end
            end
        end

        function set.nx(o,v)
            if mod(v,1)~=0 && v>=0
                error('fmm : nx should be non-negative integer')
            else
                o.nx = v;
            end
        end

        function set.ny(o,v)
            if mod(v,1)~=0 && v>=0
                error('fmm : ny should be non-negative integer')
            else
                o.ny = v;
            end
        end

    end

    %** getter functions
    methods

        function v = get.nFx(o)
            v = 2*o.nx+1;
        end

        function v = get.nSx(o)
            v = 4*o.nx+1;
        end

        function v = get.nFy(o)
            v = 2*o.ny+1;
        end

        function v = get.nSy(o)
            v = 4*o.ny+1;
        end

        function v = get.nF(o)
            v = o.nFx*o.nFy;
        end

        function v = get.bx(o)
            v = 2*pi/o.ax;
        end

        function v = get.by(o)
            v = 2*pi/o.ay;
        end

        function v = get.n1(o)
            v = sqrt(o.ep1).*sqrt(o.mu1);
        end
        
        function v = get.n2(o)
            v = sqrt(o.ep2).*sqrt(o.mu2);
        end

        function v = get.et1(o)
            v = sqrt(o.mu1)./sqrt(o.ep1);
        end

        function v = get.et2(o)
            v = sqrt(o.mu2)./sqrt(o.ep2);
        end

        function v = get.k0(o)
            v = 2*pi./o.lambda0;
        end

        function v = get.k1(o)
            v = o.n1.*o.k0;
        end

        function v = get.k2(o)
            v = o.n2.*o.k0;
        end

        function v = get.n_k(o)
            t = o.theta;
            p = o.phi;
            v = [...
                sind(t)*cosd(p);
                sind(t)*sind(p);
                cosd(t)];
        end

        function v = get.n_e(o)
            t = o.theta;
            p = o.phi;
            q = o.psi;
            h = o.eta;
            ex = cosd(h)*(cosd(q)*cosd(t)*cosd(p)-sind(q)*sind(p))...
                +1i*sind(h)*(cosd(q+90)*cosd(t)*cosd(p)-sind(q+90)*sind(p));
            ey = cosd(h)*(cosd(q)*cosd(t)*sind(p)+sind(q)*cosd(p))...
                +1i*sind(h)*(cosd(q+90)*cosd(t)*sind(p)+sind(q+90)*cosd(p));
            ez = cosd(h)*(-cosd(q)*sind(t))...
                +1i*sind(h)*(-cosd(q+90)*sind(t));
            v = [ex;ey;ez];
        end

        function v = get.dim(o)
            if o.nx==0 && o.ny==0
                v = 1;
            elseif o.ny==0
                v = 2;
            else
                v = 3;
            end
        end

        function v = get.mode(o)
            if o.ny~=0 || o.phi~=0 || o.eta~=0
                v = 'conical'; % conical
            elseif o.phi==0 && o.psi==90
                v = 'te'; % te
            elseif o.phi==0 && o.psi==0
                v = 'tm'; % tm
            else
                v = 'conical';
            end
        end

    end

    %** parameter updater
    methods (Access = private)

        function updateNumerics(o,i)
            if i==1
                o.NFx = 2*o.nx+1;
                o.NSx = 4*o.nx+1;
            elseif i==2
                o.NFy = 2*o.ny+1;
                o.NSy = 4*o.ny+1;
            end
        end

        function updateSystems(o)
            o.n1 = sqrt(o.ep1).*sqrt(o.mu1);
            o.n2 = sqrt(o.ep2).*sqrt(o.mu2);
            o.et1 = sqrt(o.mu1)./sqrt(o.ep1);
            o.et2 = sqrt(o.mu2)./sqrt(o.ep2);

            o.k0 = 2*pi./o.lambda0;
            o.k1 = o.n1.*o.k0;
            o.k2 = o.n2.*o.k0;
        end
    end
end


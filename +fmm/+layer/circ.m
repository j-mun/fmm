%fmm.layer.circ < fmm.layer.shape

classdef circ < fmm.layer.shape

    properties
        ephxx = 1   % permittivity of host media
        ephyy = 1
        ephzz = 1
        epixx = 1   % permittivity of inclusion (particle)
        epiyy = 1
        epizz = 1

        radius      % radius [m]
        x           % center coordinate x [m]
        y           % center coordinate y [m]
        fx = 1      % x-ratio
        fy = 1      % y-ratio
        theta = 0   % rotation [deg]
    end

    methods

        function o = circ(varargin)
            o.set(varargin{:});
        end

        function set(o,varargin)
            for i = 1:2:nargin-2
                switch varargin{i}
                    case {'d','thick','thickness'}
                        o.thick = varargin{i+1};
                    case {'nhxx'}
                        o.ephxx = varargin{i+1}.^2;
                    case {'nhyy'}
                        o.ephyy = varargin{i+1}.^2;
                    case {'nh','nhzz'}
                        o.ephzz = varargin{i+1}.^2;
                    case {'nxx'}
                        o.epixx = varargin{i+1}.^2;
                    case {'nyy'}
                        o.epiyy = varargin{i+1}.^2;
                    case {'n','nzz'}
                        o.epizz = varargin{i+1}.^2;
                    case {'R'}
                        o.radius = varargin{i+1};
                    otherwise
                        o.(varargin{i}) = varargin{i+1};
                end
            end
        end

        function bitmap(o,p)
            [x_,y_] = fmm.layer.util.grid([p.nx p.ny]*o.res+1,[p.ax p.ay]);
            o.image = fmm.layer.util.bitmap('circ',...
                x_,y_,...
                o.radius,o.x,o.y,o.fx,o.fy,o.theta);
            o.epzz = (o.epizz-o.ephzz)*o.image+o.ephzz;
            if o.model==2 % anisotropic
                o.epyy = (o.epiyy-o.ephyy)*o.image+o.ephyy;
                o.epxx = (o.epixx-o.ephxx)*o.image+o.ephxx;
            end
        end

        function [c] = init(o,p)
            parvar = {'ephxx','ephyy','ephzz','epixx','epiyy','epizz', ...
                'thick','radius','x','y','fx','fy','theta'};
            c = o.init_default(p,parvar);
        end

        function [c] = init_old(o,p)
            pardim = numel(p);

            %** non-parallel case
            if pardim==1
                o.bitmap(p);
                c = o;
                return
            end

            %** check parallel variables
            parvar = {'ephxx','ephyy','ephzz','epixx','epiyy','epizz', ...
                'thick','radius','x','y','fx','fy','theta'};
            exist_parvar = false;
            for i=1:numel(parvar)
                nvar = numel(o.(parvar{i}));
                if nvar==pardim
                    exist_parvar = true;
                    break
                elseif nvar~=pardim && nvar~=1
                    error('fmm::circ::check dimension of %s',parvar{i})
                end
            end

            %** if parvar doesn't exist
            if ~exist_parvar && ...
                    numel(unique(cellfun(@(x)x.ax,p)))==1 && ...
                    numel(unique(cellfun(@(x)x.ay,p)))==1
                o.bitmap(p{1});
                c = cell(1,pardim);
                for i=1:pardim
                    c{i} = copy(o);
                end
                return
            end

            %** copy class
            c = cell(1,pardim);
            for i=1:pardim
                c{i} = copy(o);
            end

            %** copy parvar
            for i=1:numel(parvar)
                nvar = numel(o.(parvar{i}));
                if nvar==pardim
                    tmpval = o.(parvar{i})(:);
                    for j=1:pardim
                        c{j}.(parvar{i}) = tmpval(j);
                    end
                elseif nvar~=pardim && nvar~=1
                    error('fmm::circ::check dimension of %s',parvar{i})
                end
            end

            %**
            for i=1:pardim
                c{i}.bitmap(p{i});
            end
        end
    end
end

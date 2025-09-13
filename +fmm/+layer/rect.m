%fmm.layer.rect
%
%
% eph : host refractive index {1}
% ep : rectangle refractive index {1}
% {xmin, xmax} min/max x-coordinates [m]
% {ymin, ymax} min/max y-coordinates [m]
% {x, xspan} center coordinate & x-span [m]
% {y yspan} center coordinate & y-span [m]
% theta: rotation angle [deg]

classdef rect < fmm.layer.shape

    properties
        ephxx = 1   % permittivity of host media
        ephyy = 1
        ephzz = 1
        epixx = 1   % permittivity of inclusion
        epiyy = 1
        epizz = 1

        xmin = -Inf
        xmax = Inf
        ymin = -Inf
        ymax = Inf
        x %= 0
        xspan %= Inf
        y %= 0
        yspan %= Inf
        theta = 0   % rotation angle [deg]
    end

    methods

        function o = rect(varargin)
            o.set(varargin{:});
        end

        function set(o,varargin)
            x1 = [];
            xspan1 = [];
            y1 = [];
            yspan1 = [];
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
                    case {'ep','epi'}
                        o.epizz = varargin{i+1};
                    case {'eph'}
                        o.ephzz = varargin{i+1};
                    case {'x'}
                        x1 = varargin{i+1};
                    case {'xspan','x span'}
                        xspan1 = varargin{i+1};
                    case {'y'}
                        y1 = varargin{i+1};
                    case {'yspan','y span'}
                        yspan1 = varargin{i+1};
                    otherwise
                        o.(varargin{i}) = varargin{i+1};
                end
            end
            if ~isempty(x1) && ~isempty(xspan1)
                o.x = x1;
                o.xspan = xspan1;
                o.xmin = x1-xspan1/2;
                o.xmax = x1+xspan1/2;
            end
            if ~isempty(y1) && ~isempty(yspan1)
                o.y = y1;
                o.yspan = yspan1;
                o.ymin = y1-yspan1/2;
                o.ymax = y1+yspan1/2;
            end

        end

        function bitmap(o,p)
            [x_,y_] = fmm.layer.util.grid([p.nx p.ny]*o.res+1,[p.ax p.ay]);
            o.image = fmm.layer.util.bitmap('rect',x_,y_,...
                o.xspan,o.x,o.yspan,o.y,o.theta);
            o.epzz = (o.epizz-o.ephzz)*o.image+o.ephzz;
            if o.model==2
                o.epyy = (o.epiyy-o.ephyy)*o.image+o.ephyy;
                o.epxx = (o.epixx-o.ephxx)*o.image+o.ephxx;
            end
        end

        function [c] = init(o,p)
            parvar = {'ephxx','ephyy','ephzz','epixx','epiyy','epizz', ...
                'thick','xmin','xmax','ymin','ymax','theta'};
            c = o.init_default(p,parvar);
        end

        function [c] = init_tmp(o,p)
            pardim = numel(p);

            %** non-parallel case
            if pardim==1
                o.bitmap(p);
                c = o;
                return
            end

            %** check parallel variables
            parvar = {'ephxx','ephyy','ephzz','epixx','epiyy','epizz', ...
                'thick','xmin','xmax','ymin','ymax','theta'};
            exist_parvar = false;
            for i=1:numel(parvar)
                nvar = numel(o.(parvar{i}));
                if nvar==pardim
                    exist_parvar = true;
                    break
                elseif nvar~=pardim && nvar~=1
                    error('fmm/rect : check dimension of <%s>',parvar{i})
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
                    error('fmm/rect : check dimension of <%s>',parvar{i})
                end
            end

            %**
            for i=1:pardim
                c{i}.bitmap(p{i});
            end
        end

    end

    % getter functions
    methods
        function [x] = get.x(o)
            if ~isfinite(o.xmin) || ~isfinite(o.xmax)
                x = 0;
            else
                x = (o.xmin+o.xmax)/2;
            end
        end

        function [xspan] = get.xspan(o)
            if ~isfinite(o.xmin) || ~isfinite(o.xmax)
                xspan = 0;
            else
                xspan = o.xmax-o.xmin;
            end
        end

        function [y] = get.y(o)
            if ~isfinite(o.ymin) || ~isfinite(o.ymax)
                y = 0;
            else
                y = (o.ymin+o.ymax)/2;
            end
        end

        function [yspan] = get.yspan(o)
            if ~isfinite(o.ymin) || ~isfinite(o.ymax)
                yspan = 0;
            else
                yspan = o.ymax-o.ymin;
            end
        end

    end
end

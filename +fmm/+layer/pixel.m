%fmm.layer.pixel | Pixelated images
%
%
%
%
%

classdef pixel < fmm.layer.shape

    properties
        ephxx = 1
        ephyy = 1
        ephzz = 1
        epixx
        epiyy
        epizz
    end

    methods

        function o = pixel(varargin)
            o.set(varargin{:});
        end

        function set(o,varargin)
            for i = 1:2:nargin-2
                switch varargin{i}
                    case {'d','thick'}
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
                    case {'nvm','disc','res'}
                        o.(varargin{i}) = varargin{i+1};
                    otherwise
                        o.(varargin{i}) = varargin{i+1};
                end
            end
        end

        function bitmap(o,~)
            o.image = o.epizz(:,:);
            o.image(o.image==o.ephzz) = 0;
            o.epzz = o.epizz;
        end

        function [c] = init(o,p)
            pardim = numel(p);

            %** non-parallel case
            if pardim==1
                o.bitmap(p);
                c = o;
                return
            end

            %** check if parallel
            exist_parvar = false;
            if size(o.epi,3)~=1
                exist_parvar = true;
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

            tmpval = o.epi;
            for j=1:pardim
                c{j}.ep = tmpval(:,:,j);
            end

            %**
            for i=1:pardim
                c{i}.bitmap(p{i});
            end
        end
    end
end


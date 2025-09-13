%fmm.layer.slab | 




classdef slab < fmm.layer.default

    properties
        epxx = 1
        epyy = 1
        epzz = 1
    end
    
    methods

        function o = slab(varargin)
            o.set(varargin{:});
        end
        
        function [] = set(o,varargin)
            for i = 1:2:nargin-2
                switch varargin{i}
                    case {'d','thickness'}
                        o.thick = varargin{i+1};
                    case {'nxx'}
                        o.epxx = varargin{i+1}.^2;
                    case {'nyy'}
                        o.epyy = varargin{i+1}.^2;
                    case {'n','nzz'}
                        o.epzz = varargin{i+1}.^2;
                    case {'epxx'}
                        o.epxx = varargin{i+1};
                    case {'epyy'}
                        o.epyy = varargin{i+1};
                    case {'eps','epr','epzz','ep'}
                        o.epzz = varargin{i+1};
                    otherwise
                        o.(varargin{i}) = varargin{i+1};
                end
            end
        end
        
        function [] = bitmap(o,~)
            o.image = 1;
        end

        function [c] = init(o,p)
            parvar = {'epxx','epyy','epzz','thick'};
            c = o.init_default(p,parvar);
        end

        function [c] = init_tmp(o,p)
            pardim = numel(p);

            %** non-parallel case
            if pardim==1
                o.bitmap;
                c = o;
                return
            end

            %** check parallel variables
            parvar = {'epxx','epyy','epzz','thick'};
            exist_parvar = false;
            for i=1:numel(parvar)
                nvar = numel(o.(parvar{i}));
                if nvar==pardim
                    exist_parvar = true;
                    break
                elseif nvar~=pardim && nvar~=1
                    error('fmm::slab::check dimension of %s',parvar{i})
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
                    error('fmm::slab::check dimension of %s',parvar{i})
                end
            end

            %**
            for i=1:pardim
                c{i}.bitmap(p{i});
            end
        end
        
        function [] = fft(o,n)
            delta = zeros(4*n(1)+1,4*n(2)+1);
            delta(2*n(1)+1,2*n(2)+1) = 1;
            o.epmnzz = o.epzz*delta;
            if o.model==2
                o.epmnyy = o.epyy*delta;
                o.epmnxx = o.epxx*delta;
            end
        end
        
        function [] = ifft(~,~) % this function will not be used
        end

        function [] = normvec(~,~,~,~) % this function will not be used
        end

        function [V,W,D] = eig(o,Kx,Ky,~)
            if o.model==2
                [V,W,D] = ...
                    fmm.eig.xslab(...
                    o.epxx,o.epyy,o.epzz,Kx,Ky);
                return
            end
            
            if o.mode==1 % conical
                [V,W,D] = ...
                    fmm.eig.slab(...
                    o.epzz,Kx,Ky);
            elseif o.mode==2 % te
                [V,W,D] = ...
                    fmm.eig.slab_te(...
                    o.epzz,Kx);
            elseif o.mode==3 % tm
                [V,W,D] = ...
                    fmm.eig.slab_tm(...
                    o.epzz,Kx);
            end
        end
    end
end
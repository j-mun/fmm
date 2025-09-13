%fmm.option | class for storing fmm options


classdef option < handle

    properties
        version = 'v23.0'
        verbose = true % {true (default), false}
        method = 1 % {t-matrix (default),s-matrix}
        algorithm
        nvm = 1 % {0, 1(default), 2?}
        fsgt = 1 % {}
        mode = -1 % {-1: auto, 1: general, 2: te, 3: tm}
        res = 32
        basis = 'ps' % {'ps' (default), 'lr'}
        sweep = false % {true, false (default)}
        parallel = false % {true, false (default)}
        pardim = 0
        parnum
        monitor = false
        
    end
    
    methods
        
        function o = option(varargin)
            o.set(varargin{:});
        end

        function [] = set(o,varargin)
            %fmm.option.set | set fmm options
            for i = 1:2:nargin-1
                o.(varargin{i}) = varargin{i+1};
            end
        end

        %** setter functions
        function set.verbose(o,v)
            if islogical(v)
                o.verbose = v;
            else
                error('fmm : verbose should be {true, false}')
            end
        end
        
        function set.method(o,v)
            if any(strcmp(v,{'tmx','smx'}))
                switch v
                    case 'tmx'
                        v = 1;
                    case 'smx'
                        v = 2;
                end
                o.method = v;
            else
                error('fmm : method should be {''tmx'',''smx''}')
            end
        end
        
        function set.mode(o,v)
            if any(strcmp(v,{'auto','conical','te','tm'}))
                switch v
                    case 'auto'
                        v = -1;
                    case 'conical'
                        v = 1;
                    case 'te'
                        v = 2;
                    case 'tm'
                        v = 3;
                end
                o.mode = v;
            else
                error('fmm : mode should be {''conical'',''te'',''tm''}')
            end
        end
        
        function set.basis(o,v)
            if any(strcmp(v,{'ps','lr'}))
                o.basis = v;
            else
                error('fmm : basis should be {''ps'',''lr''}')
            end
        end
        
        function set.pardim(o,v)
            if isscalar(v)
                o.pardim = [1 v];
            else
                o.pardim = v;
            end
        end

        function v = get.parnum(o)
            v = prod(o.pardim);
        end
    end
end


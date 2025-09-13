%fmm | handle class for fmm codes

classdef fmm < handle
    
    properties
        param   % fmm parameters
        layer   % layer parameters
        opt     % option
        tmp
        dat
        out % results
    end
    
    methods
        function o = fmm(varargin)
            %fmm | initialize fmm class

            %** fmm parameters
            o.param = fmm.param;
            
            %** default options
            o.opt = fmm.option;

            %** default layer
            o.layer = {};
            
            %** setopt
            o.setopt(varargin{:})
        end

        function set(o,varargin)
            %fmm.set | set fmm parameters
            o.param.set(varargin{:})
        end

        function setopt(o,varargin)
            %fmm.setopt | set fmm options
            o.opt.set(varargin{:});
        end
    end

    methods
        function initialize(o)
            fmm.engine.init(o)
        end

%         function visualize(o,varargin)
%             fmm.util.visualize(o,varargin{:})
%         end

        function outval = fetch(o,varargin)
            outval = fmm.engine.fetch(o,varargin{:});
        end

%         function nmsg = progmsg(o,nmsg,varargin)
%             if ~o.opt.verbose; return; end
%             nmsg = fmm.util.progmsg(o,nmsg,varargin{:});
%         end

%         function field(o,varargin)
%             %fmm field monitor
%             fmm.util.field(o,varargin{:});
%         end

%         function index(o,varargin)
%             %fmm index monitor
%             fmm.util.index(o,varargin{:})
%         end
    end

end


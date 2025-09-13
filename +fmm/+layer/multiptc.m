%fmm.layer.multiptc | Multiple particles
%
%
%
%
%


classdef multiptc < fmm.layer.shape
    
    properties
        ephxx = 1   % permittivity of host media
        ephyy = 1
        ephzz = 1
        ptc = [] % {shape, options}
        param = [];
        numptc = 0;
        tmp
    end
    
    methods
        function o = multiptc(varargin)
            o.numptc = 0;
            o.set(varargin{:});
        end
        
        function set(o,varargin)
            for i = 1:2:nargin-2
                switch varargin{i}
                    case {'d','thickness'}
                        o.thick = varargin{i+1};
                    case {'nhxx'}
                        o.ephxx = varargin{i+1}.^2;
                    case {'nhyy'}
                        o.ephyy = varargin{i+1}.^2;
                    case {'nh','nhzz'}
                        o.ephzz = varargin{i+1}.^2;
                    case {'rect','circ','poly1','poly2'}
                        o.numptc = o.numptc+1;
                        o.ptc{o.numptc} = varargin{i};
                        o.param{o.numptc} = varargin{i+1};
                    otherwise
                        o.(varargin{i}) = varargin{i+1};
                end
            end
            o.sortparam
        end
        
        function sortparam(o)
            Np = numel(o.ptc);
            for p=1:Np
                pp = o.param{p};
                
                %==========================================================
                switch o.ptc{p}
                    case {'rect'} % {eps,n,xspan,x,yspan,y,theta} // {xmin,xmax,ymin,ymax}
                        tmp1 = struct(...
                            'epyy',1,'epxx',1, ...
                            'x',0,'xspan',Inf,...
                            'y',0,'yspan',Inf,...
                            'theta',0); % default parameters
                        xmin = [];
                        xmax = [];
                        ymin = [];
                        ymax = [];
                        for i=1:2:numel(pp)
                            switch pp{i}
                                case {'nxx'}
                                    tmp1.epxx = pp{i+1}.^2;
                                case {'nyy'}
                                    tmp1.epyy = pp{i+1}.^2;
                                case {'n','nzz'}
                                    tmp1.epzz = pp{i+1}.^2;
                                case {'xmin','x1'}
                                    xmin = pp{i+1};
                                case {'xmax','x2'}
                                    xmax = pp{i+1};
                                case {'ymin','y1'}
                                    ymin = pp{i+1};
                                case {'ymax','y2'}
                                    ymax = pp{i+1};
                                otherwise
                                    tmp1.(pp{i}) = pp{i+1};
                            end
                        end
                        if ~isempty(xmin) && ~isempty(xmax)
                            tmp1.x = (xmin+xmax)/2;
                            tmp1.xspan = xmax-xmin;
                        end
                        if ~isempty(ymin) && ~isempty(ymax)
                            tmp1.y = (ymin+ymax)/2;
                            tmp1.yspan = ymax-ymin;
                        end
                        o.param{p} = struct(...
                            'epxx',tmp1.epxx,...
                            'epyy',tmp1.epyy,...
                            'epzz',tmp1.epzz,...
                            'x',tmp1.x,...
                            'xspan',tmp1.xspan,...
                            'y',tmp1.y,...
                            'yspan',tmp1.yspan,...
                            'theta',tmp1.theta,...
                            'xmin',tmp1.x-tmp1.xspan/2,...
                            'xmax',tmp1.x+tmp1.xspan/2,...
                            'ymin',tmp1.y-tmp1.yspan/2,...
                            'ymax',tmp1.y+tmp1.yspan/2);
                        %======================================================
                    case {'circ'} % {eps,n,radius,x,y,fx,fy,theta}
                        tmp1 = struct(...
                            'epyy',1,'epxx',1, ...
                            'fx',1,'fy',1,...
                            'theta',0); % default parameters
                        for i=1:2:numel(pp)
                            switch pp{i}
                                case {'nxx'}
                                    tmp1.epxx = pp{i+1}.^2;
                                case {'nyy'}
                                    tmp1.epyy = pp{i+1}.^2;
                                case {'n','nzz'}
                                    tmp1.epzz = pp{i+1}.^2;
                                case {'R','radius','r'}
                                    tmp1.radius = pp{i+1};
                                otherwise
                                    tmp1.(pp{i}) = pp{i+1};
                            end
                        end
                        o.param{p} = struct(...
                            'epxx',tmp1.epxx,...
                            'epyy',tmp1.epyy,...
                            'epzz',tmp1.epzz,...
                            'x',tmp1.x,...
                            'y',tmp1.y,...
                            'radius',tmp1.radius,...
                            'fx',tmp1.fx,...
                            'fy',tmp1.fy,...
                            'theta',tmp1.theta);
                        %======================================================
                    case {'poly1'} % {eps,n,radius,x,y,N}
                        tmp1 = struct(...
                            'epyy',1,'epxx',1, ...
                            'theta',0); % default parameters
                        for i=1:2:numel(pp)
                            switch pp{i}
                                case {'nxx'}
                                    tmp1.epxx = pp{i+1}.^2;
                                case {'nyy'}
                                    tmp1.epyy = pp{i+1}.^2;
                                case {'n','nzz'}
                                    tmp1.epzz = pp{i+1}.^2;
                                case {'R','radius','r'}
                                    tmp1.radius = pp{i+1};
                                otherwise
                                    tmp1.(pp{i}) = pp{i+1};
                            end
                        end
                        o.param{p} = struct(...
                            'epxx',tmp1.epxx,...
                            'epyy',tmp1.epyy,...
                            'epzz',tmp1.epzz,...
                            'x',tmp1.x,...
                            'y',tmp1.y,...
                            'radius',tmp1.radius,...
                            'N',tmp1.N,...
                            'theta',tmp1.theta);
                        %======================================================
                    case {'poly2'} % {eps,n,xv,yv}
                        tmp1 = struct(...
                            'epyy',1,'epxx',1); % default parameters
                        for i=1:2:numel(pp)
                            switch pp{i}
                                case {'nxx'}
                                    tmp1.epxx = pp{i+1}.^2;
                                case {'nyy'}
                                    tmp1.epyy = pp{i+1}.^2;
                                case {'n','nzz'}
                                    tmp1.epzz = pp{i+1}.^2;
                                otherwise
                                    tmp1.(pp{i}) = pp{i+1};
                            end
                        end
                        o.param{p} = struct(...
                            'epxx',tmp1.epxx,...
                            'epyy',tmp1.epyy,...
                            'epzz',tmp1.epzz,...
                            'xv',tmp1.xv,...
                            'yv',tmp1.yv);
                    otherwise
                end
            end
            o.tmp.Np = Np;
        end
        
        function bitmap(o,p)
            
            Np = o.tmp.Np;
            [x_,y_] = fmm.layer.util.grid([p.nx p.ny]*o.res+1,[p.ax p.ay]);
%             nG = [p.nx p.ny]*o.res+1;
%             a = [p.ax p.ay];
            img0 = zeros([size(x_),Np]);
            for ip=1:Np
                pp = o.param{ip};
                switch o.ptc{ip}
                    case {'rect'}
                        tmp1 = fmm.layer.util.bitmap('rect',x_,y_,...
                            pp.xspan,pp.x,pp.yspan,pp.y,pp.theta);
                    case {'circ'}
                        tmp1 = fmm.layer.util.bitmap('circ',x_,y_,...
                            pp.radius,pp.x,pp.y,pp.fx,pp.fy,pp.theta);
                    case {'poly1'}
                        tmp1 = fmm.layer.util.bitmap('poly1',x_,y_,...
                            pp.radius,pp.N,pp.x,pp.y,pp.theta);
                    case {'poly2'}
                        tmp1 = fmm.layer.util.bitmap('poly2',x_,y_,...
                            pp.xv,pp.yv);
                end
                img0(:,:,ip) = tmp1;
            end

%             img1 = zeros(size(x_));
%             for ip=1:Np
%                 pp = o.param{ip};
%                 if pp.epzz~=o.ephzz
%                     img1(img0(:,:,ip)==1) = 1;
%                 else
%                     img1(img0(:,:,ip)==1) = 0;
%                 end
%             end
%             o.image = img1;
            
            o.epzz = o.ephzz*ones(size(x_));
            for ip=1:Np
                o.epzz(img0(:,:,ip)==1) = o.param{ip}.epzz(1);
            end
            if o.model==2
                o.epyy = o.ephyy*ones(size(x_));
                for ip=1:Np
                    o.epyy(img0(:,:,ip)==1) = o.param{ip}.epyy(1);
                end
                o.epxx = o.ephxx*ones(size(x_));
                for ip=1:Np
                    o.epxx(img0(:,:,ip)==1) = o.param{ip}.epxx(1);
                end
            end
            
            o.image = o.epzz-o.ephzz;

        end

        function [c] = init(o,p)
            pardim = numel(p);

            %== non-sweep case ==%
            if pardim==1
                o.bitmap(p);
                c = o;
                return
            end
            
            %== check if sweep variable exists ==%
            parvar.layer = {'ephxx','ephyy','ephzz','thick'};
            parvar.rect = {'epxx','epyy','epzz','x','xspan','y','yspan','theta'};
            parvar.circ = {'epxx','epyy','epzz','x','y','fx','fy','radius'};
            parvar.poly1 = {'epxx','epyy','epzz','x','y','radius','N'};
            parvar.poly2 = {'epxx','epyy','epzz'};

            exist_parvar = false;

            %-- layer
            parvar1 = parvar.layer;
            for i=1:numel(parvar1)
                nvar = numel(o.(parvar1{i}));
                if nvar==pardim
                    exist_parvar = true;
                    break
                elseif nvar~=pardim && nvar~=1
                    error('fmm/multiptc : check dimension of <%s/%s>','layer',parvar1{i})
                end
            end

            %-- particles
            for ip=1:o.numptc
                parvar1 = parvar.(o.ptc{ip});
                for i=1:numel(parvar1)
                    nvar = numel(o.param{ip}.(parvar1{i}));
                    if nvar==pardim
                        exist_parvar = true;
                        break
                    elseif nvar~=pardim && nvar~=1
                        error('fmm/multiptc : check dimension of <%s/%s>',o.ptc{ip},parvar1{i})
                    end
                end
            end
            
            %== if parvar doesn't exist ==%
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
            
            %== copy class ==%
            c = cell(1,pardim);
            for i=1:pardim
                c{i} = copy(o);
            end

            %-- copy layer parameters
            parvar1 = parvar.layer;
            for i=1:numel(parvar1)
                nvar = numel(o.(parvar1{i}));
                if nvar==pardim
                    tmpval = o.(parvar1{i})(:);
                    for j=1:pardim
                        c{j}.(parvar1{i}) = tmpval(j);
                    end
                elseif nvar~=pardim && nvar~=1
                    error('fmm/multiptc : check dimension of <%s/%s>','layer',parvar1{i})
                end
            end


            %-- copy particle parameters
            for ip=1:o.numptc
                parvar1 = parvar.(o.ptc{ip});
                for i=1:numel(parvar1)
                    nvar = numel(o.param{ip}.(parvar1{i}));
                    if nvar==pardim
                        tmpval = o.param{ip}.(parvar1{i})(:);
                        for j=1:pardim
                            c{j}.param{ip}.(parvar1{i}) = tmpval(j);
                        end
                    elseif nvar~=pardim && nvar~=1
                        error('fmm/multiptc : check dimension of <%s/%s>',o.ptc{ip},parvar1{i})
                    end
                end
            end

            %== generate bitmap images ==%
            for i=1:pardim
                c{i}.bitmap(p{i});
            end


        end
    end
end


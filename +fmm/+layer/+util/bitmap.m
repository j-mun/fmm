%fmm.util.bitmap | return bitmap image of particles
%
%>> s = bitmap(type,x_,y_,...);
%
%==========================================
% type      options
% rect      {xspan,x0,yspan,y0,theta}
% circ      {radius,x0,y0,fx,fy,theta}
% poly1     {radius,N,x0,y0,theta}
% poly2     {xv,yv}
%==========================================


function [s] = bitmap(type,x_,y_,varargin) % nG,a


%** grid
% dx = a(1)/nG(1);
% dy = a(2)/nG(2);
% [x_,y_] = ndgrid(0:dx:a(1)-dx,0:dy:a(2)-dy);

%** image
% s = zeros(nG(1),nG(2));
s = zeros(size(x_));
switch type
    %----------------------------------------------------------------------
    case {'rect'}
        xspan = varargin{1};
        x0 = varargin{2};
        yspan = varargin{3};
        y0 = varargin{4};
        if numel(varargin)<5; theta = 0;
        else; theta = varargin{5}; end
        if theta~=0 % if theta~=0, rotate the system
            R = [cosd(-theta),-sind(-theta);
                sind(-theta),cosd(-theta)];
            xy2 = R*[x_(:)'-x0;y_(:)'-y0];
            x_ = reshape(xy2(1,:),size(x_))+x0;
            y_ = reshape(xy2(2,:),size(x_))+y0;
        end
        if ~isfinite(y0) || ~isfinite(yspan) || yspan==0
            s(abs(x_-x0)<=xspan/2) = 1;
        else
            s(abs(x_-x0)<=xspan/2 & abs(y_-y0)<=yspan/2) = 1;
        end
    %----------------------------------------------------------------------
    case {'circ'}
        radius = varargin{1};
        x0 = varargin{2};
        y0 = varargin{3};
        if numel(varargin)<4; fx = 1;
        else; fx = varargin{4}; end
        if numel(varargin)<5; fy = 1;
        else; fy = varargin{5}; end
        if numel(varargin)<6; theta = 0;
        else; theta = varargin{6}; end
        if theta~=0 % if theta~=0, rotate the system
            R = [cosd(-theta),-sind(-theta);
                sind(-theta),cosd(-theta)];
            xy2 = R*[x_(:)'-x0;y_(:)'-y0];
            x_ = reshape(xy2(1,:),size(x_))+x0;
            y_ = reshape(xy2(2,:),size(x_))+y0;
        end
        r = sqrt((x_-x0).^2/fx^2+(y_-y0).^2/fy^2);
        s(r<=radius) = 1;
    %----------------------------------------------------------------------
    case {'poly1'}
        radius = varargin{1};
        N = varargin{2};
        x0 = varargin{3};
        y0 = varargin{4};
        if numel(varargin)<5; theta = 0;
        else; theta = varargin{5}; end
        if theta~=0 % if theta~=0, rotate the system
            R = [cosd(-theta),-sind(-theta);
                sind(-theta),cosd(-theta)];
            xy2 = R*[x_(:)'-x0;y_(:)'-y0];
            x_ = reshape(xy2(1,:),size(x_))+x0;
            y_ = reshape(xy2(2,:),size(x_))+y0;
        end
        s1 = linspace(0,2*pi,N+1);
        vx = radius*cos(s1)+x0;
        vy = radius*sin(s1)+y0;
        in = inpolygon(x_,y_,vx,vy);
        s(in) = 1;
    %----------------------------------------------------------------------
    case {'poly2'}
        vx = varargin{1};
        vy = varargin{2};
        in = inpolygon(x_,y_,vx,vy);
        s(in) = 1;
end

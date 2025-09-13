%fmm.visualize
%
% visualize simple image
%>> fmm.visualize('simple')
%
% visualize index
%>> fmm.visualize('index')
%
% visualize fft-image
%>> fmm.visualize('fft')


function visualize(o,option,plane)

%**
if nargin<2
    option = 'simple';
end
if nargin<3
    plane = 'xy';
end

%**
if o.opt.parallel
    disp('  * fmm/visualize : <parallel=true> detected! visualize only <paridx=1>...')
    o2 = fmm;
    if numel(o.param)==1
        o2.param = o.param;
    else
        o2.param = o.param{1};
    end
    o2.layer = o.layer(:,1);
    o2.visualize(option)
    return
end

%**
o.initialize


%==========================================================================
if strcmp(plane,'xy') && strcmp(option,'simple')
    ax = o.param.ax;
    ay = o.param.ay;
    if ~isfinite(ax) && ~isfinite(ay)
        ax = 1;
        ay = 1;
    elseif ~isfinite(ay)
        ay = ax;
    elseif ~isfinite(ax)
        ax = ay;
    end
    x = [0 ax];
    y = [0 ay];

    for p=1:o.param.NL
        figure
        set(gcf,'Name',sprintf('fmm: layer %d',p),'NumberTitle','off')
        imagesc(x,y,real(o.layer{p}.image).')
        axis tight equal
        set(gcf,'units','centimeters','position',[5 5 8 6])
        set(gca,'XTick',[],'YTick',[],'YDir','normal')
        %     colorbar('Ticks',[0 1])
        colormap([1 1 1; 0 0 0])
        clim([0 1])
    end
    %==========================================================================
elseif  strcmp(plane,'xy') && strcmp(option,'index')
    ax = o.param.ax;
    ay = o.param.ay;
    if ~isfinite(ax) && ~isfinite(ay)
        ax = 1;
        ay = 1;
    elseif ~isfinite(ay)
        ay = ax;
    elseif ~isfinite(ax)
        ax = ay;
    end
    x = [0 ax];
    y = [0 ay];

    for p=1:o.param.NL
        figure
        set(gcf,'Name',sprintf('fmm: layer %d',p),'NumberTitle','off')
        imagesc(x,y,real(sqrt(o.layer{p}.epzz)).')
        axis tight equal
        set(gcf,'units','centimeters','position',[5 5 8 6])
        set(gca,'XTick',[],'YTick',[],'YDir','normal')
        colorbar
        colormap(jet)
%         caxis([0 1])
    end


    %==========================================================================
elseif  strcmp(plane,'xy') && strcmp(option,'fft')
    for p=1:o.param.NL
        o.layer{p}.fft([o.param.nx o.param.ny]);
    end
    ax = o.param.ax;
    ay = o.param.ay;
    %     nG = [o.param.nx o.param.ny]*o.opt.res;
    nGx = 1e2;
    nGy = 1e2+1;
    if ~isfinite(ax) && ~isfinite(ay)
        ax = 1;
        ay = 1;
    elseif ~isfinite(ay)
        ay = ax;
        nGy = 1;
    elseif ~isfinite(ax)
        ax = ay;
    end
    x = [0 ax];
    y = [0 ay];

    for p=1:o.param.NL
        ep = fmm.layer.util.ifft(o.layer{p}.epmnzz,[nGx nGy]);
        nn = sqrt(ep);

        figure
        set(gcf,'Name',sprintf('fmm: layer %d',p),'NumberTitle','off')
        imagesc(x,y,real(nn)')
        axis tight equal
        set(gcf,'units','centimeters','position',[5 5 8 6])
        set(gca,'XTick',[],'YTick',[],'YDir','normal')
        colorbar
        colormap(hsv)
    end
end
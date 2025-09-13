%fmm.layer.util.grid | generates grid coordinates
%

function [x_,y_] = grid(nG,a)

dx = a(1)/nG(1);
dy = a(2)/nG(2);
[x_,y_] = ndgrid(0:dx:a(1)-dx,0:dy:a(2)-dy);

if nG(2)==1
    y_(:) = 0;
end
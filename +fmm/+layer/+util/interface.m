%fmm.layer.util.interface | returns layer interface information

function [zmin,zmax] = interface(d)

nL = numel(d);
if nL>0
    zmax = cumsum(d); %
    zmin = zmax-d; %
else
    zmax = 0;
    zmin = 0;
end

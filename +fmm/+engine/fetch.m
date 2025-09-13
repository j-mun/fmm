%fmm.engine.fetch |
%
%>> T = c.fetch('Ttotal');




function [outval] = fetch(o,outvar,idx)

if nargin<3
    outval = cellfun(@(x)x.(outvar),o.out);
    return
end

if numel(idx)==1
    outval = cellfun(@(x)x.(outvar)(idx),o.out);
elseif numel(idx)==2
    outval = cellfun(@(x)x.(outvar)(idx(1),idx(2)),o.out);
end





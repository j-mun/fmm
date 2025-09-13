%fmm.layer.util.index
%
%
%
% z_ :
% zi :
% i_ :



function [i_] = index(z_,zi)

Nz = numel(z_);
Ns = numel(zi)+1;

i_ = ones(Nz,1);
for i=1:Ns
    if i==Ns
        i_(zi(Ns-1)<=z_) = Ns;
    elseif i>1
        i_(zi(i-1)<=z_ & z_<zi(i)) = i;
    end
end


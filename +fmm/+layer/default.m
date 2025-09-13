% ## the superclass for fmm/layer/*

classdef (Abstract) default < handle & matlab.mixin.Copyable
    
    properties
        thick       % layer thickness [m]
        nvm = false % 
        nvres = -1

        mode = 1    % polarization mode {1: general, 2: te, 3: tm}
        res = 16    % bitmap resolution
        image = []  % [Nx x Ny]
        model = 1   % material model
                    % 1: simple dielectric
                    % 2: anisotropic, nonmagnetic
                    % 3: anisotropic, magnetic

    end
    
    % Fourier coefficients of material properties
    properties
        epmnxx
        epmnyy
        epmnzz
        mumnxx
        mumnyy
        mumnzz
        iepmnxx
        iepmnyy
        iepmnzz
        imumnxx
        imumnyy
        imumnzz
    end
    
    methods (Abstract)
        [] = set(o,varargin)
        [c] = init(o,p)
        [] = fft(o,n,a)
        [] = ifft(o,n,a)
        [] = normvec(o,n,b,nG)
        [V,W,D] = eig(o,Kx,Ky,i_conv)
    end
    
    methods
        function [c] = init_default(o,p,parvar)
            pardim = numel(p);

            %== non-sweep case ==%
            if pardim==1
                o.bitmap(p);
                c = o;
                return
            end

            %== check if sweep variable exists ==%
            exist_parvar = false;
            for i=1:numel(parvar)
                nvar = numel(o.(parvar{i}));
                if nvar==pardim
                    exist_parvar = true;
                    break
                elseif nvar~=pardim && nvar~=1
                    error('fmm::layer::check dimension of %s',parvar{i})
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

            %-- copy parvar
            for i=1:numel(parvar)
                nvar = numel(o.(parvar{i}));
                if nvar==pardim
                    tmpval = o.(parvar{i})(:);
                    for j=1:pardim
                        c{j}.(parvar{i}) = tmpval(j);
                    end
                elseif nvar~=pardim && nvar~=1
                    error('fmm::circ::check dimension of %s',parvar{i})
                end
            end

            %== generate bitmap images ==%
            for i=1:pardim
                c{i}.bitmap(p{i});
            end
        end
    end
end


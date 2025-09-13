%fmm.layer.shape | the superclass for isotropic structured layers
%
%subclass: {circ,custom,pixel,poly1,poly2,rect,multiptc}
%
%


classdef (Abstract) shape < fmm.layer.default
    
    properties
        epxx    % [Nx x Ny x Nf]
        epyy
        epzz
        nvx % normal vector
        nvy % 
        nvmnxx
        nvmnxy
        nvmnyy
    end
    
    methods
        function o = shape(varargin)
        end
        
        function [] = fft(o,n)
            o.epmnzz = fmm.layer.util.fft(o.epzz,n);
            if o.model==2
                o.epmnyy = fmm.layer.util.fft(o.epyy,n);
                o.epmnxx = fmm.layer.util.fft(o.epxx,n);
            end
        end
        
        function [] = ifft(o,n)
            if ~o.nvm; return; end
            o.iepmnzz = fmm.layer.util.fft(1./o.epzz,n);
            if o.model==2
                o.iepmnyy = fmm.layer.util.fft(1./o.epyy,n);
                o.iepmnxx = fmm.layer.util.fft(1./o.epxx,n);
            end
        end
        
        function [] = normvec(o,n,b,nG)
            if ~o.nvm; return; end

            if o.nvres==-1
                nvres = n;
            elseif isscalar(o.nvres)
                nvres = o.nvres*[1 1];
            else
                nvres = o.nvres;
            end
            [o.nvx,o.nvy] = fmm.layer.util.normvec(o.image,nvres,b); % ,nG
            o.nvmnxx = fmm.layer.util.fft(o.nvx.^2,n);
            o.nvmnyy = fmm.layer.util.fft(o.nvy.^2,n);
            o.nvmnxy = fmm.layer.util.fft(o.nvx.*o.nvy,n);
        end
        
        function [V,W,D] = eig(o,Kx,Ky,i_conv)


            if o.model==2 && o.nvm==1
                Exx = o.epmnxx(i_conv); % convoluted [[ep]]
                Eyy = o.epmnyy(i_conv);
                Ezz = o.epmnzz(i_conv);
                recExx = o.iepmnxx(i_conv);
                recEyy = o.iepmnyy(i_conv);
                Nxx = o.nvmnxx(i_conv);
                Nxy = o.nvmnxy(i_conv);
                Nyy = o.nvmnyy(i_conv);
                [V,W,D] = fmm.eig.xshape_nvm1(Exx,Eyy,Ezz,recExx,recEyy, ...
                    Kx,Ky,Nxx,Nyy,Nxy);
                return
                
            elseif o.model==2 % anisotropic, nonmagnetic
                Exx = o.epmnxx(i_conv); % convoluted [[ep]]
                Eyy = o.epmnyy(i_conv);
                Ezz = o.epmnzz(i_conv);
                [V,W,D] = fmm.eig.xshape(Exx,Eyy,Ezz,Kx,Ky);
                return
            end

            %** convoluted matrix [[eps]]
            E = o.epmnzz(i_conv);
            usenvm = any(o.nvm);
            if usenvm
                recE = o.iepmnzz(i_conv);
            end
            
            %//
            if usenvm && o.mode==1 && o.nvm==1 % nvm1
                Nxx = o.nvmnxx(i_conv);
                Nxy = o.nvmnxy(i_conv);
                Nyy = o.nvmnyy(i_conv);
                [V,W,D] = ...
                    fmm.eig.shape_nvm1(...
                    E,recE,Kx,Ky,Nxx,Nyy,Nxy);
            elseif usenvm && o.mode==1 && o.nvm==2 % nvm2
                Nxx = o.nvmnxx(i_conv);
                Nxy = o.nvmnxy(i_conv);
                Nyy = o.nvmnyy(i_conv);
                [V,W,D] = ...
                    fmm.eig.shape_nvm2(...
                    E,recE,Kx,Ky,Nxx,Nyy,Nxy);
            elseif usenvm && o.mode==3 % nvm, TM
                [V,W,D] = ...
                    fmm.eig.shape_tm_nv(...
                    E,recE,Kx);
            elseif o.mode==1
                [V,W,D] = ...
                    fmm.eig.shape(...
                    E,Kx,Ky);
            elseif o.mode==2
                [V,W,D] = ...
                    fmm.eig.shape_te(...
                    E,Kx);
            elseif o.mode==3
                [V,W,D] = ...
                    fmm.eig.shape_tm(...
                    E,Kx);
            end
        end

        
    end
end
function surf = detrending(x,y,pha,mask,degree)
%   detrending(x,y,pha,mask,degree)
%       [x]         : x coordinates (vector)
%       [y]         : y coordinates (vector)
%       [pha]       : observations (already masked) (vector)
%       [mask]      : mask vector
%       [degree]    : degree of order (1 to 6)
%
%       Fonction to detrend a matrix using 1-6-order polynomial surface
%   
%       Script from EZ-InSAR toolbox: https://github.com/alexisInSAR/EZ-InSAR
%
%   -------------------------------------------------------
%   Alexis Hrysiewicz, UCD / iCRAG
%   Version: 1.0.0 Beta
%   Date: 06/07/2022
%
%   -------------------------------------------------------
%   Version history:
%           1.0.0 Beta: Initial (unreleased)

x_coul = x;
y_coul = y;

x_coul_temp = x_coul;
x_coul = (x_coul - mean(x_coul))./(max(x_coul) - min(x_coul));
y_coul_temp = y_coul;
y_coul = (y_coul - mean(y_coul))./(max(y_coul) - min(y_coul));
%fprintf('\t\tNormalization of X data: OK.\n');

%Building of X matrix
if degree == 1
    A = [ones(size(x_coul(mask==0))) x_coul(mask==0) y_coul(mask==0)];
    %fprintf('\t\tInversion of degree %d: in progress.\n',degree);
elseif degree == 2
    A = [ones(size(x_coul(mask==0))) x_coul(mask==0) y_coul(mask==0) ...
        x_coul(mask==0).^2 x_coul(mask==0).*y_coul(mask==0) y_coul(mask==0).^2];
    %fprintf('\t\tInversion of degree %d: in progress.\n',degree);
elseif degree == 3
    A = [ones(size(x_coul(mask==0))) x_coul(mask==0) y_coul(mask==0) ...
        x_coul(mask==0).^2 x_coul(mask==0).*y_coul(mask==0) y_coul(mask==0).^2 ...
        x_coul(mask==0).^3 (x_coul(mask==0).^2).*y_coul(mask==0) x_coul(mask==0).*(y_coul(mask==0).^2) y_coul(mask==0).^3];
    %fprintf('\t\tInversion of degree %d: in progress.\n',degree);
elseif degree == 4
    A = [ones(size(x_coul(mask==0))) x_coul(mask==0) y_coul(mask==0) ...
        x_coul(mask==0).^2 x_coul(mask==0).*y_coul(mask==0) y_coul(mask==0).^2 ...
        x_coul(mask==0).^3 (x_coul(mask==0).^2).*y_coul(mask==0) x_coul(mask==0).*(y_coul(mask==0).^2) y_coul(mask==0).^3 ...
        x_coul(mask==0).^4 (x_coul(mask==0).^3).*y_coul(mask==0) (x_coul(mask==0).^2).*y_coul(mask==0).^2 (x_coul(mask==0)).*y_coul(mask==0).^3 y_coul(mask==0).^4];
    %fprintf('\t\tInversion of degree %d: in progress.\n',degree);
elseif degree == 5
    A = [ones(size(x_coul(mask==0))) x_coul(mask==0) y_coul(mask==0) ...
        x_coul(mask==0).^2 x_coul(mask==0).*y_coul(mask==0) y_coul(mask==0).^2 ...
        x_coul(mask==0).^3 (x_coul(mask==0).^2).*y_coul(mask==0) x_coul(mask==0).*(y_coul(mask==0).^2) y_coul(mask==0).^3 ...
        x_coul(mask==0).^4 (x_coul(mask==0).^3).*y_coul(mask==0) (x_coul(mask==0).^2).*y_coul(mask==0).^2 (x_coul(mask==0)).*y_coul(mask==0).^3 y_coul(mask==0).^4 ...
        x_coul(mask==0).^5 (x_coul(mask==0).^4).*y_coul(mask==0) (x_coul(mask==0).^3).*y_coul(mask==0).^2 (x_coul(mask==0).^2).*y_coul(mask==0).^3 (x_coul(mask==0)).*y_coul(mask==0).^4 y_coul(mask==0).^5];
    %fprintf('\t\tInversion of degree %d: in progress.\n',degree);
elseif degree == 6
    A = [ones(size(x_coul(mask==0))) x_coul(mask==0) y_coul(mask==0) ...
        x_coul(mask==0).^2 x_coul(mask==0).*y_coul(mask==0) y_coul(mask==0).^2 ...
        x_coul(mask==0).^3 (x_coul(mask==0).^2).*y_coul(mask==0) x_coul(mask==0).*(y_coul(mask==0).^2) y_coul(mask==0).^3 ...
        x_coul(mask==0).^4 (x_coul(mask==0).^3).*y_coul(mask==0) (x_coul(mask==0).^2).*y_coul(mask==0).^2 (x_coul(mask==0)).*y_coul(mask==0).^3 y_coul(mask==0).^4 ...
        x_coul(mask==0).^5 (x_coul(mask==0).^4).*y_coul(mask==0) (x_coul(mask==0).^3).*y_coul(mask==0).^2 (x_coul(mask==0).^2).*y_coul(mask==0).^3 (x_coul(mask==0)).*y_coul(mask==0).^4 y_coul(mask==0).^5 ...
        x_coul(mask==0).^6 (x_coul(mask==0).^5).*y_coul(mask==0) (x_coul(mask==0).^4).*y_coul(mask==0).^3 (x_coul(mask==0).^3).*y_coul(mask==0).^4 (x_coul(mask==0)).*y_coul(mask==0).^5 y_coul(mask==0).^6 (x_coul(mask==0).^3).*y_coul(mask==0).^3];
    %fprintf('\t\tInversion of degree %d: in progress.\n',degree);
end

%Inversion
[coeff] = lscov(A,pha');

%fprintf('\t\tInversion of degree %d: OK.\n',degree);

%Computation of the surface
%fprintf('\t\tComputation of the surface: in progress.\n');
if degree == 1
    Ares = [ones(size(x_coul)) x_coul y_coul];
elseif degree == 2
    Ares = [ones(size(x_coul)) x_coul y_coul ...
        x_coul.^2 x_coul.*y_coul y_coul.^2 ];
elseif degree == 3
    Ares = [ones(size(x_coul)) x_coul y_coul ...
        x_coul.^2 x_coul.*y_coul y_coul.^2 ...
        x_coul.^3 (x_coul.^2).*y_coul x_coul.*(y_coul.^2) y_coul.^3];
elseif degree == 4
    Ares = [ones(size(x_coul)) x_coul y_coul ...
        x_coul.^2 x_coul.*y_coul y_coul.^2 ...
        x_coul.^3 (x_coul.^2).*y_coul x_coul.*(y_coul.^2) y_coul.^3 ...
        x_coul.^4 (x_coul.^3).*y_coul (x_coul.^2).*y_coul.^2 (x_coul).*y_coul.^3 y_coul.^4 ];
elseif degree == 5
    Ares = [ones(size(x_coul)) x_coul y_coul ...
        x_coul.^2 x_coul.*y_coul y_coul.^2 ...
        x_coul.^3 (x_coul.^2).*y_coul x_coul.*(y_coul.^2) y_coul.^3 ...
        x_coul.^4 (x_coul.^3).*y_coul (x_coul.^2).*y_coul.^2 (x_coul).*y_coul.^3 y_coul.^4 ...
        x_coul.^5 (x_coul.^4).*y_coul (x_coul.^3).*y_coul.^2 (x_coul.^2).*y_coul.^3 (x_coul).*y_coul.^4 y_coul.^5 ];
elseif degree == 6
    Ares = [ones(size(x_coul)) x_coul y_coul ...
        x_coul.^2 x_coul.*y_coul y_coul.^2 ...
        x_coul.^3 (x_coul.^2).*y_coul x_coul.*(y_coul.^2) y_coul.^3 ...
        x_coul.^4 (x_coul.^3).*y_coul (x_coul.^2).*y_coul.^2 (x_coul).*y_coul.^3 y_coul.^4 ...
        x_coul.^5 (x_coul.^4).*y_coul (x_coul.^3).*y_coul.^2 (x_coul.^2).*y_coul.^3 (x_coul).*y_coul.^4 y_coul.^5 ...
        x_coul.^6 (x_coul.^5).*y_coul (x_coul.^4).*y_coul.^3 (x_coul.^3).*y_coul.^4 (x_coul).*y_coul.^5 y_coul.^6 (x_coul.^3).*y_coul.^3];
end

surf = Ares*coeff;
%fprintf('\t\tComputation of the surface: OK.\n');

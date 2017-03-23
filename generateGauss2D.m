function [ Z ] = generateGauss2D( a, gc, sig, spatialSpace )
%generateGauss2D Generates 2D Gauss function
%   Parameters:
%   a - amplitude of function (scalar)
%   gc - centre of function [X0, Y0]
%   sig - sigma (scalar)
%   spatialSpace - 1D vector of arguments. Function is generated symmetrically along
%   x and y axes

[X, Y] = meshgrid(spatialSpace, spatialSpace);
Z = a*exp( -( (X-gc(1)).^2+(Y-gc(2)).^2)/(2*sig^2) );


end


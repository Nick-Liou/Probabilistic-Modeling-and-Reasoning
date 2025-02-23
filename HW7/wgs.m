function [result] = wgs(x , c , w, lambda)
% wgs - Computes a weighted sum of Gaussian basis functions
%
% Syntax:
%   result = wgs(x, c, w, lambda)
%
% Description:
%   This function evaluates a weighted sum of Gaussian basis functions 
%   at the input vector `x`, where each basis function is centered at 
%   the points specified in `c` and has a width determined by `lambda`.
%   Weights for the basis functions are provided in `w`. If `w` or `lambda` 
%   are not specified, default values are used.
%
% Inputs:
%   x       (1,:) double {mustBeReal}
%       A vector of input values where the basis functions are evaluated.
%   c       (1,:) double {mustBeReal, mustBeFinite}
%       A vector of centers for the Gaussian basis functions.
%   w       (1,:) double {mustBeReal, mustBeFinite}, optional
%       A vector of weights for the basis functions. Defaults to a vector 
%       of ones with the same size as `c`.
%   lambda  (1,1) double {mustBeReal, mustBeFinite}, optional
%       A scalar determining the width of the Gaussian basis functions.
%       Defaults to sqrt(0.03).
%
% Outputs:
%   result  double
%       The computed weighted sum of Gaussian basis functions at the input 
%       points `x`.
%
% Notes:
%   - The Gaussian basis function for a center `ci` is defined as:
%       phi(x, ci) = exp(-0.5 * (x - ci')^2 / lambda^2)
%   - If the length of `w` does not match the length of `c`, an error 
%     will occur due to size mismatch.
%
% Example:
%   figure;
%   x = linspace(-5, 5, 100);
%   c = [-2, 0, 2];
%   w = [1, -1.5, 2];
%   lambda = 1;
%   result = wgs(x, c, w, lambda);
%   plot(x, result);
%
    arguments
        x       (1,:)   double  {mustBeReal}
        c       (1,:)   double  {mustBeReal,mustBeFinite}
        w       (1,:)   double  {mustBeReal,mustBeFinite} = ones(size(c))
        lambda  (1,1)   double  {mustBeReal,mustBeFinite} = sqrt(0.03)
    end    

    phi = @(x,ci) exp(-0.5*(x- ci').^2 / lambda^2 ) ;

    result = 0 ; 
    for i = 1:length(c)
        result = result + w(i) * phi(x,c(i)) ;
    end

end
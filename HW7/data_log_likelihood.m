function [log_like] = data_log_likelihood(x_samples,y_samples,phi,a,b,B)

arguments
    x_samples   (1,:)   double
    y_samples   (1,:)   double 
    phi         (1,:)   function_handle
    a           (1,1)   double
    b           (1,1)   double
    B           (1,1)   double   
end

% B = length(phi) ;
N = length(x_samples) ;

% Simple way 
% temp_Matrix = zeros(B);
% for xi = x_samples
%     temp_Matrix = temp_Matrix + phi(xi) * phi(xi)' ;
% end
% Fast way:  temp_Matrix == phi(x_samples) * phi(x_samples)'
% tolerance = 1e-10; % Define a small tolerance value
% is_equal = all(abs(temp_Matrix - phi(x_samples) * phi(x_samples)') < tolerance, 'all')


S_inverse = (a * eye(B) + b * phi(x_samples) * phi(x_samples)' );
S =  S_inverse^-1 ; 


d = b * phi(x_samples) * y_samples' ;

% m = S * d;


log_like = -b*sum(y_samples.^2) + d'*S_inverse *d  +log(det(S)) + B * log(a) + N * log(b) - N * log(2*pi) ;

end



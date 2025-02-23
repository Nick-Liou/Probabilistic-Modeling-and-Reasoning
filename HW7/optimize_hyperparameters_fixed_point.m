function [a , b] = optimize_hyperparameters_fixed_point(x_samples,y_samples,phi ,B )
% Gull-MacKay fixed point iteration
arguments
    x_samples   (1,:)   double
    y_samples   (1,:)   double 
    phi         (1,:)   function_handle
    B           (1,1)   double   
end

% Starting values
b = 1 ; 
a = 1 ;

N = length(x_samples) ;

% 100 Iterations
for i=1:100
    S_hat = 1/N * phi(x_samples) * phi(x_samples)' ;
    S_inverse = (a * eye(B) + b * phi(x_samples) * phi(x_samples)' );
    S =  S_inverse^-1 ; 
    m = b * S * phi(x_samples) * y_samples' ;
    

    a = (B - a * trace(S)) / (m'*m) ;
    b = (1 - b*trace(S*S_hat)  ) / ( 1/N * sum(( y_samples - m' * phi(x_samples)  ).^2) );
end


end
function [a , b] = optimize_hyperparameters(x_samples,y_samples,phi ,B )

arguments
    x_samples   (1,:)   double
    y_samples   (1,:)   double 
    phi         (1,:)   function_handle
    B           (1,1)   double   
end

% Starting values
b = 0.8 ; 
a = 2 ;

N = length(x_samples) ;

for i=1:100

    S_hat = 1/N * phi(x_samples) * phi(x_samples)' ;
    S_inverse = (a * eye(B) + b * phi(x_samples) * phi(x_samples)' );
    S =  S_inverse^-1 ; 
    m = b * S * phi(x_samples) * y_samples' ;
    
    inverse_b = 1/N * sum(( y_samples - m' * phi(x_samples)  ).^2) + trace(S*S_hat);
    
    inverse_a = 1/B * (trace(S) + m'*m);

    b = 1 / inverse_b ;
    a = i / inverse_a ;
end


end
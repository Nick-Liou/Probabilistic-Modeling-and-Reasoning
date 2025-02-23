
clear;
close all ;
rng(34);
% rng(1);

phi = @(x,ci,lambda) exp(-0.5*(x- ci').^2 / lambda^2 ) ;

% Number of possible basis functions  dim(w) = B
n = 15 ; 
B = n;
% Number of samples
n_sample = 30 ;
c = linspace(-2,2 , n) ; 

%% Generate random points
actual_lambda = 0.32;
x_sample = ( rand(1,n_sample)-0.5 ) * 4; % In the [-2 2] range

% Create random weights for each basis function
w = (randn(1,n)) * 5 ;
% chose which function basis we will use
w_id = rand(1,n) < 0.6 ;  
% Keep only the chosen weughts
w(~w_id) = 0 ;

n_used_w = sum(w_id) ; 

y_sample = wgs(x_sample,c, w, actual_lambda) ;

% add the AWGN
y_sample_noise = y_sample + randn(size(y_sample))/ n_used_w;



%% Find best lambda, a, b


lambda_range = 0.2:0.01:0.5 ; 
double_log_likelihood = NaN(size(lambda_range)) ;
a = NaN(size(lambda_range));
b = NaN(size(lambda_range));

for i = 1:length(lambda_range)
    lambda = lambda_range(i);

    F = @(x) cell2mat( arrayfun(@(ci) phi(x,ci,lambda) , c  ,'UniformOutput',false)');

    [a(i),b(i)] = optimize_hyperparameters_fixed_point(x_sample,y_sample_noise,F,n)  ;  
    double_log_likelihood(i) = data_log_likelihood(x_sample,y_sample_noise,F,a(i),b(i),n);

end



[~,best_lambda_id] = max(double_log_likelihood) ;

lambda_best = lambda_range(best_lambda_id);
a_best = a(best_lambda_id);
b_best = b(best_lambda_id);

% Plot lambda
figure;
scatter(lambda_range,double_log_likelihood);

xlabel("\lambda");
ylabel("Log Likelihood");
title(sprintf("Best \\lambda %.2f with optimal a: %.3f ,b: %4.2f",lambda_best , a(best_lambda_id) ,b(best_lambda_id)))



%% Plot
figure;
hold on;

a = 2.5;
x = linspace(-a, a, 10^4); 

% Plot basis functions and weighted functions
for i = 1:length(c)
    y = phi(x, c(i),actual_lambda);  

    if i == 1 
        dips_name_1 = "All Basis Functions";
        dips_name_2 = "Weighted Basis Functions Used";
        vis = "on";
    else
        dips_name_1 = "";
        dips_name_2 = "";
        vis = "off";
    end 
    

    plot(x, y, ":", 'DisplayName', dips_name_1, 'HandleVisibility',vis);
    plot(x, w(i) * y, "--",'Color',[0.5 0.5 0.5], 'DisplayName', dips_name_2, 'HandleVisibility', vis);

    
end

% Scatter points
scatter(x_sample, y_sample, 200, ".", 'MarkerEdgeColor', [0.6350 0.0780 0.1840], 'DisplayName', "Sample Points");
scatter(x_sample, y_sample_noise, "blue", "*", 'DisplayName', "Noisy Sample Points");

% Plot the main function
plot(x, wgs(x, c, w, actual_lambda),"cyan", 'DisplayName', "Final Function");

xlabel("x");
ylabel("y");

% Add legend
legend('Location', 'best');

title_string = sprintf("Number of Basis Functions used %d / %d", n_used_w , n );
title(title_string);

%% Add mean prediction and std error bars to the plot


F_phi = @(x) cell2mat( arrayfun(@(ci) phi(x,ci,lambda_best) , c  ,'UniformOutput',false)');

S_inverse = (a_best * eye(B) + b_best * F_phi(x_sample) * F_phi(x_sample)' );
S =  S_inverse^-1 ; 
m = b_best * S * F_phi(x_sample) * y_sample_noise' ;
    

mean_prediction = m' * F_phi(x) ;

plot(x, mean_prediction,"red", 'DisplayName', "Mean prediction");

var_f_fun = @(x) F_phi(x)' * S * F_phi(x) ;

var_f = arrayfun(var_f_fun , x) ;


plot(x, mean_prediction + sqrt(var_f),"--g", 'DisplayName', "std error bars");
plot(x, mean_prediction - sqrt(var_f),"--g", 'DisplayName', "std error bars",'HandleVisibility', "off");

% Plot the shaded area between the lines
fill([x, fliplr(x)], ...
     [mean_prediction + sqrt(var_f), fliplr(mean_prediction - sqrt(var_f))], ...
     'g', 'FaceAlpha', 0.1, 'EdgeColor', 'none', 'DisplayName', 'Standard error region');








clear ; 
close all ;

% Number of possible basis functions  dim(w) = B
n = 15 ; 
% Number of samples
n_sample = 30 ;

lambda = sqrt(0.03);
c = linspace(-2,2 , n) ; 
phi = @(x,ci) exp(-0.5*(x- ci').^2 / lambda^2 ) ;



%% Generate random datapoints
% Create random weights for each basis function
w = (randn(1,n)) * 5 ; 
% chose which function basis we will use
w_id = rand(1,n) < 0.5 ; 
% Keep only the chosen weughts
w(~w_id) = 0 ;

n_used_w = sum(w_id) ; 

% In the [-2 2] range
x_sample = ( rand(1,n_sample)-0.5 ) * 4;
y_sample = wgs(x_sample,c,w,lambda) ;

% add the AWGN
y_sample_noise = y_sample + randn(size(y_sample))/ n_used_w;



%% Plot
figure;
hold on;

a = 2.5;
x = linspace(-a, a, 10^4); 

% Plot basis functions and weighted functions
for i = 1:length(c)
    y = phi(x, c(i));  

    if i == 1 
        dips_name_1 = "Basis Functions";
        dips_name_2 = "Weighted Basis Functions";
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
plot(x, wgs(x, c, w, lambda),"magenta", 'DisplayName', "Actual Function");

xlabel("x");
ylabel("y");

% Add legend
legend('Location', 'best');

title_string = sprintf("Number of Basis Functions used %d / %d", n_used_w , n );
title(title_string);



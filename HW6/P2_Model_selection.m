
clear; 
close all;

% Specify the file path
filename = 'dodder.txt';

% Read the data from the file
data = readmatrix(filename);

% Display the first few rows of the data
% disp(data(1:5, :));

n = size(data,1) ; 
sigma_t = data(:,1) ; 
x = data(:,2:end-1);
y = data(:,end);

n_vars = size(x,2); 
M = 1:(2^n_vars-1) ; 

all_double_log_p = zeros(size(M));
bestK = 0 ; 
max_double_log_p = -inf;

for K = M
    % Convert integer to binary string with fixed width
    binaryString = dec2bin(K, n_vars);
    
    % Convert binary string to logical array
    K_mask = binaryString == '1';
    K_n = sum(K_mask);

    x_k = x(:,K_mask);

    A = eye(K_n) + x_k' * (x_k  ./ sigma_t.^2);
    b = sum( (y./sigma_t.^2)  .*  x_k )';
   

    double_log_p = b' * A^-1 * b -  sum(log(2*pi*sigma_t.^2)) + log(det(A^-1)) - sum((y./sigma_t).^2);
    all_double_log_p(K) = double_log_p ;

    % if double_log_p > max_double_log_p
    %     max_double_log_p = double_log_p;
    %     bestK = K;
    % end
    
end


[max_double_log_p,bestK] = max(all_double_log_p);

fprintf("Best M is \n as an integer: %d \n as string: %s \n" ,bestK, dec2bin(bestK, n_vars) );



%% Plot
Hamming_weights = arrayfun(@(K) sum(dec2bin(K, n_vars) == '1'), M);

% Create a scatter plot with colors based on the Hamming weight
figure;
scatter(M, all_double_log_p, 36, Hamming_weights, 'filled'); % '36' is the marker size
colormap(jet); % Use a colormap of your choice (e.g., 'jet', 'parula', etc.)
cbar = colorbar(); % Add a colorbar to interpret the colors
xlabel("M");
ylabel("2log(p(Y|X,M))");
title("Scatter plot colored by number of factors");
xlim([1 max(M)])
xticks(1:4:max(M))


% Customize the colorbar
cbar.Label.String = 'Number of factors'; % Add a label to the colorbar
cbar.Ticks = 1:n_vars; % Set the colorbar ticks to show only values from 1 to n_vars


%% Best setting for w (for question 1)
A =  x' * (x  ./ sigma_t.^2);
b = sum( (y./sigma_t.^2)  .*  x )';
w = A^-1 * b;






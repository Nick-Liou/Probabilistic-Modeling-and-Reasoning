
clear ;
close all; 

% Beyes factor for Coin tossing

% Evidence:
N_Heads = 20 ;
N_Tails = 50 ; 

%% Create model 1 

% Parameters of the model 
n_1 = 11;               % Number of discrete values
mu = 0.5;              % Mean of the normal distribution
sigma = 0.1;           % Standard deviation of the normal distribution

% Generate discrete indices (centered around the mean)
theta_values_1 = linspace(0, 1, n_1); % Symmetric range for the values

% Compute the normal distribution PDF at these points
pdf_1 = exp(-((theta_values_1 - mu).^2) / (2 * sigma^2));

% Normalize to ensure the probabilities sum to 1
pdf_1 = pdf_1 / sum(pdf_1);

% Plot the distribution
figure;
stem(theta_values_1, pdf_1, 'filled');
title('Prior Discrete Normal Distribution of \theta for model 1');
xlabel('\theta');
ylabel('Probability');


%% Create model 2 

% Parameters of the model
n_2 = 11;               % Number of discrete values
mu = 0.5;              % Mean of the normal distribution
sigma = 0.1;           % Standard deviation of the normal distribution

% Generate discrete indices (centered around the mean)
theta_values_2 = linspace(0, 1, n_2); % Symmetric range for the values

% Compute the normal distribution PDF at these points
pdf_2 = exp(-((theta_values_2 - mu).^2) / (2 * sigma^2));

% Normalize to ensure the probabilities sum to 1
pdf_2 = pdf_2 / sum(pdf_2);
pdf_2 = 1.05*max(pdf_2) - pdf_2 ; 
pdf_2 = pdf_2 / sum(pdf_2) ; 

figure;
stem(theta_values_2, pdf_2, 'filled');
title('Prior Discrete Normal Distribution of \theta for model 2');
xlabel('\theta');
ylabel('Probability');

%% Calculate Beyes factor

% Direct Approach (works because 0^0 = 1 in Matlab) 
p_Data_given_Model_1 = sum( theta_values_1.^N_Heads .* (1-theta_values_1).^N_Tails .* pdf_1 );
p_Data_given_Model_2 = sum( theta_values_2.^N_Heads .* (1-theta_values_2).^N_Tails .* pdf_2 );

Beyes_factor_simple = p_Data_given_Model_1 / p_Data_given_Model_2;

% Logarithmic Approach (works because 0*inf = NaN in Matlab) 

x1 = sum( [log(theta_values_1)*N_Heads ; log(1-theta_values_1)*N_Tails ; log(pdf_1)],"omitnan");
c1 = max(x1);
log_p_Data_given_Model_1 = c1 + log(sum(exp( x1 - c1 )));

x2 = sum( [log(theta_values_2)*N_Heads ; log(1-theta_values_2)*N_Tails  ; log(pdf_2)] ,"omitnan");
c2 = max(x2);
log_p_Data_given_Model_2 = c2 + log(sum(exp( x2 - c2 )));

log_ratio = log_p_Data_given_Model_1 - log_p_Data_given_Model_2;
Beyes_factor_accurate = exp(log_ratio);  % Convert back to linear scale

% Resutls

fprintf("Number of Heads: %d \nNumber of Tails: %d \n",N_Heads , N_Tails);
disp('Results:');
disp(['Bayes Factor (Direct Approach): ', num2str(Beyes_factor_simple)]);
disp(['Bayes Factor (Logarithmic Approach): ', num2str(Beyes_factor_accurate)]);
fprintf("Therefore we select model %d \n" , (Beyes_factor_accurate < 1) + 1 )











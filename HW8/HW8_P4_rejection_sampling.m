clear;
close all;

% Parameters
sigma2 = 25;  % Variance of the proposal distribution
sigma = sqrt(sigma2);
M = exp(1 + pi^2 / (2 * sigma2)) * sqrt(2 * pi * sigma2);  % Compute M

% Define p*(x) and q(x)
p_star = @(x) exp(sin(x));  % Unnormalized target distribution
q = @(x) (1 / sqrt(2 * pi * sigma2)) * exp(-x.^2 / (2 * sigma2));  % Proposal distribution

% Rejection Sampling
N = 10000;  % Number of desired samples
samples = zeros(N, 1);
count = 0;

while count < N
    x = normrnd(0, sigma);  % Sample from q(x)
    if x >= -pi && x <= pi  % Ensure sample is within [-pi, pi]
        u = rand();  % Uniform random number
        if u <= (p_star(x) / (M * q(x)))  % Acceptance condition
            count = count + 1;
            samples(count) = x;
        end
    end
end

% Define the true normalized p(x) for plotting
normalizing_constant = integral(@(x) p_star(x), -pi, pi);  % Compute normalizing constant
p_normalized = @(x) p_star(x) / normalizing_constant;

% Plot the histogram of samples
figure;
histogram(samples, 50, 'Normalization', 'pdf');  % Histogram of samples
hold on;

% Plot the true normalized distribution
x_range = linspace(-pi, pi, 1000);
plot(x_range, p_normalized(x_range), 'r', 'LineWidth', 2);  % True p(x)
legend('Histogram of Samples', 'True Distribution',Location='best');
xlabel('x');
ylabel('Density');
title('Rejection Sampling of p(x)');
grid on;

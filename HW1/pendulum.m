function [] = pendulum(theta, variance, N)
% PENDULUM: Simulates noisy pendulum observations and computes posterior
% distribution based on Bayesian inference.
%
% INPUTS:
%   theta    - (Optional) 5 possible values for the parameter θ (default = [-1, -0.5, 0, 0.5, 1])
%   variance - (Optional) Variance (σ^2) for the noise added to the observations (default = 0.5)
%   N        - (Optional) Number of noisy observations to generate (default = 50)
%
% OUTPUT:
%   The function outputs three plots:
%   (a) Noisy observations of the pendulum's displacement over time.
%   (b) Prior belief on the 5 possible values of θ.
%   (c) Posterior belief on the 5 possible values of θ after observing the noisy data.
%   It also prints the posterior distribution as a row of 5 numbers.

    % Default input values if not specified
    arguments
        theta       (5,1) {}                             = [-1 -0.5 0 0.5 1]    % Default θ values
        variance    (1,1) {mustBeNonnegative}            = 0.5                  % Default noise variance
        N           (1,1) {mustBePositive, mustBeInteger}= 50                   % Default number of observations
    end

    % Randomly select the true value of θ from the list of 5 possible values
    real_theta = theta(randi(5));

    % Generate N time points
    t = 1:N;

    % Simulate noisy observations of pendulum displacement
    % x(t) = sin(θ * t) + Gaussian noise with mean 0 and variance σ^2
    x = sin(real_theta * t) + normrnd(0, sqrt(variance), size(t));
    figure;


    % (a) Plot the noisy observations of the pendulum
    
    % First subplot (3 rows, 1 column, first plot)
    subplot(3, 1, 1); % 3 rows, 1 column, first plot
    plot(t, x);
    title('Noisy Pendulum Observations');
    xlabel('Time');
    ylabel('Displacement');
    legend('Noisy displacement', Location='best');
    grid on;

    % (b) Plot the prior belief on the 5 possible values of θ
    
    % Second subplot (3 rows, 1 column, second plot)
    subplot(3, 1, 2); % 3 rows, 1 column, second plot
    bar(theta, repmat(1/5, 1, 5)); % Uniform prior (p(θ) = 1/5 for all θ)
    title('Prior Distribution of \theta');
    xlabel('\theta values');
    ylabel('Probability');
    ylim([0 0.3]); % Set y-axis limits for better visualization

    % Calculate the posterior distribution p(θ | x) using the noisy observations
    % Posterior p(θ | x) ∝ p(x | θ) * p(θ)
    % Likelihood: p(x | θ) ∝ exp(-(x - sin(θ * t))^2 / (2 * σ^2))
    post_dist = (1/5) * prod(1/sqrt(2*pi*variance) * exp(-(x - sin(theta * t)).^2 / (2 * variance)), 2);

    % Normalize the posterior distribution to ensure it sums to 1
    post_dist = post_dist / sum(post_dist);

    % (c) Plot the posterior distribution of θ
    
    % Third subplot (3 rows, 1 column, third plot)
    subplot(3, 1, 3); % 3 rows, 1 column, third plot
    bar(theta, post_dist); % Posterior belief
    title('Posterior Distribution of \theta');
    xlabel('\theta values');
    ylabel('Probability');
    ylim([0 max(post_dist) * 1.1]); % Adjust y-axis limits for visibility
    xline(real_theta, '--r', 'LineWidth', 2); % Mark the true θ value with a red dashed line
    legend('Posterior', 'True \theta', Location='best');
    

    % Print the posterior distribution as 5 numbers in a single row
    disp('Posterior distribution of theta:');
    disp(post_dist');
end

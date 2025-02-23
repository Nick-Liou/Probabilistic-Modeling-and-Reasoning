function [] = EM(starting_theta,starting_q_2)
% EM Function Documentation
%
% Description:
% This function implements the Expectation-Maximization (EM) algorithm for 
% a specified probabilistic model. The algorithm iteratively updates two 
% parameters: θ (theta) and q(h=2). The function visualizes the log-likelihood, 
% parameter trajectories, and a contour plot of the lower bound (LB) objective.
%
% Syntax:
% [] = EM(starting_theta, starting_q_2)
%
% Inputs:
% - starting_theta : Initial value of θ (theta). 
%                    Must be a scalar real number.
% - starting_q_2   : Initial value of q(h=2). 
%                    Must be a scalar in the range (0, 1).
%
% Outputs:
% - None (generates 3 plots for visualization).
%
% Functionality:
% 1. **Model Definition**:
%    - Defines a probabilistic model with given parameters (h1, h2, p(h1), p(h2)).
%    - Computes likelihoods using the provided equations.
%
% 2. **Log-Likelihood Plot**:
%    - Visualizes log(p(u|θ)) for a range of θ values.
%
% 3. **Run 1: Using starting_theta**:
%    - Initializes θ with starting_theta.
%    - Iteratively updates q(h=2) and θ for 100 iterations.
%    - Visualizes the trajectory of parameter updates.
%
% 4. **Run 2: Using starting_q_2**:
%    - Initializes q(h=2) with starting_q_2.
%    - Iteratively updates θ and q(h=2) for 100 iterations.
%    - Visualizes the trajectory of parameter updates.
%
% 5. **Contour Plot of LB**:
%    - Evaluates the lower bound (LB) on a grid of θ and q(h=2) values.
%    - Plots contours of the LB along with parameter update trajectories.
%
% Visualization:
% - Three figures are created:
%   1. Log-likelihood as a function of θ.
%   2. Trajectories of θ and q(h=2) for Run 1.
%   3. Trajectories of θ and q(h=2) for Run 2.
% - Each plot is normalized and arranged for side-by-side comparison.
%
% Notes:
% - Ensure that starting_q_2 lies strictly between 0 and 1 to avoid numerical issues.
% - The function does not return any outputs; its primary purpose is visualization.
%
% Example:
% % Run EM algorithm with initial parameters:
% EM(1.9,0.2);
%
% Dependencies:
% - None


arguments
    starting_theta (1,1)    {mustBeReal}
    starting_q_2 (1,1)      {mustBeInRange(starting_q_2,0,1)}
end

% Number of figures to create
num_figures = 3;

fig_height = 0.45; % Height of the figure
fig_width = 0.3;  % Width of the figure
fig_width_spacing = 0.01; % Horizontal spacing between figures
fig_y = 0.3; % Y-position of the figures

fig_margins = (1 - num_figures*(fig_width+fig_width_spacing)-fig_width_spacing ) / 2 ; % Left margin

    
% Data
u = 2.75 ; 
h1 = 1; 
h2 = 2;

p_h1 = 0.5;
p_h2 = 0.5;


% p(u|h,theta) 
p_visible = @(u,theta,h) 1/sqrt(pi) * exp(-(u-theta*h)^2) ; 

% p(u|theta)
p_visible_only = @(u,theta)  p_visible(u,theta,h1)*p_h1 + p_visible(u,theta,h2)*p_h2 ;


new_theta = @(q2) u * ( (1-q2)*h1 + q2*h2 ) / ( (1-q2)*h1^2 + q2*h2^2 );

new_q_2 = @(theta) p_visible(u,2,theta) * p_h2 / p_visible_only(u,theta) ;

LB = @(q2 , theta)  -(1-q2)*log(1-q2) - q2*log(q2) - ( (1-q2)*(u-h1*theta)^2 + (q2)*(u-h2*theta)^2 );

% Values for the plots
theta_scan = linspace(1, 3, 100);
q2_scan = linspace(0.00001, 0.99999, 100); % q2 values strictly within (0, 1)

% Create a grid of x and y values
[X, Y] = meshgrid(theta_scan, q2_scan);

% Evaluate LB on the grid using arrayfun
Z = arrayfun(@(theta ,q2 ) LB(q2, theta), X, Y);

    
% Create the figure
fig_x = fig_margins + 0 * (fig_width + fig_width_spacing);
figure("Units", "normalized", "Position", [fig_x, fig_y, fig_width, fig_height]);

plot(theta_scan, arrayfun(@(x) log(p_visible_only(u,x)), theta_scan)); 
xlabel("\theta");
ylabel('log(p(u|\theta)');
title("The log likelihood for the model")
legend('log(p(u|\theta)')

%% Run 1 using starting_theta


current_theta = starting_theta;
current_q_2 = new_q_2(current_theta);

% EM algorithm 
for i = 2:100
    % fprintf("\nIteration %d" , i )
    current_q_2(i) = new_q_2(current_theta(i-1));
    current_theta(i) = new_theta(current_q_2(i));

end

% Double each element to make the plot match 
theta_hist = repelem(current_theta, 2);
theta_hist = theta_hist(2:end);
q2_hist = repelem(current_q_2, 2);
q2_hist = q2_hist(1:end-1);


% Create the figure
fig_x = fig_margins + 1 * (fig_width + fig_width_spacing);
figure("Units", "normalized", "Position", [fig_x, fig_y, fig_width, fig_height]);
% scatter(current_theta,current_q_2)
hold on; 
% plot(current_theta,current_q_2)
hold on; 
plot(theta_hist,q2_hist)
hold on; 
scatter(theta_hist,q2_hist,"x","MarkerEdgeColor","blue")

xlim([1 3])
ylim([0 1])
 
% Plot the contours
contour(X, Y, Z, 200); % specifies the number of contour levels
% colorbar; % Add a colorbar to show the scale


% Adjust colormap and colorbar to a logarithmic scale
colormap('jet'); % Set the colormap
cb = colorbar; % Add colorbar
% set(gca, 'ColorScale', 'log'); % Change the color scale to logarithmic

% Update color limits to ensure they fit the data range
clim([min(Z(:)) max(Z(:))]); 
xlabel("\theta");
ylabel('q(h=2)');
title('Contour Plot of $$ \tilde{L}(\theta,q(h=2))$$',Interpreter='latex');
ylim([0 1])

hold on ; 
plot_1 = plot(theta_scan,arrayfun( new_q_2,theta_scan));
legend(plot_1,"starting q2 given \theta");

fprintf("Starting with theta = %f \n" , starting_theta );
fprintf("It converged to theta = %f and q(h=2) = %f \n\n" , current_theta(end),current_q_2(end) );


%% Run 2 using starting_q_2

current_theta = new_theta(starting_q_2);
current_q_2 = starting_q_2;

% EM algorithm 
for i = 2:100
    % fprintf("\nIteration %d" , i )
    current_q_2(i) = new_q_2(current_theta(i-1));
    current_theta(i) = new_theta(current_q_2(i));

end

% Double each element to make the plot match 
theta_hist = repelem(current_theta, 2);
theta_hist = theta_hist(2:end);
q2_hist = repelem(current_q_2, 2);
q2_hist = q2_hist(1:end-1);


% Create the figure
fig_x = fig_margins + 2 * (fig_width + fig_width_spacing);
figure("Units", "normalized", "Position", [fig_x, fig_y, fig_width, fig_height]);
% scatter(current_theta,current_q_2)
hold on; 
% plot(current_theta,current_q_2)
hold on; 
plot(theta_hist,q2_hist)
hold on; 
scatter(theta_hist,q2_hist,"x","MarkerEdgeColor","blue")

xlim([1 3])
ylim([0 1])
 

% Plot the contours
contour(X, Y, Z, 200); % specifies the number of contour levels
% colorbar; % Add a colorbar to show the scale


% Adjust colormap and colorbar to a logarithmic scale
colormap('jet'); % Set the colormap
cb = colorbar; % Add colorbar
% set(gca, 'ColorScale', 'log'); % Change the color scale to logarithmic

% Update color limits to ensure they fit the data range
clim([min(Z(:)) max(Z(:))]); 
xlabel("\theta");
ylabel('q(h=2)');
title('Contour Plot of $$ \tilde{L}(\theta,q(h=2))$$',Interpreter='latex');
ylim([0 1])

hold on ; 
plot_2 = plot(arrayfun( new_theta,q2_scan),q2_scan);
legend(plot_2, "Starting \theta given q2");

fprintf("Starting with q(h=2) = %f \n" , starting_q_2 );
fprintf("It converged to theta = %f and q(h=2) = %f \n" , current_theta(end),current_q_2(end) );


end


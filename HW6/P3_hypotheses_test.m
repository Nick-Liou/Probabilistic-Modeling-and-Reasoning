% Define the prior vector and observed counts
% Initialize the prior vector u (uniform prior)
u = [1, 1, 1];

% Define the observed counts for each person
m_a = [13, 3, 4]; % Counts for Person 1
m_b = [4, 9, 7];  % Counts for Person 2
m_c = [8, 8, 4];  % Counts for Person 3

%% Original Approach (Using gamma directly)

% Define the Z(u) function using the gamma function
Z_direct = @(u) prod(arrayfun(@gamma, u)) / gamma(sum(u));

% Compute Z(u) and Z(u + m) for different configurations
Z_u_direct = Z_direct(u);                  % Z(u)
Z_u_m_a_direct = Z_direct(u + m_a);        % Z(u + m_a)
Z_u_m_b_direct = Z_direct(u + m_b);        % Z(u + m_b)
Z_u_m_c_direct = Z_direct(u + m_c);        % Z(u + m_c)
Z_u_m_total_direct = Z_direct(u + m_a + m_b + m_c); % Z(u + m_a + m_b + m_c)

% Compute the Bayes factor using the direct gamma approach
bayes_factor_direct = (Z_u_m_a_direct * Z_u_m_b_direct * Z_u_m_c_direct) / ...
                      (Z_u_m_total_direct * Z_u_direct * Z_u_direct);

%% Optimized Approach (Using gammaln for numerical stability)

% Define the Z(u) function in the logarithmic domain
logZ = @(u) sum(gammaln(u)) - gammaln(sum(u)); % Logarithmic computation of Z(u)

% Compute log Z(u) and log Z(u + m) for different configurations
log_Z_u = logZ(u);                  % log Z(u)
log_Z_u_m_a = logZ(u + m_a);        % log Z(u + m_a)
log_Z_u_m_b = logZ(u + m_b);        % log Z(u + m_b)
log_Z_u_m_c = logZ(u + m_c);        % log Z(u + m_c)
log_Z_u_m_total = logZ(u + m_a + m_b + m_c); % log Z(u + m_a + m_b + m_c)

% Compute the Bayes factor in the logarithmic domain
log_bayes_factor = log_Z_u_m_a + log_Z_u_m_b + log_Z_u_m_c - ...
                   (log_Z_u_m_total + 2 * log_Z_u);

% Convert back to the normal domain
bayes_factor_log = exp(log_bayes_factor);

%% Compare Results

% Display the results from both approaches
disp('Results:');
disp(['Bayes Factor (Direct Approach): ', num2str(bayes_factor_direct)]);
disp(['Bayes Factor (Logarithmic Approach): ', num2str(bayes_factor_log)]);

% Check for differences between the two approaches
difference = abs(bayes_factor_direct - bayes_factor_log);
disp(['Difference Between Approaches: ', num2str(difference)]);

function samples = generate_markov_samples(P, n, L)
    % Check if the matrix P is valid
    if any(abs(sum(P, 1) - 1) > 1e-10)
        error('Each column of P must sum to 1.');
    end
    
    numStates = size(P, 1); % Number of states
    samples = cell(n, 1);   % Cell array to store sequences
    
    for i = 1:n
        sequence = zeros(1, L); % Initialize sequence
        sequence(1) = randi(numStates); % Random initial state
        
        for t = 2:L
            % Get transition probabilities for current state
            current_state = sequence(t-1);
            probabilities = P(:, current_state);
            
            % Sample next state based on transition probabilities
            sequence(t) = find(rand < cumsum(probabilities), 1);
        end
        
        samples{i} = sequence;
    end
end


clear; 
close all; 

A = [
0.5   0.0  0.0 ;
0.3   0.6  0.0 ;
0.2   0.4  1.0
];

B = [
0.7   0.4   0.8 ;
0.3   0.6   0.2    
];

a = [.9 .1 0]' ;

%% Question 1
a1 =  a .* B(1,:)' ;

% (A * a1)
a2 = (A * a1) .* B(2,:)' ;


% (A * a2)
a3 = (A * a2) .* B(1,:)' ;

p_visible = sum(a3)

%% Question 2

p_h1_given_vis = a3 / sum(a3)

%% Question 3

v = [ 1 2 1] ;

[a, b, c] = ndgrid(1:3, 1:3, 1:3);
all_possible_h = [a(:), b(:), c(:)];

likeall= zeros(1,size(all_possible_h,1)) ;


for i = 1:size(all_possible_h, 1)  % Loop over rows
    h = all_possible_h(i, :);      % Extract one combination
    % disp(h);               % Display the combination (optional)
    
    t=1;
    likelihood = B(v(t),h(t)) ;
    for t = 2:3
        likelihood = likelihood * B(v(t),h(t)) * A(h(t),h(t-1));
    end
    % disp(likelihood)

    likeall(i) = likelihood ;
end

figure
stem(1:size(all_possible_h, 1), likeall)
ylabel("Likelihood");
xlabel("Index of h")
title("")



figure
stem(1:size(all_possible_h, 1), likeall, 'filled', 'LineWidth', 1.5, 'MarkerSize', 6, 'Color', [0 0.4470 0.7410]); 
grid on
xlabel("Index of h")
ylabel("Likelihood")
title("Likelihood of Different Hidden Sequences")





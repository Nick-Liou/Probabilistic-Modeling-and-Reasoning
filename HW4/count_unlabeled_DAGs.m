
% Count unlabeled DAGs with at most k parents per node


% Define the maximum value of nodes
n = 15;

% Max parents
k = min(2 ,n) ; 

% Calculate possible edges for each number of nodes from 2 to n
possibleEdges = [0 arrayfun(@(x) nchoosek(x, 2), 2:n) ];

% Calculate Total DAG 
total_DAG =  [1 arrayfun(@(x) 2^nchoosek(x, 2), 2:n)];

% Initialize 
a = [1 arrayfun(@(i) 2^nchoosek(i , 2) , 2:k )] ; 

f1 = @(k,n) arrayfun(@(i) nchoosek(n-1, i) , 0:k );
for i = (k+1):n

    % Calculate possible DAG with at most k parents per node
    a(i) = a(i-1) * sum( f1(k,i) );
end


% Create a table showing the number of nodes, corresponding edges and Total DAG
edgesTable = table((1:n)', possibleEdges', a', total_DAG', ...
    'VariableNames', ["n", "Number of possible Edges",sprintf("Total DAG (max %d parents)",k),"Total DAG"]);

% Display the table
disp(edgesTable);





% Define the function handle for the expression for k = 2 
% f = @(n) 2^(1 - n) * prod(((3/2) + (0:n-2)).^2 + 7/4);
% result = arrayfun(f, 1:n);
% disp(result');

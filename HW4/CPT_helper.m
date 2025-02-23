

load('printer.mat')

x = x - 1 ; 


s = sum(x(1:5,:),2) ;
for i=1:5
    fprintf("p(x_%d = 1) = %d / %d \n" , i , s(i) , size(x,2))
end



% For x6 | x1
fprintf("\n x6|x1\n")
A = x([6 1],: );

% Determine the unique rows and count occurrences for each row.
[unique_rows, ~, idx] = unique(A', 'rows', 'stable');  % Find unique rows
counts = accumarray(idx, 1);                          % Count occurrences

% Display results
for i = 1:size(unique_rows, 1)
    fprintf('Combination %s appears %d times\n', mat2str(unique_rows(i,:)), counts(i));
end




% For x7 | x2 x3 x4
fprintf("\n x7 | x2 x3 x4\n")
A = x([7 2 3 4],: );

% Determine the unique rows and count occurrences for each row.
[unique_rows, ~, idx] = unique(A', 'rows', 'stable');  % Find unique rows
counts = accumarray(idx, 1);                          % Count occurrences

% Display results
for i = 1:size(unique_rows, 1)
    fprintf('Combination %s appears %d times\n', mat2str(unique_rows(i,:)), counts(i));
end




% For x8 | x1  x4
fprintf("\n  x8 | x1  x4\n")
A = x([8 1 4],: );

% Determine the unique rows and count occurrences for each row.
[unique_rows, ~, idx] = unique(A', 'rows', 'stable');  % Find unique rows
counts = accumarray(idx, 1);                          % Count occurrences

% Display results
for i = 1:size(unique_rows, 1)
    fprintf('Combination %s appears %d times\n', mat2str(unique_rows(i,:)), counts(i));
end




% For x9 | x4  x5
fprintf("\n x9 | x4  x5\n")
A = x([9 4 5],: );

% Determine the unique rows and count occurrences for each row.
[unique_rows, ~, idx] = unique(A', 'rows', 'stable');  % Find unique rows
counts = accumarray(idx, 1);                          % Count occurrences

% Display results
for i = 1:size(unique_rows, 1)
    fprintf('Combination %s appears %d times\n', mat2str(unique_rows(i,:)), counts(i));
end





% For x10 | x1  x5
fprintf("\n x10 | x1  x5\n")
A = x([10 1 5],: );

% Determine the unique rows and count occurrences for each row.
[unique_rows, ~, idx] = unique(A', 'rows', 'stable');  % Find unique rows
counts = accumarray(idx, 1);                          % Count occurrences

% Display results
for i = 1:size(unique_rows, 1)
    fprintf('Combination %s appears %d times\n', mat2str(unique_rows(i,:)), counts(i));
end






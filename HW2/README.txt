How to Use the "calculate_cond_prob" Function and Construct the Required Input File

# Overview of "calculate_cond_prob"

The calculate_cond_prob function computes the conditional probability P(A=a ∣ B=b)
using provided Conditional Probability Tables (CPTs).

To use the function, you need to:
    - Provide a file in the correct format (explained below) to read the CPTs.
    - Specify the probability you want to calculate by passing the following arguments:

    Arguments:
        -   A (list[int]): A list of indices for variables in event A.
        -   a (list[int]): A list of corresponding values for event A (either 0 or 1).
        -   B (list[int]): A list of indices for variables in event B.
        -   b (list[int]): A list of corresponding values for event B (either 0 or 1).
        -   tables (list[tuple[list[int], list[float]]]): A list of tuples where each tuple contains:
                - A list of variable indices.
                - A list of probabilities associated with those variables.

Example 1: Calculating P(X3 = 1 | X0 = 1, X1 = 1) 
    #This represents P(S=1 | T=1 , J=1) = 0.1604 

   selected_file = "wet_grass.txt"
    A = [3]      # Variable X3 (S)
    a = [1]      # X3 is set to 1 (S = 1)
    B = [0, 1]   # Variables X0 (T) and X1 (J)
    b = [1, 1]   # X0 = 1 (T = 1), X1 = 1 (J = 1)

    # Parse the file to get the adjacency matrix and CPT tables
    Adj_matrix, CPT_tables = parse_file(selected_file)

    # Calculate the conditional probability
    prob = calculate_cond_prob(A, a, B, b, CPT_tables)




Example 2: Calculating P(X3 = 1)  
    #This represents P(S=1) = 0.10

    selected_file = "wet_grass.txt"
    A = [3]  # Variable X3 (S)
    a = [1]  # X3 is set to 1 (S = 1)
    B = []   # No conditional variables
    b = []   # No conditions

    # Parse the file to get the adjacency matrix and CPT tables
    Adj_matrix, CPT_tables = parse_file(selected_file)

    # Calculate the marginal probability
    prob = calculate_cond_prob(A, a, B, b, CPT_tables)




# How to Construct the Required Input File

The input file must contain two sections:
    1. Adjacency Matrix (A): This represents the structure of the network.
    2. Conditional Probability Tables (CPTs): These define the probability of each variable given its dependencies.

Note:
    Parsing ignores lines that start with '$' or are empty.

Each line starts with a specific format. 

Adjacency Matrix (A):
    - The matrix starts with "A=[", followed by rows of space-separated values, and ends with "]".
    - Each value represents a directed edge between nodes (variables) in the graph.

Conditional Probability Tables (CPT):
    Each CPT starts with:
        - "CPT" followed by the variable index and its dependencies (if any).
        - Then, the conditional probabilities follow, ordered based on the binary combinations of the dependent variables.
            Example: For 2 dependencies, the probabilities are listed for (0,0),(0,1),(1,0),(1,1).


Example CPT Explanation:
Given the CPT:
$ T | R S
CPT 0 2 3
0
0.9
1
1

This represents P(X0=1 | X2, X3) , with probabilities:
    - P(X0=1 | X2=0 , X3=0) = 0
    - P(X0=1 | X2=0 , X3=1) = 0.9
    - P(X0=1 | X2=1 , X3=0) = 1
    - P(X0=1 | X2=1 , X3=1) = 1


Example file "wet_grass.txt":
A=[
0 0 0 0
0 0 0 0
1 1 0 0
1 0 0 0
]

$ T | R S
CPT 0 2 3
0
0.9
1
1

$ J | R
CPT 1 2 
0.2
1

$ R
CPT 2
0.2

$ S
CPT 3
0.1


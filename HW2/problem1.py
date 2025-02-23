import networkx as nx
import matplotlib.pyplot as plt
import numpy as np

from io import TextIOWrapper
from typing import List

def plot_graph(A :List[List[float]] ) -> None : 
    """
    Plots a directed graph from an adjacency matrix.

    Args:
        A (List[List[float]]): A 2D list representing the adjacency matrix of the graph. 
                                Each element A[i][j] should be 0 (no edge) or a positive value (edge exists).
    
    Raises:
        ValueError: If the input matrix is not square or contains invalid values (non-numeric).
    """
    # Input validation
    if not A:
        raise ValueError("The adjacency matrix cannot be empty.")
    
    matrix = np.array(A)

    # Check if the matrix is square
    if matrix.shape[0] != matrix.shape[1]:
        raise ValueError("The adjacency matrix must be square (same number of rows and columns).")

    # Check for non-numeric values
    if not np.issubdtype(matrix.dtype, np.number):
        raise ValueError("The adjacency matrix must contain numeric values.")


     # Create a directed graph
    G = nx.DiGraph()

    # Add edges from the adjacency matrix
    rows, cols = np.where(matrix != 0)  # Get the indices of non-zero entries
    edges = zip(rows.tolist(), cols.tolist())  # Create edges
    G.add_edges_from(edges)  # Add edges to the graph

    # Draw the graph
    pos = nx.spring_layout(G)  # Layout for visual representation
    nx.draw(G, pos, with_labels=True, node_size=700, node_color='lightblue', arrowsize=20, font_size=12)
    
    plt.title("Directed Graph from Adjacency Matrix")  # Title for the plot
    plt.show()

def parse_A_Dense(file: TextIOWrapper) -> List[List[float]]:
    """
    Parses a dense matrix from a file and returns it as a list of lists of floats.

    Args:
        file (TextIO): A file object containing the matrix in dense format. Each line should contain space-separated float values representing a row of the matrix.
                       Parsing stops when a closing bracket ']' is encountered on a line.

    Returns:
        List[List[float]]: A 2D list (list of lists) representing the matrix with each row as a list of floats.

    Raises:
        ValueError: If the line contains non-numeric data that cannot be converted to floats.
    """

    A = []  # Initialize an empty list to store the matrix

    for line in file:
        # Strip leading/trailing whitespace characters
        stripped_line = line.strip()

        # Break the loop if we encounter a closing bracket ']'
        if stripped_line == "]":
            break

        try:
            # Parse the row of numbers and append to the matrix A
            row = [float(x) for x in stripped_line.split()]
            A.append(row)
        except ValueError:
            raise ValueError(f"Unable to convert values in line '{stripped_line}' to floats.")

    return A


def parse_file(file_path: str) -> tuple[ List[List[float]] , list[tuple[list[int],list[float]]] ] :
    """
    Parses a file containing a dense matrix and CPT tables.

    The file is expected to contain a section for the matrix A and multiple CPT tables, where each line
    starts with a specific format. Parsing ignores lines that start with '$' or are empty.

    Args:
        file_path (str): The path to the input file.

    Returns:
        Tuple[List[List[float]], List[Tuple[List[int], List[float]]]]:
        A tuple containing:
            - A list of lists representing the dense matrix A.
            - A list of tuples, where each tuple consists of:
                - A list of integers representing conditional variable indices.
                - A list of floats representing the probabilities associated with those variables.

    Raises:
        ValueError: If the file format is incorrect or if non-numeric data is encountered while parsing.
        FileNotFoundError: If the specified file path does not exist.
    """

    CPT_tables = []  # Initialize a list to store the CPT tables
    A = []  # Initialize the matrix A
    try:
        with open(file_path, 'r') as file:
            for line in file:
                stripped_line = line.strip()

                # Skip lines that start with '$' or are empty
                if line.startswith('$') or stripped_line == '':
                    continue

                
                # Parse the matrix A if the line starts with "A=["
                if stripped_line.startswith("A=["):
                    A = parse_A_Dense(file)
                    
                # Parse the CPT table if the line starts with "CPT"
                elif stripped_line.startswith("CPT"):
                    CPT_table : tuple[list[int],list[float]]             
                    
                    data = stripped_line.split()
                    
                    # Extract conditional variable indices
                    cond_varibales  = list(map(int,data[1:]))
                    # Read the next 2**(len(data)-2) lines for probability values
                    values = [float(next(file)) for _ in range(2**(len(data)-2))]
                    
                    # Create the CPT table as a tuple
                    CPT_table = (cond_varibales , values)

                    
                    # Append the CPT table to the list
                    CPT_tables.append(CPT_table)
                    
    except FileNotFoundError:
        raise FileNotFoundError(f"The file '{file_path}' does not exist.")
    except ValueError as e:
        raise ValueError(f"Error parsing file: {e}")
       
    # Sort the CPT_tables based on the first conditional variable
    CPT_tables.sort(key=lambda x: x[0][0])

    return (A , CPT_tables)

def calculate_cond_prob(A:list[int] ,a:list[int] , B:list[int], b:list[int] , tables : list[tuple[list[int],list[float]]]  ) -> float:
    """
    Calculate the conditional probability P(A=a | B=b) based on the provided tables.

    Args:
        A (list[int]): A list of indices for variables in event A.
        a (list[int]): A list of corresponding values for event A (either 0 or 1).
        B (list[int]): A list of indices for variables in event B.
        b (list[int]): A list of corresponding values for event B (either 0 or 1).
        tables (list[tuple[list[int], list[float]]]): A list of tuples where each tuple contains a list of variable indices and a list of associated probabilities.

    Returns:
        float: The conditional probability P(A=a | B=b). If B is empty, returns the probability P(A=a).

    Raises:
        ValueError: If A and B are not disjoint or if the lengths of A and a or B and b do not match.
    """
    
    
    
    # Validate that sets A and B are disjoint
    if not set(A).isdisjoint(set(B)):
        raise ValueError("Sets A and B must be disjoint.")

    # Validate that the lengths of A and a match, and that the lengths of B and b match
    if len(A) != len(a) or len(B) != len(b):
        raise ValueError("Input arrays (A and a) and (B and b) must have the same length.")
    
    # Validate that all elements in a and b are 0 or 1 (binary values)
    if any(value not in [0, 1] for value in a + b):
        raise ValueError("Elements in 'a' and 'b' must be binary (0 or 1).")
    
    # Validate that elements in A and B are within the valid range of indices for the tables
    max_index = len(tables) - 1
    if any(index < 0 or index > max_index for index in A + B):
        raise ValueError(f"Indices in A and B must be between 0 and {max_index}.")
   

    # Calculate P(A=a , B=b)
    P_A_B = calculate_prob(A + B , a+b , tables)    
    # print(f"P_A_B({A + B} = {a+b}) = {P_A_B}")


    # If B is non-empty, calculate the conditional probability P(A=a | B=b)
    if len(B) != 0:
        # Calculate P(B=b)
        P_B = calculate_prob(B, b, tables)
        if P_B == 0:
            raise ZeroDivisionError("P(B=b) is zero, conditional probability is undefined.")
        
        # Calculate P(A=a | B=b) = P(A=a , B=b) / P(B=b)
        P_A_given_B = P_A_B / P_B
        return P_A_given_B
    else:
        # If B is empty, return the joint probability P(A=a)
        return P_A_B
    


def calculate_prob(A:list[int] ,a:list[int] , tables : list[tuple]) -> float:
    """
    Calculate the joint probability P(A=a) by summing over the possible values of unassigned variables.

    Args:
        A (list[int]): A list of indices for variables in event A.
        a (list[int]): A list of corresponding values for event A (either 0 or 1).
        tables (list[tuple[list[int], list[float]]]): A list of tuples where each tuple contains a list of variable indices and a list of probabilities for those variables.

    Returns:
        float: The joint probability P(A=a).

    Raises:
        ValueError: If the length of A and a do not match or if invalid values are provided in A or a.
    """

    # Input validation
    if len(A) != len(a):
        raise ValueError("Input arrays A and a must have the same length.")
    
    if any(value not in [0, 1] for value in a):
        raise ValueError("Values in 'a' must be binary (0 or 1).")
    
    n = len(tables)
    
    if any(index < 0 or index >= n for index in A):
        raise ValueError(f"Indices in A must be between 0 and {n-1}.")
    

    # Initialize the probability accumulator
    P_A = 0.0 

    # Create an array of zeros to hold the values of all variables
    x = np.zeros(n, dtype=int)
    
    # Assign the known values from A to their positions in x
    x[A] = a 

    # Find the indices of the free (unassigned) variables
    free_vars = find_missing_numbers(A,n)
    n_free = len(free_vars)

    # Iterate over all combinations of values for the free variables
    for i in range(2**n_free):
        # Set the free variables to each combination of binary values
        x[free_vars] =  [int(bit) for bit in format(i, f'0{n_free}b')]
        
        # The joint distribution P(X=x) is obtained by taking the product of the conditional probabilities
        P_X = 1.0

        for j in range(n):
            P_X *= claculate_prod_term( j , x , tables[j] )
        
        # Add the probability for this configuration to the total probability
        P_A += P_X

    return P_A

def claculate_prod_term( prod_term: int , x: np.ndarray , table:tuple[list[int],list[float]] ) -> float :
    """
    Calculate the probability value for a specific variable given the values of its parent variables.

    Args:
        prod_term (int): The index of the variable whose probability is being calculated.
        x (np.ndarray): The current configuration of all variables (binary values for each variable).
        table (tuple[list[int], list[float]]): A tuple where the first element is a list of variable indices (the current variable followed by its parent variables),
                                              and the second element is a list of conditional probabilities for each possible configuration of parent variables.

    Returns:
        float: The probability for the specified variable given the current values of its parent variables.

    Raises:
        ValueError: If the first index in the table does not match the specified prod_term.
    """
    
    # Ensure that the prod_term matches the first index in the table
    if prod_term != table[0][0]:
        raise ValueError("Mismatch between the requested prod_term and the CPT table's variable index.")
    
    # Extract the indices of the parent variables from the table
    conditions = table[0][1:] # Parent variables are listed after the main variable in the table

    # Compute the index in the probability table based on the parent variables' values
    result_index = 0
    for i in range(len(conditions)):
        result_index += x[conditions[len(conditions)-1-i]] * 2**i
    
    # If the current variable's value is 1, use the table's probability; otherwise, use its complement
    if ( x[prod_term] == 1 ):
        value = table[1][result_index]
    else:
        value = 1 - table[1][result_index]

    return value

def find_missing_numbers(numbers_in_list: List[int], n: int) -> List[int]:
    """
    Finds all numbers in the range [0, n-1] that are not present in the given list.

    Args:
        numbers_in_list (List[int]): A list of numbers within the range [0, n-1].
        n (int): The upper limit of the range (exclusive), i.e., numbers from 0 to n-1.

    Returns:
        List[int]: A list of numbers that are missing from numbers_in_list but are 
                   within the range [0, n-1].
    """
    # Sort the input list
    numbers_in_list.sort()

    # Initialize an empty list to store the missing numbers
    missing_numbers = []

    # Initialize indices
    j = 0  # For the sorted list

    # Iterate through the numbers from 0 to n-1
    for i in range(n):
        if j < len(numbers_in_list) and numbers_in_list[j] == i:
            # If i is in the sorted list, move to the next number in the sorted list
            j += 1
        else:
            # If i is not in the sorted list, add it to the missing numbers
            missing_numbers.append(i)
        # Move to the next number in the range

    return missing_numbers


def main() -> None:   

    selected_file = "wet_grass.txt"
    # Wet grass input for P(S=1 | T=1) = 0.338235294117647
    A = [3]
    a = [1]
    B = [0]
    b = [1]

    
    # Wet grass input for P(S=1 | T=1 , J=1) = 0.16044776119402987
    # A = [3]
    # a = [1]
    # B = [0,1]
    # b = [1,1]




    # selected_file = "chest_clinic.txt"
    # A : list[int] = [1]
    # a : list[int] = [1]
    # B : list[int] = [7]
    # b : list[int] = [0]


    (Adj_matrix , CPT_tables) = parse_file(selected_file)

    prob = calculate_cond_prob(A,a,B,b , CPT_tables)


    t1 = ', '.join([f"X{A_i} = {a_i}" for A_i, a_i in zip(A, a)])
    t2 = ', '.join([f"X{B_i} = {b_i}" for B_i, b_i in zip(B, b)])
    
    print(f"P({t1}{' | '*bool(B)}{t2}) = {prob}")


    # plot_graph(Adj_matrix)





if __name__ == "__main__":

    main()

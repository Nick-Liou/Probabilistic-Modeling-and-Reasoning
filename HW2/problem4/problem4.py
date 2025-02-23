from matplotlib import pyplot as plt
import numpy as np
import networkx as nx
from networkx.algorithms.isomorphism import GraphMatcher 

def plot_graph(matrix: np.ndarray) -> None:
    """
    Plots a directed graph based on an adjacency matrix.

    Parameters:
    matrix (np.ndarray): A square adjacency matrix where a non-zero entry 
                         at position (i, j) indicates an edge from node i to node j.

    The function uses NetworkX's spring layout to plot the graph with improved
    node spacing, arrow visibility, and edge curvature for better readability.
    """
    # Create a directed graph
    G = nx.DiGraph()

    # Add edges from the adjacency matrix
    rows, cols = np.where(matrix != 0)  # Find non-zero entries, indicating edges
    edges = zip(rows.tolist(), cols.tolist())  # Convert them into edge pairs
    G.add_edges_from(edges)  # Add edges to the directed graph

    # Set the layout for the graph. The spring_layout uses a force-directed algorithm
    # that positions nodes to reduce overlap and make the graph more readable.
    pos = nx.spring_layout(G, k=0.5, scale=2)  # k controls node spacing, scale makes the graph larger

    # Create a new figure for the plot with specified size
    plt.figure(figsize=(8, 6))
    # Draw the graph with custom aesthetics
    nx.draw(
        G, pos, 
        with_labels=True,              # Display node labels
        node_size=800,                 # Size of the nodes
        node_color='lightblue',        # Node color
        arrowsize=25,                  # Arrow size for directed edges
        font_size=14,                  # Font size for node labels
        edge_color='black',            # Color of the edges
        connectionstyle='arc3,rad=0.1' # Curve the edges slightly to reduce overlap
    )


    # Display the graph
    plt.show()
    
def find_immoralities(G:nx.DiGraph) -> set[tuple[int,int,int]]:
    """
    Find all immoralities (v-structures) in a directed acyclic graph (DAG).

    An immorality (v-structure) occurs when two nodes (parent1 and parent2) 
    both have directed edges pointing to a common child node, but there is no 
    direct edge between parent1 and parent2 (in either direction).

    Parameters:
    G (nx.DiGraph): A directed acyclic graph (DAG) represented as a NetworkX DiGraph.

    Returns:
    set[tuple[int,int,int]]: A set of tuples, where each tuple represents an immorality 
                in the form (parent1, child, parent2).

    Example:
    In the graph with edges: 1 -> 3, 2 -> 3, there is an immorality if there is no edge between 1 and 2.
    """
    immoralities = set() # To store the detected immoralities (v-structures)

    # Iterate over all nodes in the graph
    for node in G.nodes():
        # Find all parents of the current node (nodes with edges directed to it)
        parents = list(G.predecessors(node))

        # Check if the node has more than one parent (potential immorality)
        if len(parents) > 1:
            # Compare each pair of parents
            for i in range(len(parents)):
                for j in range(i + 1, len(parents)):
                    parent1 :int = parents[i]
                    parent2 :int = parents[j]
                    # Check if there is no direct edge between the two parents (either direction)
                    if not G.has_edge(parent1, parent2) and not G.has_edge(parent2, parent1):
                        # If there's no edge between the parents, it's an immorality
                        immoralities.add((parent1, int(node), parent2))  # Add immorality to the set

    return immoralities

def are_markov_equivalent(A:np.ndarray, B:np.ndarray) -> str:
    """
    Check if two directed acyclic graphs (DAGs) are Markov equivalent.

    Two DAGs are Markov equivalent if:
    1. They have the same skeleton (the undirected version of the graph).
    2. They have the same set of immoralities (v-structures).

    Parameters:
    A (np.ndarray): Adjacency matrix representing the first DAG.
    B (np.ndarray): Adjacency matrix representing the second DAG.

    Returns:
    str: A message indicating whether the two Bayesian Networks are Markov equivalent or not.
         - If not equivalent, the message explains if it's due to skeleton mismatch or immorality mismatch.
         - If equivalent, it returns "The two BNs are Markov equivalent."

    """

    # Create directed graphs from adjacency matrices A and B
    G_A = nx.DiGraph(A)
    G_B = nx.DiGraph(B)

    # 1. Check if the skeletons of the graphs are isomorphic (i.e., the same structure ignoring edge direction)
    GM = GraphMatcher(G_A.to_undirected(), G_B.to_undirected())
    if not GM.is_isomorphic():
        return "The two BNs are not Markov equivalent due to skeleton mismatch."

    # 2. Compare immoralities (v-structures) in both graphs
    immoralities_A = find_immoralities(G_A)
    immoralities_B = find_immoralities(G_B)
    
    # Use the isomorphism mapping to relabel nodes in G_B to match G_A
    mapping = GM.mapping # The mapping relates the node labels in G_A to those in G_B


    # Map the immoralities of G_B to G_A's node labels for comparison
    mapped_immoralities_A = {tuple(mapping[node] for node in immorality) for immorality in immoralities_A}


    # If the sets of immoralities are not the same, the graphs are not Markov equivalent
    if immoralities_B != mapped_immoralities_A :
        return "The two BNs are not Markov equivalent due to immorality mismatch."
     # If both skeleton and immorality checks pass, the DAGs are Markov equivalent
    
    return "The two BNs are Markov equivalent."

if __name__ == "__main__":

    # Load matrices A and B (replace with actual file paths)    
    A_matrix = np.loadtxt('problem4/p4_graphA.txt', dtype=int)
    B_matrix = np.loadtxt('problem4/p4_graphB.txt', dtype=int)
    
    # A_matrix = np.loadtxt('problem4/example_graphA.txt', dtype=int)
    # B_matrix = np.loadtxt('problem4/example_graphB.txt', dtype=int)


    
    # Check if the two DAGs are Markov equivalent and print the result
    result = are_markov_equivalent(A_matrix, B_matrix)
    print(result)

    # Plot both graphs for visual comparison
    plot_graph(A_matrix)
    plot_graph(B_matrix)
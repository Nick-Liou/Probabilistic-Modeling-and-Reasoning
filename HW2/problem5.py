import networkx as nx
import matplotlib.pyplot as plt
import numpy as np


# Barber Ex. 3.15 - Part 1 (a figure showing the network)
    
def main() -> None:
    # Adjacency matrix for a graph with 5 nodes (oil, inf, eh, bp, rt)
    matrix = np.array([
                    [0, 1, 0, 1, 0],    # oil -> inf , oil -> bp
                    [0, 0, 0, 0, 1],    # inf -> rt
                    [1, 1, 0, 0, 1],    # eh -> oil , eh -> inf , eh -> rt
                    [0, 0, 0, 0, 0],    # bp (no outgoing edges)
                    [0, 0, 0, 0, 0]     # rt (no outgoing edges)
                    ]) 

    # Node names (corresponding to indices in the matrix)
    node_names = ['oil', 'inf', 'eh', 'bp', 'rt']

    # Create a directed graph
    G = nx.DiGraph()

    # Add edges from the adjacency matrix
    rows, cols = np.where(matrix == 1)
    edges = zip(rows.tolist(), cols.tolist())
    G.add_edges_from(edges)

    # Relabel nodes with their names (oil, inf, eh, bp, rt)
    mapping = {i: node_names[i] for i in range(len(node_names))}
    G = nx.relabel_nodes(G, mapping)

    # Draw the graph
    pos = nx.spring_layout(G)  # Layout for visual representation
    nx.draw(G, pos, with_labels=True, node_size=700, node_color='lightblue', arrowsize=20, font_size=12)
    plt.show()


if __name__ == "__main__":

    main()


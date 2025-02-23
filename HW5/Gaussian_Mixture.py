import numpy as np

# EM Algorithm for two Gaussian distributions
def em_algorithm_GM(filename, output_filename = 'em_output.txt'):
    # Read the samples from the input file
    samples = np.loadtxt(filename)
    n_samples = len(samples)

    # Initialize parameters
    np.random.seed(42)
    means = np.random.uniform(np.min(samples), np.max(samples), 2)
    variances = np.random.uniform(1, 5, 2)
    mixing_coeffs = np.array([0.5, 0.5])  # Equal probability for both distributions initially
    
    # Helper function: Gaussian PDF
    def gaussian_pdf(x: float, mean : float, var : float) -> float:
        return (1 / np.sqrt(2 * np.pi * var)) * np.exp(-((x - mean) ** 2) / (2 * var))
    
  
    gaussian_probs = np.zeros((n_samples, 2))  # For storing weighted Gaussian probabilities
    q_h_given_x = np.zeros((n_samples, 2))  # For storing 'variational’ distributions
    
    # EM Algorithm with convergence condition
    epsilon = 1e-14  # Convergence tolerance
    max_iter = 100  # Maximum iterations
    iteration = 0

    # Initialize differences to a high value
    mean_diff = float('inf')
    var_diff = float('inf')


    while (mean_diff > epsilon or var_diff > epsilon) and iteration < max_iter:
        iteration += 1          
        # Store previous means and variances
        prev_means = means.copy()
        prev_variances = variances.copy()
        
                           
        # <----------------- E-step ----------------->
       
        # Calculate probabilities
        for h in range(2):  # For both Gaussians
            gaussian_probs[:, h] = gaussian_pdf(samples, means[h], variances[h]) * mixing_coeffs[h]

        # Normalize probabilities
        q_h_given_x = gaussian_probs / gaussian_probs.sum(axis=1, keepdims=True)

        
        # <----------------- M-step ----------------->

        for j in range(2):
            weight_sum = sum(q_h_given_x[:, j])  # Compute sum only once
            means[j] = sum(q_h_given_x[:, j] * samples) / weight_sum
            variances[j] = sum(q_h_given_x[:, j] * ((samples - means[j]) ** 2)) / weight_sum

        # Calculate the maximum absolute differences for stopping criteria
        mean_diff = max(abs(means - prev_means))
        var_diff = max(abs(variances - prev_variances))

    # print(f"Number of iterations {iteration}")
    
    # Determine the most probable Gaussian for each sample
    most_probable_gaussian = np.argmax(q_h_given_x, axis=1) + 1  # Add 1 to index (1 or 2)
    
    # Write output to file
    with open(output_filename, 'w') as f:
        # Write means and variances of the distributions
        f.write(f"{means[0]} {variances[0]} {means[1]} {variances[1]}\n")
        
        # Write each sample and its most probable Gaussian
        for value in most_probable_gaussian:
            f.write(f"{value}\n")

    

import tkinter as tk
from tkinter import filedialog
import os

def select_file(window_title: str = "Select a file") -> str:
    """
    Opens a file selection dialog to allow the user to choose a file. 
    The dialog starts in the current working directory and filters file types to `.txt` files by default.

    Args:
        window_title (str): The title of the file selection dialog window. Defaults to "Select a file".

    Returns:
        str: The full path of the selected file as a string. If the user cancels the selection, an empty string is returned.

    Notes:
        - The function hides the root `tkinter` window.
        - The dialog restricts the file selection to `.txt` files by default, but allows selecting any file type.
        - The initial directory is set to the current working directory.
    """ 
    # Create a root window (it won't be displayed)
    root = tk.Tk()
    root.withdraw()  # Hide the root window

    # Set the title of the file dialog window
    root.title(window_title)

    # Get the current working directory
    current_dir = os.getcwd()

    # Open a file dialog and store the selected file path
    file_path = filedialog.askopenfilename(
        title=window_title,
        initialdir=current_dir,  # Set the dialog to open in the current directory
        filetypes=[("TXT files", "*.txt"), ("All files", "*.*")]  # Restrict to .mps files by default
    )

    # Return the file path
    return file_path

def select_save_file_path(default_name: str = "untitled.txt", save_dir: str = os.getcwd()) -> str:
    """
    Opens a "Save As" dialog to allow the user to select a file path and filename for saving a file.
    The dialog will start in a specified directory and suggest a default filename and file type (.txt).

    Args:
        default_name (str): The default file name to suggest in the "Save As" dialog. Defaults to "untitled.txt".
        save_dir (str): The directory to open the dialog in. Defaults to the current working directory.

    Returns:
        str: The full path of the selected file, including the file name and extension. If the user cancels
             the operation, an empty string is returned.

    Notes:
        - The function hides the root `tkinter` window.
        - The dialog filters the file types, showing `.txt` files by default, but allows selecting any file type.
        - The `.txt` extension is added automatically if the user does not specify one.
    """

    # Create a root window (it won't be displayed)
    root = tk.Tk()
    root.withdraw()  # Hide the root window

    # Open a save file dialog and get the selected file path
    file_path = filedialog.asksaveasfilename(
        title="Save As",
        initialdir=save_dir,
        initialfile=default_name,
        defaultextension="txt",  # Add the default extension
        filetypes=[("TXT files", "*.txt"), ("All files", "*.*")]  # Restrict file types
    )

    # Return the selected file path
    return file_path



def main() -> None:
    
    input_filename = select_file() 
    # input_filename = 'samples.txt'
    print(f"Selected input file: {input_filename}")

    output_filename = select_save_file_path("em_output.txt")    
    # output_filename = 'em_output.txt'
    print(f"Data will be saved to: {output_filename}")

    # Run the EM algorithm and save the output
    em_algorithm_GM(input_filename,output_filename)

    



if __name__ == "__main__":
    main()


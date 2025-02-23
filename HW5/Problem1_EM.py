import pandas as pd
import pyAgrum as gum

# Step 1: Define the structure of the Bayesian Network
bn = gum.BayesNet("ExampleBN")

# Add nodes/variables
bn.add(gum.LabelizedVariable("Fuse"))  
bn.add(gum.LabelizedVariable("Drum"))  
bn.add(gum.LabelizedVariable("Toner")) 
bn.add(gum.LabelizedVariable("Paper")) 
bn.add(gum.LabelizedVariable("Roller"))
bn.add(gum.LabelizedVariable("Burning"))  
bn.add(gum.LabelizedVariable("Quality"))  
bn.add(gum.LabelizedVariable("Wrinkled")) 
bn.add(gum.LabelizedVariable("Mult.Pages"))
bn.add(gum.LabelizedVariable("Paper Jam")) 


bn.addArc("Fuse", "Burning")  
bn.addArc("Fuse", "Wrinkled") 
bn.addArc("Fuse", "Paper Jam")
bn.addArc("Drum", "Quality")  
bn.addArc("Toner", "Quality") 
bn.addArc("Paper", "Quality") 
bn.addArc("Paper", "Wrinkled")  
bn.addArc("Paper", "Mult.Pages")  
bn.addArc("Roller", "Mult.Pages")  
bn.addArc("Roller", "Paper Jam")  

data = [
    [None, None, 1, 1, 0, 0, 1, 0, 0, None],
    [None, 0, 1, 0, 0, None, 1, 0, None, 0],
    [None, None, 0, 1, None, None, 1, 1, 1, 1],
    [1, 0, None, 0, None, 1, 0, 0, 0, 1],
    [0, 1, None, 1, None, 0, 1, 0, None, None],
    [0, 0, 1, None, 0, 0, 1, 0, 0, 0],
    [None, 0, 0, 1, 1, 0, 0, None, 1, 1],
    [0, 1, 1, 0, None, 0, 1, 0, 0, 1],
    [None, None, 0, 1, 0, 0, 0, 1, 1, 1],
    [0, None, None, 1, 0, None, 0, None, None, 1],
    [0, 1, 0, None, None, 0, 1, 0, 0, 0],
    [None, 1, 1, 1, 0, None, 1, 0, 0, None],
    [1, None, None, 1, None, 1, None, 1, None, 0],
    [None, 0, 0, None, 1, 0, None, 1, 0, 1],
    [1, 0, None, 0, 1, None, 0, 1, 1, None]
]

df = pd.DataFrame(data, columns=["Fuse","Drum","Toner","Paper","Roller","Burning","Quality","Wrinkled","Mult.Pages","Paper Jam"])


# Step 3: Cast to integer types (ensure labels are integers)
df = df.astype({"Fuse": "Int64" ,"Drum": "Int64" ,"Toner": "Int64" ,"Paper": "Int64" ,"Roller": "Int64" ,"Burning": "Int64" ,"Quality": "Int64" ,"Wrinkled": "Int64" ,"Mult.Pages": "Int64" ,"Paper Jam": "Int64" })

# Step 4: Learn the CPTs using pyAgrum's BNLearner
learner = gum.BNLearner(df, bn)  # Initialize learner with data and structure

learner.useSmoothingPrior(1.0)  # Apply smoothing because  The conditioning set <Drum=0, Toner=0, Paper=0> for target node Quality never appears in the database.
learner.useEM(10**(-10))  # Use the EM algorithm for handling missing data
learned_bn = learner.learnParameters(bn.dag())  # Learn parameters (CPTs)

# Step 5: Display the learned BN
print("Learned CPTs:")
for node in learned_bn.nodes():
    print(f"\nNode: {learned_bn.variable(node).name()}")
    print(learned_bn.cpt(node))


# <=============== Calculate probability ===============>

# Step 1: Create a LazyPropagation engine
inference = gum.LazyPropagation(learned_bn)  # Initialize with the learned Bayesian Network


# Step 2: Set the evidence 
inference.setEvidence({"Burning": 0,"Wrinkled":0,"Quality":1}) 


# Step 3: Perform the propagation to update beliefs based on the evidence
inference.makeInference()


ans =  inference.posterior("Drum")

print("Therefore: p(x_1  | x_7 = 0 , x_5 = 0 , x_3 = 1 ) =")
print(ans)

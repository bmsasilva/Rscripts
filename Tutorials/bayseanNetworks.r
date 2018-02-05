# Tutorial adapted from:
# https://www.r-bloggers.com/bayesian-network-in-r-introduction/

#### Data prep ####
library(bnlearn)
data(coronary) # Load data from package "bnlearn"
bn_df <- data.frame(coronary) # Create data.frame

#### Find the stucture (see final notes for further information) ####
res <- hc(bn_df) # Use the “max-min hill climbing” algorithm to automatically discover the network structure
plot(res) # Visualize the network

#### Training ####
fittedbn <- bn.fit(res, data = bn_df) # Fit the network, i.e., create the conditional probability tables at each node
print(fittedbn$Proteins) # Explore the "Protein" node conditional probability tables

#### Inference ####
# What is the probability of a non-smoker having a Protein level <3? 
cpquery(fittedbn, event = (Proteins=="<3"), evidence = (Smoking=="no")) 

# What is the probability of a smoker having a Protein level <3? 
cpquery(fittedbn, event = (Proteins=="<3"), evidence = (Smoking=="yes")) 

# What is the chance that a non-smoker with pressure greater than 140 has a Proteins level less than 3?
cpquery(fittedbn, event = (Proteins=="<3"), evidence = (Smoking=="no" & Pressure==">140"))

# What is the chance that someone has a Pressure level greater than 140 if the Protein level is <3?
cpquery(fittedbn, event = (Pressure==">140"), evidence = (Proteins=="<3"))

# What is the chance that someone has a Pressure level greater than 140 if the Protein level is <3?
cpquery(fittedbn, event = (Pressure==">140"), evidence = (Proteins=="<3"))

# What is the chance that someone has a Pressure level greater than 140 if the Protein level is <3 and is a smoker?
cpquery(fittedbn, event = (Pressure==">140"), evidence = (Proteins=="<3" & Smoking=='yes'))

#### Final Notes ####
# hc() function is used to discover the stucture of the network. Some parameters include:
# whitelist=data.frame(from="Smoking", to="Family") -> force the stucture to include a connection between "Smoking" and "Family"
# blacklist=data.frame(from="Smoking", to="Family") -> force the stucture to exclude a connection between "Smoking" and "Family"

# It's also possible to manually adjust the connections after the stucture is discovered by the algorithm in hc()
# To remove the connection between "M..Work" and "Family" 
res$arcs <- res$arcs[-which((res$arcs[,'from'] == "M..Work" & res$arcs[,'to'] == "Family")),]

# To create a connection between "Family" e "P..Work"
res$arcs <- rbind(res$arcs, c("Family","P..Work"))


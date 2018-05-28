# Collaborative Spatial Reuse in Wireless Networks via Selfish Multi-Armed Bandits
### Authors
* [Francesc Wilhelmi](https://github.com/fwilhelmi)
* [Cristina Cano](http://ccanobs.github.io/)
* [Gergely Neu](http://cs.bme.hu/~gergo/)
* [Boris Bellalta](http://www.dtic.upf.edu/~bbellalt/)
* [Anders Jonsson](http://www.tecn.upf.es/~jonsson/)
* [Sergio Barrachina-Muñoz](https://github.com/sergiobarra)

### Project description
Next-generation wireless deployments are characterized by being dense and uncoordinated. The lack of self-adjustment mechanisms leads to inefficient use of resources and poor performance. To solve this, we envision the utilization of completely decentralized mechanisms that enhance Spatial Reuse (SR). In particular, we concentrate in Reinforcement Learning (RL), and more specifically, in Multi-Armed Bandits (MABs). In this work, we study the exploration-exploitation trade-off by means of the epsilon-greedy, EXP3, UCB and Thompson sampling action-selection strategies, while allowing networks to modify both their transmission power and channel based on their experienced throughput. Our results show that optimal proportional fairness can be achieved, even if no information about neighboring networks is available to the learners. With that, we prove collaborative behaviors that favor a set of WNs can be obtained even if they operate in a selfish way, which is useful to avoid centralization costs (e.g., message passing, additional hardware). However, there is high temporal variability in the throughput experienced by the individual networks, specially for the epsilon-greedy and EXP3 policies. We identify the cause of this variability to be the adversarial setting of our setup in which the set of most played actions provide intermittent good/poor performance depending on the neighboring decisions. We also show that this variability is reduced using UCB and Thompson sampling action-selection strategies, which are parameter-free policies that perform exploration according to the reward distribution of each action. In particular, Thompson sampling shows promising results regarding the achieved performance while keeping temporal variability low.	

### Repository description
This repository contains the Code and the LaTeX files used for the journal article "Collaborative Spatial Reuse in Wireless Networks via Selfish Multi-Armed Bandits", which has been sent to "Elsevier Ad-hoc Networks".

The results obtained from this work can be found in https://doi.org/10.5281/zenodo.1036737.

### Running instructions
To run the code, just 
1) "add to path" all the folders and subfolders in "./Code", 
2) Access to "Code" folder
3) Execute scripts in folder "./Code/Experiments"

Additional notes:
* The "constants.m" file contains the information regarding the simulation parameters (e.g., number of Wireless Networks, allowed transmit power levels, etc.).
* The experiments output can be found in the "./Code/Output/" folder, in which we store figures and the workspace.

### Contribute

If you want to contribute, please contact to francisco.wilhelmi@upf.edu

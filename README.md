# Collaborative Spatial Reuse in Wireless Networks via Selfish Multi-Armed Bandits
### Authors
* [Francesc Wilhelmi](https://github.com/fwilhelmi)
* [Cristina Cano](http://ccanobs.github.io/)
* [Gergely Neu](http://cs.bme.hu/~gergo/)
* [Boris Bellalta](http://www.dtic.upf.edu/~bbellalt/)
* [Anders Jonsson](http://www.tecn.upf.es/~jonsson/)
* [Sergio Barrachina-Muñoz](https://github.com/sergiobarra)

### Project description
Next-generation wireless deployments are characterized by being dense and uncoordinated, which often leads to inefficient use of resources and poor performance. To solve this, we envision the utilization of completely decentralized mechanisms to enable Spatial Reuse (SR). In particular, we focus on dynamic channel selection and Transmission Power Control (TPC). We rely on Reinforcement Learning (RL), and more specifically on Multi-Armed Bandits (MABs), to allow networks to learn their best configuration. In this work, we study the exploration-exploitation trade-off by means of the $\varepsilon$-greedy, EXP3, UCB and Thompson sampling action-selection, and compare their performance. In addition, we study the implications of selecting actions simultaneously in an adversarial setting (i.e., concurrently), and compare it with a sequential approach. Our results show that optimal proportional fairness can be achieved, even if no information about neighboring networks is available to the learners and Wireless Networks (WNs) operate selfishly. However, there is high temporal variability in the throughput experienced by the individual networks, specially for $\varepsilon$-greedy and EXP3. These strategies, contrary to UCB and Thompson sampling, base their operation on the absolute experienced reward, rather than on its distribution. We identify the cause of this variability to be the adversarial setting of our setup in which the set of most played actions provide intermittent good/poor performance depending on the neighboring decisions. We also show that learning sequentially, even if using a selfish strategy, contributes to minimize this variability. The sequential approach is therefore shown to effectively deal with the challenges posed by the adversarial settings that are typically found in decentralized WNs.

### Repository description
This repository contains the Code and the LaTeX files used for the journal article "Collaborative Spatial Reuse in Wireless Networks via Selfish Multi-Armed Bandits", which has been sent to "Elsevier Ad-hoc Networks".

The results obtained from this work can be found in https://doi.org/10.5281/zenodo.1485935.

### Running instructions
To run the code, just 
1) "add to path" all the folders and subfolders in "./Code", 
2) Access to "Code" folder
3) Execute scripts in folder "./Code/Experiments"

Additional notes:
* The "constants.m" file contains the information regarding the simulation parameters (e.g., number of Wireless Networks, allowed transmit power levels, etc.).
* The experiments output can be found in the "./Code/output/" folder, in which we store figures and the workspace.

### Contribute
If you want to contribute, please contact to francisco.wilhelmi@upf.edu

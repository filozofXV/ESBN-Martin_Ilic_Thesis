# AI Abstract Visual Reasoning: Which changes to the ESBN model affect how it learns to solve visual abstraction tasks?

Code for the paper [Emergent Symbols through Binding in External Memory](https://arxiv.org/abs/2012.14601), modified for the thesis "AI Abstract Visual Reasoning: Which changes to the ESBN model affect how it learns to solve visual abstraction tasks?".

## Abstract
This project aims to explore avenues on how to interpret Webb and colleagues (2021)’s ESBN neural network from a psychological perspective. The ESBN is a network which solves abstract reasoning tasks, such as Raven’s Progressive Matrices, with remarkable test accuracy. Moreover, it does so even when given a fraction of possible examples to train on, indicating the network is able to generalize to novel instances from limited training data. 

However, if the ESBN is to be used as a model of abstract reasoning in humans, it would require its architecture to be psychologically plausible. This project will argue that a plausible (developmental) psychological explanation to ESBN’s architecture choices is linking batch size capacity to children’s working memory capacity, and two encoders, convolutional and random, as presence or absence of inhibition control. These will be used to simulate data and observe trends, which further research should connect to human data


## Data Simulation
In order to simulate the data, run the dist3.sh or identity_rules.sh files. These files are shell scripts which will execute either the dist3 or identity rules task simulations for both encoders and all batch size conditions (32,16,8,4). In total, these will run 10 times per condition, 80 runs in total per file (4 batch sizes * 2 encoders * 10 runs = 80 runs). It is important you do not move the .sh files from their location in the folder, as they won't work. 

The shell scripts call upon the system command "py" in order to run python3. If these commands do not work on your computer, make sure you have Python3 installed (and on PATH). Finally, if that doesn't work, edit the .sh scripts with a text editor and try switching the "py" in these scripts for "python3", as these calls differ from system to system.

### Prerequisites

If you want to install from pip from a .txt file, look for the "Martin - packages.txt" file.

- Python 3 (I am running Python 3.8.1.)
- [NumPy](https://numpy.org/) (1.24.1)
- [colorlog](https://github.com/borntyping/python-colorlog) (6.7.0)
- [PIL](https://pillow.readthedocs.io/en/stable/) (10.1.0)
- [PyTorch](https://pytorch.org/)  (1.13.0+cu117) 

## Data Analysis

To analyze the data, run the dist3_analysis.R and identity_analysis.R R scripts. However, please do so only _after_ you ran the dist3.sh and identity_rules.sh shell scripts, respectively. These scripts extract data from .txt files in which the data is located, combine them in together in a data frame and assign to data factor values depending on condition (for example, batch_size = 4, encoder = "conv"). Afterwards, they check the assumptions for performing an ANOVA, perform a two-way ANOVA on them, and the pre-planned contrasts which are Bonferroni corrected. 

### Prerequisites 
- R version 4.3.2
- rstudioapi 2023.9.1.494
- ggpubr ggpubr_0.6.0
- emmeans_1.8.9

## Authorship

The Python code was written by [Taylor Webb](https://github.com/taylorwwebb). The R code and Python code adjustments were written  [Martin Ilić](https://github.com/filozofXV). 

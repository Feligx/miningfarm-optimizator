# Mining Farm Optimizator

This project proposes to find optimums to different aspects of the practice of large-scale cryptocurrency mining, i.e. cryptocurrency farms, by analyzing the different aspects surrounding it and finding situations in which it would be useful to optimize the different variables of the problem.

The project is going to be aproached from two different perspectives considering a base problem, a linear and a non-linear one, using different algorithms to optimize the proposed situation to the problem.


## Problem

Given a farm of _i_ types of computers to mine _j_ different cryptocurrencies, where each machine used has a daily limit of energy expenditure so we seek to minimize its usage, also its investors expect to obtain a minimum profit each day no matter what currency they have to mine, the maximum hours that can mine each machine per day and how many hours can be mined per day in the farm are taken into account.

## Variables

The following are the variables that were used in the tool:

* Hash rate 
  >hashing per second
* Energy consumption 
  >calculated using the wattage of the GPUs and the usage hours, by the formula `energy = (Wattage/1000)*Hours`
* Daily profit from each coin used
* Working time of each individual machine
* Total of working hours of the farm

**See the [Data](https://github.com/Feligx/miningfarm-optimizator#data) section at the end for the reference of the data**

## Algorithms used

For both problems, optimization algorithms are used, these are developed in Matlab allowing user input for certain variables to solve a specific problem for the user's wish.

*  Linear problem: **Simplex**
*  Non-linear problem : **Projected Gradient**


## Considerations

The following are considerations to have when trying the tool.


### - Disclaimer

This is a simulator, and should not be treated as a deciding tool for real miners in order to use their GPUs.
All the data used was taken from the internet and could be deprecated in some future, so if you try the tool be sure to have the data you want.

### - Data

All the data used was obtained from [Whattomine](https://whattomine.com/gpus?nvidia=true&amd=true&filter=all) website that contains iformation about some GPUs and the variables we used for the proyect.

From here we used three coins that are the ones with more information on that website for all the listed machines:

<p align="center" width="100%">
    <img width="33%" src="https://raw.githubusercontent.com/Feligx/miningfarm-optimizator/main/coins_small.png">
</p>
<p align="center" width="100%">
  Etherum, Flux & Nicehash ethash
</p>

The [.csv](https://github.com/Feligx/miningfarm-optimizator/blob/main/crypto-data-vals.csv) file has all the data we need in the format the tool requires, the columns of the file are explained below:

* **CSV data example**:

| **Hash Rate (h/s)**  | **Wattage (W)** | **Coin 1 profit** | **Coin 2 profit** | **Coin 3 profit** | **Energy consumption** | **Working time (hours)** |
| :-------------: | :-------------: | :-------------: | :-------------: |  :-------------: | :-------------: | :-------------: |
| 114  | 15.11  | 8.5 | 8.74 | 8.27 | 0.015 | 11 |
| 93  | 18.7  | 5.95 | 7.28 | 6.89 | 0.018 | 21 |

> Note that each row of the csv represents the data of one machine, and this example should be used to format new data to add to the tool.

## Attribution

This proyect couldn't be possible without the help and effort of the team, we hope you enjoy and find usefull the proyect!


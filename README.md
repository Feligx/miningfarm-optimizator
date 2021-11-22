# Mining Farm Optimizator

This project proposes to find optimums to different aspects of the practice of large-scale cryptocurrency mining, i.e. cryptocurrency farms, by analyzing the different aspects surrounding it and finding situations in which it would be useful to optimize the different variables of the problem.

The project is going to be aproached from two different perspectives considering a base problem, a linear and a non-linear one using different algorithms to optimize the proposed situation to the problem.


## Problem

Given a farm of _i_ types of computers to mine _j_ different cryptocurrencies, where each machine used has a daily limit of energy expenditure so we seek to minimize its usage, also its investors expect to obtain a minimum profit each day no matter what currency they have to mine, the maximum hours that can mine each machine per day and how many hours can be mined per day in the farm are taken into account.

## Variables

The following are the variables that were used in the tool:

* Hash rate 
  >hashing per second
* Energy consumption 
  >calculated using the wattage of the GPUs and the usage hours, by the formula `energy = (Wattage/1000)*Hours`
* Daily profit from each coin used
* Working hour of each individual machine
* Total of working hours of the farm

**See the [Data](https://github.com/Feligx/miningfarm-optimizator#data) section at the end for the reference of the data**

## Algorithms used

For both problems, optimization algorithms are used, these are developed in Matlab allowing user input for certain variables to solve a specific problem for the user's wish.

*  Linear problem: **Simplex**
*  Non-linear problem : **Projected Gradient Descent**


## Considerations

The following are considerations to have when trying the tool.


### - Disclaimer

This is a simulator, and should not be treated as a diciding tool for real miners in order to use their GPUs.
All the data used was taken from the internet and could be deprecated in some future, so if you try the tool be sure to have the data you want.

### - Data

All the data used was obtained from [Whattomine](https://whattomine.com/gpus?nvidia=true&amd=true&filter=all)



---
title: "README"
output: html_document
---

## MBH - model based hypervolumes

This package can be used to construct empirical and model-based hypervolumes to produce hypervolumes of structured or nested ecological data. 

## Installation

The MBH package can be installed from Github using the `install_github` function in the  **devtools** package

```{r}
install.packages("devtools") #if not already installed
library(devtools)
install_github("susanjarvis501/MBH")
library(MBH)
```

To run the models you will need to have an installation of [JAGS](http://mcmc-jags.sourceforge.net/) on your computer. 

## Examples

### Empirical hypervolumes

Fitting an empirical hypervolume ignores any group structure.

```{r}
#simulate multivariate data with 4 variables, 5 groups and 20 observations per group.

dat1 <- simulate_dataMBH(nobs = 20, ngroups = 5, ndims = 4)

#fit empirical hypervolume ignoring groups

hv1 <- fitMBH(dat1$data, groups = NULL, vars = c("V1", "V2", "V3", "V4"))

#plot hypervolume

plotMBH(hv1)

```

### Model-based hypervolumes

Hypervolumes are fitted including a random effect for group.

```{r}
#fit model-based hypervolume

hv2 <- fitMBH(dat1$data, groups = "Group", vars = c("V1", "V2", "V3", "V4"))

#plot hypervolume

plotMBH(hv2)

```

You can also use `plotMBH` to view the individual group ellipses

```{r}
plotMBH(hv2, groupellipses = TRUE)
```

## Other functions

`overlapMBH` can be used to estimate overlap between two hypervolumes. Note this function works by simulating a large number of points in each hypervolume and testing inclusion of each point in the other hypervolume and can be computationally demanding.

```{r}
overlapMBH(hv1, hv2, ndraws = 99)
```

`inclMBH` can be used to test the probability of inclusion of new data points in a calculated hypervolume. Note the number of dimensions and variable names must be the same

```{r}
newdat <- simulate_dataMBH(nobs = 2, ngroups = 5, ndims = 4)
inclMBH(hv2, newdat$data)
plotMBH(hv2)
points(newdat$data$V1, newdat$data$V2)
```


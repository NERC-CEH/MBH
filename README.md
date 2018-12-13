---
title: "README"
output: html_document
---

## MBH - model based hypervolumes

This package can be used to construct empirical and model-based hypervolumes to produce hypervolumes of structured or nested ecological data. 

## Examples

### Empirical hypervolumes

Fitting an empirical hypervolume ignores any group structure.

```{r}
#simulate multivariate data with 4 variables, 5 groups and 20 observations per group.

dat1 <- simulate_dataMBH(nobs = 20, ngroups = 5, ndims = 4)

#fit empirical hypervolume ignoring groups

hv1 <- fitMBH(dat1$data, groups = NULL)

#plot hypervolume

plotMBH(hv1)

```

### Model-based hypervolumes

Hypervolumes are fitted including a random effect for group.

```{r}
# fit model-based hypervolume

hv2 <- fitMBH(dat1$data, groups = "Group")

#plot hypervolume

plotMBH(hv2)

```



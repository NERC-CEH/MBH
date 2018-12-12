#' simulate_dataMBH
#'
#' This simulates multivariate data to fit model based hypervolumes
#'
#' @param nobs Number of observations to simulate per group
#' @param ndims Number of variables to simulate
#' @param ngroups Number of groups to simulate
#' @param sdgrp Standard deviation of group means
#' @param sdobs Standard deviation of observations within groups. Either a single value or vector with length equal to ndims. If NULL (default) a vector of length equal to ndims is generated from a Uniform distribution with bounds 1 and 10. Note that if sdobs = NULL the vector generated is on the variance scale, if sdobs is provided then it should be a standard deviation
#' @param variances Either "fixed" to constrain within-group variances to be the same (the default), or "variable" so within-group variances can vary
#' @param vardiff Standard deviation of within-group variance differences
#' @param means Means of each variable to simulate
#' @param returntruecov Logical. Return true covariance matrix as well as data? Defaults to FALSE
#' @return data - simulated data
#' @return (optional) truecov - covariance matrix used to simulate data
#' @export

simulate_dataMBH <- function(nobs = 10, ndims = 3, ngroups = 4, sdgrp = 2, sdobs = NULL, variances = "fixed", vardiff = 0.5, means = rep(0,ndims), returntruecov = FALSE){

  #create a random covariance matrix
  n <- ndims
  p <- qr.Q(qr(matrix(stats::rnorm(n^2), n)))
    if(is.null(sdobs)){
      truecov <- crossprod(p, p*(stats::runif(ndims,1,10)))
    } else {
      truecov <- crossprod(p, p*(sdobs^2))
    }

  #create an empty array for the data
  Y <- array(NA, dim = c(nobs,ngroups,ndims))

  #if within-group variances are fixed, simulate the required number of observations from a multivariate normal with the true covariance matrix and a random mean vector (with standard deviation defined by between-group variance parameter)
  if (variances == "fixed"){

    for(j in 1:ngroups){
      Y[,j,] <- mvtnorm::rmvnorm(nobs, mean = stats::rnorm(ndims,means,sdgrp), sigma = truecov)
    }
  }

  #if within-group variances are not fixed, add some variation to the within-group variances, then simulate the required number of observations as above
  if (variances == "variable"){

    for(j in 1:ngroups){
      truecor <- stats::cov2cor(truecov)
      sds <- sqrt(diag(truecov))
      sds1 <- sqrt(diag(truecov)) + stats::runif(3,-vardiff, vardiff)
      newcov <- sweep(sweep(truecor, 1L, sds1, "*"), 2L, sds1, "*")
      Y[,j,] <- mvtnorm::rmvnorm(nobs, mean = stats::rnorm(ndims,0,sdgrp), sigma = newcov)
    }
  }

  #condense the array to a dataframe
  Ydf <- as.data.frame(apply(Y,3L,c))

  #add a field to denote group membership
  Ydf$Group <- rep(1:ngroups, each = nobs)

  #return the dataframe and (if specified) the true covariance matrix
  if(returntruecov == TRUE){
    outlist <- list("data" = Ydf, "truecov" = truecov)
    return(outlist)
  } else{
    outlist <- list("data" = Ydf)
    return(outlist)
  }
}

#dat1 <- simulate_dataMBH()
#dat1

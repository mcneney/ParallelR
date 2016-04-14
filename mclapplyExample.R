############################################
## Serial version.
# example simulation function -- about as simple as it gets
exsimfunc = function() {
  x = rnorm(100)
  return(c(mean(x),sd(x)))
}

# code to do many replicates of the simulation and save the results in a matrix
NREPS = 10000 # number of simulation replicates
NOUT = 2 # number of outputs to record per replicate
simout = matrix(NA,nrow=NREPS,ncol=NOUT) # output matrix
set.seed(123) # set random seed so we can replicate results
for(i in 1:NREPS) {
  simout[i,] = exsimfunc()
}
simout

##########################################
## Parallel version.
library(parallel)

NREPS=10000 # same as before

NPROC = 5 # number of processors to use

exsimfunc = function() { # same as before
  x = rnorm(100)
  return(c(mean(x),sd(x)))
}

# simwrapper() encapsulates the simulation code. We'll have the mclapply()
# function from the parallel package call this on separate processors.
simwrapper = function(pNREPS) {
  NOUT = 2
  simout = matrix(NA,nrow=pNREPS,ncol=NOUT)
  for(i in 1:pNREPS) {
    simout[i,] = exsimfunc()
  }
  simout
}

# Set up a vector whose elements are the number of simulation
# replicates to do per processor. In this example, the vector is
# (2000,2000,2000,2000,2000).
simwrapper.args = rep(NREPS/NPROC,NPROC)

# Random numbers drawn on each processor can be highly correlated or even
# identical. The argument "L'Ecuyer" to set.seed() avoids this. Unfortunately,
# the details of how it does so are difficult to follow, but you can read the
# documentation for set.seed if you are interested.
set.seed(123,"L'Ecuyer")

# Call simwrapper() on each element of simwrapper.args. The mclapply() function
# sends the work to mc.cores=NPROC processors and then collects the results.
mc.simout = mclapply(simwrapper.args,simwrapper,mc.cores=NPROC)

# mc.simout is a list whose elements are simulation results from each
# processor. Combine into a single matrix using the Reduce() function.
simout = Reduce(rbind,mc.simout)

## Aside: R guru's will advise you to make the call to mclapply and
## combine the results all in one go with
simout = do.call(rbind,mclapply(simwrapper.args,simwrapper,mc.cores=NPROC))
## but I can never remember what do.call does, so I avoid it.


# ParallelRDemos
Code snippets to illustrate parallel computing with R

* README.md: This file
* mclapplyExample.R: First example circulated by email on March 2, 2016.
Simple parallel simulation using `mclapply()`, a parallel version of 
`lapply()`. To use `mclapply` for simulations requires that the 
simulation code be encapsulated in a function that `mclapply` can call. 

# Installation

Please make sure that you have the most up-to-date R version :)

# Climate data operators (cdo)

First, install `cdo` in your computer. The [`cdo` website](https://code.mpimet.mpg.de/projects/cdo/wiki) details the different ways to install this in your computer.

For Mac users, I would suggest using HomeBrew and run `brew install cdo`.

For Windows users, run `sudo apt-get install cdo`.

For Linux users, I believe it is just running `apt-get install cdo`. 

cdo is Unix friendly (and was built, I believe, using a Linux OS), so there might be some other packages that need to be installed to use `cdo` in Windows, but should be an easy install for Linux and Mac users.

# Install `hotrstuff`

`hotrstuff` is still in development, so the installation process is not the most straight forward. I'll try to give detailed instructions here, but happy to help anyone live if anyone has questions on installation.

## [preferred way] If you are familiar with GitHub
1. Fork `hotrstuff` from [https://github.com/SnBuenafe/hotrstuff](https://github.com/SnBuenafe/hotrstuff)
2. Clone the forked repository into your laptops.
3. **IMPORTANT**: Using the `devel_tin` branch, open `hotrstuff.Rproj`, and run `devtools::install()` on the console. *Note: If you don't have `devtools` installed, you might need to install it before running that code. Simply run `install.packages("devtools")`
4. Once finished, close `hotrstuff.Rproj` and in the `CodingClub_Climate_Models.Rproj`, you should be able to now load `hotrstuff` into your environment through `library(hotrstuff)`.

This is the preferred way because once I update the code, it should be easy to update your version of `hotrstuff` on your computer as well.

## If you are not familiar with GitHub
1. I will have emailed a .zip file containing all the most recent `hotrstuff` stuff ;)
2. Uncompress the .zip file and do steps 3-4 above.

# Install the following packages

Here are the other packages that we are going to use for this session:

`install.packages(c("tidyverse", "terra", "tmap", "here", "rcdo"))`

# Documentation

Unfortunately, I haven't had the time to work on a markdown for this session, but I will do so in the future with the same material! I will send that around when I get to it, but in the meantime, I have prepared a (very bare and black-and-white) presentation and have included some resources that I think are useful when starting to work with Earth System Models (ESMs) in the `docs/` directory.

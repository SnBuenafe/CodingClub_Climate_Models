# DESCRIPTION: Introduction to wrangling climate models
# Written by: Tin Buenafe
# Last modified: 12/11/2025

# Load preliminaries ------------------------------------------------------

# Load packages
library(hotrstuff) # this will be the primary package we're using when wrangling climate data; please see email for detailed instructions on how to install — you would need to be a bit familiar with GitHub to be able to install the development version of this package! The instructions are also in the README of this repository
library(tidyverse)
library(here)
library(terra)
library(tmap)

# Load data that will be used
mask <- rast(here("data", "raw", "mask", "global_raster.tif"))

# 1. Downloading climate models ----------------------------------------------
# As I have demonstrated, we will use monthly surface temperature data in the ocean from the GFDL-ESM4 model and the SSP3-7.0 scenario

htr_download_ESM(hpc = NA,
                 indir = here("data", "raw", "wget"),
                 outdir = here("data", "raw", "raw_esm"),
                 quiet = FALSE
                 )

# In the repository, I have included these raw ESMs (in data/raw/raw_esm) to save us time

# 2. Merging different files into one model-scenario-variable combination --------



# 3. 'Slicing' files to the appropriate time periods -------------------------




# 4. Regridding -----------------------------------------------------------


# 5. Filling missing data -------------------------------------------------


# 6. Masking --------------------------------------------------------------



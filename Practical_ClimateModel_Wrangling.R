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
library(rcdo)

# Load data that will be used
mask <- rast(here("data", "raw", "mask", "global_raster.tif"))

# 1. Downloading climate models ----------------------------------------------
# As I have demonstrated, we will use monthly surface temperature data in the ocean from the GFDL-ESM4 model and the SSP3-7.0 scenario

htr_download_ESM(indir = here("data", "raw", "wget"),
                 outdir = here("data", "raw", "raw_esm"),
                 quiet = FALSE
                 )

# In the repository, I have included these raw ESMs (in data/raw/raw_esm) to save us time

# 2. Merging different files into one model-scenario-variable combination --------
# As you can see, some models have split their model outputs into different files. We want to merge these files to make sure that we only have one file per model-scenario-variable combination.

htr_merge_files(indir = here("data", "raw", "raw_esm"),
                outdir = here("data", "output", "merged"),
                year_start = 2015,
                year_end = 2100)

# Let's see how these look like
merged_ras <- rast(here("data", "output", "merged", "tos_Omon_MPI-ESM1-2-LR_ssp370_r1i1p1f1_merged_20150101-21001231.nc"))
merged_ras

tm_shape(merged_ras) +
  tm_raster("tos_1")

# 3. 'Slicing' files to the appropriate time periods -------------------------

# There are instances where you are only interested in a portion of the time periods included in the file, or like me, you might need to have different time periods in the same analysis (e.g., near-future, mid-century, end-of-the-century).
# This function allows you to make new files that conveniently slice the file into the time periods that you are interested in.

# As an example, let's say we're only interested in the end-of-the-century (2075-2100)

htr_slice_period(indir = here("data", "output", "merged"),
                 outdir = here("data", "output", "sliced"),
                 freq = "Omon",
                 scenario = "ssp",
                 year_start = 2075,
                 year_end = 2100,
                 overwrite = FALSE)

# Let's see how these look like
sliced_ras <- rast(here("data", "output", "sliced", "tos_Omon_MPI-ESM1-2-LR_ssp370_r1i1p1f1_merged_20750101-21001231.nc"))
sliced_ras

# 4. Regridding -----------------------------------------------------------

# Regridding is important to standardize
# There are different regridding methods (e.g., remapbil - bilinear interpolation or remapcon — conservation remapping) and choosing which method you should use depends on the model and the variable. Generally, I use remapbil for most variables and models and use remapcon for precipitation.

htr_regrid_esm(indir = here("data", "output", "sliced"),
               outdir = here("data", "output", "regridded"),
               cell_res = 0.25,
               layer = "merged")

# Let's check this
regridded_ras <- rast(here("data", "output", "regridded", "tos_Omon_MPI-ESM1-2-LR_ssp370_r1i1p1f1_RegriddedMerged_20750101-21001231.nc"))
regridded_ras

tm_shape(regridded_ras) +
  tm_raster("tos_1",
            col.scale = tm_scale_continuous())

# 5. Filling missing data -------------------------------------------------
# TODO: Talk about why one might want to fill missing data

htr_fill_missing(indir = here("data", "output", "regridded"),
                 outdir = here("data", "output", "filled"),
                 method = "setmisstodis", # using inverse weighted distance to fill missing values
                 neighbors = 4
                 )

# Checking...
filled_ras <- rast(here("data", "output", "filled", "tos_Omon_MPI-ESM1-2-LR_ssp370_r1i1p1f1_RegriddedMerged_20750101-21001231.nc"))
filled_ras

tm_shape(filled_ras) +
  tm_raster("tos_1",
            col.scale = tm_scale_continuous())

# 6. Masking --------------------------------------------------------------
# Let's now remove the results that intersect with land
# We can easily do this using terra!

# Let's take a look at the mask we loaded
tm_shape(mask) +
  tm_raster()

# See that the ocean cells (here, the cells that we are interested in) have values of 1
# To mask the ESM, we'll simply multiply these two rasters that should have the same extent
masked_ras <- filled_ras*mask

tm_shape(masked_ras) +
  tm_raster("tos_1",
            col.scale = tm_scale_continuous())

# Voila!

# Bonus: Fiddling! --------------------------------------------------------
# We have now prepared our ESM. There are many other functions that can be used and will be happy to talk about them if we have time :)

# Let's first change the names of the raster to something more meaningful
names(masked_ras)
names(masked_ras) <- time(masked_ras)
names(masked_ras)

# Now, let's say we want to take the mean monthly temperature across the time period, we can easily do that using terra
global(masked_ras, fun = "mean", na.rm = TRUE)

# We can also apply a function across all the cells in the raster to show something spatially
tst <- app(masked_ras, fun = "mean", na.rm = TRUE)

tm_shape(tst) +
  tm_raster(col.scale = tm_scale_continuous())

# Those are the basics of looking at ESMs! I'll be happy to answer any questions you may have :)


# Using rcdo --------------------------------------------------------------

cdo_yearmonmean(ifile = here("data", "output", "regridded", "tos_Omon_MPI-ESM1-2-LR_ssp370_r1i1p1f1_RegriddedMerged_20750101-21001231.nc"), ofile = here("data", "output", "temp.nc")) %>%
  cdo_execute()

# let's check what that is
cdo_sinfo(here("data", "output", "temp.nc")) %>%
  cdo_execute()

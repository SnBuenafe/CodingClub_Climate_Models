# DESCRIPTION: Prepping workshop materials
# Written by: Tin Buenafe
# Last modified: 12/11/2025

# Create new folder within docs
ifelse(!dir.exists(file.path("resources")), dir.create(file.path("resources")), FALSE)

# Update zip with new bits and pieces and copy to docs folder
utils::zip(zipfile = "resources/ClimateModel_CodingClub.zip",
           files = c(
             "data/raw/",
             "docs",
             "Practical_ClimateModel_Wrangling.R",
             "CodingClub_Climate_Models.Rproj",
           ))

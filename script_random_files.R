# Load packages and functions
require(tcltk)
source("random_files.R")

# Set seed to reproduce results
set.seed(1001)

# Select folder with recordings
path <- tcltk::tk_choose.dir()

# Percentage or number of recordings
percent_number <- 0.2

# Random sampling of files
random_files(path, percent_number, pattern = "wav$|WAV$")

# Runs the scripts in the desired order.

#TODO: replace this file with an actual makefile or find a better solution.


# Loads all the files where functions are defined
files <- list.files(path = here::here("R"), pattern = "*.R", full.names = TRUE,
                    recursive = FALSE)
for (i in files) {
  source(i)
}

# Prepare data.
source("analysis/data_preparation.R")

# Generate a dashboard.
rmarkdown::render(here::here('analysis/dashboard/dashboard.Rmd'))

# Generate a report.
rmarkdown::render(here::here('analysis/survey_report.Rmd'))

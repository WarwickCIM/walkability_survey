# Runs all scripts in order.

rmarkdown::render(here::here('analysis/dashboard.Rmd'), output_file = here::here('vignettes/dashboard.html'))

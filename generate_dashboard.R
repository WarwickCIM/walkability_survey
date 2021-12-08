# Runs all scripts in order.

rmarkdown::render('analysis/dashboard.Rmd', output_file = here::here('docs/dashboard.html'))

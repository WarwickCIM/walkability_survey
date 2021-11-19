This repo is part of the _Walkability Perception and its Relations to Scenery Elements and Socio-Demographics  – A Study based on Street View Imagery and Automatic Image Interpretation_ research project.

Project contains  all the code and data aimed to analyse a survey on perceived walkability.

## Who are we? 

Dr Tessio Novack, Dr James Tripp and Dr Carlos Camara Menoyo. We are researchers from the 
[University of Warwick](https://warwick.ac.uk). 
 
## What are our interests? 

This study examines ‘walkability’. Specifically, what makes an area seem more or less walkable? 
 
## What is in this questionnaire? 
We ask about demographic information, a short personality inventory, for ratings of images, 
information on your past experience and influences on your ratings. No personal data from you will 
be collected at any point, and we will not have any way to trace your answers to you


## Installation

1. Clone this repo: `git clone git@github.com:WarwickCIM/walkability_survey.git`
2. Install `renv` if not already installed (instructions [here](https://rstudio.github.io/renv/index.html)).
2. Run `renv::restore()` to restore the state of your project from `renv.lock`.

## Updating packages

1. Install packages as usual.
2. Run `renv::snapshot()` to update `renv.lock`.
3. Create a commit with `renv.lock` changes and push it to the repo.

## Folder structure

``` bash
.
├── analyses      -> rmd files containing reports, papers...
├── data          -> data files
│   └── data-raw  -> original, raw data
├── img           -> images to be used in the reports and papers
│   └── cases     -> figures from our case study
├── man           -> documentation autogerated from comments
├── R             -> functions used in the project
└── renv          -> r environment, for reproducible code (ignored from repo)
    ├── library
    │   └── R-4.0
    └── staging
```

## Troubleshooting

If facing issues installing packages from Windows, run this command. (more info [in `renv` documentation](https://rstudio.github.io/renv/articles/renv.html#downloads-1) and [in this discussion](https://community.rstudio.com/t/cant-install-packages-with-renv/96696/6))

```
Sys.setenv(RENV_DOWNLOAD_METHOD = "libcurl")
```

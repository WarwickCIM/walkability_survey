# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Install Package:           'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'


#' Prepares dataframe with survey responses.
#' @description Reads a csv file containing qualtrics' export and cleans data.
#' @param file String pointing to the csv file.
#' @return Clean and tidy dataset with anonymised responses, ready to analise.
data_preparations <- function(file) {
  df <- readr::read_csv(here::here(file), skip = 1) %>%
    dplyr::filter(row_number() != 1) %>%
    janitor::clean_names() %>%
    # Removes sensitive data.
    select(-ip_address, -recipient_last_name, -recipient_first_name,
           -recipient_email, -prolific_id)

}

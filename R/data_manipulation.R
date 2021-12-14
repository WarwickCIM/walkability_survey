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
  df <- readr::read_csv(here::here(file), skip = 1, na = c("", " "),
                        col_type = list(.default = col_character())) %>%
    # Qualtrics adds comments to row one. They need to be removed.
    dplyr::filter(row_number() != 1) %>%
    # Cleaning up messy names.
    janitor::clean_names() %>%
    # Removes sensitive data.
    select(-ip_address, -recipient_last_name, -recipient_first_name,
           -recipient_email, -prolific_id, -external_data_reference) %>%
    # Remove responses from people deciding to opt out.
    filter(consent_agreement != "No") %>%
    # Further naming improvements.
    rename(gender = gender_selected_choice,
           gender_description = gender_prefer_to_self_describe_text) %>%
    # Change types.
    mutate(start_date = lubridate::ymd_hms(start_date),
           end_date = lubridate::ymd_hms(end_date),
           recorded_date = lubridate::ymd_hms(recorded_date)) %>%
    # Change factor order.
    mutate(gender = str_replace(gender, "Prefer to self-describe", "Other"),
           gender = fct_relevel(as.factor(gender),
                                levels = c("Female", "Male", "Non-binary",
                                           "Other")))

  # Rename long variables.
  # TODO: make this work!
  # for (i in 1:15) {
  #   df <- df %>%
  #     rename(!!as.name(paste0("enjoyment_img", i, "_")) := !!as.name(paste0("enjoyment_img", i, "_i_would_enjoy_walking_in_this_area")),
  #            !!as.name(paste0("aesthetics_img", i, "_")) := !!as.name(paste0("aesthetics_img", i, "_i_find_this_street_beautiful")),
  #            !!as.name(paste0("safety_img", i, "_")) := !!as.name(paste0("safety_img", i, "_i_would_feel_safe_walking_on_this_street")),
  #            !!as.name(paste0("vibrancy_img", i, "_")) := !!as.name(paste0("vibrancy_img", i, "_this_street_is_socially_vibrant")))
  #
  # }

}


# Functions related to image ratings.


# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Install Package:           'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'


#' Creates a dataframe with images' ratings.
#' @description Reads a clean dataframe with responses and generates a long
#'   dataset with all image ratings, associated to every response_id.
#' @param df Dataframe with survey's responses, after being cleaned by data_preparations().
#' @return A long dataframe with image ratings and responses_id, ready to combine
#'   it with other sources.
get_image_ratings <- function(df) {

  ratings_df_wide <- data.frame(
    response_id = character(),
    image_num = integer(),
    enjoyment_rating = character(),
    aesthetics_rating = character(),
    safety_rating = character(),
    vibrancy_rating = character()
  )

  ratings_df <- data.frame(
    response_id = character(),
    image_num = integer(),
    item = character(),
    rating = character()
  )

  for (i in 1:15) {
    ratings_df_tmp <- df %>%
      select(response_id, paste0("image_", i), starts_with(c(
       paste0("enjoyment_img", i, "_"), paste0("aesthetics_img", i, "_"),
        paste0("safety_img", i, "_"), paste0("vibrancy_img", i, "_")))) %>%
      rename(image_num = paste0("image_", i)) %>%
      pivot_longer( starts_with(
        c("enjoyment_", "aesthetics_", "safety_", "vibrancy_")),
        names_to = "item", values_to = "rating") %>%
      mutate(item = case_when(
        str_detect(item, "enjoyment_") ~ "enjoyment",
        str_detect(item, "aesthetics_") ~ "aesthetics",
        str_detect(item, "vibrancy_") ~ "vibrancy",
        str_detect(item, "safety_") ~ "safety")) %>%
      mutate(across(everything(), as.character)) %>%
      mutate(image_num = as.integer(image_num))


    ratings_df <- ratings_df %>%
      bind_rows(ratings_df_tmp)

  }

  ratings_df <- ratings_df %>%
    mutate(rating = fct_relevel(
      rating, c("Strongly disagree", "Disagree", "Neither Agree or Disagree",
                "Agree", "Strongly Agree")))

  return(ratings_df)

}

#' Generates a reactable with total ratings per image.
#' @description Generates an html table (reactable) with the total votes per
#'   image and category.
#' @param df A long dataframe with image ratings with survey's responses, after
#'   being processed by get_image_ratings.
#' @param rating_category A string containing the rating categories to be filtered out.
#'   Possible values: "aesthetics", "enjoyment", "safety" or "vibrancy".
#' @param img_width A number defining the images' width in pixels.
#' @return An html widget with a reactable with ratings of a given category for
#'   all images.
get_ratings_table <- function(df, rating_category, img_width = 160){
  df %>%
    count(image_num, item, rating) %>%
    mutate(img = paste0("<a href='https://raw.githubusercontent.com/WarwickCIM/walkability_survey/gsv_images/img/",image_num, "_composite.jpg'>",
                        "<img src='https://raw.githubusercontent.com/WarwickCIM/walkability_survey/gsv_images/img/", image_num, "_composite.jpg' width='", img_width, "px'> </a>")) %>%
    relocate(img, .after = image_num) %>%
    filter(item == rating_category) %>%
    select(-item) %>%
    arrange(rating) %>%
    pivot_wider(names_from =rating, values_from = n) %>%
    arrange(image_num) %>%
    reactable(
      searchable = TRUE,
      # pagination = FALSE,
      defaultSorted = list("Strongly Agree" = "desc"),
      defaultColDef = colDef(sortNALast = TRUE),
      columns = list(
        img = colDef(html = TRUE)
      ))
}

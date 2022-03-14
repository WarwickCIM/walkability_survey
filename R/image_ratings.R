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

  # ratings_df_wide <- data.frame(
  #   response_id = character(),
  #   image_num = integer(),
  #   enjoyment_rating = character(),
  #   aesthetics_rating = character(),
  #   safety_rating = character(),
  #   vibrancy_rating = character()
  # )

  ratings_df <- data.frame(
    response_id = character(),
    # cluster = character(),
    image_num = character(),
    item = character(),
    rating = character()
  )

  # There are four clusters. Each cluster has 3 sets of images that are
  # displayed from 1:33, 34:66 and 67:99.
  for (c in 0:4) {
    for (i in 1:3) {
      ratings_df_tmp <- df %>%
        mutate(cluster = paste0("C", c)) %>%
        select(response_id, cluster, paste0("img_c", c, "_", i), starts_with(c(
          paste0("enjoyment_img_c", c, "_", i),
          paste0("aesthetics_img_c", c, "_", i),
          paste0("safety_img_c", c, "_", i),
          paste0("vibrancy_img_c", c, "_", i)))) %>%
        unite(image_num,
          cluster, paste0("img_c", c, "_", i)) %>%
        # rename(image_num = paste0("img_c", c, "_", i)) %>%
        pivot_longer( starts_with(
          c("enjoyment_", "aesthetics_", "safety_", "vibrancy_")),
          names_to = "item", values_to = "rating") %>%
        mutate(item = case_when(
          str_detect(item, "enjoyment_") ~ "enjoyment",
          str_detect(item, "aesthetics_") ~ "aesthetics",
          str_detect(item, "vibrancy_") ~ "vibrancy",
          str_detect(item, "safety_") ~ "safety")) %>%
        mutate(across(everything(), as.character)) %>%
        # mutate(image_num = as.integer(image_num)) %>%
        filter(!is.na(rating))

      ratings_df <- ratings_df %>%
        bind_rows(ratings_df_tmp)
    }
  }

  ratings_df <- ratings_df %>%
    mutate(rating = fct_relevel(
      rating, c("Strongly Disagree", "Disagree", "Neutral",
                "Agree", "Strongly Agree"))) %>%
    # Create a numeric rating.
    mutate(cluster = as.factor(str_sub(image_num, 1, 2)),
           rating_n = as.numeric(rating))

  ratings_df_extended <- df %>%
    select(response_id, gender, age, ethnicity,
           sexual_orientation_selected_choice, inmigration_background,
           mobility_disabilities, local_knowledge_london) %>%
    left_join(ratings_df, by = "response_id")

  return(ratings_df_extended)
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
                        "<img src='https://raw.githubusercontent.com/WarwickCIM/walkability_survey/gsv_images/img/s/", image_num, "_composite.jpg' width='", img_width, "px'> </a>")) %>%
    relocate(img, .after = image_num) %>%
    filter(item == rating_category) %>%
    select(-item) %>%
    arrange(rating) %>%
    pivot_wider(names_from =rating, values_from = n) %>%
    arrange(image_num) %>%
    reactable(
      searchable = TRUE,
      # pagination = FALSE,
      striped = TRUE,
      highlight = TRUE,
      bordered = TRUE,
      defaultSorted = list("Strongly Agree" = "desc"),
      defaultColDef = colDef(sortNALast = TRUE),
      columns = list(
        img = colDef(html = TRUE)
      ))
}

wkb_avg_rating_category <- function(df, my_category) {
  my_category <- enquo(my_category)


  df <- df %>%
    select(
      !!my_category,
      starts_with(
        c("enjoyment_", "aesthetics_", "safety_", "vibrancy_")
      )
    ) %>%
    pivot_longer(!!my_category,
      names_to = "question", values_to = "answer"
    ) %>%
    mutate(
      question = case_when(
        str_detect(question, "enjoyment_") ~ "enjoyment",
        str_detect(question, "aesthetics_") ~ "aesthetics",
        str_detect(question, "vibrancy_") ~ "vibrancy",
        str_detect(question, "safety_") ~ "safety"
      ),
      answer = fct_relevel(
        answer, c(
          "Strongly Disagree", "Disagree", "Neutral", "Agree",
          "Strongly Agree"
        )
      )
    ) %>%
    count(!!my_category, question, answer) %>%
    arrange(!!my_category, question, answer) %>%
    filter(!is.na(answer))

  return(df)
}


#' Create stacked barplots.
#' @description Creates a stacked barplot using ggplot, with optional facetting.
#' @param df Regular Dataframe
#' @param my_category Category that will be used for classification. Can be a
#'   vector.
#' @param my_title String that will be used for Plot's title.
#' @param my_palette String containing a color brewer palette.
ci_barplot_horizontal <- function(df, my_category, my_title, my_facet = NULL,
                                  my_palette = "Paired") {
  my_category <- enquo(my_category)
  my_facet <- enquo(my_facet)

  if (is.null(my_facet)) {
    df <- df %>%
      filter(!!my_category != "") %>%
      count()
  } else {
    df <- df %>%
      filter(!!my_category != "") %>%
      group_by(!!my_facet, !!my_category)
  }

  df <- df %>%
    select(gender, age) %>%
    count(gender, age) %>%
    arrange(gender, age)

  p <- ggplot(demographics_df, aes(x = age, y = n, fill = gender)) +
    geom_bar(position = "dodge", stat = "identity") +
    facet_grid(vars(gender)) +
    scale_fill_brewer(palette = "Pastel1") +
    labs(
      title = "Demographics' distribution",
      x = NULL, y = NULL
    ) +
    theme_minimal() +
    theme(
      axis.line.x = element_blank(),
      strip.text = element_text(size = 14, margin = margin(0, 0, 0.2, 0, "cm")),
      legend.position = "bottom",
      legend.justification = "right",
      legend.margin = margin(4.5, 0, 1.5, 0, "pt"),
      legend.spacing.x = grid::unit(4.5, "pt"),
      legend.spacing.y = grid::unit(0, "pt"),
      legend.box.spacing = grid::unit(0, "cm")
    )


  df <- df %>%
    summarise(total = n()) %>%
    mutate(percent = percent(round(total / sum(total), digits = 2))) %>%
    arrange(desc(total)) %>%
    mutate(order = "1")

  # View(df)

  if (!is.null(my_facet)) {
    p <- ggplot(df, aes_q(x = quote(order), y = quote(total), fill = my_category)) +
      geom_bar(stat = "identity", position = "fill") +
      geom_text(aes(label = total),
        colour = "white",
        position = position_fill(vjust = 0.5)
      ) +
      scale_y_continuous(labels = percent(c(0, 0.25, 0.5, 0.75, 1))) +
      facet_wrap(as.formula(paste("~", my_facet)), ncol = 1) +
      ggtitle(my_title) +
      labs(x = "", y = "", fill = "") +
      scale_fill_brewer(palette = my_palette, direction = -1) +
      theme_minimal() +
      theme(axis.text.y = element_blank()) +
      theme(legend.position = "bottom") +
      guides(fill = guide_legend(ncol = 2)) +
      coord_flip()
  } else {
    p <- ggplot(df, aes_q(x = quote(order), y = quote(total), fill = my_category)) +
      geom_bar(stat = "identity", position = "fill") +
      geom_text(aes(label = total),
        colour = "white",
        position = position_fill(vjust = 0.5)
      ) +
      scale_y_continuous(labels = percent(c(0, 0.25, 0.5, 0.75, 1))) +
      ggtitle(my_title) +
      labs(x = "", y = "", fill = "") +
      scale_fill_brewer(palette = my_palette, direction = -1) +
      theme_minimal() +
      theme(axis.text.y = element_blank()) +
      theme(legend.position = "bottom") +
      guides(fill = guide_legend(ncol = 2)) +
      coord_flip()
  }

  print(p)
}


#' Create horizontal barplots.
#' @description Creates a horizontal barplot using ggplot.
#' @param df Regular Dataframe
#' @param my_category Category that will be used for classification. Can be a
#'   vector.
#' @param my_title String that will be used for Plot's title.
ci_barplot_horizontal <- function(df, my_category, my_title, my_facet = NULL,
                                  my_palette = "Paired") {
  my_category <- enquo(my_category)
  my_facet <- enquo(my_facet)

  if (is.null(my_facet)) {
    df <- df %>%
      filter(!!my_category != "") %>%
      group_by(!!my_category)
  } else {
    df <- df %>%
      filter(!!my_category != "") %>%
      group_by(!!my_facet, !!my_category)
  }

  df <- df %>%
    summarise(total = n()) %>%
    mutate(percent = percent(round(total / sum(total), digits = 2))) %>%
    arrange(desc(total)) %>%
    mutate(order = "1")

  # View(df)

  if (!is.null(my_facet)) {
    p <- ggplot(df, aes_q(
      x = quote(order), y = quote(total),
      fill = my_category
    )) +
      geom_bar(stat = "identity", position = "fill") +
      geom_text(aes(label = total),
        colour = "white",
        position = position_fill(vjust = 0.5)
      ) +
      scale_y_continuous(labels = percent(c(0, 0.25, 0.5, 0.75, 1))) +
      facet_wrap(as.formula(paste("~", my_facet)), ncol = 1) +
      ggtitle(my_title) +
      labs(x = "", y = "", fill = "") +
      scale_fill_brewer(palette = my_palette, direction = -1) +
      theme_minimal() +
      theme(axis.text.y = element_blank()) +
      theme(legend.position = "bottom") +
      guides(fill = guide_legend(ncol = 2)) +
      coord_flip()
  } else {
    p <- ggplot(df, aes_q(
      x = quote(order),
      y = quote(total), fill = my_category
    )) +
      geom_bar(stat = "identity", position = "fill") +
      geom_text(aes(label = total),
        colour = "white",
        position = position_fill(vjust = 0.5)
      ) +
      scale_y_continuous(labels = percent(c(0, 0.25, 0.5, 0.75, 1))) +
      ggtitle(my_title) +
      labs(x = "", y = "", fill = "") +
      scale_fill_brewer(palette = my_palette, direction = -1) +
      theme_minimal() +
      theme(axis.text.y = element_blank()) +
      theme(legend.position = "bottom") +
      guides(fill = guide_legend(ncol = 2)) +
      coord_flip()
  }

  print(p)
}

% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/image_ratings.R
\name{get_ratings_table}
\alias{get_ratings_table}
\title{Generates a reactable with total ratings per image.}
\usage{
get_ratings_table(df, rating_category, img_width = 160)
}
\arguments{
\item{df}{A long dataframe with image ratings with survey's responses, after
being processed by get_image_ratings.}

\item{rating_category}{A string containing the rating categories to be filtered out.
Possible values: "aesthetics", "enjoyment", "safety" or "vibrancy".}

\item{img_width}{A number defining the images' width in pixels.}
}
\value{
An html widget with a reactable with ratings of a given category for
  all images.
}
\description{
Generates an html table (reactable) with the total votes per
  image and category.
}

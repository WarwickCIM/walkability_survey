library(walkabilitysurvey)

# Loads all the files where functions are defined
files <- list.files(path = here::here("R"), pattern = "*.R", full.names = TRUE,
                    recursive = FALSE)
for (i in files) {
  source(i)
}

df_beta_1 <- data_preparations("data/raw/survey_beta_GroupA_2022-02-17.csv") %>%
  mutate(group = "Beta")
df_beta_2 <- data_preparations("data/raw/survey_beta_GroupB_2022-02-17.csv") %>%
  mutate(group = "Beta")

df <- df_beta_1 %>%
  bind_rows(df_beta_2) %>%
  mutate(gender = fct_relevel(as.factor(gender),
                              levels = c("Female", "Male", "Non-binary",
                                         "Other"))) %>%
  select(!starts_with("timing_"))


write.csv(df, "data/output/survey_clean.csv")


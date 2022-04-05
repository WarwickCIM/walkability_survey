library(walkabilitysurvey)

# Loads all the files where functions are defined
files <- list.files(path = here::here("R"), pattern = "*.R", full.names = TRUE,
                    recursive = FALSE)
for (i in files) {
  source(i)
}

df_beta_1 <- data_preparations("data/raw/survey_beta_GroupA_2022-02-17.csv") %>%
  mutate(group = "Prolific 1")
df_beta_2 <- data_preparations("data/raw/survey_beta_GroupB_2022-02-17.csv") %>%
  mutate(group = "Prolific 1")

df_1 <- data_preparations("data/raw/survey_GroupA_2022-02-28.csv") %>%
  mutate(group = "Prolific 2")
df_2 <- data_preparations("data/raw/survey_GroupB_2022-02-28.csv") %>%
  mutate(group = "Prolific 2")

df_public <- data_preparations("data/raw/survey_networks_2022-03-14.csv") %>%
  mutate(group = "Public")

df <- df_beta_1 %>%
  bind_rows(df_beta_2) %>%
  bind_rows(df_1) %>%
  bind_rows(df_2) %>%
  bind_rows(df_public) %>%
  mutate(gender = fct_relevel(as.factor(gender),
                              levels = c("Female", "Male", "Non-binary",
                                         "Other"))) %>%
  select(!starts_with("timing_")) %>%
  # Addressing the problem of exceeded bandwidth limits that resulted in images
  # not being displayed.
  # The first person reporting not being able to see images was from
  # 28th Feb at 18:37.
  # We checked random answers from 18:00 and they seem to follow a criteria that
  # is not random. We'll be conservative and we will say that results after
  # 18:00 are not valid.
  filter(start_date < "2022-02-28 18:00:00") %>%
  filter(group != "Public")


write.csv(df, "data/output/survey_clean.csv", row.names = FALSE)


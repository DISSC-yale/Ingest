library(tidyverse)
# read data from data source projects
# and write to this project's `dist` directory

schoolvaxview <- vroom::vroom('../schoolvaxview/standard/data.csv.gz')

schoolvaxview_exempt <- vroom::vroom('../schoolvaxview/standard/data.csv.gz')

nis <- vroom::vroom('../nis/standard/data.csv.gz')

epic <- vroom::vroom('../epic/standard/children.csv.gz') %>%
  rename(N_epic = n_vaccine_mmr,
         mmr_pct_epic = mmr_receipt)




vax_age <- nis %>%
  filter(
    Geography %in%
      c(state.name, 'District of Columbia', 'United States') &
      birth_year %in%
      c(
        '2011',
        '2012',
        '2013',
        '2014',
        '2015',
        '2016',
        '2017',
        '2018',
        '2019',
        '2020',
        '2021',
        '2022',
        '2023',
        '2024',
        '2025'
      ) &
      dim1 == 'Age'
  ) %>%
  mutate(
    vax_order = as.numeric(as.factor(Vaccine)),
    Vaccine_dose = as.factor(paste(Vaccine, Dose)),
    Vaccine_dose = gsub('NA', '', Vaccine_dose),
    Vaccine_dose = trimws(Vaccine_dose)
  ) %>%
  dplyr::select(Geography, birth_year, age, Vaccine_dose, Outcome_value1,Outcome_value1_lcl,Outcome_value1_ucl,samp_size_vax) %>%
  rename(geography = Geography, vaccine = Vaccine_dose, value = Outcome_value1, value_lcl=Outcome_value1_lcl, value_ucl=Outcome_value1_ucl, sample_size=samp_size_vax)

log_write(
  vax_age,
  './Data/Webslim/childhood_immunizations/overall_rates.parquet'
)
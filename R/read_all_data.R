# this script reads every data file that has been obtained thus far, and
# binds them into a single table, with one observation per Country per Week
# this is useful to perform analysis, or to create the repository summary
weekly_osm_data = file.path("data", dir("data", "\\d{4}_w\\d{2}", recursive = TRUE))
message("Reading ", length(weekly_osm_data), " files ...", appendLF = FALSE)

# dplyr allows to perform data manipulation
library(dplyr, warn.conflicts = FALSE)

# read the data
weekly_osm_data = setNames(weekly_osm_data, basename(weekly_osm_data)) %>%
   lapply(read.csv, colClasses = c("factor", rep("double", 6)), quote = "") %>%
   bind_rows(.id = "File") %>%
   mutate(
      Year = sub("weekly_osm(\\d{4})_w(\\d{2})\\.csv", "\\1", File) %>% as.integer,
      Week = sub("weekly_osm(\\d{4})_w(\\d{2})\\.csv", "\\2", File) %>% as.integer,
      File = NULL
   ) %>%
   relocate(Year, Week) %>%
   as_tibble()

# inform the user
message(
   " weekly_osm_data created\nDATA",
   " FROM ", weekly_osm_data[1, "Year"],
   " week ", weekly_osm_data[1, "Week"],
   " TO ", weekly_osm_data[nrow(weekly_osm_data), "Year"],
   " week ", weekly_osm_data[nrow(weekly_osm_data), "Week"]
)

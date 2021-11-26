# this script expects a list of tables obtained from the website OSMstats
# then it aggregates those tables into a single Dataset, with one observation per Country
# finally it writes that Dataset, therefore the current week is stored in the Repository
stopifnot(exists("osmstats_tables"), length(osmstats_tables) == 7)

# dplyr allows to perform data manipulation
library(dplyr, warn.conflicts = FALSE)

# bind seven tables into one
osmstats_data = bind_rows(osmstats_tables, .id = "Date") %>%
   rename_with(sub, pattern = "\\s", replacement = "_") %>%
   # drop "(organised)" info, since its meaning is unknown
   rename(Contributors = "Contributors_(organised)") %>%
   mutate(Contributors = sub("\\s.+$", "", Contributors) %>% as.integer)

# count Countries and sum Contributors by Date
message("\nDAILY ACTIVITY (count of Countries and sum of Contributors)\n")
group_by(filter(osmstats_data, Contributors > 0), Date) %>%
   summarise(Countries = n(), Contribs = sum(Contributors)) %>%
   { \(x) capture.output(x)[-1][-2] %>% paste0("\n") %>% message }()

# aggregate observations by Country
group_by(osmstats_data, Country) %>%
   summarise(
      # compute average number of (daily) active Contributors
      # since sample size is constant (seven days), the average of averages will be valid
      Contributors_mean = round(mean(Contributors)),
      # compute peak number of active Contributors and Created elements (in a single day)
      # computing the sum of Contributors would be misleading; since anyone can be active
      # throughout the week, adding Contributors implies overestimation
      across(c(Contributors, Created_elements), max, .names = "{.col}_max"),
      # compute total number of Created, Modified and Deleted elements (for this week)
      # the Created and Deleted allow to compute the net element growth; whereas
      # the Modified must be understood as amount of modifications, not elements
      across(ends_with("_elements"), sum, .names = "{.col}_sum")
   ) %>%
   # drop rows without Contributors, and arrange in descending order
   filter(Contributors_max > 0) %>%
   arrange(desc(Contributors_max)) %>%
   # write data file
   write.csv(osmstats_file, quote = FALSE, row.names = FALSE)

message("DATA SAVED: ", osmstats_file, "\n")

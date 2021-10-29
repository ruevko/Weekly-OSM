# this script expects a date of execution, which must be Monday
# then it scrapes the website OSMstats, looking for data of the previous week
# as defined in ISO 8601: weeks start on Mondays, and the week that has 01 Jan
# is week 01 only if it has four or more days in the new year; see ?strptime
stopifnot(exists("date_of_exec"), as.character(date_of_exec, "%u") == "1")

# in OSMstats, if you request a date, you receive data for the previous date, therefore
# create a vector with values as "dates for the request" and names as "dates of the data"
dates_vector = setNames(date_of_exec - 6:0, date_of_exec - 7:1)

# inform the user
message(
   "DATA FROM ", names(dates_vector[1]),
   " TO ", names(dates_vector[7]),
   as.character(dates_vector[1], " (%G week %V)\n")
)

# rvest allows to perform web scraping
library(rvest)

# loop over the dates vector, requesting data for each day of the week
osmstats_tables = lapply(dates_vector, function (date) {

   message(as.character(date - 1, "%A's data ..."), appendLF = FALSE)

   # append a date to OSMstats' URL
   osmstats_url = "https://osmstats.neis-one.org/?item=countries&date="
   osmstats_url = paste0(osmstats_url, as.character(date, "%d-%m-%Y"))

   # request the page for that date, and extract its only table
   osmstats_page = read_html(osmstats_url, encoding = "UTF-8")
   osmstats_table = html_element(osmstats_page, xpath = "//table")

   # let OSMstats rest
   message("\tobtained"); Sys.sleep(1)

   # parse the table, and return it without its first column "No."
   html_table(osmstats_table)[-1]
})

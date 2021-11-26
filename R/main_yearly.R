# this script can be used to scrape all the data for a specific year, starting with 2011
# this should be used to populate the data folder, not to run as part of a workflow

year = 2021

# generate all the Mondays inside the specified year
year_mondays = as.Date(paste0(year + 0:1, "-01-01")) - 0:1
year_mondays = seq(from = year_mondays[1], to = year_mondays[2], by = 1)
year_mondays = year_mondays[as.character(year_mondays, "%u") == "1"]

# the service started Tue, 01 Nov 2011 (with the data for Mon, 31 Oct 2011)
# remove all the Mondays prior to that, and after present date; stop if empty
year_mondays = year_mondays[year_mondays > "2011-10-31" & year_mondays < Sys.Date()]
stopifnot(length(year_mondays) > 0)

# do the following for each of the Mondays
for (date_of_exec in as.list(year_mondays)) {

   # create data file name; stop if already exists
   osmstats_file = as.character(date_of_exec-1, "data/weekly_osm%G/weekly_osm%G_w%V.csv")
   stopifnot(! file.exists(osmstats_file))
   if (! dir.exists(dirname(osmstats_file))) { dir.create(dirname(osmstats_file)) }

   # source the relevant scripts
   source("R/scrape_tables.R")
   source("R/write_data.R")
   Sys.sleep(10)
}

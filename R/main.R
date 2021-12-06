# this script will run in a workflow every Monday, to scrape data for the previous week

date_of_exec = Sys.Date()

# if a workflow run ever fails: input the Monday (see below), run and commit the data
# date_of_exec = as.Date("YYYY-MM-DD")
if (as.character(date_of_exec, "%u") != "1") { stop("Execution date must be monday") }

# create data file name; stop if already exists
osmstats_file = as.character(date_of_exec-1, "data/weekly_osm%G/weekly_osm%G_w%V.csv")
if (file.exists(osmstats_file)) { stop("Data already exists for execution date") }
if (! dir.exists(dirname(osmstats_file))) { dir.create(dirname(osmstats_file)) }

# source the relevant scripts
source("R/scrape_tables.R")
source("R/write_data.R")
# source("R/write_readme.R")

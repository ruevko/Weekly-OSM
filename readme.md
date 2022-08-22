# Weekly OSM
LAST RUN: AUG 22, 2022

[OSMstats](https://osmstats.neis-one.org) is a website maintained by
[Pascal Neis](https://neis-one.org/about), containing "statistics of the free wiki
world map"; that is, statistics of [OpenStreetMap](https://www.openstreetmap.org).
Particularly, the [Countries tab](https://osmstats.neis-one.org/?item=countries)
records the daily activity in as many as 260 territories. This repository applies
web scraping to obtain, every Monday, the prior week's activity; it relies on the
`R` language and packages `renv`, `rvest` and `dplyr`.

## License
OpenStreetMap data (© OpenStreetMap contributors) has an
[Open Database License](license.txt). Products derived from it (such as
this repository) must be distributed with the same license; as stated at
OpenStreetMap's [Copyright webpage](https://www.openstreetmap.org/copyright):

> OpenStreetMap® is open data, licensed under the
[Open Data Commons Open Database License](https://opendatacommons.org/licenses/odbl)
(ODbL) by the [OpenStreetMap Foundation](https://wiki.osmfoundation.org/wiki/Main_Page)
(OSMF). You are free to copy, distribute, transmit and adapt our data, as long
as you credit OpenStreetMap and its contributors. If you alter or build upon
our data, you may distribute the result only under the same licence.

Credit goes to Pascal Neis for processing the daily contributions and grouping them
by country; note that this process may result in inaccuracies between 2% and 10%.

## Usage
This repository has a `main.yaml` workflow, scheduled to run around
03:13 UTC on Monday; it executes `R/main.R`, which in turn executes:
* [`R/scrape_tables.R`](R/scrape_tables.R) uses `rvest`
to obtain tables of data, from the OSMstats website
* [`R/write_data.R`](R/write_data.R) uses `dplyr`
to aggregate the data, and write it into a single file
* [`R/write_readme.R`](R/write_readme.R) updates this readme

In this way, the activity corresponding to the previous week is recorded into a
comma-separated values (.csv) file. Files for each week since October 31, 2011
are available in the data folder; to use them, start by cloning the repository:
```
git clone https://github.com/ruevko/Weekly-OSM.git
```

Then launch `R` inside the Weekly-OSM folder and run `renv::restore()`. `renv` is
a package that manages dependencies, and will install what is required to work with
the data. Finally, run `source("R/read_all_data.R")`; a `weekly_osm_data` tibble
will be created, containing all available observations up to that moment.

#' @title rrricanes
#' @description rrricanes is a web-scraping library for R designed to deliver
#' hurricane data (past and current) into well-organized datasets. With these
#' datasets you can explore past hurricane tracks, forecasts and structure
#' elements.
#'
#' This documentation and additional help articles
#' \href{https://ropensci.github.io/rrricanes/}{can be found online}.
#'
#' Text products (Forecast/Advisory, Public Advisory, Discussions and
#' Probabilities) are only available from 1998 to current. An effort will be
#' made to add prior data as available.
#'
#' @section Getting Storms:
#' List all storms that have developed by year and basin. Year must be in a
#' four-digit format (\%Y) and no earlier than 1998. Basin can be one or both
#' of Atlantic ("AL") or East Pacific ("EP").
#' \describe{
#'   \item{\code{\link{get_storms}}}{List all storms by year, basin}
#' }
#'
#' @section Getting Storm Data:
#'
#' \code{\link{get_storm_data}} can be used to select multiple products,
#' multiple storms and from multiple basins.
#'
#' Additional text products are:
#' \describe{
#'   \item{\code{\link{get_discus}}}{Storm Discussions}
#'   \item{\code{\link{get_fstadv}}}{Forecast/Advisory. These products contain a
#'   bulk of the information for tropical cyclones including current position,
#'   structure, forecast position and forecast structure.}
#'   \item{\code{\link{get_posest}}}{Position Estimates. Rare and used generally
#'   for threatening cyclones. This product was discontinued after the 2013
#'   season and is now issued as \code{\link{get_update}}.}
#'   \item{\code{\link{get_prblty}}}{Strike Probabilities. Show the probability
#'   of the center of a cyclone passing within 65nm of a location for a given
#'   forecast period. This product was discontinued after 2005, replaced with
#'   \code{\link{get_wndprb}}.}
#'   \item{\code{\link{get_public}}}{Public Advisory. General non-structured
#'   information exists in these products.}
#'   \item{\code{\link{get_update}}}{Updates. Generally issued when a cyclone
#'   undergoes a sudden change that requires immediate notice.}
#'   \item{\code{\link{get_wndprb}}}{Wind Speed Probability. Lists the
#'   probability of a location experiencing a minimum of 35kt, 50kt or 64kt
#'   winds for an alotted forecast period or accumulated probability. This
#'   product replaced \code{\link{get_prblty}} after the 2005 season.}
#' }
#'
#' The products above may take some time to load if the NHC website is slow (as
#' is often the case, unfortunately). For all storm advisories issued outside
#' of the current month, use the \code{rrricanesdata} package.
#'
#' To install \code{rrricanesdata}, run
#'
#' \code{
#' install.packages("rrricanesdata",
#'          repos = "https://timtrice.github.io/drat/",
#'          type = "source")
#' }
#'
#' See \code{vignette("installing_rrricanesdata", package = "rrricanes")} for
#' more information.
#'
#' @section GIS Data:
#'
#' For enhanced plotting of storm data, several GIS datasets are available. The
#' core GIS functions return URLs to help you refine the data you wish to view.
#' (Some products will not exist for all storms/advisories). These products are:
#'
#' \describe{
#'   \item{\code{\link{gis_advisory}}}{Past track, current position, forecast and wind radii}
#'   \item{\code{\link{gis_breakpoints}}}{Breakpoints for watches and warnings}
#'   \item{\code{\link{gis_latest}}}{All available GIS products for active cyclones}
#'   \item{\code{\link{gis_outlook}}}{Tropical Weather Outlook}
#'   \item{\code{\link{gis_prob_storm_surge}}}{Probabilistic Storm Surge}
#'   \item{\code{\link{gis_windfield}}}{Wind Radii}
#'   \item{\code{\link{gis_wsp}}}{Wind Speed Probabilities}
#' }
#'
#' \code{\link{gis_download}} will download the datasets from the above
#' functions.
#'
#' Some GIS datasets will need to be converted to dataframes to plot geoms. Use
#' \code{\link{shp_to_df}} to convert SpatialLinesDataFrames and
#' SpatialPolygonsDataFrames. SpatialPointsDataFrames can be converted using
#' \code{tibble::as_data_frame} targeting the @data object.
#'
#' @section Package Options:
#'
#' \code{dplyr.show_progress} displays the dplyr progress bar when scraping raw
#' product datasets. In \code{\link{get_storms}}, it is based on the number of
#' years being requested. In the product functions (i.e.,
#' \code{\link{get_fstadv}}) it is based on the number of advisories. It can be
#' misleading when calling \code{\link{get_storm_data}} because it shows the
#' progress of working through a storm's product advisories but will reset on
#' new products/storms.
#'
#' @section Package Options:
#'
#' \code{dplyr.show_progress} displays the dplyr progress bar when scraping raw
#' product datasets. In \code{\link{get_storms}}, it is based on the number of
#' years being requested. In the product functions (i.e.,
#' \code{\link{get_fstadv}}) it is based on the number of advisories. It can be
#' misleading when calling \code{\link{get_storm_data}} because it shows the
#' progress of working through a storm's product advisories but will reset on
#' new products/storms.
#'
#' \code{rrricanes.working_msg} is set to FALSE by default. When TRUE, it will
#' list the current storm, advisory and date being worked.
#'
#' @docType package
#' @name rrricanes
NULL

#' @importFrom magrittr %>%
#' @importFrom utils packageVersion

.pkgenv <- new.env(parent = emptyenv())

.onLoad <- function(libname, pkgname) {
  op <- options()
  op.rrricanes <- list(rrricanes.working_msg = FALSE)
  toset <- !(names(op.rrricanes) %in% names(op))
  if (any(toset)) options(op.rrricanes[toset])
  invisible()
  has_data <- requireNamespace("rrricanesdata", quietly = TRUE)
  .pkgenv[["has_data"]] <- has_data
}

.onAttach <- function(libname, pkgname) {
  msg <- "rrricanes is not intended for use in emergency situations."
  packageStartupMessage(msg)
}

hasData <- function(has_data = .pkgenv$has_data) {
  if (!has_data) {
  stop("rrricanesdata is not installed.")
  }
}

utils::globalVariables(c("Date", "Hour", "Minute", "Lat", "LatHemi", "Lon",
             "LonHemi", "Wind", "Gust", "Month", "Year", "FcstDate",
             "WindField34", "WindField50", "WindField64", "lat",
             "long", "group", ".", "NW34", "name", "data", "Basin",
             paste0(c("NE", "SE", "SW", "NW", "64")),
             paste0(c("NE", "SE", "SW", "NW", "50")),
             paste0(c("NE", "SE", "SW", "NW", "34"))))

#' @title convert_lat_lon
#' @description Converts lat, lon to negative if in southern, western
#'   hemisphere, respectively
#' @param x integer
#' @param y character
#' @return integer positive or negative
#' @keywords internal
convert_lat_lon <- function(x, y) {
  if (!is.numeric(x)) {stop("x is not numeric!")}
  if (!(y %in% c('N', 'S', 'E', 'W'))) {stop("y must be c('N','S','E','W')")}
  ifelse(y == 'S' | y == 'W', return(x * -1), return(x))
}

#' @title extract_year_archive_link
#' @description Extracts the year from the archive link.
#' @param link URL of archive page
#' @return year 4-digit numeric
#' @keywords internal
extract_year_archive_link <- function(link) {
  # Year is listed in link towards the end surrounded by slashes.
  year <- as.numeric(stringr::str_match(link, '/([:digit:]{4})/')[,2])
  return(year)
}

#' @title get_url_contents
#' @description Get contents from URL
#' @details This function primarily is reserved for extracting the contents of
#' the individual products \(thought it can be used in other instances\). Often,
#' there are timeout issues. This is an attempt to try to work around that.
#' @param link URL to download
#' @keywords internal
get_url_contents <- function(links) {
  links <- crul::Async$new(urls = links)
  res <- links$get()
  return(res)
}

#' @title get_nhc_link
#' @description Return root link of NHC archive pages.
#' @param withTrailingSlash True, by default. False returns URL without
#' trailing slash.
#' @keywords internal
get_nhc_link <- function(withTrailingSlash = TRUE) {
  if (withTrailingSlash)
    return('http://www.nhc.noaa.gov/')
  return('http://www.nhc.noaa.gov')
}

#' @title knots_to_mph
#' @description convert knots (kt) to miles per hour (mph)
#' @param x wind speed in knots
#' @return x in miles per hour
#' @examples
#' knots_to_mph(65)
#' @export
knots_to_mph <- function(x) {
  return(x * 1.15077945)
}

#' @title mb_to_in
#' @description convert millibars (mb) to inches of mercury (in)
#' @param x barometric pressure in mb
#' @return x in inches
#' @examples
#' mb_to_in(999)
#' @export
mb_to_in <- function(x) {
  return(x * 0.029529983071)
}

#' @title month_str_to_num
#' @description Convert three-character month abbreviation to integer
#' @param m Month abbreviated (SEP, OCT, etc.)
#' @return numeric 1-12
#' @keywords internal
month_str_to_num <- function(m) {
  abbr <- which(month.abb == stringr::str_to_title(m))
  if (purrr::is_empty(abbr))
    stop(sprintf("%s is not a valid month abbreviation.", m))
  return(abbr)
}

#' @title nm_to_sm
#' @description Convert nautical miles to survey miles
#' @param x Nautical miles
#' @examples
#' nm_to_sm(c(50, 100, 150))
#' @export
nm_to_sm <- function(x) {
  return(x * 1.15078)
}

#' @title saffir
#' @description Return category of tropical cyclone based on wind. Saffir-
#' Simpson Hurricane Scale does not apply to non-tropical cyclones.
#' @param x Vector of wind speed values.
#' @examples
#' saffir(c(32, 45, 70, 90, 110, 125, 140))
#' @export
saffir <- function(x) {
  y <- character(length = length(x))
  y[x <= 33] <- "TD"
  y[dplyr::between(x, 34, 64)] <- "TS"
  y[dplyr::between(x, 65, 83)] <- "HU1"
  y[dplyr::between(x, 84, 95)] <- "HU2"
  y[dplyr::between(x, 96, 113)] <- "HU3"
  y[dplyr::between(x, 114, 134)] <- "HU4"
  y[x >= 135] <- "HU5"
  return(y)
}

#' @title status_abbr_to_str
#' @description Convert Status abbreviation to string
#' @param x character vector of status abbreviations
#' @details Status abbreviations
#' \describe{
#'   \item{DB}{Disturbance (of any intensity)}
#'   \item{EX}{Extratropical cyclone (of any intensity)}
#'   \item{HU}{Tropical cyclone of hurricane intensity (> 64 knots)}
#'   \item{LO}{A low that is neither a tropical cyclone, a subtropical
#'         cyclone, nor an extratropical cyclone (of any intensity)}
#'   \item{SD}{Subtropical cyclone of subtropical depression intensity
#'         (< 34 knots)}
#'   \item{SS}{Subtropical cyclone of subtropical storm intensity
#'         (> 34 knots)}
#'   \item{TD}{Tropical cyclone of tropical depression intensity (< 34 knots)}
#'   \item{TS}{Tropical cyclone of tropical storm intensity (34-63 knots)}
#'   \item{WV}{Tropical Wave (of any intensity)}
#' }
#' @return character vector of strings
#' @seealso \url{http://www.aoml.noaa.gov/hrd/hurdat/newhurdat-format.pdf}
#' @examples
#' # Extratropical Cyclone
#' status_abbr_to_str("EX")
#'
#' # Hurricane
#' status_abbr_to_str("HU")
#' @export
status_abbr_to_str <- function(x) {
  y <- character(length = 0)
  y[x == "TD"] <- "Tropical Depression"
  y[x == "TS"] <- "Tropical Storm"
  y[x == "HU"] <- "Hurricane"
  y[x == "EX"] <- "Extratropical Cyclone"
  y[x == "SD"] <- "Subtropical Depression"
  y[x == "SS"] <- "Subtropical Storm"
  y[x == "LO"] <- "Low"
  y[x == "WV"] <- "Tropical Wave"
  y[x == "DB"] <- "Disturbance"
  return(y)
}

#' @title validate_year
#' @description Test if year is 4-digit numeric.
#' @return numeric year(s)
#' @keywords internal
validate_year <- function(y) {
  y <- as.numeric(y)
  if (all(is.na(y)))
    stop('Year must be numeric.')
  if (any(nchar(y) != 4))
    stop('Year must be 4 digits.')
  return(y)
}

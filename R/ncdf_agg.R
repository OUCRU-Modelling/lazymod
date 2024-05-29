#' Generate a spatiotemporally aggregated weather variable dataframe based on `stars` object
#' @author Tuyen Huynh \url{https://github.com/tuyenhn}
#'
#' @param var_name name of weather variable
#' @param agg_fn aggregation function, e.g. sum, mean
#' @param temp_agg temporal aggregation resolution, e.g. "1 month", "1 week". ?stars::aggregate
#' @param shp shapefile for spatial aggregation, should be `sf` object. ?stars::aggregate
#' @param trans_fn transformation function after aggregation, e.g. magrittr::add, magrittr::subtract
#' @param ... parameters for `trans_fn`
#' @param date_idx_fn tsibble function for date index, e.g. tsibble::year_month
#' @param new_var_name rename variable to a new name (if you want)
#' @param dataset `stars` object containing weather variable and time dimension. Based on NetCDF from ECMWF ERA5.
#'
#' @return
#' A **tsibble** with 2 columns:
#' * `date`: containing the date index variable. Time step is based on `temp_agg`
#' * `var_name`: name of the aggregated weather variable
#'
#' @export
#'
#' @examples
#' # TODO: add real data file for example
#' \dontrun{
#' raw_weather_era5 <- stars::read_ncdf("*NetCDF weather data downloaded from ERA5*")
#' shp <- read_rds("gadm41_VNM_1_pk.rds") %>%
#'   terra::unwrap() %>%
#'   st_as_sf()
#' gen_covar_df("t2m", mean, province_shp, subtract, 273.15, raw_weather_era5)
#' }
gen_weather_var_df <- function(var_name, agg_fn, temp_agg, shp, trans_fn = identity, ..., date_idx_fn, new_var_name = NULL, dataset) {
  dataset %>%
    dplyr::select(tidyselect::all_of(var_name)) %>%
    stars::aggregate.stars(temp_agg, FUN = agg_fn) %>%
    stars::aggregate.stars(shp, FUN = agg_fn) %>%
    tibble::as_tibble() %>%
    select(all_of(c("time", var_name))) %>%
    dplyr::mutate(
      date = date_idx_fn(time),
      !!ifelse(is.null(new_var_name), var_name, new_var_name) := trans_fn(!!rlang::sym(var_name), ...)
    ) %>%
    select(all_of(c("date", ifelse(is.null(new_var_name), var_name, new_var_name)))) %>%
    tsibble::as_tsibble(index = date)
}

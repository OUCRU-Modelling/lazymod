% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ncdf_agg.R
\name{gen_weather_var_df}
\alias{gen_weather_var_df}
\title{Generate a spatiotemporally aggregated weather variable dataframe based on `stars` object}
\usage{
gen_weather_var_df(
  var_name,
  agg_fn,
  temp_agg,
  shp,
  trans_fn = identity,
  ...,
  date_idx_fn,
  new_var_name = NULL,
  dataset
)
}
\arguments{
\item{var_name}{name of weather variable}

\item{agg_fn}{aggregation function, e.g. sum, mean}

\item{temp_agg}{temporal aggregation resolution, e.g. "1 month", "1 week". ?stars::aggregate}

\item{shp}{shapefile for spatial aggregation, should be `sf` object. ?stars::aggregate}

\item{trans_fn}{transformation function after aggregation, e.g. magrittr::add, magrittr::subtract}

\item{...}{parameters for `trans_fn`}

\item{date_idx_fn}{tsibble function for date index, e.g. tsibble::year_month}

\item{new_var_name}{rename variable to a new name (if you want)}

\item{dataset}{`stars` object containing weather variable and time dimension. Based on NetCDF from ECMWF ERA5.}
}
\value{
A **tsibble** with 2 columns:
* `date`: containing the date index variable. Time step is based on `temp_agg`
* `var_name`: name of the aggregated weather variable
}
\description{
Generate a spatiotemporally aggregated weather variable dataframe based on `stars` object
}
\examples{
# TODO: add real data file for example
\dontrun{
raw_weather_era5 <- stars::read_ncdf("*NetCDF weather data downloaded from ERA5*")
shp <- read_rds("gadm41_VNM_1_pk.rds") \%>\%
  terra::unwrap() \%>\%
  st_as_sf()
gen_covar_df("t2m", mean, province_shp, subtract, 273.15, raw_weather_era5)
}
}
\author{
Tuyen Huynh \url{https://github.com/tuyenhn}
}

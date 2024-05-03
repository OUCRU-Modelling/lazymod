
<!-- README.md is generated from README.Rmd. Please edit that file -->

# lazymod

<!-- badges: start -->
<!-- badges: end -->

Lazy mode for lazy modellers.

## Installation

You can install the development version of lazymod from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("OUCRU-Modelling/lazymod")
```

## Instructions

This package is designed to make our life much better by spending (a lot
of) time writing well-documented, generalisable code now and reusing it
in a no-brain manner later.

### Documentation

Please explain your code carefully and write documentation with
`roxygen2`. To write documentation, put the cursor somewhere within the
function, click `Code` \> `Insert Roxygen Skeleton`.

Remember to put your name in the `@author` field so we know who’s to
blame when your function runs wild. For example:

``` r
#' @author Thinh Ong \url{https://github.com/thinhong}
```

When you are happy with the documentation, run:

``` r
devtools::document()
```

### Data for example

If you need data to demonstrate examples, make an object `data_name` for
your data. This `data_name` will be used to call your data so you may
want to put some thoughts to make a nice name. Then just run this code
and it will handle everything.

``` r
usethis::use_data(data_name)
```

To load your data, simple assign its name to an object:

``` r
df <- data_name
```

### Dependencies

If you need dependencies, use this function to put them in `Imports`

``` r
usethis::use_package("pkg_name")
```

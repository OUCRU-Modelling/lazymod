#' Calculate time series frequency and proportion
#' @author Thinh Ong \url{https://github.com/thinhong}
#'
#' @param data A data frame
#' @param varname Variable to compute
#' @param time Time variable
#'
#' @return
#' A tibble with 4 columns
#'
#' * `time`: the time variable
#'
#' * `varname`: the variable to compute
#'
#' * `n`: frequency of each category of `varname` per time step
#'
#' * `prop`: proportion of each category of `varname` per time step
#'
#' @export
#'
#' @examples
#' df <- patients
#' calc_ts_np(data = df, varname = age_class, time = onset_month)
calc_ts_np <- function(data, varname, time) {
  data %>%
    dplyr::filter(!is.na({{ varname }}), !is.na({{ time }})) %>%
    dplyr::count({{ time }}, {{ varname }}) %>%
    dplyr::group_by({{ time }}) %>%
    dplyr::mutate(prop = n / sum(n))
}

#' Plot time series stacked bar chart
#' @author Thinh Ong \url{https://github.com/thinhong}
#'
#' @param data A data frame
#' @param varname Variable to plot
#' @param time Time variable
#' @param style Add minimal theme and ggsci palette
#'
#' @return
#' A list contains:
#'
#' * `data`: A data frame created by `calc_ts_np()` using to plot
#'
#' * `plot`: A ggplot object for the time series stacked bar chart
#'
#' @export
#'
#' @examples
#' df <- patients
#' outp <- plot_ts_stacked_bar(data = df, varname = age_class, time = onset_month)
#' outp$plot
#' # Add other ggplot elements
#' outp$plot + ggplot2::theme_minimal()
plot_ts_stacked_bar <- function(data, varname, time, style = F) {

  # Compute proportion
  df <- calc_ts_np(data, {{ varname }}, {{ time }})

  # Ensure the input is data frame to use function complete()
  df <- data.frame(df)

  # Use complete to fill missing groups with 0
  df <- df %>%
    tidyr::complete({{ time }}, {{ varname }}, fill = list(n = 0, prop = 0))

  # Plot
  p <- ggplot2::ggplot(df, ggplot2::aes(x = {{ time }}, y = prop, fill = {{ varname }})) +
    ggplot2::geom_bar(stat = "identity")

  if (style == T) {
    p <- p +
      ggsci::scale_fill_jco() +
      theme_minimal()
  }

  list(data = df, plot = p)
}


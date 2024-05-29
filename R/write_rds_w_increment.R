#' Write object to RDS file with incrementing number suffixed to file name
#' @author Tuyen Huynh \url{https://github.com/tuyenhn}
#'
#' @param object object to be written
#' @param dir directory for the file
#' @param fname desired file name
#'
#' @return a string confirming where the file has been written to
#' @export
#'
#' @examples
#' write_rds_w_increment(identity, "~", "temp")
#' # "New file written at ~/temp.rds"
#' write_rds_w_increment(identity, "~", "temp")
#' # "New file written at ~/temp_01.rds"
#' write_rds_w_increment(identity, "~", "temp")
#' # "New file written at ~/temp_02.rds"
write_rds_w_increment <- function(object, dir, fname) {
  # directory and file name cleaning
  dir %<>% path_tidy() %>% path()
  fname %<>% path_sanitize()
  fname_no_ext <- path_ext_remove(fname)

  # check if directory exists
  if (!dir_exists(dir)) stop("path directory doesn't exist")

  # check if similarly named files already exist in directory
  dfiles_no_ext <- dir %>%
    dir_ls() %>%
    path_file() %>%
    path_ext_remove()

  matched_dfiles <- str_subset(dfiles_no_ext, fname_no_ext)

  if (!is_empty(matched_dfiles)) {
    # if similarly named files exist, increment the number suffix
    curr_fnos <- str_extract(matched_dfiles, "\\d+") %>%
      as.numeric() %>%
      na.omit()

    curr_max_fno <- ifelse(is_empty(curr_fnos), 0, max(curr_fnos))

    new_fname_no_ext <- paste0(fname_no_ext, sprintf("_%02d", curr_max_fno + 1))
    new_fpath <- path(dir, new_fname_no_ext, ext = "rds")
  } else {
    # if not, create new file
    new_fpath <- path(dir, fname_no_ext, ext = "rds")
  }

  write_rds(object, new_fpath)

  sprintf("New file written at %s", new_fpath)
}

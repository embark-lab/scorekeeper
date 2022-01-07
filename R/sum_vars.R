

#' Sum variables using metadata
#'
#' @param raw A raw data object
#' @param metadata A formatted metadata object
#' @import dplyr
#' @import glue
#' @return raw tibble with four additional columns appended: a column which is the raw sum of items, a _NAs column with the count of NAs among items summed, the _NA_percent column with the percentage of NAs among the summed variables, and the _weighted_sum column with the sum that is weighted by the number of non-NA items included
#' @export
#'

sum_vars <- function (raw, metadata){
  raw_data <- raw
  metadata <- metadata %>%
    filter (recode_operation_r == 'sum')

  #create a new tibble with just the raw data --we'll add columns with sum scores as we loop down below
  new_table2 <- tibble(raw_data)

  for (i in 1:nrow(metadata)){
    new_var <- metadata$recoded_var[i]
    raw_var <-  metadata$raw_vars_r[i]
    new_label <- metadata$recode_label_r[i]

    sum_table <- sum_function(raw_tbl = raw, n_var = new_var, r_vars = r_var_func(metadata, i), n_lab = new_label)

    #save the last 4 columns (the new sum column, the NAs column, the NA percent column, and the weighted sum column), and append to the 'new table'
    new_table1 <- sum_table[,(ncol(sum_table)-3):ncol(sum_table)]
    new_table2 <- new_table2 %>%
      add_column(new_table1[1], new_table1[2], new_table1[3], new_table1[4])
  }

  #return the new table
  return(new_table2)
}


#The sum function takes a raw table and several variables from the metadata. n_var is the new variable name, r_vars are the raw variables to be summed, and n_lab is the is the variable label for the new summed variable
sum_function <- function (raw_tbl, n_var, r_vars, n_lab) {
  new_tbl <-raw_tbl %>%
    #create a new variable that sums across the raw variables
    mutate("{n_var}" := rowSums(across(r_vars, na.rm = FALSE))) %>%
    #label the new variable
    set_variable_labels("{n_var}" := n_lab) %>%
    #create a new variable that tells you -- across the raw variables, the number that are missing
    mutate("{n_var}_NAs" := rowSums(is.na(across(r_vars))))  %>%
    #create a new variable that tells you -- across the raw variables that are summed, the percent that are missing
    mutate("{n_var}_NA_percent" := ((rowSums(is.na(across(r_vars))))/(length(r_vars)))) %>%
    #create a new variable that is your weighted sum score
    mutate ("{n_var}_weighted_sum" := ((!!as.name(n_var))/(1-(((rowSums(is.na(across(r_vars))))/(length(r_vars)))))))
  return(new_tbl)
}

#the r_var_function takes raw variables to be summed are defined in a list, splitting by the commas in the charachter string, trimming the whitespace
r_var_func <- function (metadata, i) {
  raw_vars <- as.list(el(strsplit(metadata$raw_vars_r[i], ",")))
  raw_vars <- trimws(raw_vars)
  return(raw_vars)
}




#' recode_vars function
#' recodes variables according to scoresheet instructions
#'
#' @param raw : A raw data object
#' @param scoresheet  : A scoresheet object
#' @import dplyr
#' @import labelled
#' @importFrom haven as_factor
#' @import tibble
#' @import rlang
#' @importFrom rlang eval_tidy
#' @importFrom purrr as_vector
#' @return A tibble with both original and recoded variables
#' @export
#'
#'

recode_vars <- function (raw, scoresheet){

  #from the scoresheet file - filter rows where the variables need to be recoded
  raw_data <-raw
  #create a new, empty tibble with just the id numbers
  new_table2 <- tibble(raw_data)
  #filter rows of the scoresheet where the operation is 'recode'
  scoresheet <- scoresheet %>%
    filter (scoresheet$operation == 'recode')
  #loop through the recode function, using the arguments defined frp, the scoresheet file and using the functions above
  for (i in 1:nrow(scoresheet)){
    new_var <- scoresheet$new_var[i]
    raw_var <- scoresheet$raw_vars[[i]]
    new_label <- scoresheet$label[i]

    new_table <- recode_function(raw_tbl = raw, n_var = new_var, r_var = raw_var, n_val = n_val_func(scoresheet, i), n_val_lab = n_val_lab_func(scoresheet,i), n_lab = new_label, n_var_factor = n_var_factor_func(scoresheet,i))
  #save the last two columns (the new named variable and the '.factor' variable as columns in the new table at each loop)
    new_table1 <- new_table[,(ncol(new_table)-1):ncol(new_table)]
    new_table2 <- new_table2 %>%
      add_column(new_table1[1], new_table1[2])
  }
#close the loop  - return the new table
  return(new_table2)
}


#define function to recode using variables that will be read in from scoresheet. This is the primary function that will recode the data and be put on loop down each row of the scoresheet. This function takes a raw data table (raw_tbl), a new variable name (n_var) and raw variable name (r_var), new value assignments (n_val) and new value labels (n_val_lab), the new varaible label (n_lab), and a second new variable name that will be the 'factor' variable where the variable labels will be presented instead of variable values in each row (n_var_factor).



recode_function <- function (raw_tbl, n_var, r_var, n_val, n_val_lab, n_lab, n_var_factor) {
  raw_tbl <-raw_tbl %>%
    mutate({{r_var}} := as.numeric({{r_var}}) ) |>
    #make a new variable using the new variable name, recode the old variable using the new value assignments. get rid of the old value labels that are now incorrect
    mutate("{n_var}" := dplyr::recode(!!as.name(r_var), !!!n_val)) %>%
    #relabel values in accordance with the new, correct variable labels
    mutate("{n_var}" := labelled(!!as.name(n_var), n_val_lab)) %>%
    #label the new variable
    set_variable_labels("{n_var}" := n_lab) %>%
    #create the factor variable by using the 'as_factor' function on the new variable"
    mutate("{n_var_factor}" := as_factor(!!as.name(n_var), ordered = TRUE)) %>%
    #label the factor variable using the same label
    set_variable_labels("{n_var_factor}" := n_lab)
  #return the raw table with the two new variables appended. We'll pull just these two variables into a new table later as we run the loop
  return(raw_tbl)
}


#this final function just creates the name of the .factor variable, taking the 'new variable' name and appending .factor to the end
n_var_factor_func <- function(scoresheet, i) {
  n_var <- scoresheet$new_var[i]
  n_var_factor <- paste(n_var,'.factor')
  n_var_factor <- gsub (" ", "", n_var_factor, fixed = TRUE)
  return(n_var_factor)
}

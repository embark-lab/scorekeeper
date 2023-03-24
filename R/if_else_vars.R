
#' if_else_vars function
#' creates a new variable based on if_else statements provided
#' @param raw Raw data object
#' @param scoresheet Formatted scoresheet object. Key variables for if_else_vars are 'if_condition', 'if_true_return' and 'else_return'.
#' These variables should be entered in as the 'condition', 'TRUE' and 'FALSE' statements,
#' respectively, in a 'dplyr' if_else statement. see: [dyplyr if_else](https://dplyr.tidyverse.org/reference/if_else.html).
#' @import dplyr
#' @import labelled
#' @import tibble
#' @import stringr
#' @importFrom rlang parse_expr
#' @return a tibble with 'new_var' appended.
#' @export
#'


#uses a raw data file and a score sheet, filtering for rows in the scoresheet where operation is specified as 'if_else'
if_else_vars <- function (raw, scoresheet){
  raw_data <- raw
  scoresheet <- scoresheet %>%
    filter (scoresheet$operation == 'if_else')

#creates a new tibble with just the raw data
  new_table2 <- tibble(raw_data)

#for each row of the scoresheet with an if_else statement, identifies variables for input into if_else_function as those elements
  for (i in 1:nrow(scoresheet)){
    new_var <- scoresheet$new_var[i]
    raw_var <-  scoresheet$raw_vars[i]
    new_label <- scoresheet$label[i]
    if_condition <- scoresheet$if_condition [i]
    if_true_return <- scoresheet$if_true_return[i]
    else_return <- scoresheet$else_return[i]

#a new table 'if_else_table' is created by using the variables defined above as input. Value labels for the new variable are defined using the 'n_val_lab_func'
    if_else_table <- if_else_function(raw_tbl = raw_data, n_var = new_var, if_cond = if_condition, if_true_r = if_true_return, else_r = else_return, n_val_labs = n_val_lab_func(scoresheet, i), n_lab = new_label)

 #save the last column of if_else_table (which will be the new variable that is created; 'new_var') and append to the 'new table'
    new_table1 <- if_else_table[,ncol(if_else_table)]
    new_table2 <- new_table2 %>%
      add_column(new_table1[1])
  }

  #return the new table which now has 'new_var' appended
  return(new_table2)
}

#this function is used in the code above to create 'if_else_table'.
if_else_function <- function (raw_tbl, n_var, if_cond, if_true_r, else_r, n_lab, n_val_labs) {
  new_tbl <-raw_tbl %>%
    #create a new variable that parses the three elements from the scoresheet -- 'if_condition', 'if_true_return', and 'else_return' into an if_else statement that is
    #readable by dplyr and evaluate it
    mutate("{n_var}" := ifelse( (eval_tidy(rlang::parse_expr(if_cond))), eval(parse(text = if_true_r)), eval(parse(text = else_r)), missing = NULL ))
    #set value labels and variable labels
    new_tbl <- new_tbl %>%
    mutate("{n_var}" := labelled(!!as.name(n_var), {{n_val_labs}})) %>%
    set_variable_labels('{n_var}' := n_lab)
  return(new_tbl)
}


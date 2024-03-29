% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/select_vars.R
\name{select_vars}
\alias{select_vars}
\title{Select Variables Using scoresheet}
\usage{
select_vars(raw, scoresheet)
}
\arguments{
\item{raw}{\itemize{
\item raw data object
}}

\item{scoresheet}{\itemize{
\item formatted scoresheet object. Key variables in this operation are \code{raw_vars}. The select operation currently takes a comma-separated
character string (i.e. one character string which will be turned into a list via parsing at commas) of \code{raw_vars} and selects those variables. Remember to select any necessary variables for identification of your data when scoring a measure
(so that you can later stitch tibbles back together for analysis if needed). Currently, you must enter the names of variables you would like
in a simple, comma separated list. You cannot use shorthand expressions (e.g. \code{starts_with} or \code{c(1:7)} will not work as input. Full variables
names are necessary. Additional flexibility for this function is planned for future releases
}}
}
\value{
tibble with selected variables
}
\description{
Select Variables Using scoresheet
}

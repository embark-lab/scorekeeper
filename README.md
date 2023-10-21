
<!-- README.md is generated from README.Rmd. Please edit that file -->

# scorekeeper


A data cleaning package, by Katherine Schaumberg

For a detailed example of how this package works, see [package
vignette](https://embark-lab.github.io/scorekeeper/articles/scorekeeper-vignette.html)

Instructional videos can be found
[here](https://www.youtube.com/playlist?list=PLj0MKOezmHuAfQEhidIuzTjV8fUD67U58)

The goal of scorekeeper is to support the development of accessible,
approachable, and reproducible scoring algorithms for multi-item
measures. This package was designed with psychological assessment
measures in mind, but can be broadly applicable to other multi-item
assessments. The package requires a raw data file and a scoresheet (an
RData or .csv metadata file) as input. Scorekeeper uses dplyr
functionality to manipulate and clean data in a systematic way, as
specified in the scoresheet. The scoresheet can then serve as a resource
that will make your data cleaning process both reproducible and easily
shared (e.g. if a colleague would like to score a measure in the same
way that you did for their project on a different sample, you can send
or post your RData or .csv/.xlsx scoresheet and it should easily
replicate your scoring algorithm – no need to send or post additional
code). While scoresheets are structured to be more easily developed and
interpreted as compared to raw code, I also recommend a companion text
file outlining each step in your data cleaning to maximize ease of
interpretation when sharing with others (or your future self!).
Currently, scoresheets must be formatted in accordance with guidelines
outlined in each of the ‘operation’ functions and with steps that
proceed in an appropriate order.

I recommend building a scoresheet step-by-step. Add one ‘step’ at a time
in your data manipulaton and complete error checking by running
functions in the scorekeeper package as you build the scoresheet.

## Scoresheet Structure

***Columns in a scoresheet include***:

**raw_vars** : a raw variable or list of raw variables (either a vector
or a single, comma separated character string) needed for an operation

**new_var**: the desired name of a new variable created during the
operation

**label**: the new variable label, if needed

**operation**: the operation to preform (`select`, `filter_at`,
`recode`, `sum`, `if_else`, `case_when`, `rename`, `mean`)

**step**: identifies the order of operations to be preformed, starting
with ‘1’. I recommend entering any raw metadata as ‘0’ to increase
transparency of your scoring method when sharing a scoresheet

**val_labs**: value labels for a new variable. Follow the convention
`label` = `value`. label/value pairs can be listed as a single, comma
separated character string or as a vector of character strings.

**new_vals**: values to be recoded in a `recode` operation. Follow the
convention `old` = `new`. old/new pairs can be listed as a single, comma
separated character string or as a vector of character strings.

**if_condition**: a logical condition to be evaluated for an `if_else`
operation

**if_true_return**: value that is returned if the ‘if_condition’ == TRUE
in `if_else` operations

**else_return**: value that is returned if the ‘if_condition’ != TRUE in
`if_else` operations

**code**: code for performing a ‘filter_at’ or ‘case_when’ operation.
Not needed for other operations.

The required columns in a scoresheet currently have limited flexibility
– see documentation for the individual functions for details on these
limitations. I anticipate adding additional functionality in the future.

## Operations

Current operations supported are:

**select** : selects variables that you identify in
`scoresheet$raw_vars`.

**filter_at**: filters rows of a dataset. Use `filter_at` dplyr
conventions using `scoresheet$code`

**recode**: recodes a variable into a new variable, using values defined
in `scoresheet$new_vals`. Renames the new variable to the name defined
in `scoresheet$new_var`. creates value labels defined in
`scoresheet$val_labs`. labels new variable according to
`scoresheet$label`

**sum**: sums variables identified in `scoresheet$raw_vars`, new raw sum
variable (NA values counted as 0) is named the value in
`scoresheet$new_var`. In addition to the raw sum, four additional new
variables are appended - complete case sums, the number of and
proportion of `NA` values in the sum, and a weighted sum based on the
number of variables included in the sum.

**if_else** : creates a new variable, `scoresheet$new_var`, defined in
`scoresheet$if_condition`, `scoresheet$if_true return`,
`soresheet$else_return`

**case_when** : creates a new variable, `scoresheet$new_var`, using
case_when code defined in `scoresheet$code`

**rename**: renames a single variable entered in `scoresheet$raw_vars`
to `scoresheet$new_var`

**mean**: creates a mean of variables identified in
`scoresheet$raw_vars`, named in accordance with `scoresheet$new_var`. In
addition to the mean, three additional new variables are appended - the
mean of complete cases only, and the number of an proportion of `NA`
values in the mean.

## Installation

Install scorekeeper from its GitHub repository. If you do not have the
remotes package installed, first install the remotes package.

``` r
install.packages("remotes")
```

then install R/scorekeeper using the install_github function in remotes.

``` r
library(remotes)
install_github("embark-lab/scorekeeper")
```

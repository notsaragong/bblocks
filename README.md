
<!-- README.md is generated from README.Rmd. Please edit that file -->
bblocks: builds blocks for randomization
========================================

`bblocks` is designed to prepare data for blocked, or stratified, randomization. Given a minimum block size and a set of covariates, `bblocks` efficiently partitions the covariate space into subgroups with reduced heterogeneity.

Installation
------------

You can install the released version of bblocks from [CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("bblocks")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("notsaragong/bblocks")
```

Usage
-----

    bblocks(data, min_block_size, blockby)

### Arguments

`data` is a dataframe with variables describing background characteristics.

`min_block_size` is a number indicating the desired minimum number of observations in each block.

`blockby` is a list of specifications for partitioning the covariate space, in order of decreasing importance.

### Details

`bblocks` iteratively sorts data in the order of covariates described by `blockby`, then works backwards to combine subgroups until there are at least `min_block_size` observations in each block. Within each covariate, blocking is performed according to the specifications given by the elements of `blockby`. Observations that do not match any listed specification are also grouped together. Note that if there are outliers, there may not be a solution to the sorting algorithm. In this case, try reordering the specifications in `blockby` or using broader specifications.

Calling `bblocks` on a dataframe of N observations will return an N-length column vector assigning each observation to a block. Randomization may then be carried out using any preferred randomization package.

Example
-------

The following code performs blocking by three variables in the built-in dataset `mtcars`. Within the variable `carb`, `carb == 1` and `carb == 2` are grouped together, as are `carb == 3`, `carb == 4`, and `carb == 5`.

``` r
library(bblocks)

# load built-in dataset and create useful variable
data("mtcars")
mtcars$mpg.over.18 <- ifelse(mtcars$mpg > 18, "Yes", "No")

# perform blocking
mtcars$block <- bblocks(mtcars, 4, blockby = list(mpg.over.18 = "Yes",
                                                  mpg.over.18 = "No",
                                                  gear = 4,
                                                  carb = c(1, 2),
                                                  carb = c(3, 4, 5)))
#> [1] "Successfully created 5 blocks of minimum size 4."
```

In this case, `bblocks` returns a vector with a maximum of 3x3x2 = 18 unique blocks.

| block                                                  |  Freq|
|:-------------------------------------------------------|-----:|
| \_1\_mpg.over.18\_No                                   |     4|
| \_1\_mpg.over.18\_No\_2\_gear\_other\_3\_carb\_3\_4\_5 |     9|
| \_1\_mpg.over.18\_Yes                                  |     4|
| \_1\_mpg.over.18\_Yes\_2\_gear\_4\_3\_carb\_1\_2       |     8|
| \_1\_mpg.over.18\_Yes\_2\_gear\_other\_3\_carb\_1\_2   |     7|

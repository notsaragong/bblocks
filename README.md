bblocks
================

Description
-----------

`bblocks` is designed to prepare data for blocked, or stratified, randomization. Given a minimum block size and a set of covariates, `bblocks` efficiently partitions the covariate space into subgroups with reduced heterogeneity.

Usage
-----

    bblocks(data, min_block_size, blockby = list(...))

Arguments
---------

`data` is a dataframe with variables describing background characteristics.

`min_block_size` is a number indicating the desired minimum number of observations in each block.

`blockby` is a list of specifications for partitioning the covariate space, in order of decreasing importance.

Details
-------

`bblocks` iteratively sorts data in the order of covariates described by `blockby`, then works backwards to combine subgroups until there are at least `min_block_size` observations in each block. Within each covariate, blocking is performed according to the specifications given by the elements of `blockby`. Observations that do not match any listed specification are also grouped together. Note that if there are outliers, there may not be a solution to the sorting algorithm. In this case, try reordering the specifications in `blockby` or using broader specifications.

Calling `bblocks` on a dataframe of N observations will return an N-length column vector assigning each observation to a block. Randomization may then be carried out using any preferred randomization package.

Example
-------

The following code performs blocking by three variables in the dataset "automobiles": "type", "color", and "year". Within the variable "type", "truck" and "minivan" are grouped together.

    my_subjects$block <- bblocks(automobiles, 6, blockby = list(type = "sedan",
                                                                type = c("truck", "minivan")
                                                                color = "red",
                                                                color = "green",
                                                                year = 2019))

In this case, `bblocks` returns a vector with a maximum of 3x3x2 = 18 unique blocks: for example, `_1_type_sedan_2_color_other_3_year_2019` and `_1_type_truck_minivan_2_color_red`.

Reference
---------

Athey, Susan and Guido Imbens. "The Econometrics of Randomized Experiments." (2017).

Notes
-----

Sara Gong (<saragong@usc.edu>)

Columbia Business School | University of Southern California

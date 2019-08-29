\name{bblocks}
\alias{bblocks}

\title{
bblocks
}

\description{
\code{bblocks} is designed to prepare data for blocked, or stratified, randomization. Given a minimum block size and a set of covariates, \code{bblocks} efficiently partitions the covariate space into subgroups with reduced heterogeneity.
}

\usage{
bblocks(data, min_block_size, blockby = list(...))
}

\arguments{
  \item{data}{
  a dataframe with variables describing background characteristics.
   }
  \item{min_block_size}{
  a number indicating the desired minimum number of observations in each block.
   }
  \item{blockby}{
  a list of specifications for partitioning the covariate space, in order of decreasing importance.}
}

\details{
\code{bblocks} iteratively sorts data in the order of covariates described by \code{blockby}, then works backwards to combine subgroups until there are at least \code{min_block_size} observations in each block. Within each covariate, blocking is performed according to the specifications given by the elements of \code{blockby}. Observations that do not match any listed specification are also grouped together. Note that if there are outliers, there may not be a solution to the sorting algorithm. In this case, try reordering the specifications in \code{blockby} or using broader specifications.

Calling \code{bblocks} on a dataframe of N observations will return an N-length column vector assigning each observation to a block. Randomization may then be carried out using any preferred randomization package.
}

\author{
Sara Gong (saragong@usc.edu)

Columbia Business School | University of Southern California
}

\examples{
# load built-in dataset and create useful variable
data("mtcars")
mtcars$mpg.over.18 <- ifelse(mtcars$mpg > 18, "Yes", "No")

# perform blocking using bblocks
mtcars$block <- bblocks(mtcars, 4, blockby = list(mpg.over.18 = "Yes",
                                                  mpg.over.18 = "No",
                                                  gear = 4,
                                                  carb = c(1, 2),
                                                  carb = c(3, 4, 5)))
}

\keyword{block}
\keyword{stratified}
\keyword{randomization}

# bblocks.R

#' @export
bblocks <- function(data, min_block_size, blockby) {

  # build blocks --------------------

  data$block_id <- ""
  num_tags <- 0

  covariates <- unique(names(blockby))
  num_obs <- nrow(data)
  num_covar <- length(covariates)
  num_specif <- length(blockby)

  # iterate through covariates
  for (i in c(1:num_covar)) {
    num_tags <- num_tags + 1

    covar <- covariates[i]
    specif_list <- blockby[names(blockby) == covar]

    # iterate through specifications for each covariate
    for (j in c(1:length(specif_list))) {
      specif_tag <- paste(num_tags,
                          covar,
                          paste(unlist(specif_list[[j]]),
                                collapse = "_"),
                          sep = "_")

      data$block_id <- ifelse(data[,covar] %in% specif_list[[j]],
                              paste(data$block_id,
                                    specif_tag,
                                    sep = "_"),
                              data$block_id)
    }

    # assign ID if no match found
    data$block_id <- ifelse(is.na(data[,covar]) == TRUE
                            | !(data[,covar] %in% unlist(specif_list, use.names = FALSE)),
                            paste(data$block_id,
                                  paste(num_tags,
                                        covar,
                                        "other",
                                        sep = "_"),
                                  sep = "_"),
                            data$block_id)
  }

  # merge blocks --------------------

  # check if there are blocks that need merging
  block_freq_table <- as.data.frame(table(data$block_id, dnn = c("block_id")))
  blocks_to_merge <- subset(block_freq_table, block_freq_table$Freq < min_block_size)
  num_blocks_to_merge <- nrow(blocks_to_merge)

  # keep trying block sizes until finding smallest size that doesn't leave leftovers
  data$block_id_long <- data$block_id
  try_block_size <- min_block_size
  lowest_tag <- num_tags

  while (num_blocks_to_merge > 0 & try_block_size <= num_obs/2) {

    while (num_blocks_to_merge > 0 & lowest_tag > 1) {

      # strip last tag from block_id
      pattern_to_strip <- paste('_', as.character(lowest_tag), '_.*', sep = '')
      data$block_id <- ifelse(data$block_id %in% blocks_to_merge$block_id,
                              gsub(pattern_to_strip, "", data$block_id),
                              data$block_id)

      # store the number of the next tag to strip
      lowest_tag <- lowest_tag - 1

      # check if there are blocks that need merging
      block_freq_table <- as.data.frame(table(data$block_id, dnn = c("block_id")))
      blocks_to_merge <- subset(block_freq_table, block_freq_table$Freq < try_block_size)
      num_blocks_to_merge <- nrow(blocks_to_merge)
    }

    # reset sort process if the last minimum block size had leftovers
    if (num_blocks_to_merge > 0) {
      print(paste("Minimum block size ",
                  try_block_size,
                  " is too small. Trying size ",
                  try_block_size + 1,
                  "...", sep = ""))
      data$block_id <- data$block_id_long
      lowest_tag <- num_tags
      try_block_size <- try_block_size + 1
    }
  }

  if (try_block_size <= num_obs/2) {
    num_final_blocks <- length(unique(data$block_id))
    print(paste("Successfully created ",
                num_final_blocks,
                " blocks of minimum size ",
                try_block_size,
                ".",
                sep = ""))

    return(data$block_id)
  }

  if (try_block_size > num_obs/2) {
    print(paste("Unable to sort data into blocks of minimum size ",
                min_block_size,
                ". Try reordering the specifications or using broader specifications.",
                sep = ""))

    return(NA)
  }
}

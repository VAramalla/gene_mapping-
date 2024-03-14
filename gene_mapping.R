# Load necessary libraries
library(tidyverse)
library(biomaRt)
library(dplyr)

# Read the .gmt file
gmt_data <- read.table("/Users/vaishnaviaramalla/Downloads/hiring_task/h.all.v2023.1.Hs.symbols.gmt", sep = "\t", header = FALSE, fill = TRUE)

# Load gene info file
gene_info_file <- "/Users/vaishnaviaramalla/Downloads/hiring_task/Homo_sapiens.gene_info.gz"
gene_info <- read.table(gene_info_file, sep = "\t", header = TRUE, fill = TRUE, comment.char = "")

# Create a mapping function to replace symbols with Entrez IDs
map_symbols_to_entrez <- function(symbol) {
  if (is.na(symbol)) {
    return(NA)  # Return NA for NA values
  } else {
    entrez_id <- gene_info$GeneID[gene_info$Symbol == symbol]
    if (length(entrez_id) == 1) {
      return(as.character(entrez_id))
    } else if (length(entrez_id) > 1) {
      warning(paste("Multiple matches found for symbol:", symbol))
      return(as.character(entrez_id[1]))  # Return the first match
    } else {
      warning(paste("No match found for symbol:", symbol))
      return(symbol)  # Return symbol itself when no match found
    }
  }
}


# Apply the mapping function to each element in the GMT file
gmt_data_entrez <- apply(gmt_data, MARGIN = 2, FUN = function(x) sapply(x, map_symbols_to_entrez))

# Save the modified GMT file with Entrez IDs
output_file <- "/Users/vaishnaviaramalla/Downloads/hiring_task/h.all.v2023.1.Hs.entrez.gmt"
write.table(gmt_data_entrez, file = output_file, sep = "\t", quote = FALSE, row.names = FALSE, col.names = FALSE)

cat("GMT file with Entrez IDs created:", output_file, "\n")

output <- read.table("/Users/vaishnaviaramalla/Downloads/hiring_task/h.all.v2023.1.Hs.entrez.gmt", sep = "\t", header = FALSE, fill = TRUE)
View(output)

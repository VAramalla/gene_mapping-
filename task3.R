# Load necessary libraries
library(tidyverse)
library(ggplot2)
library(dplyr)

# Define input file name
input_file <- "/Users/vaishnaviaramalla/Downloads/hiriing_task2/Homo_sapiens.gene_info.gz"

# Read the data
gene_info <- tryCatch(
  {
    read.table(gzfile(input_file), sep = "\t", header = TRUE, fill = TRUE, comment.char = "")
  },
  error = function(e) {
    message("Error reading data file: ", e)
    NULL
  }
)

specified_values <- c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", 
                      "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", 
                      "21", "22", "X", "Y", "MT", "Un")

gene_info <- gene_info %>%
  filter(chromosome %in% specified_values)

# Create a custom factor for chromosome with specified order
gene_info$chromosome <- factor(gene_info$chromosome, levels = specified_values)

# Count the number of genes per chromosome
genes_per_chromosome <- table(gene_info$chromosome)

# Convert the result to a data frame
genes_per_chromosome_df <- data.frame(chromosome = names(genes_per_chromosome),
                                      count = as.numeric(genes_per_chromosome))
summary(genes_per_chromosome_df)



#genes_per_chromosome_df <- genes_per_chromosome_df[order(genes_per_chromosome_df$chromosome), ]

gg <- ggplot(data = genes_per_chromosome_df, aes(x = factor(chromosome, levels = specified_values), y = count)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  labs(x = "Chromosome", y = "Number of Genes", title = "Number of Genes per Chromosome in Human Genome") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "none")

  
ggsave("/Users/vaishnaviaramalla/Downloads/hiriing_task2/genes_per_chromosome_plot.pdf", plot = gg, width = 8, height = 6)

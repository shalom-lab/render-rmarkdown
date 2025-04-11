# Install required packages
if (!requireNamespace("flexdashboard", quietly = TRUE)) {
  install.packages("flexdashboard")
}

# Get command line arguments
args <- commandArgs(trailingOnly = TRUE)
input_file <- args[1]

# Render the document
rmarkdown::render(input_file)

# List generated files
base_dir <- dirname(input_file)
base_name <- tools::file_path_sans_ext(basename(input_file))
output_files <- list.files(
  path = base_dir,
  pattern = paste0("^", base_name, "\\.(pdf|html|docx)$"),
  full.names = TRUE
)

# Output results
writeLines(sprintf("::set-output name=output_files::%s", 
                  paste(output_files, collapse = ","))) 
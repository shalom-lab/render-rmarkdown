# Get command line arguments
args <- commandArgs(trailingOnly = TRUE)
input_file <- args[1]

# Read and parse YAML header
yaml_content <- rmarkdown::yaml_front_matter(input_file)

# Check if flexdashboard is needed
needs_flexdashboard <- any(
  grepl("flexdashboard", 
        sapply(yaml_content$output, function(x) if(is.character(x)) x else names(x)[1]))
)

# Install required packages only if needed
if (needs_flexdashboard && !requireNamespace("flexdashboard", quietly = TRUE)) {
  install.packages("flexdashboard")
}

# Set knitr options for figures
knitr::opts_chunk$set(
  fig.width = 7,
  fig.height = 5,
  fig.path = 'figures/'
)

# Render all formats defined in YAML
rmarkdown::render(
  input = input_file,
  output_format = "all"  # This will render all formats defined in YAML
)

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
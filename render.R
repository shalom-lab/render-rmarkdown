# Get command line arguments
args <- commandArgs(trailingOnly = TRUE)
input_file <- args[1]

# Create output directory
output_dir <- "_output"
if (!dir.exists(output_dir)) {
  dir.create(output_dir)
}

# Print debug info
cat("Working directory:", getwd(), "\n")
cat("Input file:", input_file, "\n")
cat("File exists:", file.exists(input_file), "\n")
cat("Output directory:", output_dir, "\n")

# Set knitr options for figures
knitr::opts_chunk$set(
  fig.width = 7,
  fig.height = 5,
  fig.path = 'figures/'
)

# Render document
tryCatch({
  rmarkdown::render(
    input = input_file,
    output_format = "all",  # This will render all formats defined in YAML
    output_dir = output_dir
  )
}, error = function(e) {
  cat("\nError during rendering:\n")
  cat(e$message, "\n")
  quit(status = 1)
})

# List generated files
base_name <- tools::file_path_sans_ext(basename(input_file))
output_files <- list.files(
  path = output_dir,
  pattern = paste0("^", base_name, "\\.(pdf|html|docx)$"),
  full.names = TRUE
)

# Print debug info about output files
cat("\nOutput directory contents:\n")
cat(paste(list.files(output_dir), collapse = "\n"), "\n")
cat("\nFound output files:\n")
cat(paste(output_files, collapse = "\n"), "\n")

# Get GITHUB_OUTPUT environment variable
github_output <- Sys.getenv("GITHUB_OUTPUT")
if (github_output != "") {
  # Write to GITHUB_OUTPUT file
  write(
    sprintf("output_files=%s", paste(output_files, collapse = ",")),
    file = github_output,
    append = TRUE
  )
} else {
  # Fallback for local testing
  cat("output_files=", paste(output_files, collapse = ","), "\n")
} 
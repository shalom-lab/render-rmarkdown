# Get command line arguments
args <- commandArgs(trailingOnly = TRUE)
input_file <- args[1]

# Try to read YAML header safely
needs_flexdashboard <- tryCatch({
  # First check if we can read the file
  if (!file.exists(input_file)) {
    warning("Input file not found")
    FALSE
  } else {
    # Read the first few lines to check for flexdashboard
    lines <- readLines(input_file, n = 30)  # Read first 30 lines
    yaml_text <- paste(lines, collapse = "\n")
    any(grepl("flexdashboard", yaml_text, fixed = TRUE))
  }
}, error = function(e) {
  warning("Error reading YAML header: ", e$message)
  FALSE
})

# Print debug info
cat("Working directory:", getwd(), "\n")
cat("Input file:", input_file, "\n")
cat("File exists:", file.exists(input_file), "\n")
cat("Needs flexdashboard:", needs_flexdashboard, "\n")

# Set knitr options for figures
knitr::opts_chunk$set(
  fig.width = 7,
  fig.height = 5,
  fig.path = 'figures/'
)

# Render all formats defined in YAML
tryCatch({
  if (needs_flexdashboard) {
    # For flexdashboard, render directly
    rmarkdown::render(
      input = input_file,
      output_format = "flexdashboard::flex_dashboard"
    )
  } else {
    # For multiple formats, render each format separately
    formats <- c("pdf_document", "html_document", "word_document")
    for (format in formats) {
      tryCatch({
        rmarkdown::render(
          input = input_file,
          output_format = format
        )
      }, error = function(e) {
        cat("\nWarning: Failed to render", format, ":", e$message, "\n")
      })
    }
  }
}, error = function(e) {
  cat("\nError during rendering:\n")
  cat(e$message, "\n")
  quit(status = 1)
})

# List generated files
base_dir <- dirname(input_file)
base_name <- tools::file_path_sans_ext(basename(input_file))
output_files <- list.files(
  path = base_dir,
  pattern = paste0("^", base_name, "\\.(pdf|html|docx)$"),
  full.names = TRUE
)

# Print debug info about output files
cat("\nOutput directory contents:\n")
cat(paste(list.files(base_dir), collapse = "\n"), "\n")
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
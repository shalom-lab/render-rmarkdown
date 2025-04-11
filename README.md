# RMD Render Action

A GitHub Action to render R Markdown documents using the rocker/r-rmd Docker image. This action includes rmarkdown, pandoc, and LaTeX support out of the box.

## Features

- Renders R Markdown documents to PDF, Word, HTML formats, and Flexdashboard
- Uses the official rocker/r-rmd image which includes all necessary dependencies
- Simple configuration with minimal setup required
- Automatic installation of required R packages (including flexdashboard)

## Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `input_file` | Path to the input R Markdown file | Yes | - |
| `output_format` | Output format (`pdf_document`, `word_document`, `html_document`, or `flexdashboard::flex_dashboard`) | No | `pdf_document` |

## Outputs

| Output | Description |
|--------|-------------|
| `output_file` | Path to the rendered output file |

## Example Usage

Here's how to use this action in your workflow:

```yaml
name: Render R Markdown
on: [push]

jobs:
  render:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Render Document
        uses: ./  # Uses this action
        with:
          input_file: 'path/to/your/document.Rmd'
          output_format: 'pdf_document'  # Optional, defaults to pdf_document
      
      # Optional: Upload the rendered file as an artifact
      - name: Upload Rendered File
        uses: actions/upload-artifact@v2
        with:
          name: rendered-document
          path: ${{ steps.render.outputs.output_file }}
```

### Flexdashboard Example

To render a flexdashboard, use the following configuration:

```yaml
name: Render Flexdashboard
on: [push]

jobs:
  render:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Render Dashboard
        uses: ./
        with:
          input_file: 'dashboard.Rmd'
          output_format: 'flexdashboard::flex_dashboard'
      
      # Optional: Upload the rendered dashboard
      - name: Upload Dashboard
        uses: actions/upload-artifact@v2
        with:
          name: dashboard
          path: ${{ steps.render.outputs.output_file }}
```

Example Flexdashboard R Markdown header:
```yaml
---
title: "My Dashboard"
output: 
  flexdashboard::flex_dashboard:
    orientation: columns
    vertical_layout: fill
---
```

## Example Workflow with Commit Back

If you want to commit the rendered document back to your repository:

```yaml
name: Render and Commit
on: [push]

jobs:
  render:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Render Document
        uses: ./
        with:
          input_file: 'document.Rmd'
      
      - name: Commit Files
        run: |
          git config --local user.email "action@github.com"
          git config --local user.name "GitHub Action"
          git add *.pdf *.html  # Added *.html for flexdashboard outputs
          git commit -m "Re-render R Markdown documents" || echo "No changes to commit"
          git push origin || echo "No changes to push"
```

## Notes

- The action uses the rocker/r-rmd image which includes all necessary dependencies for rendering R Markdown documents
- LaTeX is pre-installed in the image, so PDF rendering will work out of the box
- The flexdashboard package is automatically installed if not present
- The action will automatically determine the output file name based on the input file name and chosen format
- Flexdashboard outputs are always rendered as HTML files

## License

MIT 
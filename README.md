# R Markdown Render Action

A GitHub Action for rendering R Markdown documents in multiple formats (PDF, HTML, Word, Flexdashboard).

## Features

- Supports multiple output formats:
  - PDF (using XeLaTeX)
  - HTML
  - Word
  - Flexdashboard
- Uses `slren/tidyverse-rmd` Docker image with all dependencies pre-installed
- Automatic package installation based on document requirements

## Usage

```yaml
name: Render R Markdown
on: [push]

jobs:
  render:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Render Documents
        uses: ./
        with:
          input_file: 'path/to/your/document.Rmd'
```

## Inputs

| Name | Description | Required |
|------|-------------|----------|
| `input_file` | Path to the R Markdown file to render | Yes |

## Outputs

| Name | Description |
|------|-------------|
| `output_files` | Comma-separated list of generated output files |

## Example

```yaml
name: Test R Markdown Formats
on: [push]

jobs:
  render:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Render Documents
        id: render_docs
        uses: ./
        with:
          input_file: 'test/test_formats.Rmd'
      
      - name: Upload Documents
        uses: actions/upload-artifact@v4
        with:
          name: rendered-documents
          path: ${{ steps.render_docs.outputs.output_files }}
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details. 
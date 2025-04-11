# 📝 R Markdown Render Action

A GitHub Action for rendering R Markdown documents in multiple formats (PDF, HTML, Word, Flexdashboard).

## ✨ Features

- 🎯 Multiple output formats:
  - 📄 PDF (using XeLaTeX)
  - 🌐 HTML
  - 📝 Word
  - 📊 Flexdashboard
- 🐳 Uses `slren/tidyverse-rmd` Docker image
- 🔄 Automatic package installation

## 🚀 Quick Start

### Using the Action in Your Repository

```yaml
name: Render R Markdown
on: [push]

jobs:
  render:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Render Documents
        id: render_docs
        uses: shalom-lab/render-rmarkdown@v1
        with:
          input_file: 'path/to/your/document.Rmd'
      
      ## Process your subsequent logic with the rendered files(under _output directory)
      - name: Upload Documents
        uses: actions/upload-artifact@v4
        with:
          name: rendered-documents
          path: _output/
```

### Example Workflow

Here's a complete example that renders an R Markdown file and publishes the output:

```yaml
name: Render and Publish R Markdown

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  render:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Render Documents
        uses: shalom-lab/render-rmarkdown@v1
        with:
          input_file: 'docs/report.Rmd'
      
      - name: Upload Documents
        uses: actions/upload-artifact@v4
        with:
          name: rendered-documents
          path: _output/
```

## 📚 Usage Guide

### 🔧 Inputs

| Name | Description | Required |
|------|-------------|----------|
| `input_file` | Path to the R Markdown file to render | Yes |

### 📤 Outputs

| Name | Description |
|------|-------------|
| `output_files` | Comma-separated list of generated output files in the `_output/` directory |

### 📁 Output Location

All rendered files are saved in the `_output/` directory:

- Input: `docs/report.Rmd`
- Output: 
  - `_output/report.pdf`
  - `_output/report.html`
  - `_output/report.docx`

## 🛠️ Development

### 🧪 Local Testing

```bash
docker pull slren/tidyverse-rmd
docker run -v $(pwd):/workspace -w /workspace slren/tidyverse-rmd Rscript render.R test/test_formats.Rmd
```

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details. 
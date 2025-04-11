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
        uses: ./
        with:
          input_file: 'path/to/your/document.Rmd'
      
      # Optional: Upload as artifacts
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

### 💾 Committing to Repository

You can optionally commit the rendered files to your repository:

```yaml
# Configure Git
- name: Configure Git
  run: |
    git config --global user.name 'github-actions[bot]'
    git config --global user.email 'github-actions[bot]@users.noreply.github.com'

# Commit specific files
- name: Commit specific files
  run: |
    git add _output/report.pdf  # Only commit PDF
    git commit -m "Update PDF report [skip ci]"
    git push

# Or commit all files
- name: Commit all files
  run: |
    git add _output/
    git commit -m "Update all rendered documents [skip ci]"
    git push
```

## 🛠️ Development

### 🧪 Local Testing

```bash
docker pull slren/tidyverse-rmd
docker run -v $(pwd):/workspace -w /workspace slren/tidyverse-rmd Rscript render.R test/test_formats.Rmd
```

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details. 
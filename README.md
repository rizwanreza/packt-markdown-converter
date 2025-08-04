# Packt Markdown to Word Converter

A conversion tool for technical book authors writing for Packt Publishing. Converts Markdown files to properly formatted Word documents with Packt-specific styling.

## Requirements

- Ruby
- Pandoc
- Python 3 with `python-docx` library

## Usage

```bash
ruby convert.rb <markdown-file>
```

**Example:**
```bash
ruby convert.rb chapter-4-draft.md
```

This will generate `final.docx` with proper Packt Publishing formatting.

## What it does

1. Converts Markdown to Word using pandoc with Packt reference styles
2. Remaps code block styles to Packt-specific formatting:
   - Fenced code blocks → `L - Source` style
   - Inline code → `P - Code` style

## Files

- `convert.rb` - Main conversion script
- `reference.docx` - Packt Publishing Word template
- `map-styles.lua` - Pandoc Lua filter for style mapping
- `remap_code_style.py` - Python script for final code style remapping
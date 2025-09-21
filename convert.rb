#!/usr/bin/env ruby

require 'fileutils'

def main
  if ARGV.length != 1
    puts "Usage: ruby convert.rb <markdown-file>"
    puts "Example: ruby convert.rb chapter-4-draft.md"
    exit 1
  end

  markdown_file = ARGV[0]
  
  unless File.exist?(markdown_file)
    puts "ERROR: '#{markdown_file}' not found."
    exit 1
  end

  # Generate output filename
  base_name = File.basename(markdown_file, File.extname(markdown_file))
  cleaned_file = "#{base_name}_cleaned.md"
  intermediate_file = "#{base_name}_intermediate.docx"
  final_file = "#{base_name}.docx"

  puts "Converting #{markdown_file} to Word document..."

  # Step 1: Prepare markdown
  puts "Step 1: Preparing markdown..."
  FileUtils.mkdir_p('tmp') unless Dir.exist?('tmp')
  prepare_cmd = "ruby scripts/prepare_markdown.rb \"#{markdown_file}\" \"tmp/#{cleaned_file}\""

  unless system(prepare_cmd)
    puts "ERROR: Markdown preparation failed"
    exit 1
  end

  # Step 2: Run pandoc
  puts "Step 2: Running pandoc..."
  pandoc_cmd = "pandoc \"tmp/#{cleaned_file}\" --reference-doc=scripts/reference.docx --lua-filter=scripts/map-styles.lua -o \"tmp/#{intermediate_file}\""
  
  unless system(pandoc_cmd)
    puts "ERROR: pandoc conversion failed"
    exit 1
  end

  # Step 3: Run Python script for style remapping
  puts "Step 3: Remapping code styles..."
  FileUtils.mkdir_p('output') unless Dir.exist?('output')
  python_cmd = "python scripts/remap_code_style.py \"tmp/#{intermediate_file}\" \"output/#{final_file}\""
  
  unless system(python_cmd)
    puts "ERROR: Python style remapping failed"
    exit 1
  end

  puts "✓ Conversion complete: output/#{final_file}"
  puts "✓ Prepared markdown saved as: tmp/#{cleaned_file} (for debugging)"
  puts "✓ Intermediate file saved as: tmp/#{intermediate_file} (for debugging)"
end

if __FILE__ == $0
  main
end

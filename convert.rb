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
  intermediate_file = "#{base_name}_intermediate.docx"
  final_file = "#{base_name}.docx"

  puts "Converting #{markdown_file} to Word document..."

  # Step 1: Run pandoc
  puts "Step 1: Running pandoc..."
  FileUtils.mkdir_p('tmp') unless Dir.exist?('tmp')
  pandoc_cmd = "pandoc \"#{markdown_file}\" --reference-doc=scripts/reference.docx --lua-filter=scripts/map-styles.lua -o \"tmp/#{intermediate_file}\""
  
  unless system(pandoc_cmd)
    puts "ERROR: pandoc conversion failed"
    exit 1
  end

  # Step 2: Run Python script for style remapping
  puts "Step 2: Remapping code styles..."
  FileUtils.mkdir_p('output') unless Dir.exist?('output')
  python_cmd = "python scripts/remap_code_style.py \"tmp/#{intermediate_file}\" \"output/#{final_file}\""
  
  unless system(python_cmd)
    puts "ERROR: Python style remapping failed"
    exit 1
  end

  puts "✓ Conversion complete: output/#{final_file}"
  puts "✓ Intermediate file saved as: tmp/#{intermediate_file} (for debugging)"
end

if __FILE__ == $0
  main
end

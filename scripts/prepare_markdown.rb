#!/usr/bin/env ruby

require 'uri'

def prepare_markdown(input_file, output_file)
  content = File.read(input_file)

  # First pass: handle code blocks and inline code
  content = process_inline_code(content)
  content = process_urls(content)

  lines = content.split("\n")

  cleaned_lines = []
  i = 0

  while i < lines.length
    line = lines[i]

    # Skip horizontal rules
    if line.strip == '---'
      i += 1
      next
    end

    # Handle chapter number and title formatting
    if i == 0 && line.match(/^#\s*\d+\s*$/)
      # First line is just a chapter number - add custom style and continue to next line for title
      cleaned_lines << "#{line.strip} {custom-style=\"H1 - Chapter\"}"
      i += 1

      # Skip empty lines until we find the title
      while i < lines.length && lines[i].strip.empty?
        i += 1
      end

      # Add the title with H1 - Chapter style if it exists
      if i < lines.length && lines[i].match(/^#\s+/)
        title_line = lines[i].sub(/^#\s+/, '# ').strip
        cleaned_lines << "#{title_line} {custom-style=\"H1 - Chapter\"}"
      end

    elsif i == 0 && line.match(/^#\s+.*Chapter\s+\d+/i)
      # First line contains both chapter number and title
      cleaned_lines << "#{line.strip} {custom-style=\"H1 - Chapter\"}"

    elsif line.match(/^#\s+\d+\.\s+(.+)$/)
      # Recipe headings with numbers - remove the number
      recipe_title = line.match(/^#\s+\d+\.\s+(.+)$/)[1]
      cleaned_lines << "# #{recipe_title}"

    else
      # Keep all other lines as-is
      cleaned_lines << line
    end

    i += 1
  end

  # Write cleaned content
  File.write(output_file, cleaned_lines.join("\n"))
end

def process_inline_code(content)
  # Match pairs of single backticks that are NOT part of triple backticks
  # Use negative lookbehind/lookahead to avoid ``` sequences
  content.gsub(/(?<!`)`([^`]+?)`(?!`)/) do |match|
    code_content = $1
    "<span custom-style=\"P - Code\">#{code_content}</span>"
  end
end

def process_urls(content)
  # Replace markdown links with URL styling
  content = content.gsub(/\[([^\]]+)\]\(([^\)]+)\)/) do |match|
    link_text = $1
    url = $2
    "<span custom-style=\"P - URL\">#{link_text}</span>"
  end

  # Style standalone URLs
  content.gsub(URI.regexp(['http', 'https'])) do |match|
    "<span custom-style=\"P - URL\">#{match}</span>"
  end
end

if __FILE__ == $0
  if ARGV.length != 2
    puts "Usage: ruby prepare_markdown.rb <input-file> <output-file>"
    exit 1
  end

  input_file = ARGV[0]
  output_file = ARGV[1]

  unless File.exist?(input_file)
    puts "ERROR: Input file '#{input_file}' not found."
    exit 1
  end

  prepare_markdown(input_file, output_file)
  puts "✓ Markdown preparation complete: #{output_file}"
end

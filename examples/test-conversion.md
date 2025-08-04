# Test Document for Style Conversion {custom-style="H1 - Chapter"}

# Chapter 1: Test Conversion Document

This is a test document to verify the markdown to Word conversion process works correctly with Packt Publishing styles.

## Getting Started

Let's start with some basic text and then test various formatting elements.

### Code Examples

Here's an inline code example: `Rails.application.routes` which should be styled correctly.

Now let's test a code block:

```ruby
class TestController < ApplicationController
  def index
    @message = "Hello, World!"
    @status = :success
  end
end
```

### More Code Styles

Another inline code snippet: `bundle install` for installing gems.

```javascript
function testConversion() {
  console.log("Testing JavaScript code block");
  return true;
}
```

## Technical Requirements

This test assumes you have:
- Ruby installed
- Pandoc installed  
- Python with python-docx library

## Summary

This document tests the key formatting styles used in Packt Publishing technical books, specifically focusing on code formatting that gets remapped by the conversion process.

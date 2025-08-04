#!/usr/bin/env python3
import sys, os
from docx import Document

def main():
    if len(sys.argv) != 3:
        print("Usage: python remap_code_style.py input.docx output.docx")
        sys.exit(1)

    inp, outp = sys.argv[1], sys.argv[2]
    if not os.path.isfile(inp):
        print(f"ERROR: '{inp}' not found.")
        sys.exit(1)

    # Load the document
    doc = Document(inp)

    # Iterate paragraphs for remapping styles
    for para in doc.paragraphs:
        # Fenced code blocks: style_id 'SourceCode' → custom 'L-Source'
        if para.style and para.style.style_id == 'SourceCode':
            para.style = doc.styles['L - Source']

        # Inline code runs: style_id 'Code' → custom 'P-Code'
        for run in para.runs:
            if run.style and run.style.style_id == 'Code':
                run.style = doc.styles['P - Code']

    # Save the updated document
    doc.save(outp)
    print(f"Re-styled document saved as: {outp}")

if __name__ == '__main__':
    main()


-- map-styles.lua
-- Only remap headings, nothing else.

local heading_style = {
  [1] = "H1 - Section",
  [2] = "H2 - Heading",
  [3] = "H3 - Subheading",
  -- add more if needed
}

function Header(h)
  -- 1) Check for an explicit {custom-style="…"} on the heading
  local attr_style = h.attr and h.attr.attributes["custom-style"]
  -- 2) Fallback to your level→style table
  local style = attr_style or heading_style[h.level]
  if not style then
    return h  -- leave it as a real Header
  end
  -- 3) Wrap in a Div+Para so Word applies your paragraph style
  --    (and you lose true Header semantics, but code blocks and inline
  --     code elsewhere are untouched)
  return pandoc.Div(
    { pandoc.Para(h.content) },
    pandoc.Attr("", {}, { ["custom-style"] = style })
  )
end

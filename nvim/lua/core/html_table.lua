local M = {}

local entities = {
  amp = "&",
  apos = "'",
  gt = ">",
  lt = "<",
  nbsp = " ",
  quot = '"',
}

local function decode_entities(value)
  value = value:gsub("&#x([%da-fA-F]+);", function(code)
    local ok, character = pcall(utf8.char, tonumber(code, 16))
    return ok and character or "&#x" .. code .. ";"
  end)
  value = value:gsub("&#(%d+);", function(code)
    local ok, character = pcall(utf8.char, tonumber(code, 10))
    return ok and character or "&#" .. code .. ";"
  end)
  return value:gsub("&([%a]+);", function(name)
    return entities[name] or "&" .. name .. ";"
  end)
end

local function cell_text(value)
  value = value:gsub("<br%s*/?>", " / ")
  value = value:gsub("<[^>]->", "")
  value = decode_entities(value)
  value = value:gsub("%s+", " ")
  return vim.trim(value)
end

local function normalize_tags(value)
  return value:gsub("<(%s*/?%s*)([%w:_-]+)(.-)>", function(prefix, name, suffix)
    return "<" .. prefix .. name:lower() .. suffix .. ">"
  end)
end

local function parse_rows(value)
  local rows = {}
  local header_rows = {}

  for _, row in normalize_tags(value):gmatch("<tr([^>]*)>(.-)</tr%s*>") do
    local cells = {}
    local header = false
    for kind, attributes, content in row:gmatch("<t([dh])([^>]*)>(.-)</t[dh]%s*>") do
      local text = cell_text(content)
      local colspan = tonumber(attributes:match('colspan%s*=%s*["\']?(%d+)')) or 1
      cells[#cells + 1] = text
      for _ = 2, colspan do
        cells[#cells + 1] = ""
      end
      header = header or kind == "h"
    end
    if #cells > 0 then
      rows[#rows + 1] = cells
      header_rows[#rows] = header
    end
  end

  return rows, header_rows
end

local function pad(value, width)
  return value .. string.rep(" ", width - vim.fn.strdisplaywidth(value))
end

local function border(widths, left, middle, right)
  local cells = {}
  for index, width in ipairs(widths) do
    cells[index] = string.rep("─", width + 2)
  end
  return left .. table.concat(cells, middle) .. right
end

local function render_table(value)
  local rows, header_rows = parse_rows(value)
  if #rows == 0 then
    return nil
  end

  local widths = {}
  for _, row in ipairs(rows) do
    for column, cell in ipairs(row) do
      widths[column] = math.max(widths[column] or 0, vim.fn.strdisplaywidth(cell))
    end
  end

  local lines = {
    { { border(widths, "┌", "┬", "┐"), "RenderMarkdownTableRow" } },
  }
  for row_index, row in ipairs(rows) do
    local cells = {}
    for column, width in ipairs(widths) do
      cells[column] = " " .. pad(row[column] or "", width) .. " "
    end
    local highlight = header_rows[row_index] and "RenderMarkdownTableHead" or "RenderMarkdownTableRow"
    lines[#lines + 1] = { { "│" .. table.concat(cells, "│") .. "│", highlight } }
    if row_index < #rows then
      lines[#lines + 1] = { { border(widths, "├", "┼", "┤"), "RenderMarkdownTableRow" } }
    end
  end
  lines[#lines + 1] = { { border(widths, "└", "┴", "┘"), "RenderMarkdownTableRow" } }
  return lines
end

local function table_ranges(lines)
  local ranges = {}
  local start_row

  for row, line in ipairs(lines) do
    local lower = line:lower()
    if not start_row and lower:find("<table[%s>]", 1) then
      start_row = row
    end
    if start_row and lower:find("</table%s*>", 1) then
      ranges[#ranges + 1] = { start_row, row }
      start_row = nil
    end
  end
  return ranges
end

function M.parse(ctx)
  if ctx.last == false then
    return {}
  end

  local source = vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)
  local marks = {}

  for _, range in ipairs(table_ranges(source)) do
    local first, last = range[1], range[2]
    local rendered = render_table(table.concat(source, "\n", first, last))
    if rendered then
      marks[#marks + 1] = {
        conceal = false,
        start_row = first - 1,
        start_col = 0,
        opts = {
          end_row = last,
          end_col = 0,
          conceal_lines = "",
          virt_lines = rendered,
          virt_lines_above = true,
        },
      }
    end
  end

  return marks
end

return M

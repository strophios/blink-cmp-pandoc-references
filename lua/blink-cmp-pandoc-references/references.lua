--- @type lsp.CompletionItem[]
local entries = {}
local M = {}

-- (Crudely) Locates the bibliography
local function locate_bib(lines)
  for _, line in ipairs(lines) do
    local location = string.match(line, 'bibliography: (%g+)')
    if location then
      return location
    end
  end
  -- no bib locally defined
  -- test for quarto project-wide definition
  local fname = vim.api.nvim_buf_get_name(0)
  local root = require('lspconfig.util').root_pattern '_quarto.yml'(fname)
  if root then
    local file = root .. '/_quarto.yml'
    for line in io.lines(file) do
      local location = string.match(line, 'bibliography: (%g+)')
      if location then
        return location
      end
    end
  end
end

-- Remove newline & excessive whitespace
local function clean(text)
  if text then
    text = text:gsub('\n', ' ')
    return text:gsub('%s%s+', ' ')
  else
    return text
  end
end

local function name_parse(name)
  -- NOTE: add logic dealing with suffixes?
  if not name['non-dropping-particle'] then
    return name.family
  else
    return name['non-dropping-particle'] .. ' ' .. name.family
  end
end

local function author_parse(authors)
  if not authors then
    return ''
  end

  local parsed_auths = {}
  for i = 1, table.maxn(authors) do
    table.insert(parsed_auths, name_parse(authors[i]))
  end

  if table.maxn(parsed_auths) == 1 then
    return parsed_auths[1]
  elseif table.maxn(parsed_auths) == 2 then
    return (parsed_auths[1] .. ' and ' .. parsed_auths[2])
  elseif table.maxn(parsed_auths) == 3 then
    return (parsed_auths[1] .. ', ' .. parsed_auths[2] .. ', and ' .. parsed_auths[3])
  else
    return (parsed_auths[1] .. ', ' .. parsed_auths[2] .. ', et al.')
  end
end

local function date_parse(issued)
  if not issued then
    return ''
  end

  local parts = issued['date-parts']
  return parts[1][1]
end

-- Parses the .bib file, formatting the completion item
local function parse_bib(filename, fields)
  local file = io.open(filename, 'rb')
  assert(file, 'Could not open file ' .. filename)
  local bibentries = file:read '*all'
  file:close()
  bibentries = vim.json.decode(bibentries)

  for i = 1, table.maxn(bibentries) do
    local title = clean(bibentries[i].title) or ''
    local authors = clean(author_parse(bibentries[i].author)) or ''
    local year = date_parse(bibentries[i].issued)

    local doc = { '**' .. title .. '**', '', '*' .. authors .. '*', year }

    --- @type lsp.CompletionItem
    local entry = {
      label = '@' .. bibentries[i]['citation-key'],
      kind = fields.entry_kind,
      insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText,
      documentation = {
        kind = fields.documentation_kind,
        value = table.concat(doc, '\n'),
      },
    }

    table.insert(entries, entry)
  end
end

-- Parses the references in the current file, formatting for completion
local function parse_ref(lines, fields)
  local words = table.concat(lines, '\n')

  for ref in words:gmatch '{#(%a+[:%-][%w_-]+)' do
    local entry = {}
    entry.label = '@' .. ref
    entry.kind = fields.entry_kind
    table.insert(entries, entry)
  end
  for ref in words:gmatch '#| label: (%a+[:%-][%w_-]+)' do
    local entry = {}
    entry.label = '@' .. ref
    entry.kind = fields.entry_kind
    table.insert(entries, entry)
  end
end

-- Returns the entries as a table, clearing entries beforehand
function M.get_entries(lines, fields)
  local location = locate_bib(lines)

  entries = {}

  if location and vim.fn.filereadable(location) == 1 then
    parse_bib(location, fields)
  end
  parse_ref(lines, fields)

  return entries
end

return M

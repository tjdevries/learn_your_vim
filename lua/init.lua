local vim = vim
local api = vim.api

function os.capture(cmd, raw)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')
  return s
end

local lyv = {}


function lyv.test()
    local keymap = api.nvim_get_keymap('n')

    local lookedup_sids = {}

    local anki_lines = {}
    for _, mapping_dict in ipairs(keymap) do
        local script_sid = mapping_dict.sid

        local script_filename = nil
        if lookedup_sids[script_sid] ~= nil then
            script_filename = lookedup_sids[script_sid]
        else
           script_filename = api.nvim_call_function('scriptease#scriptname', {script_sid})
        end


        local line_value = os.capture(string.format("sed '%sq;d' %s", mapping_dict.lnum - 1, script_filename))
        table.insert(anki_lines, {line=line_value, mapping=mapping_dict})
    end

    return anki_lines
end

-- print(os.time())
-- print(lyv.test())
-- print(os.time())

return lyv

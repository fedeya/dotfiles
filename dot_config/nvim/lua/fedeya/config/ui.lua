local msgs = require 'vim._core.ui2.messages'
local ui2 = require 'vim._core.ui2'

ui2.enable({
  enable = true,
  msg = {
    targets = {
      [''] = 'msg',
      empty = 'msg',
      bufwrite = 'msg',
      echo = 'msg',
      echomsg = 'msg',
      shell_ret = 'msg',
      undo = 'msg',
      wmsg = 'msg',
      completion = 'msg',
      confirm = 'dialog',
      confirm_sub = 'dialog',
      echoerr = 'msg',
      emsg = 'msg',
      list_cmd = 'pager',
      lua_error = 'msg',
      lua_print = 'msg',
      progress = 'msg',
      quickfix = 'msg',
      rpc_error = 'msg',
      search_cmd = 'cmd',
      search_count = 'cmd',
      shell_cmd = 'msg',
      shell_err = 'msg',
      shell_out = 'msg',
      typed_cmd = 'msg',
      verbose = 'pager',
      wildlist = 'msg',
    },
    cmd = { height = 0.5 },
    dialog = { height = 0.5 },
    msg = { height = 0.5, timeout = 2000 },
    pager = { height = 0.8 },
  },
})

local IGNORED_KINDS = {
  bufwrite = true,
  [''] = true,
  empty = true,
  search_cmd = true,
  search_count = true,
}


local SKIP_PATTERNS = {
  '%d+L, %d+B',
  '; after #%d+',
  '; before #%d+',
  '%d fewer lines',
  '%d more lines',
  '%d lines yanked',
}


local function content_to_text(content)
  if type(content) ~= 'table' then
    return tostring(content or '')
  end
  local parts = {}
  for _, chunk in ipairs(content) do
    if type(chunk) == 'table' and chunk[2] then
      parts[#parts + 1] = chunk[2]
    end
  end
  return table.concat(parts)
end


local function should_skip(kind, content)
  if IGNORED_KINDS[kind] then
    return true
  end
  local text = content_to_text(content)
  for _, pat in ipairs(SKIP_PATTERNS) do
    if text:find(pat) then
      return true
    end
  end
  return false
end

-- local orig_msg_show = msgs.msg_show

msgs.msg_show = function(kind, content, replace_last, _, append, id, trigger)
  if should_skip(kind, content) then
    return
  end

  -- orig_msg_show(kind, content, replace_last, history, append, id, trigger)

  local tgt = ui2.cfg.msg.targets[kind]
      or (trigger ~= '' and ui2.cfg.msg.targets[trigger])
      or ui2.cfg.msg.targets[trigger]
      or ui2.cfg.msg.target

  msgs.show_msg(tgt, kind, content, replace_last, append, id)
  msgs.set_pos(tgt)
end

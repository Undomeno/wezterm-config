local wezterm = require('wezterm')

local color_palette = require('themes.color')

-- Inspired by https://github.com/wez/wezterm/discussions/628#discussioncomment-1874614

local nf = wezterm.nerdfonts

local GLYPH_EMACS = nf.custom_emacs --[[ '' ]]
local GLYPH_CIRCLE_DOUBLE = nf.md_circle_double--[[ '󰺕' ]]
local GLYPH_BOOK= nf.fae_book_open_o --[[ '' ]]
local GLYPH_CIRCLE = nf.oct_dot_fill --[[ '' ]]
local GLYPH_ADMIN = nf.md_shield_half_full --[[ '󰞀' ]]
local GLYPH_UBUNTU = nf.cod_terminal_linux

local M = {}

local __cells__ = {} -- wezterm FormatItems (ref: https://wezfurlong.org/wezterm/config/lua/wezterm/format.html)

-- stylua: ignore
local colors = {
   default   = { bg = 'rgba(0,0,0,0)', fg = color_palette.tab_bar.inactive_tab.fg_color },
   is_active = { bg = 'rgba(0,0,0,0)', fg = color_palette.tab_bar.active_tab.fg_color },
   hover     = { bg = 'rgba(0,0,0,0)', fg = color_palette.tab_bar.inactive_tab_hover.fg_color },
}

local _set_process_name = function(s)
   local a = string.gsub(s, '(.*[/\\])(.*)', '%2')
   return a:gsub('%.exe$', '')
end

local _set_title = function(process_name, base_title, max_width, inset)
   local title
   inset = inset or 6

   if process_name:len() > 0 then
      title = process_name .. ' ~ ' .. base_title
   else
      title = base_title
   end

   if title:len() > max_width - inset then
      local diff = title:len() - max_width + inset
      title = wezterm.truncate_right(title, title:len() - diff)
   end

   return title
end

local _check_if_admin = function(p)
   if p:match('^Administrator: ') or p:match('(Admin)') then
      return true
   end
   return false
end

local _check_if_wsl = function(title)
   if title:match('^wsl') then
      return true
   end
   return false
end

local _check_if_emacs = function(p)
   if p:match('^emacsclient') or p:match('(Emacs)') then
      return true
   end
   return false
end


---@param fg string
---@param bg string
---@param attribute table
---@param text string
local _push = function(bg, fg, attribute, text)
   table.insert(__cells__, { Background = { Color = bg } })
   table.insert(__cells__, { Foreground = { Color = fg } })
   table.insert(__cells__, { Attribute = attribute })
   table.insert(__cells__, { Text = text })
end

M.setup = function()
   wezterm.on('format-tab-title', function(tab, _tabs, _panes, _config, hover, max_width)
      __cells__ = {}

      local bg
      local fg
      local tab_id = tab.tab_id + 1
      local process_name = tab_id .. ': ' .. _set_process_name(tab.active_pane.foreground_process_name)
      local is_admin = _check_if_admin(tab.active_pane.title)
      local is_wsl = _check_if_wsl(process_name)
      local is_emacs = _check_if_emacs(process_name)
      local title =
         _set_title(process_name, tab.active_pane.title, max_width, ((is_admin or is_wsl or is_emacs) and 8))

      if tab.is_active then
         bg = colors.is_active.bg
         fg = colors.is_active.fg
      elseif hover then
         bg = colors.hover.bg
         fg = colors.hover.fg
      else
         bg = colors.default.bg
         fg = colors.default.fg
      end

      for _, pane in ipairs(tab.panes) do
         if pane.has_unseen_output then
            has_unseen_output = true
            break
         end
      end

      -- Left semi-circle
      _push(bg, bg, { Intensity = 'Bold' }, ' ')

      -- Active tab pin
      if tab.is_active then
         _push(bg, fg, { Intensity = 'Bold' }, GLYPH_CIRCLE_DOUBLE)
      else
         _push(bg, fg, { Intensity = 'Half' }, GLYPH_CIRCLE)
      end

      -- Title
      _push(bg, fg, { Intensity = 'Normal' }, ' ' .. title)

       -- Admin Icon
      if is_admin then
         _push(bg, fg, { Intensity = 'Bold' }, ' ' .. GLYPH_ADMIN)
      end

      -- WSL Icon
      if is_wsl then
         _push(bg, fg, { Intensity = 'Bold' }, ' ' .. GLYPH_UBUNTU)
      end

      -- Emacs Icon
      if is_emacs then
         _push(bg, fg, { Intensity = 'Bold' }, ' ' .. GLYPH_EMACS)
         end


      -- Right padding
      _push(bg, fg, { Intensity = 'Bold' }, ' ')


      -- Right semi-circle
      _push(bg, bg, { Intensity = 'Bold' }, ' ')

      return __cells__
   end)
end

return M

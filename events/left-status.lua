local wezterm = require('wezterm')
local color_palette = require('themes.color')

local nf = wezterm.nerdfonts
local M = {}

local GLYPH_SEMI_CIRCLE_LEFT = nf.ple_left_half_circle_thick --[[ '' ]]
local GLYPH_SEMI_CIRCLE_RIGHT = nf.ple_right_half_circle_thick --[[ '' ]]
local GLYPH_KEY_TABLE = nf.md_table_key --[[ '󱏅' ]]
local GLYPH_KEY = nf.md_key --[[ '󰌆' ]]
local GLYPH_BOOK = nf.fae_book_open_o --[[ '' ]]

local colors = {
   glyph_semi_circle = { bg = 'rgba(0, 0, 0, 0)', fg = color_palette.ansi[5] },
   text = { bg = color_palette.ansi[5], fg = color_palette.foreground },
   default   = { bg = 'rgba(0,0,0,0)', fg = color_palette.tab_bar.inactive_tab.fg_color },
}

local __cells__ = {}

---@param text string
---@param fg string
---@param bg string
local _push = function(text, fg, bg)
   table.insert(__cells__, { Foreground = { Color = fg } })
   table.insert(__cells__, { Background = { Color = bg } })
   table.insert(__cells__, { Attribute = { Intensity = 'Bold' } })
   table.insert(__cells__, { Text = text })
end

M.setup = function()
   wezterm.on('update-right-status', function(window, _pane)
      __cells__ = {}

      _push(' ' .. GLYPH_BOOK .. ' ', colors.default.fg, colors.default.bg)

      local name = window:active_key_table()
      if name then
         _push(' ' .. GLYPH_SEMI_CIRCLE_LEFT, colors.glyph_semi_circle.fg, colors.glyph_semi_circle.bg)
         _push(GLYPH_KEY_TABLE, colors.text.fg, colors.text.bg)
         _push(' ' .. string.upper(name), colors.text.fg, colors.text.bg)
         _push(GLYPH_SEMI_CIRCLE_RIGHT, colors.glyph_semi_circle.fg, colors.glyph_semi_circle.bg)
      end

      if window:leader_is_active() then
         _push(' ' .. GLYPH_SEMI_CIRCLE_LEFT, colors.glyph_semi_circle.fg, colors.glyph_semi_circle.bg)
         _push(GLYPH_KEY, colors.text.fg, colors.text.bg)
         _push(' ', colors.text.fg, colors.text.bg)
         _push(GLYPH_SEMI_CIRCLE_RIGHT, colors.glyph_semi_circle.fg, colors.glyph_semi_circle.bg)
      end

      window:set_left_status(wezterm.format(__cells__))
   end)
end

return M

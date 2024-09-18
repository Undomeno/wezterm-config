local wezterm = require('wezterm')
local umath = require('utils.math')
local color_palette = require('themes.color')

local nf = wezterm.nerdfonts
local M = {}

local SEPARATOR_CHAR = nf.cod_kebab_vertical .. ' '

local discharging_icons = {
   nf.md_battery_10,
   nf.md_battery_20,
   nf.md_battery_30,
   nf.md_battery_40,
   nf.md_battery_50,
   nf.md_battery_60,
   nf.md_battery_70,
   nf.md_battery_80,
   nf.md_battery_90,
   nf.md_battery_heart_variant,
}
local charging_icons = {
   nf.md_battery_charging_10,
   nf.md_battery_charging_20,
   nf.md_battery_charging_30,
   nf.md_battery_charging_40,
   nf.md_battery_charging_50,
   nf.md_battery_charging_60,
   nf.md_battery_charging_70,
   nf.md_battery_charging_80,
   nf.md_battery_charging_90,
   nf.md_battery_heart_variant,
}

local colors = {
   date_fg = color_palette.brights[5],
   date_bg = 'rgba(0, 0, 0, 0)',
   battery_fg = color_palette.brights[5],
   battery_bg = 'rgba(0, 0, 0, 0)',
   separator_fg = color_palette.ansi[8],
   separator_bg = 'rgba(0, 0, 0, 0)',
}

local __cells__ = {} -- wezterm FormatItems (ref: https://wezfurlong.org/wezterm/config/lua/wezterm/format.html)

---@param text string
---@param icon string
---@param fg string
---@param bg string
local _push = function(text, fg, bg, separate)
   table.insert(__cells__, { Foreground = { Color = fg } })
   table.insert(__cells__, { Background = { Color = bg } })
   table.insert(__cells__, { Text = text .. ' ' })

   if separate then
      table.insert(__cells__, { Foreground = { Color = colors.separator_fg } })
      table.insert(__cells__, { Background = { Color = colors.separator_bg } })
      table.insert(__cells__, { Text = SEPARATOR_CHAR })
   end
end

local _set_date = function()
   local date = wezterm.strftime('%a %H:%M')
   _push(date, colors.date_fg, colors.date_bg)
end

local _set_utc_date = function()
   local utc_date = wezterm.strftime_utc('%H:%M')
   local date = '(UTC ' .. utc_date .. ')'
   _push(date, color_palette.ansi[8], colors.date_bg, false)
end

local _set_battery = function()
   -- ref: https://wezfurlong.org/wezterm/config/lua/wezterm/battery_info.html

   local charge = ''
   local charge_num = 0
   local icon = ''

   for _, b in ipairs(wezterm.battery_info()) do
      local idx = umath.clamp(umath.round(b.state_of_charge * 10), 1, 10)
      charge_num = b.state_of_charge * 100
      charge = string.format('%.0f%%', charge_num)

      if b.state == 'Charging' then
         colors.battery_fg = color_palette.ansi[8]
         charge =  charge  .. ' ' .. charging_icons[idx]
      elseif charge_num < 15 then
         colors.battery_fg = color_palette.brights[2]
         charge =  charge  .. ' ' .. discharging_icons[idx]
      elseif charge_num < 35 then
         colors.battery_fg = color_palette.brights[4]
         charge =  charge  .. ' ' .. discharging_icons[idx]
      elseif charge_num <70 then
         colors.battery_fg = color_palette.brights[5]
         charge =  charge  .. ' ' .. discharging_icons[idx]
      else
         colors.battery_fg = color_palette.ansi[8]
         charge =  charge  .. ' ' .. discharging_icons[idx]
      end
   end

   _push(charge, colors.battery_fg, colors.battery_bg, true)
end

M.setup = function()
   wezterm.on('update-right-status', function(window, _pane)
      __cells__ = {}
      _set_battery()
      _set_date()
      _set_utc_date()

      window:set_right_status(wezterm.format(__cells__))
   end)
end

return M

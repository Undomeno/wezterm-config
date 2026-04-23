local wezterm = require('wezterm')
local umath = require('utils.math')
local color_palette = require('themes.color')
local spotify = require("events.spotify")
local utilities = require("events.utilities")

local nf = wezterm.nerdfonts
local M = {}

local SEPARATOR_CHAR = nf.cod_kebab_vertical .. ' '
local date_format = '%a %H:%M'
local startup_time = os.time()
local is_initialized = false

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
   date_utc_fg = color_palette.ansi[8],
   date_utc_bg = 'rgba(0, 0, 0, 0)',
   battery_fg = color_palette.brights[5],
   default_bg = 'rgba(0, 0, 0, 0)',
   separator_fg = color_palette.ansi[8],
   separator_bg = 'rgba(0, 0, 0, 0)',
}

local __cells__ = {} -- wezterm FormatItems (ref: https://wezfurlong.org/wezterm/config/lua/wezterm/format.html)

---@param text string
---@param fg string
---@param bg string
---@param separate boolean
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
   local date = wezterm.strftime(date_format)
   _push(date, colors.date_fg, colors.date_bg)
end

local _set_utc_date = function()
   local utc_date = wezterm.strftime_utc('%H:%M')
   local date = '(UTC ' .. utc_date .. ')'
   _push(date, colors.date_utc_fg, colors.date_utc_bg, false)
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
         charge = charge .. ' ' .. charging_icons[idx]
      elseif charge_num < 15 then
         colors.battery_fg = color_palette.brights[2]
         charge = charge .. ' ' .. discharging_icons[idx]
      elseif charge_num < 35 then
         colors.battery_fg = color_palette.brights[4]
         charge = charge .. ' ' .. discharging_icons[idx]
      else
         colors.battery_fg = color_palette.ansi[8]
         charge = charge .. ' ' .. discharging_icons[idx]
      end
   end

   _push(charge, colors.battery_fg, colors.default_bg, true)
end

local _set_spotify = function()
   -- Skip spotify during startup to avoid issues
   local current_time = os.time()
   if current_time - startup_time < 3 then
      return
   end

   -- 使用 pcall 来捕获可能的错误
   local success, text = pcall(function()
      return spotify.get_currently_playing(40, 15)
   end)

   if success and text and text:len() > 0 then
      _push(text, colors.date_utc_fg, colors.date_utc_bg, true)
   end
end

-- Function to update the status bar for a window
local function update_status(window)
   if not window then return end

   -- Prevent duplicate updates during rapid event firing
   local current_time = os.time()
   if not is_initialized and current_time - startup_time < 1 then
      return
   end
   is_initialized = true

   __cells__ = {}

   -- Use pcall to catch any errors that might occur during status updates
   local success, err = pcall(function()
      _set_spotify()
      _set_battery()
      _set_date()
      _set_utc_date()
   end)

   if not success then
      -- If there was an error, show minimal status to avoid blank status bar
      __cells__ = {}
      _set_date()
      _set_utc_date()
   end

   -- Set the status with error handling
   pcall(function()
      window:set_right_status(wezterm.format(__cells__))
   end)
end

M.setup = function(config)
   -- Allow customizing the date format
   if config and config.date_format then
      date_format = config.date_format
   end

   -- Handle regular status updates
   wezterm.on('update-right-status', function(window, _pane)
      update_status(window)
   end)

   -- Handle window focus events to force an update when window gets focus
   -- This helps with resuming from sleep, but only after initialization
   wezterm.on('window-focus-changed', function(window, pane)
      if window:is_focused() and is_initialized then
         -- Add a small delay to prevent rapid updates
         wezterm.sleep_ms(100)
         update_status(window)
      end
   end)

   -- Use a timer to ensure proper initialization after startup
   wezterm.time.call_after(2, function()
      local mux = wezterm.mux
      for _, window in ipairs(mux.all_windows()) do
         local gui_window = window:gui_window()
         if gui_window then
            update_status(gui_window)
         end
      end
   end)
end

return M

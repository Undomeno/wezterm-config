local wezterm = require('wezterm')
local colors = require('themes.color')
local mux = wezterm.mux
local gpu_adapters = require('utils.gpu_adapter')

wezterm.on("gui-startup", function()
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

return {
   animation_fps = 60,
   max_fps = 60,
   front_end = 'WebGpu',
   webgpu_power_preference = 'HighPerformance',
   webgpu_preferred_adapter = gpu_adapters:pick_best(),

   -- color scheme
   colors = colors,

   -- tab
   show_tab_index_in_tab_bar = true,
   enable_tab_bar = true,
   tab_bar_at_bottom = true,
   hide_tab_bar_if_only_one_tab = false,
   use_fancy_tab_bar = false,
   switch_to_last_active_tab_when_closing_tab = true,
   tab_max_width = 27,

   -- window

   window_background_opacity = 0.6,
   macos_window_background_blur = 10,
   window_decorations = "RESIZE",
   window_close_confirmation = 'NeverPrompt',

   inactive_pane_hsb = {
      saturation = 0.9,
      brightness = 0.65,
   },

   window_padding = {
      left = 10,
      right = 7,
      top = 2,
      bottom = 0,
   },

   native_macos_fullscreen_mode = true,
}

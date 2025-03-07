local wezterm = require('wezterm')
local colors = require('themes.color')
local mux = wezterm.mux
local gpu_adapters = require('utils.gpu-adapter')

wezterm.on("gui-startup", function()
  local tab, pane, window = mux.spawn_window{}
  window:gui_window():maximize()
end)

return {
   max_fps = 120,
   front_end = 'WebGpu',
   webgpu_power_preference = 'HighPerformance',
   webgpu_preferred_adapter = gpu_adapters:pick_best(),
   -- webgpu_preferred_adapter = gpu_adapters:pick_manual('Dx12', 'IntegratedGpu'),
   -- webgpu_preferred_adapter = gpu_adapters:pick_manual('Gl', 'Other'),
   underline_thickness = '1.5pt',

   -- cursor
   animation_fps = 120,
   cursor_blink_ease_in = 'EaseOut',
   cursor_blink_ease_out = 'EaseOut',
   default_cursor_style = 'BlinkingBlock',
   cursor_blink_rate = 650,

   -- color scheme
   colors = colors,

   -- scrollbar
   enable_scroll_bar = true,

   -- tab bar
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
   window_padding = {
      left = 0,
      right = 0,
      top = 10,
      bottom = 7.5,
   },
   adjust_window_size_when_changing_font_size = false,
   window_close_confirmation = 'NeverPrompt',
   window_frame = {
      active_titlebar_bg = '#090909',
      -- font = fonts.font,
      -- font_size = fonts.font_size,
   },
   -- inactive_pane_hsb = {
   --    saturation = 0.9,
   --    brightness = 0.65,
   -- },
   inactive_pane_hsb = {
      saturation = 1,
      brightness = 1,
   },
   window_decorations = "RESIZE",

   visual_bell = {
      fade_in_function = 'EaseIn',
      fade_in_duration_ms = 250,
      fade_out_function = 'EaseOut',
      fade_out_duration_ms = 250,
      target = 'CursorColor',
   },

   window_padding = {
      left = 10,
      right = 7,
      top = 2,
      bottom = 0,
   },
   native_macos_fullscreen_mode = true,
}

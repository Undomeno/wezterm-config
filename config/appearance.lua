local wezterm = require('wezterm')
local colors = require('themes.color')
local backdrops = require('utils.backdrops')
local gpu_adapters = require('utils.gpu-adapter')
local platform = require('utils.platform')


return {
   max_fps = 120,
   front_end = 'WebGpu',
   webgpu_power_preference = 'LowPower',
   -- webgpu_preferred_adapter = gpu_adapters:pick_manual('Dx12', 'IntegratedGpu'),
   -- webgpu_preferred_adapter = gpu_adapters:pick_manual('Gl', 'Other'),
   underline_thickness = '1.5pt',

   -- window size
   initial_cols = 153,
   initial_rows = 47,

   -- cursor
   animation_fps = 120,
   cursor_blink_ease_in = 'EaseOut',
   cursor_blink_ease_out = 'EaseOut',
   default_cursor_style = 'BlinkingBlock',
   cursor_blink_rate = 650,

   -- color scheme
   colors = colors,

   -- background: pass in `true` if you want wezterm to start with focus mode on (no bg images)
   background = backdrops:initial_options({ no_img = true }),

   -- scrollbar
   enable_scroll_bar = false,

   -- tab bar
   show_tab_index_in_tab_bar = true,
   enable_tab_bar = true,
   tab_bar_at_bottom = true,
   hide_tab_bar_if_only_one_tab = false,
   use_fancy_tab_bar = false,
   switch_to_last_active_tab_when_closing_tab = true,
   tab_max_width = 27,

   -- command palette
   command_palette_fg_color = '#b4befe',
   command_palette_bg_color = '#11111b',
   command_palette_font_size = 12,
   command_palette_rows = 25,

   -- window

   window_background_opacity = 0.6,
   macos_window_background_blur = 3,
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
   window_decorations = platform.is_mac and 'RESIZE' or 'NONE',

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

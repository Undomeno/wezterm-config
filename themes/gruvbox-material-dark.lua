-- A slightly altered version of catppucchin gruvbox
local gruvbox = {
   bg_dim = '#1b1b1b',
   bg0 = '#282828',
   bg1 = '#32302f',
   bg2 = '#32302f',
   bg3 = '#45403d',
   bg4 = '#45403d',
   bg5 = '#5a524c',
   bg_statusline1 = '#32302f',
   bg_statusline2 = '#3a3735',
   bg_statusline3 = '#504945',
   bg_diff_green = '#34381b',
   bg_visual_green = '#3b4439',
   bg_diff_red = '#402120',
   bg_visual_red = '#4c3432',
   bg_diff_blue = '#0e363e',
   bg_visual_blue = '#374141',
   bg_visual_yellow = '#4f422e',
   bg_current_word = '#3c3836',
   fg0 = '#d4be98',
   fg1 = '#ddc7a1',
   fg2 = '#d5c4a1',
   fg3 = '#bdae93',
   fg4 = '#a89984',
   red = '#ea6962',
   orange = '#e78a4e',
   yellow = '#d8a657',
   green = '#a9b665',
   aqua = '#89b482',
   blue = '#7daea3',
   purple = '#d3869b',
   bg_red = '#ea6962',
   bg_green = '#a9b665',
   bg_yellow = '#d8a657',
   grey0 = '#7c6f64',
   grey1 = '#928374',
   grey2 = '#a89984',
}

local colorscheme = {
   foreground = gruvbox.fg0,
   background = gruvbox.bg0,
   cursor_bg = gruvbox.grey1,
   cursor_border = gruvbox.bg1,
   cursor_fg = gruvbox.bg0,
   selection_bg = gruvbox.bg_current_word,
   selection_fg = gruvbox.grey1,
   ansi = {
      '#282828', -- black
      '#cc241d', -- red
      '#98971a', -- green
      '#d79921', -- yellow
      '#458588', -- blue
      '#b16286', -- magenta/purple
      '#689d6a', -- cyan
      '#a89984', -- white
   },
   brights = {
      '#928374', -- black
      '#fb4934', -- red
      '#b8bb26', -- green
      '#fabd2f', -- yellow
      '#83a598', -- blue
      '#d3869b', -- magenta/purple
      '#8ec07c', -- cyan
      '#ebdbb2', -- white
   },
   tab_bar = {
      background = 'rgba(0, 0, 0, 0)',
      active_tab = {
         bg_color = gruvbox.bg0,
         fg_color = gruvbox.blue,
      },
      inactive_tab = {
         bg_color = gruvbox.bg0,
         fg_color = gruvbox.grey0,
      },
      inactive_tab_hover = {
         bg_color = gruvbox.bg0,
         fg_color = gruvbox.fg4,
      },
      new_tab = {
         bg_color = 'rgba(0,0,0,0)',
         fg_color = gruvbox.grey0,
      },
      new_tab_hover = {
         bg_color = 'rgba(0,0,0,0)',
         fg_color = gruvbox.fg4,
      },
   },
   split = gruvbox.statusline1,
}

return colorscheme

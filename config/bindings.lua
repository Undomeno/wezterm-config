local wezterm = require('wezterm')
local platform = require('utils.platform')()
local act = wezterm.action

local mod = {}

if platform.is_mac then
   mod.SUPER = 'SUPER'
   mod.SUPER_REV = 'SUPER|CTRL'
elseif platform.is_win or platform.is_linux then
   mod.SUPER = 'ALT' -- to not conflict with Windows key shortcuts
   mod.SUPER_REV = 'ALT|CTRL'
end

-- stylua: ignore
local keys = {
   -- misc/useful --
   { key = 'F1', mods = 'NONE', action = 'ActivateCopyMode' },
   { key = 'F2', mods = 'NONE', action = act.ActivateCommandPalette },
   { key = 'F3', mods = 'NONE', action = act.ShowLauncher },
   { key = 'F4', mods = 'NONE', action = act.ShowLauncherArgs({ flags = 'FUZZY|TABS' }) },
   {
      key = 'F5',
      mods = 'NONE',
      action = act.ShowLauncherArgs({ flags = 'FUZZY|WORKSPACES' }),
   },
   { key = 'F11', mods = 'NONE',    action = act.ToggleFullScreen },
   { key = 'F12', mods = 'NONE',    action = act.ShowDebugOverlay },
   { key = 'f',   mods = mod.SUPER, action = act.Search({ CaseInSensitiveString = '' }) },
   {
      key = 'u',
      mods = mod.SUPER,
      action = wezterm.action.QuickSelectArgs({
         label = 'open url',
         patterns = {
            '\\((https?://\\S+)\\)',
            '\\[(https?://\\S+)\\]',
            '\\{(https?://\\S+)\\}',
            '<(https?://\\S+)>',
            '\\bhttps?://\\S+[)/a-zA-Z0-9-]+'
         },
         action = wezterm.action_callback(function(window, pane)
            local url = window:get_selection_text_for_pane(pane)
            wezterm.log_info('opening: ' .. url)
            wezterm.open_with(url)
         end),
      }),
   },

   -- cursor movement --
   { key = 'LeftArrow',  mods = mod.SUPER,     action = act.SendString '\x1bOH' },
   { key = 'RightArrow', mods = mod.SUPER,     action = act.SendString '\x1bOF' },
   { key = 'Backspace',  mods = mod.SUPER,     action = act.SendString '\x15' },

   -- copy/paste --
   { key = 'c',          mods = mod.SUPER,  action = act.CopyTo('Clipboard') },
   { key = 'v',          mods = mod.SUPER,  action = act.PasteFrom('Clipboard') },

   -- tabs --
   -- tabs: spawn+close
   { key = 't',          mods = mod.SUPER,     action = act.SpawnTab('DefaultDomain') },
   { key = 't',          mods = mod.SUPER_REV, action = act.SpawnTab({ DomainName = 'WSL:Ubuntu' }) },
   { key = 'w',          mods = mod.SUPER_REV, action = act.CloseCurrentTab({ confirm = false }) },

   -- tabs: navigation
   { key = '[',          mods = mod.SUPER,     action = act.ActivateTabRelative(-1) },
   { key = ']',          mods = mod.SUPER,     action = act.ActivateTabRelative(1) },
   { key = '[',          mods = mod.SUPER_REV, action = act.MoveTabRelative(-1) },
   { key = ']',          mods = mod.SUPER_REV, action = act.MoveTabRelative(1) },

   -- window --
   -- spawn windows
   { key = 'n',          mods = mod.SUPER,     action = act.SpawnWindow },

   -- quit wezterm
   { key = 'q', mods = 'CMD', action = wezterm.action.QuitApplication },

   -- background controls --
   --[==[
   {
      key = [[/]],
      mods = mod.SUPER,
      action = wezterm.action_callback(function(window, _pane)
         backdrops:random(window)
      end),
   },
   {
      key = [[,]],
      mods = mod.SUPER,
      action = wezterm.action_callback(function(window, _pane)
         backdrops:cycle_back(window)
      end),
   },
   {
      key = [[.]],
      mods = mod.SUPER,
      action = wezterm.action_callback(function(window, _pane)
         backdrops:cycle_forward(window)
      end),
   },
   {
      key = [[/]],
      mods = mod.SUPER_REV,
      action = act.InputSelector({
         title = 'Select Background',
         choices = backdrops:choices(),
         fuzzy = true,
         fuzzy_description = 'Select Background: ',
         action = wezterm.action_callback(function(window, _pane, idx)
            ---@diagnostic disable-next-line: param-type-mismatch
            backdrops:set_img(window, tonumber(idx))
         end),
      }),
   },
   --]==]

   -- panes --
   -- panes: split panes
   {
      key = [[\]],
      mods = mod.SUPER,
      action = act.SplitVertical({ domain = 'CurrentPaneDomain' }),
   },
   {
      key = [[\]],
      mods = mod.SUPER_REV,
      action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }),
   },

   -- panes: zoom+close pane
   { key = 'Enter', mods = mod.SUPER,     action = act.TogglePaneZoomState },
   { key = 'w',     mods = mod.SUPER,     action = act.CloseCurrentPane({ confirm = false }) },

   -- panes: navigation
   { key = 'k',     mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Up') },
   { key = 'j',     mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Down') },
   { key = 'h',     mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Left') },
   { key = 'l',     mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Right') },
   {
      key = 'p',
      mods = mod.SUPER_REV,
      action = act.PaneSelect({ alphabet = '1234567890', mode = 'SwapWithActiveKeepFocus' }),
   },

   -- windows: navigation
   { key = '1',     mods = mod.SUPER, action = act.ActivateTab(0) },
   { key = '2',     mods = mod.SUPER, action = act.ActivateTab(1) },
   { key = '3',     mods = mod.SUPER, action = act.ActivateTab(2) },
   { key = '4',     mods = mod.SUPER, action = act.ActivateTab(3) },
   { key = '5',     mods = mod.SUPER, action = act.ActivateTab(4) },
   { key = '6',     mods = mod.SUPER, action = act.ActivateTab(5) },
   { key = '7',     mods = mod.SUPER, action = act.ActivateTab(6) },
   { key = '8',     mods = mod.SUPER, action = act.ActivateTab(7) },
   { key = '9',     mods = mod.SUPER, action = act.ActivateTab(-1) },

   -- key-tables --
   -- resizes fonts
   {
      key = 'f',
      mods = 'LEADER',
      action = act.ActivateKeyTable({
         name = 'resize_font',
         one_shot = false,
         timemout_miliseconds = 1000,
      }),
   },
   -- resize panes
   {
      key = 'p',
      mods = 'LEADER',
      action = act.ActivateKeyTable({
         name = 'resize_pane',
         one_shot = false,
         timemout_miliseconds = 1000,
      }),
   },
  }

-- stylua: ignore
local key_tables = {
   resize_font = {
      { key = 'k',      action = act.IncreaseFontSize },
      { key = 'j',      action = act.DecreaseFontSize },
      { key = 'r',      action = act.ResetFontSize },
      { key = 'Escape', action = 'PopKeyTable' },
      { key = 'q',      action = 'PopKeyTable' },
   },
   resize_pane = {
      { key = 'k',      action = act.AdjustPaneSize({ 'Up', 1 }) },
      { key = 'j',      action = act.AdjustPaneSize({ 'Down', 1 }) },
      { key = 'h',      action = act.AdjustPaneSize({ 'Left', 1 }) },
      { key = 'l',      action = act.AdjustPaneSize({ 'Right', 1 }) },
      { key = 'Escape', action = 'PopKeyTable' },
      { key = 'q',      action = 'PopKeyTable' },
      {key=" ",mods="CTRL|ALT",action=wezterm.action{SendString="\x1b[====\x20"}},
      {key="g",mods="CTRL|ALT",action=wezterm.action{SendString="\x1b[====\x67"}},
      {key=" ",mods="CTRL|SHIFT|ALT",action=wezterm.action{SendString="\x1b[==\x20"}},
      {key=" ",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x20"}},
      {key="0",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x30"}},
      {key="1",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x31"}},
      {key="2",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x32"}},
      {key="3",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x33"}},
      {key="4",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x34"}},
      {key="5",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x35"}},
      {key="6",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x36"}},
      {key="7",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x37"}},
      {key="8",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x38"}},
      {key="9",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x39"}},
      {key="a",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x61"}},
      {key="b",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x62"}},
      {key="c",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x63"}},
      {key="d",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x64"}},
      {key="e",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x65"}},
      {key="f",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x66"}},
      {key="g",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x67"}},
      {key="h",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x68"}},
      {key="i",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x69"}},
      {key="j",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x6a"}},
      {key="k",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x6b"}},
      {key="l",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x6c"}},
      {key="m",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x6d"}},
      {key="n",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x6e"}},
      {key="o",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x6f"}},
      {key="p",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x70"}},
      {key="q",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x71"}},
      {key="r",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x72"}},
      {key="s",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x73"}},
      {key="t",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x74"}},
      {key="u",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x75"}},
      {key="v",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x76"}},
      {key="w",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x77"}},
      {key="x",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x78"}},
      {key="y",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x79"}},
      {key="z",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x7a"}},
      {key="`",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x60"}},
      {key="-",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x2d"}},
      {key="=",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x3d"}},
      {key="[",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x5b"}},
      {key="]",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x5d"}},
      {key="\\",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x5c"}},
      {key=";",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x3b"}},
      {key="'",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x27"}},
      {key=",",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x2c"}},
      {key=".",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x2e"}},
      {key="/",mods="SUPER",action=wezterm.action{SendString="\x18\x40\x68\x2f"}},
      {key="~",mods="SUPER",action=wezterm.action{SendString="\x1b[======\x7e"}},
      {key="_",mods="SUPER",action=wezterm.action{SendString="\x1b[======\x5f"}},
      {key="+",mods="SUPER",action=wezterm.action{SendString="\x1b[======\x2b"}},
      {key="{",mods="SUPER",action=wezterm.action{SendString="\x1b[======\x7b"}},
      {key="}",mods="SUPER",action=wezterm.action{SendString="\x1b[======\x7d"}},
      {key="|",mods="SUPER",action=wezterm.action{SendString="\x1b[======\x7c"}},
      {key=":",mods="SUPER",action=wezterm.action{SendString="\x1b[======\x3a"}},
      {key="\"",mods="SUPER",action=wezterm.action{SendString="\x1b[======\x22"}},
      {key="<",mods="SUPER",action=wezterm.action{SendString="\x1b[======\x3c"}},
      {key=">",mods="SUPER",action=wezterm.action{SendString="\x1b[======\x3e"}},
      {key="?",mods="SUPER",action=wezterm.action{SendString="\x1b[======\x3f"}},
      {key=")",mods="SUPER",action=wezterm.action{SendString="\x1b[======\x29"}},
      {key="!",mods="SUPER",action=wezterm.action{SendString="\x1b[======\x21"}},
      {key="@",mods="SUPER",action=wezterm.action{SendString="\x1b[======\x40"}},
      {key="#",mods="SUPER",action=wezterm.action{SendString="\x1b[======\x23"}},
      {key="$",mods="SUPER",action=wezterm.action{SendString="\x1b[======\x24"}},
      {key="%",mods="SUPER",action=wezterm.action{SendString="\x1b[======\x25"}},
      {key="^",mods="SUPER",action=wezterm.action{SendString="\x1b[======\x5e"}},
      {key="&",mods="SUPER",action=wezterm.action{SendString="\x1b[======\x26"}},
      {key="*",mods="SUPER",action=wezterm.action{SendString="\x1b[======\x2a"}},
      {key="(",mods="SUPER",action=wezterm.action{SendString="\x1b[======\x28"}},
      {key=" ",mods="SUPER|SHIFT",action=wezterm.action{SendString="\x1b[======\x20"}},
      {key="A",mods="SUPER|SHIFT",action=wezterm.action{SendString="\x1b[======\x41"}},
      {key="B",mods="SUPER|SHIFT",action=wezterm.action{SendString="\x1b[======\x42"}},
      {key="C",mods="SUPER|SHIFT",action=wezterm.action{SendString="\x1b[======\x43"}},
      {key="D",mods="SUPER|SHIFT",action=wezterm.action{SendString="\x1b[======\x44"}},
      {key="E",mods="SUPER|SHIFT",action=wezterm.action{SendString="\x1b[======\x45"}},
      {key="F",mods="SUPER|SHIFT",action=wezterm.action{SendString="\x1b[======\x46"}},
      {key="G",mods="SUPER|SHIFT",action=wezterm.action{SendString="\x1b[======\x47"}},
      {key="H",mods="SUPER|SHIFT",action=wezterm.action{SendString="\x1b[======\x48"}},
      {key="I",mods="SUPER|SHIFT",action=wezterm.action{SendString="\x1b[======\x49"}},
      {key="J",mods="SUPER|SHIFT",action=wezterm.action{SendString="\x1b[======\x4a"}},
      {key="K",mods="SUPER|SHIFT",action=wezterm.action{SendString="\x1b[======\x4b"}},
      {key="L",mods="SUPER|SHIFT",action=wezterm.action{SendString="\x1b[======\x4c"}},
      {key="M",mods="SUPER|SHIFT",action=wezterm.action{SendString="\x1b[======\x4d"}},
      {key="N",mods="SUPER|SHIFT",action=wezterm.action{SendString="\x1b[======\x4e"}},
      {key="O",mods="SUPER|SHIFT",action=wezterm.action{SendString="\x1b[======\x4f"}},
      {key="P",mods="SUPER|SHIFT",action=wezterm.action{SendString="\x1b[======\x50"}},
      {key="Q",mods="SUPER|SHIFT",action=wezterm.action{SendString="\x1b[======\x51"}},
      {key="R",mods="SUPER|SHIFT",action=wezterm.action{SendString="\x1b[======\x52"}},
      {key="S",mods="SUPER|SHIFT",action=wezterm.action{SendString="\x1b[======\x53"}},
      {key="T",mods="SUPER|SHIFT",action=wezterm.action{SendString="\x1b[======\x54"}},
      {key="U",mods="SUPER|SHIFT",action=wezterm.action{SendString="\x1b[======\x55"}},
      {key="V",mods="SUPER|SHIFT",action=wezterm.action{SendString="\x1b[======\x56"}},
      {key="W",mods="SUPER|SHIFT",action=wezterm.action{SendString="\x1b[======\x57"}},
      {key="X",mods="SUPER|SHIFT",action=wezterm.action{SendString="\x1b[======\x58"}},
      {key="Y",mods="SUPER|SHIFT",action=wezterm.action{SendString="\x1b[======\x59"}},
      {key="Z",mods="SUPER|SHIFT",action=wezterm.action{SendString="\x1b[======\x5a"}},
      {key="1",mods="CTRL",action=wezterm.action{SendString="\x18\x40\x63\x31"}},
      {key="2",mods="CTRL",action=wezterm.action{SendString="\x18\x40\x63\x32"}},
      {key="3",mods="CTRL",action=wezterm.action{SendString="\x18\x40\x63\x33"}},
      {key="4",mods="CTRL",action=wezterm.action{SendString="\x18\x40\x63\x34"}},
      {key="5",mods="CTRL",action=wezterm.action{SendString="\x18\x40\x63\x35"}},
      {key="6",mods="CTRL",action=wezterm.action{SendString="\x18\x40\x63\x36"}},
      {key="7",mods="CTRL",action=wezterm.action{SendString="\x18\x40\x63\x37"}},
      {key="8",mods="CTRL",action=wezterm.action{SendString="\x18\x40\x63\x38"}},
      {key="9",mods="CTRL",action=wezterm.action{SendString="\x18\x40\x63\x39"}},
      {key="A",mods="CTRL|SHIFT",action=wezterm.action{SendString="\x1b[=\x41"}},
      {key="B",mods="CTRL|SHIFT",action=wezterm.action{SendString="\x1b[=\x42"}},
      {key="C",mods="CTRL|SHIFT",action=wezterm.action{SendString="\x1b[=\x43"}},
      {key="D",mods="CTRL|SHIFT",action=wezterm.action{SendString="\x1b[=\x44"}},
      {key="E",mods="CTRL|SHIFT",action=wezterm.action{SendString="\x1b[=\x45"}},
      {key="F",mods="CTRL|SHIFT",action=wezterm.action{SendString="\x1b[=\x46"}},
      {key="G",mods="CTRL|SHIFT",action=wezterm.action{SendString="\x1b[=\x47"}},
      {key="H",mods="CTRL|SHIFT",action=wezterm.action{SendString="\x1b[=\x48"}},
      {key="I",mods="CTRL|SHIFT",action=wezterm.action{SendString="\x1b[=\x49"}},
      {key="J",mods="CTRL|SHIFT",action=wezterm.action{SendString="\x1b[=\x4a"}},
      {key="K",mods="CTRL|SHIFT",action=wezterm.action{SendString="\x1b[=\x4b"}},
      {key="L",mods="CTRL|SHIFT",action=wezterm.action{SendString="\x1b[=\x4c"}},
      {key="M",mods="CTRL|SHIFT",action=wezterm.action{SendString="\x1b[=\x4d"}},
      {key="N",mods="CTRL|SHIFT",action=wezterm.action{SendString="\x1b[=\x4e"}},
      {key="O",mods="CTRL|SHIFT",action=wezterm.action{SendString="\x1b[=\x4f"}},
      {key="P",mods="CTRL|SHIFT",action=wezterm.action{SendString="\x1b[=\x50"}},
      {key="Q",mods="CTRL|SHIFT",action=wezterm.action{SendString="\x1b[=\x51"}},
      {key="R",mods="CTRL|SHIFT",action=wezterm.action{SendString="\x1b[=\x52"}},
      {key="S",mods="CTRL|SHIFT",action=wezterm.action{SendString="\x1b[=\x53"}},
      {key="T",mods="CTRL|SHIFT",action=wezterm.action{SendString="\x1b[=\x54"}},
      {key="U",mods="CTRL|SHIFT",action=wezterm.action{SendString="\x1b[=\x55"}},
      {key="V",mods="CTRL|SHIFT",action=wezterm.action{SendString="\x1b[=\x56"}},
      {key="W",mods="CTRL|SHIFT",action=wezterm.action{SendString="\x1b[=\x57"}},
      {key="X",mods="CTRL|SHIFT",action=wezterm.action{SendString="\x1b[=\x58"}},
      {key="Y",mods="CTRL|SHIFT",action=wezterm.action{SendString="\x1b[=\x59"}},
      {key="Z",mods="CTRL|SHIFT",action=wezterm.action{SendString="\x1b[=\x5a"}},
      {key=" ",mods="CTRL|SHIFT",action=wezterm.action{SendString="\x1b[=\x20"}},
      {key="A",mods="CTRL|SHIFT|ALT",action=wezterm.action{SendString="\x1b[==\x41"}},
      {key="B",mods="CTRL|SHIFT|ALT",action=wezterm.action{SendString="\x1b[==\x42"}},
      {key="C",mods="CTRL|SHIFT|ALT",action=wezterm.action{SendString="\x1b[==\x43"}},
      {key="D",mods="CTRL|SHIFT|ALT",action=wezterm.action{SendString="\x1b[==\x44"}},
      {key="E",mods="CTRL|SHIFT|ALT",action=wezterm.action{SendString="\x1b[==\x45"}},
      {key="F",mods="CTRL|SHIFT|ALT",action=wezterm.action{SendString="\x1b[==\x46"}},
      {key="G",mods="CTRL|SHIFT|ALT",action=wezterm.action{SendString="\x1b[==\x47"}},
      {key="H",mods="CTRL|SHIFT|ALT",action=wezterm.action{SendString="\x1b[==\x48"}},
      {key="I",mods="CTRL|SHIFT|ALT",action=wezterm.action{SendString="\x1b[==\x49"}},
      {key="J",mods="CTRL|SHIFT|ALT",action=wezterm.action{SendString="\x1b[==\x4a"}},
      {key="K",mods="CTRL|SHIFT|ALT",action=wezterm.action{SendString="\x1b[==\x4b"}},
      {key="L",mods="CTRL|SHIFT|ALT",action=wezterm.action{SendString="\x1b[==\x4c"}},
      {key="M",mods="CTRL|SHIFT|ALT",action=wezterm.action{SendString="\x1b[==\x4d"}},
      {key="N",mods="CTRL|SHIFT|ALT",action=wezterm.action{SendString="\x1b[==\x4e"}},
      {key="O",mods="CTRL|SHIFT|ALT",action=wezterm.action{SendString="\x1b[==\x4f"}},
      {key="P",mods="CTRL|SHIFT|ALT",action=wezterm.action{SendString="\x1b[==\x50"}},
      {key="Q",mods="CTRL|SHIFT|ALT",action=wezterm.action{SendString="\x1b[==\x51"}},
      {key="R",mods="CTRL|SHIFT|ALT",action=wezterm.action{SendString="\x1b[==\x52"}},
      {key="S",mods="CTRL|SHIFT|ALT",action=wezterm.action{SendString="\x1b[==\x53"}},
      {key="T",mods="CTRL|SHIFT|ALT",action=wezterm.action{SendString="\x1b[==\x54"}},
      {key="U",mods="CTRL|SHIFT|ALT",action=wezterm.action{SendString="\x1b[==\x55"}},
      {key="V",mods="CTRL|SHIFT|ALT",action=wezterm.action{SendString="\x1b[==\x56"}},
      {key="W",mods="CTRL|SHIFT|ALT",action=wezterm.action{SendString="\x1b[==\x57"}},
      {key="X",mods="CTRL|SHIFT|ALT",action=wezterm.action{SendString="\x1b[==\x58"}},
      {key="Y",mods="CTRL|SHIFT|ALT",action=wezterm.action{SendString="\x1b[==\x59"}},
      {key="Z",mods="CTRL|SHIFT|ALT",action=wezterm.action{SendString="\x1b[==\x5a"}},
      {key=" ",mods="SHIFT",action=wezterm.action{SendString="\x18\x40\x53\x20"}},
      {key="\\",mods="CTRL|ALT",action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
      {key="h",mods="CTRL|ALT|SUPER",action=wezterm.action{ActivatePaneDirection="Left"}},
      {key="j",mods="CTRL|ALT|SUPER",action=wezterm.action{ActivatePaneDirection="Down"}},
      {key="k",mods="CTRL|ALT|SUPER",action=wezterm.action{ActivatePaneDirection="Up"}},
      {key="l",mods="CTRL|ALT|SUPER",action=wezterm.action{ActivatePaneDirection="Right"}},
   },
}

local mouse_bindings = {
   -- Ctrl-click will open the link under the mouse cursor
   {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'CTRL',
      action = act.OpenLinkAtMouseCursor,
   },
}

return {
   disable_default_key_bindings = true,
   keys = keys,
   key_tables = key_tables,
   mouse_bindings = mouse_bindings,
   leader = { key = ';', mods = mod.SUPER_REV },
}

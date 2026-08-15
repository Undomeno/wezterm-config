-- The only required line is this one.
local wezterm = require 'wezterm'
local Config = require('config')
local platform = require('utils.platform')

-- :set_focus('#000000')
-- :set_images_dir(require('wezterm').home_dir .. '/Pictures/Wallpapers/')

require('events.right-status').setup({ date_format = '%a %H:%M' })
require('events.left-status').setup()
require('events.tab-title').setup()
require('events.new-tab-button').setup()
require('events.gui-startup').setup()

-- Reading and re-copying hands ownership to wl-copy's background process, so a
-- copy survives this window going away. 
if platform.is_linux then
	wezterm.on('window-focus-changed', function(window, pane)
		wezterm.run_child_process { 'sh', '-c', 'wl-paste -n | wl-copy' }
	end)
end

return Config:init()
	:append(require('config.appearance'))
	:append(require('config.fonts'))
	:append(require('config.general'))
	:append(require('config.bindings')).options

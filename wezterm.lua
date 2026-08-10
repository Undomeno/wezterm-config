-- The only required line is this one.
local wezterm = require 'wezterm'
local Config = require('config')

-- :set_focus('#000000')
-- :set_images_dir(require('wezterm').home_dir .. '/Pictures/Wallpapers/')

require('events.right-status').setup({ date_format = '%a %H:%M' })
require('events.left-status').setup()
require('events.tab-title').setup()
require('events.new-tab-button').setup()
require('events.gui-startup').setup()

return Config:init()
	:append(require('config.appearance'))
	:append(require('config.fonts'))
	:append(require('config.general'))
	:append(require('config.bindings')).options

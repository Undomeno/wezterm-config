-- The only required line is this one.
local wezterm = require 'wezterm'
local Config = require('config')

require('events.right-status').setup()
require('events.new-tab-button').setup()
require('events.tab-title').setup()

return Config:init()
	:append(require('config.appearance'))
	:append(require('config.fonts')).options

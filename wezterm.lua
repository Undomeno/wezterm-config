-- The only required line is this one.
local wezterm = require 'wezterm'
local Config = require('config')

require('events.right-status').setup()
require('events.new-tab-button').setup()
require('events.tab-title').setup()

return Config:init()
	:append(require('config.appearance'))
	:append(require('config.fonts'))
	:append(require('config.domains'))
	:append(require('config.general'))
	:append(require('config.bindings'))
	:append(require('config.launch')).options

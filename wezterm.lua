-- The only required line is this one.
local wezterm = require 'wezterm'
local Config = require('config')

require('events.right-status').setup()
require('events.new-tab-button').setup()

return Config:init()
	:append(require('config.appearance')).options

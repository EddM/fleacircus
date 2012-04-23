require "rubygems"
require "bundler/setup"
require "gosu"

require "lib/game"

GameWindow.setup!
GameWindow.current.debug = true
GameWindow.current.show
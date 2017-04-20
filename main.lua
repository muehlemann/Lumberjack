-----------------------------------------------------------------------------------------
-- Author		: Matt Muehlemann 
-- File Name	: main.lua
-- Date Created	: 08-21-2016
-----------------------------------------------------------------------------------------

-- libraries
local loadsave = require("loadsave")

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- globals
screenW  = display.contentWidth;
screenH  = display.contentHeight;
halfW    = screenW * 0.5;
halfH    = screenH * 0.5;

-- loads settings
settings = loadsave.loadTable("settings.json")
if (settings == nil) then
	settings = {}
	settings.music = true
	settings.fx    = true
	settings.score = 0
	loadsave.saveTable(settings, "settings.json")
end

-- Background Audio
-- Allows for audio in background
--
if audio.supportsSessionProperty == true then
	print("supportsSessionProperty is true")
	audio.setSessionProperty(audio.MixMode, audio.AmbientMixMode)
end

font_title = native.newFont("gfx/fonts/title.ttf")
font_body  = native.newFont("gfx/fonts/body.ttf")

layer_background = require("background")
layer_background.load()

scr_game_over = require("game_over")
scr_game_over.isVisible = false
scr_game_over.load()

scr_game_screen = require("game_screen")
scr_game_screen.isVisible = false

scr_game_start = require("game_start")
scr_game_start.isVisible = true
scr_game_start.load()

-- system_events
-- triggerd on system events
--
function system_events(event)

	if (event.type == "applicationExit") then
		-- saved state
		loadsave.saveTable(settings, "settings.json")
	elseif (event.type == "applicationOpen") then
		-- load state
		settings = loadsave.loadTable("settings.json")
	end

end

Runtime:addEventListener("system", system_events)



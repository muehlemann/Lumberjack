-----------------------------------------------------------------------------------------
-- Author		: Matt Muehlemann 
-- File Name	: game.lua
-- Date Created	: 08-21-2016
-----------------------------------------------------------------------------------------

local scr_game_over   = display.newGroup()
local factory         = require("factory")
local loadsave        = require("loadsave")

-- Variables: Objects
local txt_prompt      = {}
local txt_high_score  = {}
local txt_score       = {}
local btn_replay      = {}
local txt_replay      = {}

-- replay
-- sets up for replay
-- 
function replay()

	layer_background.fx("tick")

	btn_replay:removeEventListener('touch', replay)
	scr_game_over.isVisible = false
	scr_game_start.isVisible = true

end

-- set_score
-- sets the score
-- 
function set_score(score)

	if (score == nil) then
		score = 0
	end

	txt_score.text      = string.format("SCORE: %i", score)
	txt_high_score.text = string.format("HIGH SCORE: %i", settings.score)

	if (settings.score < score) then
		settings.score = score
		loadsave.saveTable(settings, "settings.json")
		txt_high_score.text = string.format("HIGH SCORE: %i", settings.score)
	end

end

-- load
-- first fuction to run
--
function load()

	txt_prompt = display.newText({ text = 'Game Over', fontSize = 108, font = font_title, align = 'center', x = halfW, y = 400, width = screenW, height = 150 })
	txt_prompt:setFillColor(0, 0, 0)
	scr_game_over:insert(txt_prompt)

	txt_high_score = display.newText({ text = '', fontSize = 36, font = font_body, align = 'center', x = halfW, y = txt_prompt.y + 110, width = 500, height = 60 })
	txt_high_score:setFillColor(0, 0, 0)
	scr_game_over:insert(txt_high_score)

	txt_score = display.newText({ text = '', fontSize = 36, font = font_body, align = 'center', x = halfW, y = txt_high_score.y + 40, width = screenW, height = 60 })
	txt_score:setFillColor(0, 0, 0)
	scr_game_over:insert(txt_score)
	
 	btn_replay = factory.make_button({x = halfW, y = halfH + 130, size = 120, filename = 'gfx/btn/restart.png'})
	btn_replay:addEventListener("tap", replay)
	scr_game_over:insert(btn_replay)

end

-- class functions
scr_game_over.load  = load
scr_game_over.score = set_score

return scr_game_over

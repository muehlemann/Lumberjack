-----------------------------------------------------------------------------------------
-- Author		: Matt Muehlemann 
-- File Name	: game.lua
-- Date Created	: 08-21-2016
-----------------------------------------------------------------------------------------

local scr_game_start  = display.newGroup()
local factory         = require("factory")
local loadsave        = require("loadsave")

-- Variables: Objects
local btn_music_on  = {}
local btn_music_off = {}
local btn_fx_on     = {}
local btn_fx_off    = {}

-- play
-- 
-- 
function play()

	layer_background.fx("tick")

	scr_game_screen.load()
	scr_game_start.isVisible = false
	scr_game_screen.isVisible = true

end

-- credits
-- 
--
function credits()

	layer_background.fx("tick")

	local scr_game_credits = display.newGroup()
	scr_game_start.isVisible = false

	-- done
	-- 
	--
	local function done()
		layer_background.fx("tick")
		scr_game_start.isVisible = true
		display.remove( scr_game_credits )
	end

	-- link
	-- 
	--
	local function link()
		system.openURL("http://www.icons8.com")
	end

	local txt_dev = display.newText({ text = "• DEVELOPER •\nMatt Muehlemann\n\n• ARTIST •\nJon Decker\n\n • ICONS •\n Icons8.com", fontSize = 40, font = font_body, align = 'center', x = halfW, y = 400, width = screenW - 10, height = 400 })
	txt_dev:setFillColor(0, 0, 0)
	scr_game_credits:insert(txt_dev)

	local btn_credits = display.newRect(txt_dev.x, txt_dev.y + 140, 280, 90)
	btn_credits.alpha = 0.01
	btn_credits:addEventListener('tap', link)
	scr_game_credits:insert(btn_credits)
	
	local btn_done = factory.make_button({x = halfW, y = btn_credits.y + 250, size = 120, filename = 'gfx/btn/done.png'})
	btn_done:addEventListener('tap', done)
	scr_game_credits:insert(btn_done)

end

-- music_on
-- 
--
function music_on(f)

	if not (f == true) then
		layer_background.fx("tick")
	end

	btn_music_on.isVisible  = true
	btn_music_off.isVisible = false
	settings.music          = true
	
	-- start the music	
	layer_background.play_music()

	-- save
	loadsave.saveTable(settings, "settings.json")

end

-- music_off
-- 
--
function music_off(f)

	if not (f == true) then
		layer_background.fx("tick")
	end

	btn_music_off.isVisible = true
	btn_music_on.isVisible  = false
	settings.music          = false

	-- stop the music	
	layer_background.stop_music()

	-- save
	loadsave.saveTable(settings, "settings.json")

end

-- fx_on
-- 
--
function fx_on(f)

	btn_fx_on.isVisible  = true
	btn_fx_off.isVisible = false
	settings.fx          = true

	if not (f == true) then
		layer_background.fx("tick")
	end

	-- save
	loadsave.saveTable(settings, "settings.json")

end

-- fx_off
--
--
function fx_off(f)

	btn_fx_off.isVisible = true
	btn_fx_on.isVisible  = false
	settings.fx          = false

	if not (f == true) then
		layer_background.fx("tick")
	end
	-- save
	loadsave.saveTable(settings, "settings.json")

end

-- load
-- 
--
function load()

	local txt_title = display.newText({ text = 'LumberJack', fontSize = 108, font = font_title, align = 'center', x = halfW, y = 500, width = screenW, height = 140 })
	txt_title:setFillColor(0, 0, 0)
	scr_game_start:insert(txt_title)

 	local btn_play = factory.make_button({x = halfW - 200, y = txt_title.y + 130, size = 120, filename = 'gfx/btn/play.png'})
	btn_play:addEventListener('tap', play)
	scr_game_start:insert(btn_play)

	btn_music_on = factory.make_button({x = halfW - 70, y = txt_title.y + 130, size = 120, filename = 'gfx/btn/music_h.png'})
	btn_music_on:addEventListener('tap', music_off)
	scr_game_start:insert(btn_music_on)

	btn_music_off = factory.make_button({x = halfW - 70, y = txt_title.y + 130, size = 120, filename = 'gfx/btn/music_l.png'})
	btn_music_off:addEventListener('tap', music_on)
	scr_game_start:insert(btn_music_off)

	if (settings.music) then
		btn_music_on.isVisible  = true
		btn_music_off.isVisible = false
		music_on(true)
	else	
		btn_music_on.isVisible  = false
		btn_music_off.isVisible = true
		music_off(true)
	end

	btn_fx_on = factory.make_button({x = halfW + 70, y = txt_title.y + 130, size = 120, filename = 'gfx/btn/fx_h.png'})
	btn_fx_on:addEventListener('tap', fx_off)
	scr_game_start:insert(btn_fx_on)

	btn_fx_off = factory.make_button({x = halfW + 70, y = txt_title.y + 130, size = 120, filename = 'gfx/btn/fx_l.png'})
	btn_fx_off:addEventListener('tap', fx_on)
	scr_game_start:insert(btn_fx_off)

	if (settings.fx) then
		btn_fx_on.isVisible  = true
		btn_fx_off.isVisible = false
		fx_on(true)
	else	
		btn_fx_on.isVisible  = false
		btn_fx_off.isVisible = true
		fx_off(true)
	end

	local btn_credit = factory.make_button({x = halfW + 200, y = txt_title.y + 130, size = 120, filename = 'gfx/btn/credit.png'})
	btn_credit:addEventListener('tap', credits)
	scr_game_start:insert(btn_credit)

end

-- class functions
scr_game_start.load = load

return scr_game_start

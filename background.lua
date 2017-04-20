-----------------------------------------------------------------------------------------
-- Author		: Matt Muehlemann 
-- File Name	: main.lua
-- Date Created	: 08-21-2016
-----------------------------------------------------------------------------------------

local layer_background = display.newGroup()

-- Load sounds 
local s_track  = audio.loadStream("gfx/sounds/soundtrack.mp3")
local s_tick   = audio.loadSound('gfx/sounds/tick.mp3')
local s_saw    = audio.loadSound('gfx/sounds/saw.mp3')
local s_bounce = audio.loadSound('gfx/sounds/bounce.mp3')
local s_below  = audio.loadSound('gfx/sounds/game_over.mp3')

-- load
-- first fuction to run
--
local function load()
	
	-- Element: overlay
	overlay = display.newImageRect('gfx/background.png', screenW + 170, screenH)
	overlay.x = halfW + 85
	overlay.y = halfH 
	layer_background:insert(overlay)

end

-- play_music
--
--
local function play_music()

	audio.play(s_track, {channel = 1, loops = -1})

end

-- stop_music
--
--
local function stop_music()
	
	audio.stop(1)

end

-- play_fx
--
--
local function play_fx(sound)

	if (settings.fx == true) then

		-- stop all in use channels
		for i = 2, 5 do
			if audio.isChannelPlaying(i) then
				audio.stop(i)
			end
		end
		print( sound )

		if (sound == 'tick') then
			audio.play(s_tick, {channel = 2, loops = 0})
		elseif (sound == 'saw') then
			audio.play(s_saw, {channel = 3, loops = 0})
		elseif (sound == 'bounce') then
			audio.play(s_bounce, {channel = 4, loops = 0})
		elseif (sound == 'below') then
			audio.play(s_below, {channel = 5, loops = 0})
		end
	end

end

-- class functions
layer_background.load       = load
layer_background.fx         = play_fx
layer_background.play_music = play_music
layer_background.stop_music = stop_music

return layer_background
-----------------------------------------------------------------------------------------
-- Author		: Matt Muehlemann 
-- File Name	: game_screen.lua
-- Date Created	: 08-21-2016
-----------------------------------------------------------------------------------------

local scr_game_screen = display.newGroup()
local factory         = require('factory')

-- Libraries
local widget          = require('widget')
local physics         = require('physics')
physics.start()
physics.setGravity(0, 9.8)
-- physics.setDrawMode('hybrid')

-- Variables: Objects
local blocks         = {}
local player         = {}
local tmp_platform   = {}
local tmp_platform_h = {} 
local txt_score      = {}
local txt_blocks     = {}
local btn_quit       = {}

-- load
-- first fuction to run
--
function load()

	-- Element: Player
	player = display.newImageRect('gfx/player.png', 100, 100, true)
	player.x = halfW
	player.y = screenH - 80
	player.half = player.width * 0.5
	player.linearDamping = 0
	player.score = 0
	player.direction = 1
	player.collision = collision_handler
	player:addEventListener('collision', player)
	physics.addBody(player, { density = 1.0, friction = 0.0, bounce = 0.75, radius = player.half - 6})
	scr_game_screen:insert(player)

	-- Group: Blocks
	make_paltform({ x = 40,           y = screenH - 160, tag = 'block', rotation = 10  })
	make_paltform({ x = halfW,        y = screenH - 10,  tag = 'block', rotation = 0   })
	make_paltform({ x = screenW - 40, y = screenH - 100, tag = 'block', rotation = -40 })

	-- Elements: Score
	txt_score = display.newText({ text = '0', fontSize = 34, font = font_body, align = 'right', x = halfW - 20, y = 50, width = screenW - 5, height = 65 })
	txt_score:setFillColor(0, 0, 0)
	scr_game_screen:insert(txt_score)

	-- Elements: blocks
	txt_blocks = display.newText({ text = 'Platforms: 4', fontSize = 34, font = font_body, align = 'left', x = halfW + 20, y = 50, width = screenW - 5, height = 65 })
	txt_blocks:setFillColor(0, 0, 0)
	scr_game_screen:insert(txt_blocks)

	-- Elements: button
	btn_quit = factory.make_button({x = screenW - 40, y = screenH - 40, size = 60, filename = 'gfx/btn/done.png'})
	btn_quit:addEventListener('tap', game_over)
	scr_game_screen:insert(btn_quit)

	local txt_instructions = display.newText({ text = 'touch and hold to add platforms at different angles', fontSize = 35, font = font_body, align = 'center', x = halfW, y = halfH, width = screenW - 70, height = 190 })
	txt_instructions:setFillColor(0, 0, 0)
	scr_game_screen:insert(txt_instructions)

	transition.to( txt_instructions, { 
		delay = 2000,
		time = 1000, 
		alpha = 0,
		onComplete = function() 
			scr_game_screen:remove(txt_instructions)
			txt_instructions:removeSelf()
			txt_instructions = nil
		end 
	})

	-- Runtime Listeners: tap, enterFrame
	Runtime:addEventListener('touch', touch_handler)
	Runtime:addEventListener('enterFrame', frame_handler)

	-- Animation: Explosion
	local sheet_data = { 
		width = 256, height = 256, numFrames = 4, sheetContentWidth = 1024, sheetContentHeight = 256
	}

	local sequenceData = { 
		{ name="dust", sheet=sheet_boom, start = 1, count = 4, time = 600, loopCount = 1 },
	}

	local sheet_boom = graphics.newImageSheet('gfx/saw_dust.png', sheet_data)

	explosion = display.newSprite(sheet_boom, sequenceData)
	explosion.isVisible = false
	explosion:addEventListener("sprite", sprite_handler)
	explosion:setSequence("dust")

end

-- collision_handler
-- handels collision
--
function collision_handler(self, event)

	object = event.other	
	if (event.phase == 'began') then

		-- apply force
		vx, vy = self:getLinearVelocity()
		if vy > 0 then
			if object.tag == 'block' then
				self:setLinearVelocity(0, 570)
			end
		end

		-- check enemy
		if object.tag == 'saw' then
			layer_background.fx("saw")
			explosion.isVisible = true
			explosion.x = player.x
			explosion.y = player.y
			explosion:play()
		end

	elseif (event.phase == 'ended') then
		-- play sound
		if (object.tag == 'block') then
			layer_background.fx("bounce")
		end
	end

end

-- sprite_handler
-- handles sprite actions
-- 
function sprite_handler(event)

	if (event.phase == "began") then
		physics.pause()
	elseif (event.phase == "ended") then
		game_over(true)
		physics.start()
	end

end

-- touch_handler
-- handles touch 
--
function touch_handler(event) 
	
	print( tmp_platform )	
	if (event.phase == 'began') then

		local rotation = math.random( 0, 360 )

		-- Elements: Platform placement
		tmp_platform = display.newRect(event.x, event.y, 100, 10)
		tmp_platform.markX = tmp_platform.x
		tmp_platform.markY = tmp_platform.y
		tmp_platform.alpha = 0.8
		tmp_platform.rotation = rotation
		tmp_platform:setFillColor(0.12, 0.14, 0.17)
		scr_game_screen:insert(tmp_platform)

		-- Elements: Platform placement indicator
		tmp_platform_h = display.newImageRect('gfx/platform-highlight.png', 230, 230)
		tmp_platform_h.x = event.x
		tmp_platform_h.y = event.y
		tmp_platform_h.markX = tmp_platform_h.x
		tmp_platform_h.markY = tmp_platform_h.y
		tmp_platform_h.rotation = rotation
		tmp_platform_h.alpha = 1.0
		scr_game_screen:insert(tmp_platform_h)

		-- Get object focus
		display.getCurrentStage():setFocus(tmp_platform, event.id)
		tmp_platform.isFocus = true

		-- Animate rotation
		transition.to(tmp_platform,   {time = 26000, rotation = tmp_platform.rotation + 7200 })
		transition.to(tmp_platform_h, {time = 26000, rotation = tmp_platform.rotation + 7200 })


	elseif (tmp_platform ~= nil) then

		if (tmp_platform.isFocus) then
			if event.phase == 'moved' then

				-- Follow point of object
				tmp_platform.x = event.x - event.xStart + tmp_platform.markX
				tmp_platform.y = event.y - event.yStart + tmp_platform.markY
				tmp_platform_h.x = event.x - event.xStart + tmp_platform_h.markX
				tmp_platform_h.y = event.y - event.yStart + tmp_platform_h.markY

			elseif event.phase == 'ended' or event.phase == 'cancelled' then

				-- Place or cancel the object
				display.getCurrentStage():setFocus(tmp_platform, nil)
				tmp_platform.isFocus = false

				tmp_platform.alpha = 0
				tmp_platform_h.alpha = 0

				tmp_platform.file = 'gfx/platform.png'
				tmp_platform.tag = 'block'
				
				-- Limits the blocks to 7 alowed on the screen
				local n = 0
				for i = 1, #blocks do
					if (blocks[i].tag == 'block') then
						n = n + 1
					end
				end

				if (n < 7) then
					make_paltform(tmp_platform)
					tmp_platform = nil
				end

			end
			
		end
	end


	-- return true so Corona knows that the touch event was handled propertly
	return true

end

-- frame_handler
-- handles enterFrame 
--
function frame_handler(event) 

	player.rotation = player.rotation + 2.5

	-- Check if the player is stuck
	vx, vy = player:getLinearVelocity()

	if (player.y < 400) then  

		-- move the blocks down
		for i = 1, #blocks do
			blocks[i].y = blocks[i].y - (player.y - 400)
		end

		-- update the blocks array
		for i = #blocks, 1, -1 do
			if (blocks[i].y > screenH + blocks[i].height) then
				blocks[i]:removeSelf()
				table.remove( blocks, i )
			end
		end

		-- move the player accordingly and increase the score
		player.y        = player.y - (player.y - 400)
		player.score    = player.score + 1

		-- Check if the background should be changed
		if (player.score % 100 == 0) then
			make_saw()
		end

		-- display the score
		txt_score.text = player.score

	elseif (player.y > screenH + (player.height / 2)) or (vy == 0) then
		layer_background.fx('below')
		game_over(true)
	elseif (player.x > screenW + player.half) then
		player.x = 0 - player.half
	elseif (player.x < 0 - player.half) then
		player.x = screenW + player.half
	end

	-- update the block count
	local n = 0
	for i = 1, #blocks do
		if (blocks[i].tag == 'block') then
			n = n + 1
		end
		if (blocks[i].tag == 'saw') then
			blocks[i].rotation = blocks[i].rotation - blocks[i]._rotation
		end
	end

	if (txt_blocks) then
		txt_blocks.text = string.format('Platforms: %i', 7 - n)	
	end

end

-- make_platform
-- factory function for a platform
--
function make_paltform(obj)
	
	-- Element: Platform
	local platform = display.newRect(obj.x, obj.y, 100, 10, 4)
	platform.x = obj.x
	platform.y = obj.y
	platform.tag = obj.tag
	platform:setFillColor(0.12, 0.14, 0.17)
	platform.rotation = obj.rotation
	physics.addBody(platform, 'static', { density = 1.0, friction = 0.0, bounce = 0.0 })
	table.insert(blocks, platform)
	scr_game_screen:insert(1, platform )

end

-- make_rock
-- factory function for a saw
--
function make_saw()

	var = math.random(0, 100)
	if ((player.score >= 50) and (var > 20)) then
		-- Element: Rock
		radius = math.random(50, 80)
		local saw = display.newImageRect('gfx/saw.png', radius * 2, radius * 2)
		saw.y = -100
		saw.x = math.random(20, screenW - 40)
		saw.tag = 'saw'
		saw._rotation = math.random(5, 20)
		physics.addBody(saw, 'static', { density = 1.0, friction = 0.0, bounce = 0.0, radius = radius * 0.7})
		table.insert(blocks, saw)
		scr_game_screen:insert(1, saw)
	end
	
end

-- game_over
-- runs game over
--
function game_over(flag)

	if not (flag == true) then
		layer_background.fx("tick")
	end

	scr_game_screen.isVisible = false
	scr_game_over.isVisible = true
	scr_game_over.score(player.score)

	reset_game()

end

-- reset_game
-- clears and resets game data
--
function reset_game()

	-- Runtime Listeners: touch, enterFrame
	btn_quit:removeEventListener('tap', game_over)
	Runtime:removeEventListener('touch', touch_handler)
	Runtime:removeEventListener('enterFrame', frame_handler)

	-- remove the player
	physics.removeBody(player)
	scr_game_screen:remove(player)

	-- remove all blocks
	for i = 1, #blocks do 
		physics.removeBody(blocks[i]) 
		scr_game_screen:remove(blocks[i])
	end

	-- remove explosion
	display.remove( explosion )
	explosion:removeEventListener("sprite", sprite_handler)
	explosion = nil

	-- remove elements
	scr_game_screen:remove(tmp_platform)
	tmp_platform = nil

	scr_game_screen:remove(tmp_platform_h)
	tmp_platform_h = nil

	scr_game_screen:remove(txt_score)
	txt_score = nil

	scr_game_screen:remove(txt_blocks)
	txt_blocks = nil

	scr_game_screen:remove(btn_quit)
	btn_quit = nil

	-- clear player and blocks
	player = {}
	blocks = {}

end

-- class functions
scr_game_screen.load  = load

return scr_game_screen
-----------------------------------------------------------------------------------------
-- Author		: Matt Muehlemann 
-- File Name	: factory.lua
-- Date Created	: 08-21-2016
-----------------------------------------------------------------------------------------

local obj = {}

local function make_button(obj)

	local g = display.newGroup()

	local i = display.newImage(obj.filename, obj.x, obj.y, true)
	i.width = obj.size
	i.height = obj.size

	g:insert(i)

	return g

end

obj.make_button = make_button

return obj
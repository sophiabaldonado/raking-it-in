local class = require 'class'
local Tile = class()

function Tile:init()
	-- self.isDeadly = false -- mine, trap, hole, etc
	self.revealed = false
end

function Tile:draw(x, y, size)
	local color = { 255, 150, 0, 255 }
	if self.isDeadly then color = { 255, 0, 0, 255 } end

	if not self.revealed then
		love.graphics.setColor(color)
		love.graphics.rectangle('fill', x, y, size, size)
		love.graphics.setColor(255, 255, 255, 255)
	end
end

function Tile:setIsDeadly(deadly)
	self.isDeadly = deadly
end

return Tile

local class = require 'class'
local Tile = class()

function Tile:init()
	self.revealed = false
end

function Tile:draw(size)
	local color = { 255, 150, 0, 255 }
	if self.isDeadly then color = { 255, 0, 0, 255 } end
	if self.item then color = { 0, 100, 200, 255 } end
	if self.revealed then color = { 0, 0, 0, 255 } end

	love.graphics.setColor(color)
	love.graphics.rectangle('fill', self.x, self.y, size, size)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.print(self.pos, self.x, self.y)
	love.graphics.setColor(255, 255, 255, 255)

end

function Tile:setDeadly()
	self.isDeadly = 'splosion'
end

function Tile:setRandomItem()
	self.item = { name = 'watch', value = '2' }
end

function Tile:setCoords(x, y)
	self.x = x
	self.y = y
end

return Tile

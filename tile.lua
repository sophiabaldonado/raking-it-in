local class = require 'class'
local Tile = class()

function Tile:init()
	self.revealed = false
end

function Tile:draw(x, y, size)
	local color = { 255, 150, 0, 255 }
	if self.isDeadly then color = { 255, 0, 0, 255 } end
	if self.revealed then color = { 0, 0, 0, 255 } end

	love.graphics.setColor(color)
	love.graphics.rectangle('fill', x, y, size, size)
	love.graphics.setColor(255, 255, 255, 255)
end

function Tile:setDeadly(deadly)
	self.isDeadly = deadly
end

function Tile:setItem()

end

return Tile

local grid = require 'grid'

local player = {}

function player:load()
	self.pos = 1
end

function player:update(dt)

end

function player:keypressed(key)

		if key == 'up' then
			self.pos = self.pos - grid.width
		elseif key == 'down' then
			self.pos = self.pos + grid.width
		elseif key == 'left' then
			self.pos = self.pos - 1
		elseif key == 'right' then
			self.pos = self.pos + 1
		end


end

function player:draw(coords)
	love.graphics.circle('fill', coords.x, coords.y, 25)
end

return player

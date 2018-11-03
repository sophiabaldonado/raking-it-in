local grid = require 'grid'

local player = {}

function player:load()
	self.pos = 1
end

function player:update(dt)

end

function player:keypressed(key)

		if key == 'up' then
			if self.pos > grid.width then
				self.pos = self.pos - grid.width
				print(self.pos)
			end
		elseif key == 'down' then
			if self.pos <= #grid.tiles - grid.width then
				self.pos = self.pos + grid.width
				print(self.pos)
			end
		elseif key == 'left' then
			if self.pos % grid.width ~= 1 then
				self.pos = self.pos - 1
				print(self.pos)
			end
		elseif key == 'right' then
			if self.pos % grid.width ~= 0 then
				self.pos = self.pos + 1
				print(self.pos)
			end
		end

end

function player:draw(coords)
	love.graphics.circle('fill', coords.x, coords.y, 25)
end

return player

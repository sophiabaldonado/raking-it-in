local Tile = require 'tile'
local grid = {}

function grid:load(size)
	self.tiles = {}
	self.size = size
	self.tileSize = 100

	for i = 1, self.size do
		local tile = Tile(false)
		table.insert(self.tiles, tile)
	end
	self.tiles[love.math.random(1, size)]:setIsDeadly(true)
	self.width, self.height = math.sqrt(#self.tiles), math.sqrt(#self.tiles)
end

function grid:update(dt)
	--
end

function grid:draw()
	local i = 1
	for w = 1, self.width do
		for h = 1, self.height do
			x, y = self:coords(w, h)
			if self.tiles[i].raked then
				if self.tiles[i] == 2 then
					love.graphics.circle('fill', x - self.tileSize / 2, y - self.tileSize / 2, 2)
				else
					love.graphics.circle('line', x - self.tileSize / 2, y - self.tileSize / 2, 2)
				end
			else
				self.tiles[i]:draw(x, y, self.tileSize)
			end
			i = i + 1
		end
	end
end

function grid:coords(w, h)
	return w * self.tileSize, h * self.tileSize
end

function grid:getTile(pos)
	return self.tiles[pos]
end


return grid

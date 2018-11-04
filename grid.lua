local Tile = require 'tile'
local grid = {}

function grid:load(size)
	self.tiles = {}
	self.size = size
	self.tileSize = 100

	for i = 1, self.size do
		local tile = Tile(false)
		tile.pos = i
		table.insert(self.tiles, tile)
	end
	self.tiles[love.math.random(1, size - 1)]:setDeadly()
	self.tiles[love.math.random(1, size)]:setRandomItem()

	self.width, self.height = math.sqrt(#self.tiles), math.sqrt(#self.tiles)

	local i = 1
	for h = 1, self.width do
		for w = 1, self.height do
			x, y = self:coords(w - 1, h - 1)
			self.tiles[i]:setCoords(x, y)
			i = i + 1
		end
	end
end

function grid:update(dt)
	--
end

function grid:draw()
	for _,tile in ipairs(self.tiles) do
		tile:draw(self.tileSize)
	end
end

function grid:coords(w, h)
	return w * self.tileSize, h * self.tileSize
end

function grid:getTile(pos)
	return self.tiles[pos]
end


return grid

local Tile = require 'tile'
local grid = {}

function grid:load(size)
	self.tiles = {}
	self.size = size
	self.tileSize = 50

	for i = 1, self.size do
		local tile = Tile(false)
		tile.pos = i
		table.insert(self.tiles, tile)
	end

	self:pickSpecials()
	self:pickDeadlies()

	self.width, self.height = math.sqrt(#self.tiles), math.sqrt(#self.tiles)
	self.offset = (love.graphics.getWidth() / 2) - ((self.width / 2) * self.tileSize)

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
	for k,tile in ipairs(self.tiles) do
		tile:update(dt)
	end
end

function grid:draw()
	for _,tile in ipairs(self.tiles) do
		tile:draw(self.tileSize)
	end
end

function grid:coords(w, h)
	return self.offset + (w * self.tileSize), 50 + h * self.tileSize
end

function grid:getTile(pos)
	return self.tiles[pos]
end

function grid:pickDeadlies()
	local deadlies = {}
	while #deadlies < 5 do
		table.insert(deadlies, love.math.random(1, self.size - 1))
	end
	for _, tile in ipairs(deadlies) do
		self.tiles[tile]:setDeadly()
	end
end

function grid:pickSpecials()
	local highSpecials = {}
	while #highSpecials < 10 do
		table.insert(highSpecials, love.math.random(1, self.size / 2))
	end
	for _, tile in ipairs(highSpecials) do
		self.tiles[tile]:setRandomHighValueItem()
	end

	local lowSpecials = {}
	while #lowSpecials < 35 do
		table.insert(lowSpecials, love.math.random(self.size / 4, self.size - 1))
	end
	for _, tile in ipairs(lowSpecials) do
		self.tiles[tile]:setRandomLowValueItem()
	end
end

return grid

local grid = {}

function grid:load()
	-- tiles = {
	-- 	0, 0, 0, 0, 0,
	-- 	0, 0, 0, 0, 0,
	-- 	0, 0, 0, 0, 0,
	-- 	0, 0, 0, 0, 0,
	-- 	0, 0, 0, 0, 0,
 	-- }
	self.tileSize = 100
	self.width, self.height = math.sqrt(#self.tiles), math.sqrt(#self.tiles)

	self.tiles = {
		0, 0, 0,
		0, 0, 0,
		0, 0, 0
	}
end

function grid:update(dt)
	--
end

function grid:draw()
	for w = 1, #self.tiles / 2 do
		for h = 1, #self.tiles / 2 do
			x, y = self:coords(w, h)
			love.graphics.rectangle("line", x - self.tileSize / 2, y - self.tileSize / 2, 10, 10)
		end
	end
end

function grid:coords(w, h)
	return w * self.tileSize, h * self.tileSize
end

return grid

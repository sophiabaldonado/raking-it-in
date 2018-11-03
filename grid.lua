local grid = {}

function grid:load()
	self.tiles = {
		0, 0, 0,
		0, 0, 0,
		0, 0, 0
	}
	-- tiles = {
	-- 	0, 0, 0, 0, 0,
	-- 	0, 0, 0, 0, 0,
	-- 	0, 0, 0, 0, 0,
	-- 	0, 0, 0, 0, 0,
	-- 	0, 0, 0, 0, 0,
 	-- }
	self.tileSize = 100
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
			if self.tiles[i] > 0 then
				if self.tiles[i] == 2 then
					love.graphics.circle('fill', x - self.tileSize / 2, y - self.tileSize / 2, 2)
				else
					love.graphics.circle('line', x - self.tileSize / 2, y - self.tileSize / 2, 2)
				end
			else
				love.graphics.rectangle('line', x - self.tileSize / 2, y - self.tileSize / 2, 50, 50)
			end
			i = i + 1
		end
	end
end

function grid:coords(w, h)
	return w * self.tileSize, h * self.tileSize
end

function grid:rake(tile)
	self.tiles[tile] = self.tile[tile] + 1
end


return grid

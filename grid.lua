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
	for w = 0, self.width do
		for h = 0, self.height do
			x, y = self:coords(w, h)
			love.graphics.rectangle("line", x - self.tileSize / 2, y - self.tileSize / 2, 10, 10)
		end
	end
end

function grid:coords(w, h)
	return w * self.tileSize, h * self.tileSize
end

function grid:moveplayer(pos, dir)
	if dir == 'up' then
		return pos - self.width
	elseif dir == 'down' then
		return pos + self.width
	if dir == 'left' then
		return pos
	elseif dir == 'right' then
		return
	end

end

return grid

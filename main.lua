local player = require 'player'
local grid = require 'grid'

function love.load()
	grid:load()
	player:load()
	convert = {
		[1] = (grid.tileSize / 2) * 1,
		[2] = (grid.tileSize / 2) * 3,
		[0] = (grid.tileSize / 2) * 5
	}
end

function love.update(dt)
	grid:update(dt)
	player:update(dt)
end

function love.draw()
	grid:draw()
	x = convert[math.fmod(player.pos, grid.width)]
	y = convert[findY(player.pos)]
	player:draw({ x = x, y = y })
end

function findY(pos)
	if pos <= grid.width then return 1 end
	if pos > #grid.tiles - grid.width then return 0 end
	return 2

end

function love.keypressed(key)
	player:keypressed(key)
end

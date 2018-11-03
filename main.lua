local player = require 'player'
local grid = require 'grid'

function love.load()
	grid:load()
	player:load()
end

function love.update(dt)
	grid:update(dt)
	player:update(dt)
end

function love.draw()
	grid:draw()
	player:draw({ x = (player.pos * grid.tileSize) + grid.tileSize / 2, y = player.pos * grid.tileSize + grid.tileSize / 2 })
	-- player:draw({ x = (player.pos + grid.tileSize), y = (player.pos * grid.tileSize })

end

function love.keypressed(key)
	-- player:keypressed(key)
end

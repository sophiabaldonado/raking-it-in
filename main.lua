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
	player:draw({ x = (player.pos - 1) * grid.tileSize + grid.tileSize / 2, y = (player.pos - 1) * grid.tileSize + grid.tileSize / 2 })
end

function love.keypressed(key)
	player:keypressed(key)
end

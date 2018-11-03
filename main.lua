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
	player:draw({ x = 50, y = 50 })
end

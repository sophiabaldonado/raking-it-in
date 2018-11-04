local player = require 'player'
local grid = require 'grid'
local store = require 'store'

function love.load()
	grid:load(100)
	player:load()
	store:load()

	paused = false
	newStep = false
	currentTile = grid:getTile(player.pos)
	player:stepson(currentTile)
end

function love.update(dt)
	if not paused then
		grid:update(dt)
		player:update(dt)
	end
	if player.dead then
		paused = true
	end
end

function love.draw()
	grid:draw()
	player:draw({ x = currentTile.x + grid.tileSize / 2, y = currentTile.y + grid.tileSize / 2 })
	drawHud()
	if store.active then
		store:draw()
	end
end

function love.keypressed(key)
	if store.active then
		if key == 'escape' then
			store.active = false
		end

	end

	if key == 'escape' or key == 'p' then
		paused = not paused
	end

	if not paused then
		local prevPos = player.pos
		player:keypressed(key)
		if player.pos ~= prevPos then
			currentTile = grid:getTile(player.pos)
			player:stepson(currentTile)
 		end
	end
end

function drawHud()
	love.graphics.print('$'..player.pocketmoney, 25, 25)

	if paused then
		local text = 'opps no text :('
		if player.dead then
			text = 'yoer ded!!!'
		end

		love.graphics.rectangle('fill', 100, 100, 300, 300)
		love.graphics.setColor(0, 100, 0, 255)
		love.graphics.print(text, 150, 200)
		love.graphics.setColor(255, 255, 255, 255)
	end
end

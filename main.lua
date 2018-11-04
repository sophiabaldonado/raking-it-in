local player = require 'player'
local grid = require 'grid'
local store = require 'store'
local piggybank = require 'bank'

function love.load()
	grid:load(100)
	player:load()
	store:load()
	piggybank:load()

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
	piggybank:draw()
	store:draw()
	player:draw({ x = currentTile.x + grid.tileSize / 2, y = currentTile.y + grid.tileSize / 2 })
	drawHud()
end

function love.keypressed(key)
	if store.active then
		if key == 'escape' then
			store.active = false
		end
	else
		if key == 'escape' or key == 'p' then
			paused = not paused
		end

		if not paused then
			if player.pos == #grid.tiles then
				if key == 'right' then
					store.active = true
				end
				if key == 'down' then
					piggybank:deposit(player.pocketmoney)
					player.pocketmoney = 0
				end
			end

			local prevPos = player.pos
			player:keypressed(key)
			if player.pos ~= prevPos then
				currentTile = grid:getTile(player.pos)
				player:stepson(currentTile)
	 		end
		end
	end
end

function drawHud()
	love.graphics.print('$'..player.pocketmoney, 25, 25)
	love.graphics.print('$'..piggybank.total, piggybank.x + (piggybank.width / 2) + 10, piggybank.y - 5)

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

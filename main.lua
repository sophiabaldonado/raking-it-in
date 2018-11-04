local player = require 'player'
local grid = require 'grid'
local store = require 'store'
local piggybank = require 'bank'

function love.load()
	setmetatable(_G, {
		__index = require('cargo').init('/')
	})
	
	newSession()
end

function love.update(dt)
	if not paused then
		grid:update(dt)
		player:update(dt)
	end
	if player.dead then
		paused = true
	end
	if currentTile.item then
		lastItem = currentTile.item
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
		store:keypressed(key)
	else
		if key == 'escape' or key == 'p' then
			paused = not paused
		end

		if paused and player.dead then
			if key == 'r' then
				setupBoard()
			end
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
				currentTile.item = nil
				currentTile = grid:getTile(player.pos)
				player:stepson(currentTile)
	 		end
		end
	end
end

function drawHud()
	love.graphics.print('$'..player.pocketmoney, 25, 25)
	love.graphics.print('$'..piggybank.total, piggybank.x + (piggybank.width / 2) + 10, piggybank.y - 5)

	if lastItem then
		local desc = 'You found a'..lastItem.name..' worth $'..lastItem.value..'!'
		love.graphics.print(desc, grid.tiles[1].x + grid.tileSize / 2, 550)
	end

	if paused then
		local text = 'pause (press Escape to resume)'
		if player.dead then
			text = 'yoer ded!!!! (press R to restart)'
		end

		local x = (love.graphics.getWidth() / 2) - 150
		love.graphics.rectangle('fill', x, 100, 300, 300)
		love.graphics.setColor(0, 100, 0, 255)
		love.graphics.print(text, x + 50, 200)
		love.graphics.setColor(255, 255, 255, 255)
	end
end

function newSession()
	setupBoard()
	piggybank:load()
end

function setupBoard()
	grid:load(100)
	player:load()
	store:load()

	paused = false
	newStep = false
	currentTile = grid:getTile(player.pos)
	player:stepson(currentTile)
end

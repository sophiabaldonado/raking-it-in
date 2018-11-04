local player = require 'player'
local grid = require 'grid'
local store = require 'store'
local piggybank = require 'bank'
local timer = require 'timer'

io.stdout:setvbuf('no')

function love.load()
	setmetatable(_G, {
		__index = require('cargo').init('/')
	})
	
	session = {}
	newSession()
end

function love.update(dt)
	if not session.paused then
		grid:update(dt)
		player:update(dt)
	end
	if player.dead then
		session.paused = true
	end
	if session.currentTile.item then
		lastItem = session.currentTile.item
	end
end

function love.draw()
	grid:draw()
	piggybank:draw()
	store:draw()
	player:draw({ x = session.currentTile.x + grid.tileSize / 2, y = session.currentTile.y + grid.tileSize / 2 })
	drawHud()
end

function love.keypressed(key)
	if store.active then
		store:keypressed(key)
	else
		if key == 'escape' or key == 'p' then
			session.paused = not session.paused
		end

		if session.paused and player.dead then
			if key == 'r' then
				setupBoard()
			end
		elseif session.paused and session.narrative then
			session.narrative = nil
			session.paused = false
		end

		if not session.paused then
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
				session.currentTile.item = nil
				session.currentTile = grid:getTile(player.pos)
				player:stepson(session.currentTile)
	 		end
		end
	end
end

function drawHud()
	love.graphics.print('$'..player.pocketmoney, 25, 25)
	love.graphics.print('$'..piggybank.total, piggybank.x + piggybank.width + 10, piggybank.y + 20)
	love.graphics.print(session.lives, 25, 45)

	if lastItem then
		local desc = 'You found a'..lastItem.name..' worth $'..lastItem.value..'!'
		love.graphics.print(desc, grid.tiles[1].x + grid.tileSize / 2, 550)
	end

	if session.paused then
		local text = 'pause (press Escape to resume)'
		local image = assets.images.pause
		if player.dead then
			text = 'yoer ded!!!! (press R to restart)'
			if session.lives <= 1 then
				image = assets.images.gameover
			else
				image = assets.images.dead
			end
		elseif session.narrative then
			text = session.narrative.text
			image = assets.images.speechright
		end

		local x = (love.graphics.getWidth() / 2) - 150
		love.graphics.draw(image, x, 140)
		
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.print(text, x + 40, 200)
		love.graphics.setColor(255, 255, 255, 255)
	end
end

function newSession()
	session.lives = 4
	piggybank:load()
	setupBoard()
end

function setupBoard()
	grid:load(100)
	player:load()
	store:load()

	session.lives = session.lives - 1
	session.narrative = { char = 'player', type = 'start', text = 'Neat! This piggy bank alread has $'..piggybank.total..'!' }
	session.paused = true
	session.currentTile = grid:getTile(player.pos)
	player:stepson(session.currentTile)
end

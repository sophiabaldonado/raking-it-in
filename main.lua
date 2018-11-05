local player = require 'player'
local grid = require 'grid'
local store = require 'store'
local piggybank = require 'bank'

io.stdout:setvbuf('no')

function love.load()
	setmetatable(_G, {
		__index = require('cargo').init('/')
	})
	love.graphics.setBackgroundColor( 137, 192, 123 )
	session = {}
	newSession()
end

function love.update(dt)
	grid:update(dt)
	player:update(dt)
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
	player:draw({ x = session.currentTile.x + player.width / 2, y = session.currentTile.y + player.width / 2 })
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
				if key == 'down' then
					piggybank:deposit(player.pocketmoney)
					player.pocketmoney = 0
				end
				if key == 'right' then
					store.active = true
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

	for i = 1, session.lives do
		love.graphics.draw(assets.images.heart, (40 * i) - 30, 50, 0, .75)
	end

	if lastItem then
		local desc = 'You found a'..lastItem.name..' worth $'..lastItem.value..'!'
		love.graphics.print(desc, grid.tiles[1].x + grid.tileSize / 2, 550)
	end

	if session.paused then
		local text = 'pause (press Escape to resume)'
		local textY = 240
		local xOffset = 250
		local x = (love.graphics.getWidth() / 2) - xOffset
		local textX = x + 80
		local color = { 255, 255, 255, 255 }
		local image = assets.images.pause
		if player.dead then
			textY = 280
			color = { 182, 11, 11, 255 }
			if session.lives <= 1 then
				text = ''
				image = assets.images.gameover
			else
				text = '(press R to restart)'
				image = assets.images.dead
			end
		elseif session.narrative then
			text = session.narrative.text
			image = assets.images.speechright
		end

		love.graphics.draw(image, x, 140)

		love.graphics.setColor(color)
		love.graphics.print(text, textX, textY)
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

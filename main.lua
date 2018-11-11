local piggybank = require 'bank'
local player = require 'player'
local store = require 'store'
local grid = require 'grid'
local flux = require 'flux'
local major, minor = love.getVersion()
local newVersion = minor > 10
local cargo = newVersion and 'cargo11' or 'cargo10'

io.stdout:setvbuf('no')

function love.load()
	setmetatable(_G, {
		__index = require(cargo).init('/'),
	})
	love.window.setTitle('Raking It In')
	local bgcolor = newVersion and {.54, .75, .48 } or { 137, 192, 123 }
	love.graphics.setBackgroundColor(bgcolor)
	local font = assets.fonts.krona(15)
	love.graphics.setFont(font)
	startMenu = false

	startSession()
end

function love.update(dt)
	flux.update(dt)
	if session.grandma > 0 then
		timeHer()
	end
	if session.currentTile.item then
		lastItem = session.currentTile.item
	end
	grid:update(dt)
	player:update(dt)
	if player.dead then
		session.paused = true
	end
end

function timeHer()
	flux.to(session, 0, { grandma = 0, grandmaNum = 0 }):delay(session.grandma)
end

function love.draw()
	if startMenu then
		drawStartMenu()
	else
		grid:draw()
		session.piggybank:draw()
		store:draw()
		player:draw({ x = session.currentTile.x + player.width / 2, y = session.currentTile.y + player.width / 2 })
		if session.grandmaNum ~= 1 then drawHud() end
		drawWin()
		drawGranny()
	end
end

function love.keypressed(key)
	if session.win or session.lives == 0 then
		if key == 'r' then
			startSession()
		end
	elseif startMenu then
		if key == 'space' then
			startMenu = false
		end
	else
		if session.grandma > 0 then return end

		if store.active then
			store:keypressed(key, session)
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
						session.piggybank:deposit(player.pocketmoney)
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
					player:stepson(session)
		 		end
			end
		end
	end
end

function drawStartMenu()
	love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
end

function drawGranny()
	if session.grandma > 0 then
		local img = 'grandma'..session.grandmaNum
		local x = session.grandmaNum == 6 and -80 or -20
		love.graphics.draw(assets.images[img], x, 100)
		local textTop, textMid, textTopBot = '', '', ''

		if session.grandmaNum < 6 then love.graphics.draw(assets.images.speechleft, 300, 100) end
		if session.grandmaNum == 1 then
			textTop = "What a nice child you are."
			textMid = "I'll give you $20 to rake my backyard."
			textBot = "Good luck..."
			love.graphics.print(textTop, 380, 180)
			love.graphics.print(textBot, 380, 220)
		else

		end
		love.graphics.print(textMid, 380, 200)
	end
end

function drawHud()
	love.graphics.print('$'..player.pocketmoney, 40, 60)
	love.graphics.print('$'..session.piggybank.total, session.piggybank.x + session.piggybank.width, session.piggybank.y + 20)

	for i = 1, session.lives do
		love.graphics.draw(assets.images.heart, (40 * i) - 30, 10, 0, .75)
	end

	if lastItem then
		local desc = 'You found a'..lastItem.name..' worth $'..lastItem.value..'!'
		love.graphics.print(desc, grid.tiles[1].x + grid.tileSize / 2, 18)
	end

	if session.paused then
		local text = 'pause (press Escape to resume)'
		local textY = 240
		local xOffset = 250
		local x = (love.graphics.getWidth() / 2) - xOffset
		local textX = x + 60
		local color = newVersion and { 1, 1, 1, 1 } or { 255, 255, 255, 255 }
		local image = assets.images.pause
		if player.dead then
			textY = 280
			color = newVersion and { .72, .01, 0, 1 } or { 182, 11, 11, 255 }
			image = getKOScreen()
			text = '(press R to restart)'
			if session.lives == 0 then
				session.grandmaNum = 6
				session.grandma = 20000
			end
		elseif session.narrative then
			text = session.narrative.text
			image = assets.images.speechright
		end

		love.graphics.draw(image, x, 140)

		love.graphics.setColor(color)
		love.graphics.print(text, textX, textY)
		color = newVersion and { 1, 1, 1, 1 } or { 255, 255, 255, 255 }
		love.graphics.setColor(color)
	end
end

function drawWin()
	if session.win then
		local image = assets.images.pause
		local xOffset = 250
		local x = (love.graphics.getWidth() / 2) - xOffset
		love.graphics.draw(image, x, 140)
		local color = newVersion and { .61, .12, .90, 1 } or { 156, 30, 230, 255 }
		love.graphics.setColor(color)
		love.graphics.print('YOU ESCAPED!', x + 180, 230)
		love.graphics.print('(press R to restart)', x + 155, 250)
		color = newVersion and { 1, 1, 1, 1 } or { 255, 255, 255, 255 }
		love.graphics.setColor(color)
	end
end

function startSession()
	session = {}
	session.grandmaNum = 1
	session.grandma = 400
	session.lives = 3
	session.piggybank = piggybank
	session.piggybank:load()
	setupBoard()
end

function setupBoard()
	grid:load(100)
	player:load()
	store:load()

	session.narrative = { char = 'player', type = 'start', text = 'This piggy bank already has $'..session.piggybank.total..'!' }
	session.paused = true
	session.currentTile = grid:getTile(player.pos)
	player:stepson(session)
end

function getKOScreen()
	return session.lives == 0 and assets.images.gameover or assets.images.dead
end

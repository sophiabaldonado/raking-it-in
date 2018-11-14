local piggybank = require 'bank'
local player = require 'player'
local store = require 'store'
local grid = require 'grid'
local flux = require 'flux'
local major, minor = love.getVersion()
local newVersion = minor ~= 10
local cargo = newVersion and 'cargo11' or 'cargo10'

io.stdout:setvbuf('no')

function love.load()
	setmetatable(_G, {
		__index = require(cargo).init('/'),
	})
	love.window.setTitle('Raking It In')
	local bgcolor = newVersion and { .54, .75, .48 } or { 137, 192, 123 }
	love.graphics.setBackgroundColor(bgcolor)
	bigfont = assets.fonts.krona(25)
	font = assets.fonts.krona(15)
	love.graphics.setFont(font)
	startMenu = false
	sound = loadSounds()
	sound.win:setVolume(0.8)
	timing = false
	startSession()
end

function love.update(dt)
	flux.update(dt)
	if session.grandma then
		if not timing then
			timeHer()
		end
	end
	local tile = session.currentTile
	if tile.item then
		session.lastItem = tile.item
		session.sound.coin[love.math.random(1, 5)]:play()
		if tile.triggersGranny then
			if session.grandmaTween then session.grandmaTween:stop() end
			session.grandmaNum = love.math.random(2, 5)
			session.grandmaWords = getRandomGrannySpeech()
			session.grandmaPos = 400
			session.grandmaTimer = 100
			session.grandma = true
		end
		tile.item = nil
	end
	grid:update(dt)
	player:update(dt)
	if player.dead then
		session.paused = true
	end
end

function timeHer()
	timing = true
	session.grandmaTween = flux.to(session, 40, { grandmaPos = 100 })
		:after(session, session.grandmaTimer, { grandmaPos = 100 })
		:after(session, 50, { grandmaPos = 600 })
		:oncomplete(function()
			session.grandma = false
			session.grandmaNum = 0
			timing = false
		end)
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
		if session.grandma then return end

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
						if player.pocketmoney > 0 then session.sound.deposit:play() end
						player.pocketmoney = 0
					end
					if key == 'right' then
						store.active = true
						session.sound.storeOpen:play()
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
	if session.grandma then
		local img = 'grandma'..session.grandmaNum
		local x = session.grandmaNum == 6 and -80 or -20
		love.graphics.draw(assets.images[img], x, session.grandmaPos)
		local textTop, textMid, textTopBot = '', '', ''

		if session.grandmaNum < 6 then love.graphics.draw(assets.images.speechleft, 300, 100) end
		if session.grandmaNum == 1 then
			textTop = "What a nice child you are."
			textMid = "I'll give you $20 to rake my backyard."
			textBot = "Good luck..."
			love.graphics.print(textTop, 380, 180)
			love.graphics.print(textBot, 380, 220)
		elseif session.grandmaNum < 6 then
			textMid = session.grandmaWords
		end
		love.graphics.print(textMid, 380, 200)
	end
end

function getRandomGrannySpeech()
	local words = {
		"I'm watching you..",
		"Be a doll and bring that in for me",
		"What a clever child..",
		"Curiosity killed the cat!",
		"What did you find..",
		"Nobody likes a snoop",
		"I've been looking everywhere for that"
	}
	return words[love.math.random(1, #words)]
end

function drawHud()
	love.graphics.setFont(bigfont)
	love.graphics.print('$'..string.format('%.2f', player.pocketmoney), 10, 60)
	love.graphics.setFont(font)
	love.graphics.print('$'..string.format('%.2f', session.piggybank.total), session.piggybank.x + session.piggybank.width, session.piggybank.y + 20)

	for i = 1, session.lives do
		love.graphics.draw(assets.images.heart, (40 * i) - 30, 10, 0, .75)
	end

	if session.lastItem then
		local desc = 'You found a'..session.lastItem.name..' worth $'..session.lastItem.value..'!'
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
			textY = 295
			color = newVersion and { .72, .01, 0, 1 } or { 182, 11, 11, 255 }
			image = getKOScreen()
			text = 'You dropped $'..string.format('%.2f', player.pocketmoney)..' (press R to respawn)'
			if session.lives == 0 then
				session.grandmaNum = 6
				session.grandmaTimer = 20000
				session.grandma = true
				text = 'You still need $'..string.format('%.2f', store.prices.bike - (player.pocketmoney + session.piggybank.total))..' (press R to replay)'
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
		love.graphics.setFont(bigfont)
		love.graphics.print('YOU ESCAPED!', x + 125, 220)
		love.graphics.setFont(font)
		love.graphics.print('(press R to replay)', x + 155, 250)
		color = newVersion and { 1, 1, 1, 1 } or { 255, 255, 255, 255 }
		love.graphics.setColor(color)
	end
end

function startSession()
	session = {}
	timing = false
	session.sound = sound
	session.grandmaNum = 1
	session.grandmaTimer = 250
	session.grandmaPos = 400
	session.grandmaWords = getRandomGrannySpeech()
	session.grandma = true
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

function loadSounds()
	return {
		deposit = love.audio.newSource('assets/audio/deposit.ogg', 'static'),
		coin = {
			[1] = love.audio.newSource('assets/audio/coin1.ogg', 'static'),
			[2] = love.audio.newSource('assets/audio/coin2.ogg', 'static'),
			[3] = love.audio.newSource('assets/audio/coin3.ogg', 'static'),
			[4] = love.audio.newSource('assets/audio/coin4.ogg', 'static'),
			[5] = love.audio.newSource('assets/audio/coin5.ogg', 'static')
		},
		storeOpen = love.audio.newSource('assets/audio/storeOpen.ogg', 'static'),
		storeClose = love.audio.newSource('assets/audio/storeClose.ogg', 'static'),
		heart = love.audio.newSource('assets/audio/heart.ogg', 'static'),
		granny = love.audio.newSource('assets/audio/cackle.ogg', 'static'),
		gameover = love.audio.newSource('assets/audio/gameover.ogg', 'static'),
		win = love.audio.newSource('assets/audio/win.ogg', 'static')
	}
end

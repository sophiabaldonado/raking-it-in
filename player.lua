local grid = require 'grid'

local player = {}

function player:load()
	self.pos = #grid.tiles
	self.pocketmoney = 0
	self.dead = false
	self.item = 'rake'
	self.dir = math.pi
	self.image = assets.images['player'..love.math.random(1, 6)]
	self.width = self.image:getWidth()
	self.step = {
		[1] = love.audio.newSource('assets/audio/step1.ogg', 'static'),
		[2] = love.audio.newSource('assets/audio/step2.ogg', 'static'),
		[3] = love.audio.newSource('assets/audio/step3.ogg', 'static'),
		[4] = love.audio.newSource('assets/audio/step4.ogg', 'static'),
		[5] = love.audio.newSource('assets/audio/step5.ogg', 'static'),
		[6] = love.audio.newSource('assets/audio/step6.ogg', 'static')
	}
end

function player:update(dt)
	--
end

function player:keypressed(key)
	if key == 'up' then
		if self.pos > grid.width then
			self.dir = math.pi
			self.pos = self.pos - grid.width
			self.step[love.math.random(1, 6)]:play()
		end
	elseif key == 'down' then
		if self.pos <= #grid.tiles - grid.width then
			self.dir = 0
			self.pos = self.pos + grid.width
			self.step[love.math.random(1, 6)]:play()
		end
	elseif key == 'left' then
		if self.pos % grid.width ~= 1 then
			self.dir = math.pi / 2
			self.pos = self.pos - 1
			self.step[love.math.random(1, 6)]:play()
		end
	elseif key == 'right' then
		if self.pos % grid.width ~= 0 then
			self.dir = math.pi + math.pi / 2
			self.pos = self.pos + 1
			self.step[love.math.random(1, 6)]:play()
		end
	end
end

function player:stepson(session)
	local tile = session.currentTile
	if tile.isDeadly then
		self.dead = true
		session.lives = session.lives - 1
		local sound = session.lives == 0 and session.sound.gameover or session.sound.granny
		sound:play()
	end

	if tile.revealed then return end

	if self.item == 'rake' then
		self.action = 'Raking...'
		tile:rake()

		if tile.item and not tile.isDeadly then
			self:addmoney(tile.item.value)
		end
	end
end

function player:addmoney(itemvalue)
	self.pocketmoney = self.pocketmoney + itemvalue
end

function player:draw(coords)
	love.graphics.draw(self.image, coords.x, coords.y, self.dir,  1, 1, self.width / 2, self.width / 2)
end

return player

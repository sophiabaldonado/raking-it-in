local class = require 'class'
local flux = require 'flux'
local Tile = class()

function Tile:init()
	self.revealed = false
	self.adjectives = self:generateAdjectives()
	self.lowItems, self.highItems = self:generateItems()
	self.imageNum = love.math.random(1, 4)
	self.imageBig = assets.images['tilebig'..self.imageNum]
	self.imageMed = assets.images['tilemed'..self.imageNum]
	self.imageSmall = assets.images['tilesmall'..self.imageNum]
	self.alphaBig = { a = 1 }
	self.alphaMed = { a = 1 }
	self.alphaSmall = { a = 1 }
end

function Tile:update(dt)
	flux.update(dt)
end

function Tile:draw(size)
	if self.pos == 100 then
		love.graphics.setColor(.91, .52, .23, 1)
		love.graphics.rectangle('fill', self.x, self.y, size, size)
		love.graphics.setColor(1, 1, 1, 1)
	end
	if not self.revealed then
		if self.imageSmall then
			love.graphics.setColor(1, 1, 1, self.alphaSmall.a)
			love.graphics.draw(self.imageSmall, self.x, self.y)
			love.graphics.setColor(1, 1, 1, 1)
		end
		if self.imageMed then
			love.graphics.setColor(1, 1, 1, self.alphaMed.a)
			love.graphics.draw(self.imageMed, self.x, self.y)
			love.graphics.setColor(1, 1, 1, 1)
		end
		if self.imageBig then
			love.graphics.setColor(1, 1, 1, self.alphaBig.a)
			love.graphics.draw(self.imageBig, self.x, self.y)
			love.graphics.setColor(1, 1, 1, 1)
		end
	end
end

function Tile:rake()
	flux.to(self.alphaBig, 10, { a = 0 }):ease("linear"):delay(14)
	flux.to(self.alphaMed, 15, { a = 0 }):ease("linear"):delay(17)
	flux.to(self.alphaSmall, 18, { a = 0 }):ease("linear"):delay(26)
end

function Tile:setDeadly()
	self.isDeadly = true
	local deadlyItems = {
		{ name = ' landmine', value = 'your life' },
		{ name = ' bear trap', value = 'your life' },
		{ name = ' 30ft hole', value = 'your life' },
		{ name = ' grenade', value = 'your life' },
		{ name = ' poisonous snake', value = 'your life' }
	}
	self.item = self:pickRandom(deadlyItems)
end

function Tile:setRandomLowValueItem()
	self.item = self:getItem(self.lowItems)
end

function Tile:setRandomHighValueItem()
	self.item = self:getItem(self.highItems)
end

function Tile:setCoords(x, y)
	self.x = x
	self.y = y
end

function Tile:generateAdjectives()
	return {
		' ',
		' dirty ',
		'n old ',
		' bloody ',
		' stinky ',
		' nice ',
		' shiny ',
		' ragged ',
		' scraggly ',
		' spooky ',
		' rusty ',
		'n odd ',
		'n oily ',
		'n ancient '
	}
end

function Tile:pickRandom(t)
	local i = love.math.random(1, #t)
	return t[i]
end

function Tile:getItem(items)
	local randoItem = self:pickRandom(items)
	local name = self:pickRandom(self.adjectives)..randoItem.name
	randoItem.name = name
	return randoItem
end

function Tile:generateItems()
	return {
		{ name = 'watch', value = '2' },
		{ name = 'gold', value = '1' },
		{ name = 'silver', value = '0.50' },
		{ name = 'coin', value = '1.50' },
		{ name = 'necklace', value = '2' },
		{ name = 'locket', value = '4' },
		{ name = 'frisbee', value = '0.35' },
		{ name = 'bottlecap', value = '0.17' },
		{ name = 'monocle', value = '11' },
		{ name = 'pin', value = '7' },
		{ name = 'fork', value = '1.90' },
		{ name = 'picture frame', value = '5' },
		{ name = 'can', value = '.67' },
		{ name = 'bottle', value = '0.50' },
		{ name = 'boot', value = '13' },
		{ name = 'shoe', value = '3' },
		{ name = 'rock', value = '0' },
		{ name = 'handkerchief', value = '3.50' },
		{ name = 'rubber duck', value = '3' },
		{ name = 'lighter', value = '5' },
		{ name = 'baseball bat', value = '10' },
		{ name = 'finger', value = '0' },
		{ name = 'pen', value = '9' }
	},
	{
		{ name = 'gameboy', value = '19' },
		{ name = 'glasses', value = '22' },
		{ name = 'pocket knife', value = '23' },
		{ name = 'knife', value = '15' },
		{ name = 'hatchet', value = '35' },
		{ name = 'ring', value = '27' },
		{ name = 'chainsaw', value = '79' },
		{ name = 'machete', value = '56' },
		{ name = 'gun', value = '103' },
		{ name = 'brass knuckles', value = '99' },
		{ name = 'gold tooth', value = '60' },
		{ name = 'dinosaur bone', value = '84' },
		{ name = 'stein', value = '52' },
		{ name = 'broach', value = '44' },
		{ name = 'stopwatch', value = '30' },
		{ name = 'hammer', value = '29' }
	}
end

return Tile

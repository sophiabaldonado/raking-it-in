local major, minor = love.getVersion()
local newVersion = minor ~= 10
local bank = {}

function bank:load()
	self.total = 5
	self.x = 600
	self.y = 545
	self.width = 80
end

function bank:draw()
	love.graphics.draw(assets.images.piggybank, self.x, self.y, 0, .8)
	local color = newVersion and { 1, 1, 1, 1 } or { 255, 255, 255, 255 }
	love.graphics.setColor(color)
end

function bank:deposit(value)
	self.total = self.total + value
end

return bank

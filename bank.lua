local bank = {}

function bank:load()
	self.total = 5
	self.x = 590
	self.y = 500
	self.width = 80
end

function bank:draw()
	love.graphics.draw(assets.images.piggybank, self.x, self.y)
	love.graphics.setColor(255, 255, 255, 255)
end
function bank:deposit(value)
	self.total = self.total + value
end

return bank

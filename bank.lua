local bank = {}

function bank:load()
	self.total = 5
	self.x = 610
	self.y = 550
	self.width = 80
end

function bank:draw()
	love.graphics.setColor(100, 0, 50, 255)
	love.graphics.circle('fill', self.x, self.y, self.width / 2)
	love.graphics.setColor(255, 255, 255, 255)
end
function bank:deposit(value)
	self.total = self.total + value
end

return bank

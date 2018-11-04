local store = {}

function store:load()
	self.active = false
end

function store:draw()
	love.graphics.setColor(255, 50, 255, 255)
	local x = (love.graphics.getWidth() / 2) - 200
	love.graphics.rectangle('fill', x, 100, 400, 300)
	love.graphics.setColor(255, 255, 255, 255)
end

return store

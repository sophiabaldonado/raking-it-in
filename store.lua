local store = {}

function store:load()
	self.active = false
end

function store:draw()
	love.graphics.setColor(0, 200, 50, 255)
	love.graphics.rectangle('fill', 660, 400, 75, 100)
	love.graphics.setColor(255, 255, 255, 255)

	if self.active then
		local x = (love.graphics.getWidth() / 2) - 200
		love.graphics.draw(assets.images.storeGUI, x, 100)
		love.graphics.setColor(255, 255, 255, 255)
	end
end

function store:keypressed(key)
	if key == 'escape' or key == 'left' then
		self.active = false
	end
end

return store

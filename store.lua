local store = {}

function store:load()
	self.active = false
end

function store:draw()
	love.graphics.draw(assets.images.store, 660, 460)

	if self.active then
		local x = (love.graphics.getWidth() / 2) - 200
		love.graphics.draw(assets.images.storeGUI, x, 100)
		love.graphics.draw(assets.images.heart, x + 100, 280)
		love.graphics.print('press 1', x + 92, 350)
		love.graphics.print('$100', x + 98, 335)
		love.graphics.draw(assets.images.bike, x + 220, 270, 0, .9)
		love.graphics.print('press 2', x + 230, 350)
		love.graphics.print('$500', x + 235, 335)
		love.graphics.setColor(1, 1, 1, 1)
	end
end

function store:keypressed(key, session)
	if key == '1' then
		if session.piggybank.total < 100 or session.lives == 3 then
			return
		end
		session.lives = session.lives + 1
		session.piggybank.total = session.piggybank.total - 100
	elseif key == '2' then
		if session.piggybank.total < 500 then
			return
		end
		session.win = true
		session.piggybank.total = session.piggybank.total - 500
	elseif key == 'escape' or key == 'left' then
		self.active = false
	end
end

return store

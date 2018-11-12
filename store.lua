local major, minor = love.getVersion()
local newVersion = minor > 10
local store = {}

function store:load()
	self.active = false
	self.prices = { bike = 500, heart = 100 }
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
		local color = newVersion and { 1, 1, 1, 1 } or { 255, 255, 255, 255 }
		love.graphics.setColor(color)
	end
end

function store:keypressed(key, session)
	if key == '1' then
		if session.piggybank.total < self.prices.heart or session.lives == 3 then
			return
		end
		session.lives = session.lives + 1
		session.sound.heart:play()
		session.piggybank.total = session.piggybank.total - self.prices.heart
	elseif key == '2' then
		if session.piggybank.total < self.prices.bike then
			return
		end
		session.win = true
		session.sound.win:play()
		session.piggybank.total = session.piggybank.total - self.prices.bike
	elseif key == 'escape' or key == 'left' then
		session.sound.storeClose:play()
		self.active = false
	end
end

return store

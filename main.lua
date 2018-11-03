local player = require 'player'

function love.load()

	-- grid.load()
end

function love.update(dt)
	--
end

function love.draw()
	for x = 1, 10 do
		for y = 1, 10 do
			love.graphics.rectangle("line", x * 50, y * 50, 50, 50)
		end
	end
	player:draw()
end

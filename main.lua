local player = require 'player'
local grid = require 'grid'
-- local hud = require 'hud'

function love.load()
	grid:load(9)
	player:load()
	convert = {
		[1] = (grid.tileSize / 2) * 1,
		[2] = (grid.tileSize / 2) * 3,
		[0] = (grid.tileSize / 2) * 5
	}

	paused = false
	newStep = false
end

function love.update(dt)
	if not paused then
		grid:update(dt)
		player:update(dt)
	end
	if player.dead then
		paused = true
	end
end

function love.draw()
	grid:draw()
	x = convert[math.fmod(player.pos, grid.width)]
	y = convert[findY(player.pos)]
	player:draw({ x = x, y = y })

	drawHud()
end

function love.keypressed(key)
	if key == 'escape' or key == 'p' then
		paused = not paused
	end

	if not paused then
		local prevPos = player.pos
		player:keypressed(key)
		if not player.pos == prevPos then
			player:stepson(grid:getTile(player.pos))
 		end
	end
end

function drawHud()
	if paused then
		local text = 'opps no text :('
		if player.dead then
			text = 'yoer ded!!!'
		end

		love.graphics.rectangle('fill', 100, 100, 300, 300)
		love.graphics.setColor(0, 100, 0, 255)
		love.graphics.print(text, 150, 200)
		love.graphics.setColor(255, 255, 255, 255)
	end
end

function findY(pos)
	if pos <= grid.width then return 1 end
	if pos > #grid.tiles - grid.width then return 0 end
	return 2

end

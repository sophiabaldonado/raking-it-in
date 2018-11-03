local grid = {}

function grid:load()
	--
end

function grid: update(dt)
	--
end

function grid:draw()
	for x = 1, 10 do
		for y = 1, 10 do
			love.graphics.rectangle("line", x * 50, y * 50, 50, 50)
		end
	end
end

return grid

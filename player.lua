local player = {}

function player:load()

end

function player:update(dt)
	--
end

function player:draw(coords)
	love.graphics.circle('fill', coords.x, coords.y, 25)
end

return player

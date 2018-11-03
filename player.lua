local player = {}

function player:load()

end

function player:draw()
	love.graphics.circle('fill', 50, 50, 25)
end

return player

local grid = {}

local function generateNoiseGrid()
	-- Fill each tile in our grid with noise.
	local baseX = 10000*love.math.random()
	local baseY = 10000*love.math.random()
	for y = 1, 256 do
		grid[y] = {}
		for x = 1, 256 do
			grid[y][x] = love.math.noise(baseX+.1*x, baseY+.1*y)
		end
	end
end

function love.load()
	generateNoiseGrid()
end
function love.keypressed(key)
	if key == "escape" then love.event.quit() end
	generateNoiseGrid()
end

function love.draw()
	local tileSize = 4
	for y = 1, #grid do
		for x = 1, #grid[y] do
			love.graphics.setColor(1, 1, 1, 1)
			if grid[y][x] > 0 then
				love.graphics.setColor(grid[y][x]*1, 1, 1, grid[y][x]*1)
			else
				love.graphics.setColor(1, grid[y][x]*0, 1, grid[y][x]*0)
			end
			love.graphics.rectangle("fill", x*tileSize, y*tileSize, tileSize, tileSize)
		end
	end
end

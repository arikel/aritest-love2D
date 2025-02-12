local rnd = love.math.random


local core = require("core")
local gui = require("gui/init")
local Game = require("game")
local DungeonRenderer3 = require("dm/dungeonRenderer3")

local width = love.graphics.getWidth()
local height = love.graphics.getHeight()

local game = Game()
local dmr = DungeonRenderer3(640,400)

function love.load()
	
end

function love.update(dt)
	--game.GUI.update(dt)
	dmr.update(dt)
end

function love.draw()
	--love.graphics.draw(game.grid.canvas, cx, cy)
	dmr.draw(31,30)
	--game.GUI.draw()
end

function love.keypressed(key)
	if key == "escape" then love.event.quit() end
	if key == "a" then
		
	end
	if key == "e" then
		
	end
	if key == "space" then
		
	end
end

function love.mousepressed(x, y, button)
	game.GUI.mousepressed(x, y, button)
end

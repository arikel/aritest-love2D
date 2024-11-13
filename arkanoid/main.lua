--package.path = "../?.lua;" .. package.path
--package.path = "../?/?.lua;" .. package.path
--package.path = package.path .. ";./core/?.lua"
package.path = "../core/?.lua;" .. package.path
package.path = "../gui/?.lua;" .. package.path
local core = require("initCore")
local gui = require("initGui")
local Vec, Rect, List = core.Vec, core.Rect, core.List
print(Vec(5,20))
print(Rect(5,2))
print(List("a", "b", 12))

local rnd = math.random

function GameData()
	local self = {}
	self["padw"] = 100
	self["padh"] = 32
	self["width"] = 800
	self["height"] = 600
	return self
end

function Pad(w, h)
	local self = {}
	self.gw = 800
	self.gh = 600
	self.x = 0
	self.y = 0
	self.w = w or 96
	self.h = h or 32
	
	function self.draw()
		love.graphics.polygon("fill", {
			self.x, self.y,
			self.x + self.w, self.y,
			self.x + self.w, self.y+self.h,
			self.x, self.y + self.h
		} )
	end
	
	function self.update(dt)
		x, y = love.mouse.getPosition()
		self.x = x
		if self.x > 700 then self.x = 700 end
		self.y = self.gh - self.h
	end
	
	
	return self
end
function Ball(size)
	local self = {}
	self.size = size
	self.x = 0
	self.y = 0
	self.dx = 250
	self.dy = 150
	
	function self.draw()
		love.graphics.circle("fill", self.x, self.y, size)
	end
	
	function self.update(dt)
		self.x = self.x + self.dx * dt
		self.y = self.y + self.dy * dt
	end
	
	return self
end

function Brick(x, y, w, h)
	local self = {}
	self.w = w or 32
	self.h = h or 16
	self.x = x or 0
	self.y = y or 0
	
	self.color = {1,rnd(),rnd(),1}
	
	function self.draw()
		love.graphics.setColor(self.color)
		love.graphics.polygon("fill",
			{
			self.x, self.y,
			self.x + self.w, self.y,
			self.x + self.w, self.y + self.h,
			self.x, self.y + self.h
			}
		)
		love.graphics.setColor(1,1,1,1)
	end
	
	function self.isIn(x, y)
		if x > self.x and x < self.x + self.w and y > self.y and y< self.y + self.h then
			return true
		end
	return false
	end
	
	return self
end

function Game()
	local self = {}
	self.gameData = GameData()
	success = love.window.setMode(self.gameData["width"], self.gameData["height"], {})
	
	self.pad = Pad(self.gameData.padw, self.gameData.padh)
	
	self.ball = Ball(8)
	
	self.bricks = {}
	
	self.brickList = {}
	for j = 0,12 do
		for i = 0, 8 do
			local b = Brick(i*66,j*33,64,32)
			table.insert(self.brickList, b)
		end
	end
	
	function self.update(dt)
		if self.ball.x < 0 then
			self.ball.dx = - self.ball.dx
		end
		if self.ball.y < 0 then
			self.ball.dy = - self.ball.dy
		end
		if self.ball.x > self.gameData["width"] then
			self.ball.dx = - self.ball.dx
		end
		if self.ball.y > self.gameData["height"] then
			self.ball.dy = - self.ball.dy
		end
		
		self.ball.update(dt)
		self.pad.update(dt)
		
	end
	
	return self
end

g = Game()

function clamp(x, y, t)
	return math.max(math.min(y, t),x)
end


function love.update(dt)
	x, y = love.mouse.getPosition()
	g.update(dt)
	for i, v in pairs(g.brickList) do
		if v.isIn(g.ball.x, g.ball.y) then
			v.color = {0,0,0,0}
		end
	end
end

function love.draw()
	g.pad.draw()
	
	g.ball.draw()
	for i, v in ipairs(g.brickList) do
		v.draw()
	end
	love.graphics.print("Hello World!", 380, 300)
end

function love.mousepressed( x, y, button, istouch, presses )
	if button == 1 then
		print("Mouse clicked")
		g.ball.dx = rnd() * 250 + 125
		g.ball.dy = rnd() * 250 + 125
	end
	
	if button == 2 then
		g.ball.dx = 0
		g.ball.dy = 0
	end
end

function love.keypressed(key)
	if key == "escape" then love.event.quit() end
end


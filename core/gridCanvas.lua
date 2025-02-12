local GridModule = require("core/gridModule")
local rnd = love.math.random

local function GridCanvas(x, y, tw, th, theme)
	
	local self = GridModule(x, y)
	self.tw = tw
	self.th = th
	self.x = x or 0
	self.y = y or 0
	
	self.canvas = love.graphics.newCanvas(x*tw, y*th)
	
	self.rndCanvas = function()
		love.graphics.setCanvas(self.canvas)
		for i = 0,x do
			for j = 0,y do
				--love.math.setRandomSeed(rnd(1,10000))
				local a = rnd()
				--love.math.setRandomSeed(2)
				local b = rnd()
				--love.math.setRandomSeed(3)
				local c = rnd()
				love.graphics.setColor(a,b,c)
				
				love.graphics.polygon("fill", i*tw,j*th, (i+1)*tw-1,j*th ,(i+1)*tw-1, (j+1)*th-1, i*tw,(j+1)*th-1)
				
				love.graphics.setColor(1,1,1)
				
			end
		end
		--print("GridCanvas created, ", x, y)
		love.graphics.setCanvas()
	end
	
	self.rndCanvas()
	
	love.graphics.setCanvas()
	
		
	self.isIn = function(x, y)
		return x>=0 and y < self.x and y >= 0 and y < self.y
	end
	
	
	return self
	
end

return GridCanvas

local core = require("core")
local Vec = core.Vec
local Vec3 = core.Vec3

local function DungeonRenderer3(w, h)
	local self = {}
	
	self.w = w
	self.h = h
	self.canvas = love.graphics.newCanvas(self.w, self.h)
	
	self.VP = Vec(self.w / 2, self.h / 2)
	self.scale = Vec(1,1)
	
	-- eye to picture plane
	self.dist = 50
	
	function self.drawCanvasLine(...)
		--love.graphics.setLineStyle("smooth")
		love.graphics.setLineWidth(2)
		
		-- docs won't tell you this simple trick
		-- local arg = {...}
		
		local V = {}
		for i, v in ipairs({...}) do
			table.insert(V, v.x)
			table.insert(V, v.y)
		end

		love.graphics.line(V)
	end
	
	self.draw = function(x, y)
		love.graphics.setCanvas(self.canvas)
		love.graphics.clear()
		local A = Vec(0,0)
		local B = Vec(self.w, 0)
		local C = Vec(self.w, self.h)
		local D = Vec(0, self.h)
		self.drawCanvasLine(A,B, C, D, A, C, B, D)
		
		v1 = {50,50,0,0,1,0,0,1}
		v2 = {350,50,0,0,1,0,0,1}
		v3 = {350,250,0,0,1,1,0,1}
		v4 = {50,250,0,0,1,0,1,0}
		local mesh = love.graphics.newMesh({v1,v2,v3,v4})
		love.graphics.draw(mesh)
		
		love.graphics.setCanvas()
		
		love.graphics.draw(self.canvas, x, y)
		
	end
	
	self.update = function(dt)
		
	end
	
	return self
end

return DungeonRenderer3

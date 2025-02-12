local core = require("core")
local Vec = core.Vec
local Vec3 = core.Vec3

local function DungeonRenderer(w, h)
	local self = {}
	
	self.w = w
	self.h = h
	
	self.VP = Vec(self.w / 2, self.h / 2)
	self.scale = Vec(1,1)
	self.dist = 50
	self.canvas = love.graphics.newCanvas(self.w, self.h)
	
	
	local scalex = self.w / 2
	local scaley = self.h / 2
	
	self.localToCanvas = function(v)
		return Vec(v.x + self.w /2, - v.y + self.h / 2)
	end
	
	self.drawLine = function(v1, v2)
		love.graphics.line(v1.x, v1.y, v2.x, v2.y)
	end
	
	self.drawQuad = function(v1, v2, v3, v4)
		self.drawLine(v1, v2)
		self.drawLine(v2, v3)
		self.drawLine(v3, v4)
		self.drawLine(v4, v1)
	end
	
	-- v.x, v.y, z are the 3D coords. d is the distance from eye to picture plane
	self.convert3to2 = function(v, z, d)
		local x2 = v.x * d / z
		local y2 = v.y * d / z
		return Vec(x2, y2)
	end
	
	self.convert2toCanvas = function(v)
		--return Vec(v.x + self.w /2, -v.y + self.h / 2)
		return v + self.VP
	end
	
	self.convert3toCanvas = function(v, z, d)
		return self.convert2toCanvas(self.convert3to2(v, z, d))
	end
	
	self.drawCanvasQuad = function()
		love.graphics.setColor(1,0,0)
		local v1, v2, v3, v4 = Vec(0,0), Vec(self.w, 0), Vec(self.w, self.h), Vec(0, self.h)
		self.drawQuad(v1, v2, v3, v4)
		self.drawLine(v1,v3)
		self.drawLine(v2,v4)
	end
	
	self.drawPerspLines = function()
		love.graphics.setColor(0,0,1)
		for i = 0, 16 do
			
			i = i * 2 * math.pi / 16
			local v1 = Vec(0,0)
			local v2 = Vec(math.cos(i) * scalex, math.sin(i) * scaley)
			self.drawLine(self.convert2toCanvas(v1), self.convert2toCanvas(v2))
		end
	end
	
	--[[
	self.drawEllipseCanvas = function()
		love.graphics.setColor(0,1,0)
		local dec = 0.1
		for i = 0 , 2* math.pi, dec do
			--i = i*15
			i = i * 2 * math.pi / 6
			local v1 = Vec(math.cos(i)* scalex, math.sin(i)* scaley)
			local v2 = Vec(math.cos(i+dec)* scalex, math.sin(i+dec)* scaley)
			v1 = self.convert2toCanvas(v1)
			v2 = self.convert2toCanvas(v2)
			self.drawLine(v1, v2)
		end
	end
	
	self.drawSpiral = function()
		love.graphics.setColor(1,1,0)
		local dec = 0.1
		for i = 0,180, dec do
			local v1 = Vec(math.cos(i),math.sin(i))
			local v2 = Vec(math.cos(i+dec), math.sin(i+dec))
			local z = 10
			local d = self.dist * i
			v2 = v2.rotate(dec)
			local v1 = self.convert3to2(v1, z, d)
			local v2 = self.convert3to2(v2, z, d)
			
			v1 = self.convert2toCanvas(v1)
			v2 = self.convert2toCanvas(v2)
			self.drawLine(v1, v2)
		end
	end
	]]--
	
	
	self.drawFace = function(x, y, w, h, z)
		love.graphics.setColor(0,1,0)
		local v1 = self.convert3toCanvas(Vec(x, y), z, self.dist)
		local v2 = self.convert3toCanvas(Vec(x+w, y), z, self.dist)
		local v3 = self.convert3toCanvas(Vec(x+w, y+h), z, self.dist)
		local v4 = self.convert3toCanvas(Vec(x, y+h), z, self.dist)
		self.drawQuad(v1, v2, v3, v4)
		
	end
	
	self.drawHDalle = function (x, y, z)
		love.graphics.setColor(0,1,0)
		local v1 = self.convert3to2(Vec(x, y), z, self.dist)
		local v2 = self.convert3to2(Vec(x+10, y), z, self.dist)
		local v3 = self.convert3to2(Vec(x+10, y), z+10, self.dist)
		local v4 = self.convert3to2(Vec(x, y), z+10, self.dist)
		v1 = self.convert2toCanvas(v1)
		v2 = self.convert2toCanvas(v2)
		v3 = self.convert2toCanvas(v3)
		v4 = self.convert2toCanvas(v4)
		--self.drawLine(v1, v2)
		self.drawQuad(v1, v2, v3, v4)
		love.graphics.setColor(1,1,1)
	end
	
	
	self.draw = function(x, y)
		love.graphics.setCanvas(self.canvas)
		love.graphics.clear()
		
		-- ellipse matching the canvas
		--self.drawEllipseCanvas()
		
		-- glorious spiral
		--self.drawSpiral()
		
		--just a canvas quad
		self.drawCanvasQuad()
		
		-- lines from vanishing point in a circle
		self.drawPerspLines()
		
		
		love.graphics.setColor(0,1,0)
		
		local dx = self.w / self.h
		
		for i = 0, 10 do
			for j = 0, 10 do
				for k = 0, 10 do
					local v1 = Vec3(i, j, k)
					local v2 = Vec3(i+1, j, k)
					self.drawLine(v1, v2)
				end
			end
		end
		
		love.graphics.setColor(1,0,0)
		
		
		love.graphics.setColor(1,1,1)
		love.graphics.setCanvas()
		
		love.graphics.draw(self.canvas, x, y)
		
	end
	
	self.update = function(dt)
		--self.updateCanvas()
	end
	
	return self
end

return DungeonRenderer

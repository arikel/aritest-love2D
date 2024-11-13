local VecMT = {}
local Vec

VecMT.__index = VecMT
function VecMT:__add(other)
	return Vec(self.x + other.x, self.y + other.y)
end

function VecMT:__mul(other)
	if type(other) == "number" then
		return Vec(self.x * other, self.y * other)
	elseif type(self) == "number" then
		return Vec(self * other.x, self * other.y)
	else
		return Vec(self.x * other.x, self.y * other.y)
	end
end

function VecMT:__sub(other)
	return Vec(self.x - other.x, self.y - other.y)
end

function VecMT:__div(other)
	return Vec(self.x / other, self.y / other)
end

function VecMT:__eq(other)
	return self.x == other.x and self.y == other.y
end

function VecMT:__tostring()
	return "Vec(" .. self.x .. ", " .. self.y .. ")"
end

function VecMT:__concat(other)
	return tostring(self) .. tostring(other)
end

function Vec(x, y)
	local self = {}
	setmetatable(self, VecMT)
	
	self.type = "Vec"
	
	self.set = function(x, y)
		self.x = x
		self.y = y
	end
	
	self.setPos = function(x, y)
		self.set(x, y)
	end
	
	self.len = function()
		return math.sqrt(self.x * self.x + self.y * self.y)
	end
	self.length = self.len
	
	self.normalize = function(n)
		local n = n or 1
		local len = self.len()
		if len > 0 then
			self.set(n*self.x/len, n*self.y/len)
		end
	end
	
	self.cross = function(other)
		return self.x * other.y - self.y * other.x
	end
	
	self.dot = function(other)
		return self.x * other.x  + self.y * other.y
	end
	
	self.getAngle = function()
		local angle = math.atan(self.y/self.x)
		if self.x < 0 then
			angle = angle + math.pi
		end
		return angle
	end
	
	self.rotate = function(angle)
		local s = math.sin(angle)
		local c = math.cos(angle)
		local x2 = self.x * c - self.y * s
		local y2 = self.x * s + self.y * c
		self.set(x2, y2)
	end
	
	local x = x or 0
	local y = y or 0
	self.set(x, y)
	
	return self
end




return Vec

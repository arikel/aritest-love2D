local Vec3MT = {}
local Vec3

Vec3MT.__index = Vec3MT

function Vec3MT:__add(other)
	return Vec3(self.x + other.x, self.y + other.y, self.z+other.z)
end

function Vec3MT:__mul(other)
	if type(other) == "number" then
		return Vec3(self.x * other, self.y * other, self.z * other)
	elseif type(self) == "number" then
		return Vec3(self * other.x, self * other.y, self * other.z)
	else
		return Vec3(self.x * other.x, self.y * other.y, self.z * other.z)
	end
end

function Vec3MT:__sub(other)
	return Vec3(self.x - other.x, self.y - other.y, self.z - other.z)
end

function Vec3MT:__div(other)
	return Vec3(self.x / other, self.y / other, self.z / other)
end

function Vec3MT:__eq(other)
	return self.x == other.x and self.y == other.y and self.z == other.z
end

function Vec3MT:__tostring()
	return "Vec3(" .. self.x .. ", " .. self.y .. ", " .. self.z .. ")"
end

function Vec3MT:__concat(other)
	return tostring(self) .. tostring(other)
end


function Vec3MT:type()
	return "core.Vec3"
end



function Vec3(x, y, z)
	local self = {}
	setmetatable(self, Vec3MT)
	
	self.set = function(x, y, z)
		self.x = x
		self.y = y
		self.z = z
	end
	
	self.setPos = function(x, y, z)
		self.set(x, y, z)
	end
	
	self.len = function()
		return math.sqrt(self.x * self.x + self.y * self.y + self.z * self.z)
	end
	self.length = self.len
	
	self.normalize = function(n)
		local n = n or 1
		local len = self.len()
		if len > 0 then
			self.set(n*self.x/len, n*self.y/len, n*self.z/len)
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
		--self.set(x2, y2)
		return Vec(x2, y2)
	end
	
	local x = x or 0
	local y = y or 0
	local z = z or 0
	
	self.set(x, y, z)
	
	return self
end

return Vec3

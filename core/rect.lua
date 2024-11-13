local function Rect(x, y, w, h)
	local self = {}
	setmetatable(self, self)
	-- default values
	self.x = x or 0
	self.y = y or 0
	self.w = w or 16
	self.h = h or 16
	
	self.x2 = self.x + self.w
	self.y2 = self.y + self.h
	
	self.setPos = function(x, y)
		self.x = x
		self.y = y
		self.x2 = self.x + self.w
		self.y2 = self.y + self.h
	end
	
	self.getPos = function()
		return self.x, self.y
	end
	
	self.setSize = function(w, h)
		self.w = w
		self.h = h
		self.x2 = self.x + self.w
		self.y2 = self.y + self.h
	end
	
	self.getSize = function()
		return self.w, self.h
	end
	
	self.tostring = function()
		return "Rect(" .. self.x .. ", " .. self.y .. ", " .. self.w .. ", " .. self.h .. ")"
	end
	
	self.__tostring = function()
		return self.tostring()
	end
	
	self.__concat = function(self, other)
		return tostring(self) .. tostring(other)
	end
	
	self.collidePoint = function(x,  y)
		return (x >= self.x) and (x < self.x2) and (y >= self.y) and (y < self.y2)
	end
	
	self.collideRect = function(r)
		return self.x < r.x2 and r.x < self.x2 and self.y < r.y2 and r.y < self.y2
	end
	
	return self
end

return Rect

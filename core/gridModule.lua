------------------------------------------------------------------------
-- GridMT
------------------------------------------------------------------------

local GridMT = {}
GridMT.__index = GridMT

function GridMT:isIn(x, y)
	return 1<=x and x <=self.w and 1<=y and y<= self.h
end

function GridMT:getTile(x, y)
	if not self:isIn(x, y) then
		return nil
	end
	return self.tiles[x][y]
end

function GridMT:__call(x, y)
	return self:getTile(x, y)
end

function GridMT:setTile(x, y, n)
	if self:isIn(x, y) then
		self.tiles[x][y] = n
	end
end

function GridMT:setSize(w, h)
	self.w = w or 10
	self.h = h or 10
	self.tiles = {}
	for i = 1, self.w do
		table.insert(self.tiles, {})
		for j = 1, self.h do
			table.insert(self.tiles[i], self.default)
		end
	end
end
	

	
function GridMT:fill(tile)
	for i =1, self.w do
		for j  = 1, self.h do
			self:setTile(i, j, tile)
		end
	end
end
	
function GridMT:expandLeft(n)
	for i = 1, n do
		local newCol = {}
		for j =1, self.h do
			table.insert(newCol, self.default)
		end
		table.insert(self.tiles, 1, newCol)
	end
	self.w = self.w + n
end

function GridMT:expandRight(n)
	for i = 1, n do
		local newCol = {}
		for j =1, self.h do
			table.insert(newCol, self.default)
		end
		table.insert(self.tiles, newCol)
	end
	self.w = self.w + n
end
	
function GridMT:expandUp(n)
	for i = 1, n do
		for j =1, self.w do
			table.insert(self.tiles[j], 1, self.default)
		end
	end
	self.h = self.h + n
end
	
function GridMT:expandDown(n)
	for i = 1, n do
		for j =1, self.w do
			table.insert(self.tiles[j], self.default)
		end
	end
	self.h = self.h + n
end

function GridMT:reduceLeft(n)
	for i = 1, n do
		table.remove(self.tiles, 1)
	end
	self.w = self.w - n
end

function GridMT:reduceRight(n)
	for i = 1, n do
		table.remove(self.tiles)
	end
	self.w = self.w - n
end

function GridMT:reduceUp(n)
	for i = 1, self.w do
		for j = 1, n do
			table.remove(self.tiles[i], 1)
		end
	end
	self.h = self.h - n
end

function GridMT:reduceDown(n)
	for i = 1, self.w do
		for j = 1, n do
			table.remove(self.tiles[i])
		end
	end
	self.h = self.h - n
end

function GridMT:__tostring()
	return "Grid : (" ..  self.w .. ", " .. self.h .. ")"
end

function GridMT:aff()
	local res = ""
	for i = 1, self.h do
		for j = 1, self.w do
			res = res .. self:getTile(j, i)
		end
		res = res .. "\n"
	end
	print(res)
end

------------------------------------------------------------------------
-- Grid
------------------------------------------------------------------------

local function Grid(w, h, default)
	local self = {}
	self.default = default or 0
	setmetatable(self, GridMT)
	self:setSize(w, h)
	return self
end

return Grid

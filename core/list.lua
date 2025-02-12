local List_MT = {}
List_MT.__index = List_MT

function List_MT:append(item)
	table.insert(self, item)
end


function List_MT:iter()
	local i = 0
	return function()
		i = i+1
		if self[i] then
			return self[i]
		end
	end
end

function List_MT:extend(liste)
	for item in liste:iter() do
		self:append(item)
	end
end

function List_MT:pop(n)
	local r = self[n]
	table.remove(self, n)
	return r
end

function List_MT:remove(item)
	for index, val in ipairs(self) do
		if val == item then
			self:pop(index)
			break
		end
	end
end

function List_MT:len()
	return table.getn(self)
end

function List_MT:__tostring()
	local first = true
	local s = "List {"
	for item in self:iter() do
		if first then
			s = s .. tostring(item)
			first = false
		else
			s = s .. ", " .. tostring(item)
		end
	end
	s = s .. "}"
	return s
end

function List_MT:enumerate()
	local i = 0
	return function()
		i = i+1
		if self[i] then
			return i, self[i]
		end
	end
end

function List_MT:has(item)
	for i in self:iter() do
		if i == item then
			return true
		end
	end
	return false
end


function List_MT:index(item)
	for i, it in self:enumerate() do
		if it == item then return i end
	end
	return nil
end

local function List(...)
	local self = {}
	setmetatable(self, List_MT)
	--------------------------------------------------------------------
	-- constructor can get default values
	for i, item in ipairs({...}) do
		self:append(item)
	end
	
	return self
end

return List


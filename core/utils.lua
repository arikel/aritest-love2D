------------------------------------------------------------------------
-- string manipulation

local function strip(s)
	first = string.sub(s, 1, 1)
	last = string.sub(s, -1)
	if first == " " then
		return strip(string.sub(s, 2, string.len(s) - 1))
	elseif last == " " then
		return strip(string.sub(s, 1, string.len(s) - 1))
	else
		return s
	end
end

local function splitLines(s)
	local lines = string.gmatch(s, "[^\r\n]+")
	local result = {}
	for i in lines do
		table.insert(result, i)
	end
	return result
end

local function splitInTwo(s, p)
	i, j = string.find(s, p)
	if i then
		left = string.sub(s, 1, i-1)
		right = string.sub(s, i+string.len(p), -1)
		--if left and right then return left, right end
		return left, right
	else
		return s
	end
end

local function split(s, p)
	local result = {}
	local rep = true
	while(rep) do
		i, j = splitInTwo(s, p)
		if j then
			table.insert(result, i)
			s = j
		else
			if i then
				table.insert(result, i)
			end
			rep = false
		end
	end
	return result
end



------------------------------------------------------------------------
local function range(n)
	local i = 0
	local limit = n or 1
	return function()
		i = i+1
		if i <=limit then
			return i
		end
	end
end

math.randomseed(os.time())
function getRandInt(a, b)
	return math.random(a, b)
end

------------------------------------------------------------------------
-- tables

local function iterVal(tab)
	local i = 0
	return function()
		i = i+1
		if tab[i] then return tab[i] end
	end
end

local function countTab(t)
	local res = 0
	local i, v
	for i, v in pairs(t) do
		res = res + 1
	end
	return res
end

local function getIndex(tab, val)
	for i, v in ipairs(tab) do
		if v == val then return i end
	end
end

local function findNextId(tab)
	local i = 1
	while true do
		local res = tab[i]
		if res then
			i = i+1
		else
			return i
		end
	end
end



------------------------------------------------------------------------
local function reload(m)
	package.loaded[m] = nil
	return require(m)
end

local function doString(s)
	loadstring(s)()
end

------------------------------------------------------------------------

local Utils = {}

Utils.strip = strip
Utils.splitLines = splitLines
Utils.splitInTwo = splitInTwo
Utils.split = split

Utils.range = range
Utils.getRandInt = getRandInt

Utils.iterVal = iterVal
Utils.countTab = countTab
Utils.getIndex = getIndex
Utils.findNextId = findNextId


Utils.reload = reload
Utils.doString = doString

return Utils


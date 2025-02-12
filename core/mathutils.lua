local Vec = require "vec"

local function intersectLines(A, B, C, D)
	-- if first line is vertical
	if A.x == B.x then
		-- second line vertical too
		if C.x == D.x then
			return nil
		-- only first line is vertical
		else
			local aCD = (C.y - D.y) / (C.x - D.x)
			local bCD = C.y - aCD*C.x
			return Vec(A.x, aCD*A.x + bCD)
		end
	
	-- if second line only is vertical
	elseif C.x == D.x then
		local aAB = (A.y - B.y) / (A.x - B.x)
		local bAB = A.y - aAB*A.x
		return  Vec(C.x, aAB*C.x + bAB)
	end
	
	-- if no vertical line involved
	local aAB = (A.y - B.y) / (A.x - B.x)
	local bAB = A.y - aAB*A.x
	
	local aCD = (C.y - D.y) / (C.x - D.x)
	local bCD = C.y - aCD*C.x
	
	-- if parallel lines
	if aAB == aCD then return nil end
	
	-- finally, the general case
	local Px = (bCD-bAB) / (aAB-aCD)
	local Py = aAB * Px + bAB
	return Vec(Px, Py)
end

local function getAngleBetween(A, B)
	return A.getAngle() - B.getAngle()
end

local function getVecDirection(v)
	local direction
	if v.x > 0 then
		if v.y > 0 then
			direction = "downright"
		elseif v.y <0 then
			direction = "upright"
		else -- v.y == 0
			direction = "right"
		end
	elseif v.x < 0 then
		if v.y > 0 then
			direction = "downleft"
		elseif v.y <0 then
			direction = "upleft"
		else -- v.y == 0
			direction = "left"
		end
	else -- v.x == 0
		if v.y > 0 then
			direction = "down"
		elseif v.y <0 then
			direction = "up"
		else -- v.y == 0
			direction = "none"
		end
	end
	return direction
end




local function CrossTilesDownRight(A, B)
	local A = A
	local B = B
	local v = B - A
	-- direction == downright
	local startTile = Vec(math.floor(A.x), math.floor(A.y))
	local endTile = Vec(math.floor(B.x), math.floor(B.y))
	-- currentTile
	local ct = Vec(math.floor(A.x), math.floor(A.y))
	-- currentPoint
	local cPt = Vec(A.x, A.y)
	
	local nb = math.abs(startTile.x - endTile.x) + math.abs(startTile.y - endTile.y)
	
	local top = {Vec(ct.x, ct.y), Vec(ct.x+1, ct.y)}
	local bottom = {Vec(ct.x, ct.y+1), Vec(ct.x+1, ct.y+1)}
	local left = {Vec(ct.x, ct.y), Vec(ct.x, ct.y+1)}
	local right = {Vec(ct.x+1, ct.y), Vec(ct.x+1, ct.y+1)}
	local ptList = {}
	
	local nextH = bottom
	local nextV = right
	local i = 0
	while(i < nb) do
		local p1 = intersectLines(A, B, nextH[1], nextH[2])
		local p2 = intersectLines(A, B, nextV[1], nextV[2])
		local d1 = (p1-A).len()
		local d2 = (p2-A).len()
		if d1 > d2 then -- we crossed a vertical line
			table.insert(ptList, p2)
			nextV[1].x = nextV[1].x + 1
			nextV[2].x = nextV[2].x + 1
			i = i+1
		elseif d1 < d2 then-- we crossed a horizontal line
			table.insert(ptList, p1)
			nextH[1].y = nextH[1].y + 1
			nextH[2].y = nextH[2].y + 1
			i = i+1
		else -- we crossed a corner
			nextV[1].x = nextV[1].x + 1
			nextV[2].x = nextV[2].x + 1
			nextH[1].y = nextH[1].y + 1
			nextH[2].y = nextH[2].y + 1
			table.insert(ptList, p1)
			i = i+2
		end
	end
	return ptList
end

local function CrossTilesDownLeft(A, B)
	local A = A
	local B = B
	local v = B - A
	-- direction == downleft
	local startTile = Vec(math.floor(A.x), math.floor(A.y))
	local endTile = Vec(math.floor(B.x), math.floor(B.y))
	-- currentTile
	local ct = Vec(math.floor(A.x), math.floor(A.y))
	-- currentPoint
	local cPt = Vec(A.x, A.y)
	
	local nb = math.abs(startTile.x - endTile.x) + math.abs(startTile.y - endTile.y)
	
	local top = {Vec(ct.x, ct.y), Vec(ct.x+1, ct.y)}
	local bottom = {Vec(ct.x, ct.y+1), Vec(ct.x+1, ct.y+1)}
	local left = {Vec(ct.x, ct.y), Vec(ct.x, ct.y+1)}
	local right = {Vec(ct.x+1, ct.y), Vec(ct.x+1, ct.y+1)}
	
	if A.x == startTile.x then -- if point on a vertical line
		left[1].x = left[1].x - 1
		left[2].x = left[2].x - 1
		nb = nb - 1
	end
	
	local ptList = {}
	
	local nextH = bottom
	local nextV = left
	local i = 0
	while(i < nb) do
		local p1 = intersectLines(A, B, nextH[1], nextH[2])
		local p2 = intersectLines(A, B, nextV[1], nextV[2])
		local d1 = (p1-A).len()
		local d2 = (p2-A).len()
		if d1 > d2 then -- we crossed a vertical line
			table.insert(ptList, p2)
			nextV[1].x = nextV[1].x - 1
			nextV[2].x = nextV[2].x - 1
			i = i+1
		elseif d1 < d2 then-- we crossed a horizontal line
			table.insert(ptList, p1)
			nextH[1].y = nextH[1].y + 1
			nextH[2].y = nextH[2].y + 1
			i = i+1
		else -- we crossed a corner
			nextV[1].x = nextV[1].x - 1
			nextV[2].x = nextV[2].x - 1
			nextH[1].y = nextH[1].y + 1
			nextH[2].y = nextH[2].y + 1
			table.insert(ptList, p1)
			i = i+2
		end
	end
	return ptList
end

local function CrossTilesDown(A, B)
	local A = A
	local B = B
	local v = B - A
	-- direction == down
	local startTile = Vec(math.floor(A.x), math.floor(A.y))
	local endTile = Vec(math.floor(B.x), math.floor(B.y))
	-- currentTile
	local ct = Vec(math.floor(A.x), math.floor(A.y))
	-- currentPoint
	local cPt = Vec(A.x, A.y)
	
	local nb = math.abs(startTile.x - endTile.x) + math.abs(startTile.y - endTile.y)
	
	local top = {Vec(ct.x, ct.y), Vec(ct.x+1, ct.y)}
	local bottom = {Vec(ct.x, ct.y+1), Vec(ct.x+1, ct.y+1)}
	local left = {Vec(ct.x, ct.y), Vec(ct.x, ct.y+1)}
	local right = {Vec(ct.x+1, ct.y), Vec(ct.x+1, ct.y+1)}
	
	local ptList = {}
	
	local nextH = bottom
	local i = 0
	while(i < nb) do
		local p1 = intersectLines(A, B, nextH[1], nextH[2])
		local d1 = (p1-A).len()
		table.insert(ptList, p1)
		nextH[1].y = nextH[1].y + 1
		nextH[2].y = nextH[2].y + 1
		i = i+1
	end
	return ptList
end

local function CrossTilesUpRight(A, B)
	local A = A
	local B = B
	local v = B - A
	-- direction == upright
	local startTile = Vec(math.floor(A.x), math.floor(A.y))
	local endTile = Vec(math.floor(B.x), math.floor(B.y))
	-- currentTile
	local ct = Vec(math.floor(A.x), math.floor(A.y))
	-- currentPoint
	local cPt = Vec(A.x, A.y)
	
	local nb = math.abs(startTile.x - endTile.x) + math.abs(startTile.y - endTile.y)
	
	local top = {Vec(ct.x, ct.y), Vec(ct.x+1, ct.y)}
	local bottom = {Vec(ct.x, ct.y+1), Vec(ct.x+1, ct.y+1)}
	local left = {Vec(ct.x, ct.y), Vec(ct.x, ct.y+1)}
	local right = {Vec(ct.x+1, ct.y), Vec(ct.x+1, ct.y+1)}
	
	if A.y == startTile.y then -- if point on a horizontal line
		top[1].y = top[1].y - 1
		top[2].y = top[2].y - 1
		nb = nb - 1
	end
	
	local ptList = {}
	
	local nextH = top
	local nextV = right
	local i = 0
	while(i < nb) do
		local p1 = intersectLines(A, B, nextH[1], nextH[2])
		local p2 = intersectLines(A, B, nextV[1], nextV[2])
		local d1 = (p1-A).len()
		local d2 = (p2-A).len()
		if d1 > d2 then -- we crossed a vertical line
			table.insert(ptList, p2)
			nextV[1].x = nextV[1].x + 1
			nextV[2].x = nextV[2].x + 1
			i = i+1
		elseif d1 < d2 then-- we crossed a horizontal line
			table.insert(ptList, p1)
			nextH[1].y = nextH[1].y - 1
			nextH[2].y = nextH[2].y - 1
			i = i+1
		else -- we crossed a corner
			nextV[1].x = nextV[1].x + 1
			nextV[2].x = nextV[2].x + 1
			nextH[1].y = nextH[1].y - 1
			nextH[2].y = nextH[2].y - 1
			table.insert(ptList, p1)
			i = i+2
		end
	end
	return ptList
end

local function CrossTilesUpLeft(A, B)
	local A = A
	local B = B
	local v = B - A
	-- direction == upleft
	local startTile = Vec(math.floor(A.x), math.floor(A.y))
	local endTile = Vec(math.floor(B.x), math.floor(B.y))
	-- currentTile
	local ct = Vec(math.floor(A.x), math.floor(A.y))
	-- currentPoint
	local cPt = Vec(A.x, A.y)
	
	local nb = math.abs(startTile.x - endTile.x) + math.abs(startTile.y - endTile.y)
	
	local top = {Vec(ct.x, ct.y), Vec(ct.x+1, ct.y)}
	local bottom = {Vec(ct.x, ct.y+1), Vec(ct.x+1, ct.y+1)}
	local left = {Vec(ct.x, ct.y), Vec(ct.x, ct.y+1)}
	local right = {Vec(ct.x+1, ct.y), Vec(ct.x+1, ct.y+1)}
	
	if A.y == startTile.y then -- if point on a horizontal line
		top[1].y = top[1].y - 1
		top[2].y = top[2].y - 1
		nb = nb - 1
	end
	
	if A.x == startTile.x then
		left[1].x = left[1].x - 1
		left[2].x = left[2].x - 1
		nb = nb - 1
	end
	
	local ptList = {}
	
	local nextH = top
	local nextV = left
	local i = 0
	
	while(i < nb) do
		local p1 = intersectLines(A, B, nextH[1], nextH[2])
		local p2 = intersectLines(A, B, nextV[1], nextV[2])
		local d1 = (p1-A).len()
		local d2 = (p2-A).len()
		if d1 > d2 then -- we crossed a vertical line
			table.insert(ptList, p2)
			nextV[1].x = nextV[1].x - 1
			nextV[2].x = nextV[2].x - 1
			i = i+1
		elseif d1 < d2 then-- we crossed a horizontal line
			table.insert(ptList, p1)
			nextH[1].y = nextH[1].y - 1
			nextH[2].y = nextH[2].y - 1
			i = i+1
		else -- we crossed a corner
			nextV[1].x = nextV[1].x - 1
			nextV[2].x = nextV[2].x - 1
			nextH[1].y = nextH[1].y - 1
			nextH[2].y = nextH[2].y - 1
			table.insert(ptList, p1)
			i = i+2
		end
	end
	return ptList
end

local function CrossTilesUp(A, B)
	local A = A
	local B = B
	local v = B - A
	-- direction == up
	local startTile = Vec(math.floor(A.x), math.floor(A.y))
	local endTile = Vec(math.floor(B.x), math.floor(B.y))
	-- currentTile
	local ct = Vec(math.floor(A.x), math.floor(A.y))
	-- currentPoint
	local cPt = Vec(A.x, A.y)
	
	local nb = math.abs(startTile.x - endTile.x) + math.abs(startTile.y - endTile.y)
	
	local top = {Vec(ct.x, ct.y), Vec(ct.x+1, ct.y)}
	local bottom = {Vec(ct.x, ct.y+1), Vec(ct.x+1, ct.y+1)}
	local left = {Vec(ct.x, ct.y), Vec(ct.x, ct.y+1)}
	local right = {Vec(ct.x+1, ct.y), Vec(ct.x+1, ct.y+1)}
	
	
	local ptList = {}
	
	local nextH = top
	
	local i = 0
	if A.y == startTile.y then
		top[1].y = top[1].y - 1
		top[2].y = top[2].y - 1
		i = i+1
	end
	
	
	while(i < nb) do
		local p1 = intersectLines(A, B, nextH[1], nextH[2])
		local d1 = (p1-A).len()
		table.insert(ptList, p1)
		nextH[1].y = nextH[1].y - 1
		nextH[2].y = nextH[2].y - 1
		i = i+1
	end
	return ptList
end

local function CrossTilesLeft(A, B)
	local A = A
	local B = B
	local v = B - A
	-- direction == left
	local startTile = Vec(math.floor(A.x), math.floor(A.y))
	local endTile = Vec(math.floor(B.x), math.floor(B.y))
	-- currentTile
	local ct = Vec(math.floor(A.x), math.floor(A.y))
	-- currentPoint
	local cPt = Vec(A.x, A.y)
	
	local nb = math.abs(startTile.x - endTile.x) + math.abs(startTile.y - endTile.y)
	
	local top = {Vec(ct.x, ct.y), Vec(ct.x+1, ct.y)}
	local bottom = {Vec(ct.x, ct.y+1), Vec(ct.x+1, ct.y+1)}
	local left = {Vec(ct.x, ct.y), Vec(ct.x, ct.y+1)}
	local right = {Vec(ct.x+1, ct.y), Vec(ct.x+1, ct.y+1)}
	
	
	local ptList = {}
	
	local nextV = left
	
	local i = 0
	if A.x == startTile.x then
		left[1].x = left[1].x - 1
		left[2].x = left[2].x - 1
		i = i+1
	end
	
	
	while(i < nb) do
		local p1 = intersectLines(A, B, nextV[1], nextV[2])
		local d1 = (p1-A).len()
		table.insert(ptList, p1)
		nextV[1].x = nextV[1].x - 1
		nextV[2].x = nextV[2].x - 1
		i = i+1
	end
	return ptList
end


local function CrossTilesRight(A, B)
	local A = A
	local B = B
	local v = B - A
	-- direction == left
	local startTile = Vec(math.floor(A.x), math.floor(A.y))
	local endTile = Vec(math.floor(B.x), math.floor(B.y))
	-- currentTile
	local ct = Vec(math.floor(A.x), math.floor(A.y))
	-- currentPoint
	local cPt = Vec(A.x, A.y)
	
	local nb = math.abs(startTile.x - endTile.x) + math.abs(startTile.y - endTile.y)
	
	local top = {Vec(ct.x, ct.y), Vec(ct.x+1, ct.y)}
	local bottom = {Vec(ct.x, ct.y+1), Vec(ct.x+1, ct.y+1)}
	local left = {Vec(ct.x, ct.y), Vec(ct.x, ct.y+1)}
	local right = {Vec(ct.x+1, ct.y), Vec(ct.x+1, ct.y+1)}
	
	
	local ptList = {}
	
	local nextV = right
	
	local i = 0
	
	while(i < nb) do
		local p1 = intersectLines(A, B, nextV[1], nextV[2])
		local d1 = (p1-A).len()
		table.insert(ptList, p1)
		nextV[1].x = nextV[1].x + 1
		nextV[2].x = nextV[2].x + 1
		i = i+1
	end
	return ptList
end

local function CrossTiles(A, B)
	local A = A
	local B = B
	local v = B - A
	local direction = getVecDirection(v)
	if direction == "downright" then
		return CrossTilesDownRight(A, B)
	elseif direction == "downleft" then
		return CrossTilesDownLeft(A, B)
	elseif direction == "down" then
		return CrossTilesDown(A, B)
	elseif direction == "upright" then
		return CrossTilesUpRight(A, B)
	elseif direction == "upleft" then
		return CrossTilesUpLeft(A, B)
	elseif direction == "up" then
		return CrossTilesUp(A, B)
	elseif direction == "left" then
		return CrossTilesLeft(A, B)
	elseif direction == "right" then
		return CrossTilesRight(A, B)
	end
	return {}
end


local function getCirclePoints(x, y, r, n)
	local res = {}
	for i = 1, n do
		angle = i/n * 2 * math.pi
		table.insert(res, {x + r*math.cos(angle), y + r*math.sin(angle)})
	end
	return res
end


local function sameSide(p1, p2, a, b)
	local cp1 = (b-a).cross(p1-a)
	local cp2 = (b-a).cross(p2-a)
	if cp1 * cp2 >= 0 then return true end
	return false
end

local function pointInsideTriangle(p, a, b, c)
	local ab = sameSide(p, c, a, b)
	local bc = sameSide(p, a, b, c)
	local ca = sameSide(p, b, c, a)
	if ab and bc and ca then return true end
	return false
end

local function projectOnSegment(p, a, b)
	if a.x == b.x then return Vec(a.x, p.y) end
	--a.y = A * a.x + B
	--b.y = A * b.x + B
	local A = (a.y - b.y) / (a.x - b.x)
	local B = a.y - A * a.x
	---1/A
	--p.y = -p.x/A + B2
	local A2 = -1/A
	local B2 = p.y + p.x/A
	--Y = A*X + B
	--Y = A2*X + B2
	--A*X + B = A2*X + B2
	--(A-A2)*X = B2 - B
	local X = (B2- B) / (A - A2)
	local Y = A*X + B
	return Vec(X, Y)
end

local MathUtils = {}

MathUtils.intersectLines = intersectLines
MathUtils.getAngleBetween = getAngleBetween
MathUtils.getVecDirection = getVecDirection
MathUtils.CrossTiles = CrossTiles


MathUtils.getCirclePoints = getCirclePoints
MathUtils.sameSide = sameSide
MathUtils.pointInsideTriangle = pointInsideTriangle
MathUtils.projectOnSegment = projectOnSegment


function MathUtils.Clamp( Minimum, Maximum, Value ) -- Makes sure a number is between the minimum and the maximum.
	return math.max( Minimum, math.min( Maximum, Value ) )
end

function MathUtils.Lerp( Minimum, Maximum, Value ) -- Linear Interpolate a value (change from a scale from 0 to 1 to a range of values).
	return ( Maximum - Minimum ) * Value + Minimum
end

return MathUtils

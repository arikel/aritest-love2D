local core = require("core")
local GUI = require("gui")


local Game = function()
	local self = {}
	self.GUI = GUI()
	self.grid = core.GridCanvas(10,10,16,16)
	return self
end

return Game

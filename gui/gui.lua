
local core = require("core")
--local class30 = require("extras/30log-clean")


local function Theme()
	local self = {}
	
	self.defcolor1 = {0.5, 0.5, 0.5}
	self.defcolor2 = {0.7, 0.7, 0.7}
	self.defcolor3 = {0.4, 0.4, 0.4}
	
	self.hovercolor1 = {0.7, 0.7, 0.7}
	self.hovercolor2 = {0.8, 0.8, 0.8}
	self.hovercolor3 = {0.5, 0.5, 0.5}
	
	self.clickedcolor1 = {0.8, 0.8, 0.8}
	self.clickedcolor2 = {0.5, 0.5, 0.5}
	self.clickedcolor3 = {0.2, 0.2, 0.2}
	
	self.borderWidth = 2
	
	self.textDx = 5
	self.textDy = 3
	return self
end

local function drawText(t, x, y)
	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.print(t, x+1, y)
	love.graphics.print(t, x-1, y)
	love.graphics.print(t, x, y-1)
	love.graphics.print(t, x, y-1)
	
	love.graphics.print(t, x+2, y)
	love.graphics.print(t, x-2, y)
	love.graphics.print(t, x, y-2)
	love.graphics.print(t, x, y+2)
	
	love.graphics.print(t, x+1, y+1)
	love.graphics.print(t, x-1, y+1)
	love.graphics.print(t, x-1, y-1)
	love.graphics.print(t, x+1, y-1)
	
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print(t, x, y)
	--print("Draw text called", t)
end

local function Widget(x, y, w, h)
	local self = {}
	self.text = "Default Text"
	
	self.focused = false
	
	self.x = x
	self.y = y
	self.w = w
	self.h = h
	--print("Creating widget , with ", self.x, self.y, self.w, self.h)
	self.rect = core.Rect(self.x, self.y, self.w, self.h)
	
	self.canvas = love.graphics.newCanvas(self.w, self.h)
	
	self.theme = Theme()
	
	local dx = self.theme.borderWidth
	
	self.updateCanvas = function ()
		love.graphics.setCanvas(self.canvas)
		
		
		local dx = self.theme.borderWidth +1
		if self.hover then
		love.graphics.setColor(self.theme.hovercolor2)
		love.graphics.polygon("fill", 0, 0, self.w, 0, self.w, self.h, 0, self.h)
		love.graphics.setColor(self.theme.hovercolor1)
		love.graphics.polygon("fill", 0+dx, 0+dx, self.w-dx, 0+dx, self.w-dx, self.h-dx, 0+dx, self.h-dx)
		love.graphics.setColor(self.theme.hovercolor3)
		love.graphics.polygon("fill", 0+dx, 0+dx, 0, 0, 0, self.h, dx, self.h - dx)
		love.graphics.polygon("fill", 0, self.h, self.w, self.h, self.w - dx, self.h-dx, dx, self.h-dx)
		
		else
		local dx = self.theme.borderWidth
		
		love.graphics.setColor(self.theme.defcolor2)
		love.graphics.polygon("fill", 0, 0, self.w, 0, self.w, self.h, 0, self.h)
		love.graphics.setColor(self.theme.defcolor1)
		love.graphics.polygon("fill", 0+dx, 0+dx, self.w-dx, 0+dx, self.w-dx, self.h-dx, 0+dx, self.h-dx)
		love.graphics.setColor(self.theme.defcolor3)
		love.graphics.polygon("fill", 0+dx, 0+dx, 0, 0, 0, self.h, dx, self.h - dx)
		love.graphics.polygon("fill", 0, self.h, self.w, self.h, self.w - dx, self.h-dx, dx, self.h-dx)
		end
		
		love.graphics.setColor(1,1,1)
		
		drawText(self.text, self.theme.textDx, self.theme.textDy)
		--print ("Drew text", self.text)
		
		love.graphics.setCanvas()
		
	end
	
	
	
	self.active = true
	self.visible = true
	
	function self.show()
		self.visible = true
	end
	
	function self.hide()
		self.visible = false
	end
	
	function self.enable()
		self.active = true
	end
	
	function self.disable()
		self.active = false
	end
	
	function self.draw()
		if self.visible then
			love.graphics.draw(self.canvas, self.x, self.y)
		end
	end
	
	function self.update(dt)
		local x, y = love.mouse.getPosition()
		
		if self.active then
			if self.rect.collidePoint(x, y) then
				self.hover = true
				--print("Hover!")
			else
				self.hover = false
				--print("Not hover!")
			end
		else
			print("Not active? wtf")
		end
		
		local dx = self.theme.borderWidth
		
		self.updateCanvas(dt)
		
		if self.hover then
		
		else
			
		end
	end
	
	return self

end

local function Button(x, y, w, h, text, theme)
	local self = Widget(x, y, w, h)
	self.text = text
	self.updateCanvas()
	
	self.bind = function (func, args)
		--print("Binding new func, with args : ", args)
		self.args = args
		self.func = func
		self.onClicked = function()
			self.func(self.args)
		end
		
		--print("By args, I mean :")
		for i = 1, #self.args do
			--print(self.args[i])
		end
		--print("Ok?")
		
	end
	
	self.bind(
		function() print(self.text, "was clicked!", self.args) end,
		{"saha", "baba"})
	return self
end

local function Menu(x, y, w, h)
	local self = {}
	self.theme = Theme()
	self.list = core.List()
	self.x = x
	self.y = y
	self.w = w
	self.h = h
	
	--print("Menu created, with : ", self.x, self.y, self.w, self.h)
	
	function self.add(text)
		local len = self.list:len()
		local dy = (len * 25)
		
		--print("List len = ", len, "dy= ", dy)
		self.list:append(Button(self.x, self.y + dy, self.w, self.h, text, self.theme))
	end
	
	function self.update(dt)
		for b in self.list:iter() do
			b.update(dt)
		end
	end
	
	function self.draw()
		for b in self.list:iter() do
			b.draw()
		end
	end
	
	return self
end

local function GUI()
	local self = {}
	
	self.menu = Menu(5,50,120,20)
	self.menu.add("Bulllshiit")
	self.menu.add("NOOOOO!!!")
	self.menu.add("yééé!éééé!!")
	
	function self.update(dt)
		self.menu.update(dt)
	end
	
	function self.draw()
		self.menu.draw()
	end
	
	function self.mousepressed(x, y, button)
		for b in self.menu.list:iter() do
			if b.hover then
				print("Clicking on button advanced, args are :")
				for i = 1, #b.args do
					print(b.args[i])
				end
				b.onClicked()
			end
		end
		
	end

	
	return self
end


return GUI

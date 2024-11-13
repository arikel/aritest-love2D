width = 800
height = 600
success = love.window.setMode( width, height, {} )

local canvas = love.graphics.newCanvas( width, height )
local rnd = love.math.random

function randRect(nb)
	love.graphics.setCanvas(canvas)
	for i = 1, nb do
		love.graphics.setColor(rnd()*1, rnd()*1, rnd()*1, 1)
		local x = rnd() * width local y = rnd() * height local w = rnd() * 16 + 2 local h = rnd() * 16 + 16
		
		local drawMode = "fill"
		if rnd()>0.5 then
			drawMode = "line"
		end
		love.graphics.polygon(drawMode, x,y, x+w,y ,x+w, y+h, x,y+h)
		
	end
	
	local drawMode = "fill"
	if rnd()>0.5 then
		drawMode = "line"
	end
	love.graphics.arc(drawMode, width*rnd(), height*rnd(), 5 + rnd()*32, rnd(), rnd() + 2*math.pi, 24 )

	love.graphics.setColor(1,1,1,1)
	
end

function love.draw()
	randRect(5)
	love.graphics.setCanvas()
	love.graphics.draw(canvas)
	
	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.print("Hello World!", 381, 300)
	love.graphics.print("Hello World!", 379, 300)
	love.graphics.print("Hello World!", 380, 299)
	love.graphics.print("Hello World!", 380, 301)
	
	love.graphics.print("Hello World!", 382, 300)
	love.graphics.print("Hello World!", 378, 300)
	love.graphics.print("Hello World!", 380, 298)
	love.graphics.print("Hello World!", 380, 302)
	
	love.graphics.print("Hello World!", 381, 301)
	love.graphics.print("Hello World!", 379, 301)
	love.graphics.print("Hello World!", 379, 299)
	love.graphics.print("Hello World!", 381, 299)
	
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print("Hello World!", 380, 300)
end

function love.keypressed(key)
	if key == "escape" then love.event.quit() end
end

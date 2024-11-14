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

function drawText(text, x, y)
	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.print(text, x+1, y)
	love.graphics.print(text, x-1, y)
	love.graphics.print(text, x, y-1)
	love.graphics.print(text, x, y+1)
	
	love.graphics.print(text, x+2, y)
	love.graphics.print(text, x-2, y)
	love.graphics.print(text, x, y-2)
	love.graphics.print(text, x, y+2)
	
	love.graphics.print(text, x+1, y+1)
	love.graphics.print(text, x-1, y+1)
	love.graphics.print(text, x-1, y-1)
	love.graphics.print(text, x+1, y-1)
	
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print(text, x, y)
end


function love.draw()
	randRect(5)
	love.graphics.setCanvas()
	love.graphics.draw(canvas)
	
	drawText("Hello people!", 400, 300)
end

function love.keypressed(key)
	if key == "escape" then love.event.quit() end
end

function love.conf(t)
	--t.window.width = 0 -- t.screen.width in 0.8.0 and earlier
	--t.window.height = 0 -- t.screen.height in 0.8.0 and earlier
	local c = 1
	if c ==1 then
		t.window.width = 600
		t.window.height = 600
		t.window.fullscreen = false
	else
		t.window.width = 0
		t.window.height = 0
		t.window.fullscreen = true
	end
	--t.window.fullscreen = true
	--t.window.vsync = false
	t.modules.joystick = true
	t.modules.physics = false
	t.title = "Space Colony"
	t.author = "Arikel"
	--t.window.icon = "img/icon.png"
	--t.version = "0.9.2"
end

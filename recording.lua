function love.load()
	count = love.audio.getActiveSourceCount()
	devices = love.audio.getRecordingDevices( )
	micro = devices[1]
end

function love.keypressed(key)
	if key == "escape" then love.event.quit() end
	if key == "a" then
		micro:start(100000)
		print("Starting recording!")
	end
	if key == "e" then
		print("sample count ", micro:getSampleCount())
		local data = micro:stop()
		print("Stopping recording, data = ", data, "duration = " , data:getDuration(), "sample count ", micro:getSampleCount())
		source = love.audio.newSource(data, "stream")
		
		love.audio.setEffect("myEffect", {type="reverb"})
		source:setEffect("myEffect")
		
		love.audio.setEffect("myEffect2", {
			type = "distortion",
			gain = .5,
			edge = .25,
		})
		source:setEffect("myEffect2")
		
		source:play()
		--love.audio.play(source)
		print("Ended recording!")
	end
	if key == "space" then
		if source then
			--love.audio.play(source)
			source:play()
		end
	end
end

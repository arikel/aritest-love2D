enet = require "enet"

enethost = nil
hostevent = nil
clientpeer = nil

function love.load(args)
	love.window.setTitle("AriServer")
	love.window.setMode(150,100)
	love.window.setPosition(550,150)
	-- establish host for receiving msg
	enethost = enet.host_create("localhost:6750")
end

function love.update(dt)
	ServerListen()
end

function love.draw()
end

function love.keypressed(key)
	if key == "escape" then love.event.quit() end
	if key == "space" then
		if peer then
			peer:send("Server is talking to you!")
			enethost:broadcast("And this is for everyone!")
		end
	end
end

function ServerListen()

	hostevent = enethost:service(10)
	
	if hostevent then
		--print("Server detected message type: " .. hostevent.type)
		if hostevent.type == "connect" then 
			print(hostevent.peer, "connected.")
			peer = hostevent.peer
			print(peer:connect_id())
		end
		if hostevent.type == "receive" then
			print("Received message: ", hostevent.data, hostevent.peer)
			hostevent.peer:send("Server said : Received message " ..  hostevent.data)
		end
	end
end


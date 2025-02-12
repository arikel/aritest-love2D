enet = require "enet"

enethost = nil
hostevent = nil
clientpeer = nil

function love.load(args)
	love.window.setTitle("AriClient")
	love.window.setMode(150,100)
	love.window.setPosition(550,350)
	enetclient = enet.host_create()
	clientpeer = enetclient:connect("localhost:6750")
	hiNum = 0
end

function love.update(dt)
	ClientListen()
end

function love.draw()
end

function love.keypressed(key)
	if key == "escape" then love.event.quit() end
	if key == "space" then ClientSend() end
end


function ClientSend()
	enetclient:service(10)
	hiNum = hiNum + 1
	local msg = "Hi " .. tostring(hiNum)
	clientpeer:send(msg)
	print("Client sent " .. msg)
end

function ClientListen()

	hostevent = enetclient:service(10)
	
	if hostevent then
		--print("Client detected message type: " .. hostevent.type)
		if hostevent.type == "connect" then 
			print(hostevent.peer, "connected.")
			peer = hostevent.peer
		end
		if hostevent.type == "receive" then
			print("Client received message: ", hostevent.data, hostevent.peer)
			--hostevent.peer:send("Server said : Reveived message")
		end
		if hostevent.type == "disconnect" then
			print("Client received message: casse-toi!")
			love.event.quit()
		end
	end
end

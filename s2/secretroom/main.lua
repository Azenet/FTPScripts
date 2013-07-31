rednet.open("top")

while true do
	e,a,b,c = os.pullEvent("rednet_message")
	if (a == 29) then
		if (b == "open") then
			rednet.broadcast("down")
			sleep(1.2)
			rednet.broadcast("down")
			sleep(1.3)
			redstone.setOutput("right", true)
		elseif (b == "close") then
			redstone.setOutput("right", false)
			sleep(0.2)
			rednet.broadcast("up")
			sleep(1.2)
			rednet.broadcast("up")
		end
	end
end


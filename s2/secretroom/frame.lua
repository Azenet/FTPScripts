rednet.open("back")

m = peripheral.wrap("right")

while true do
	e,a,b,c = os.pullEvent("rednet_message")
	if (a == 58) then
		if (b == "down") then
			m.move(0, false, false)  
		elseif (b == "up") then
			m.move(1, false, false)
		end
	end
end


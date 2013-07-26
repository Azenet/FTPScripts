function explode(div,str) -- credit: http://richard.warburton.it
	if (div=='') then return false end
	local pos,arr = 0,{}
	-- for each divider found
	for st,sp in function() return string.find(str,div,pos,true) end do
		table.insert(arr,string.sub(str,pos,st-1)) -- Attach chars left of current divider
		pos = sp + 1 -- Jump past current divider
	end
	table.insert(arr,string.sub(str,pos)) -- Attach chars right of last divider
	return arr
end

rednet.open("top")
locked = false

while true do
	e,a,b,c = os.pullEvent("rednet_message")
	if (string.match(b, "azenet:xp:")) then
		local m = explode(':', b)
		print(m[3])
		if (tonumber(m[3]) > 1980) then
			rednet.broadcast("azenet:closexp")
			redstone.setOutput("bottom", true)
			locked = true
		elseif (tonumber(m[3]) <= 1980) then
			if locked then
				rednet.broadcast("azenet:openxp")
				redstone.setOutput("bottom", false)
				locked = false
			end
		end
	elseif (b == "azenet:closexp") then
		redstone.setOutput("bottom", true)
	elseif (b == "azenet:openxp") then
		if not locked then redstone.setOutput("bottom", false)
		else sleep(0.5) rednet.broadcast("azenet:closexp") end
	end
end


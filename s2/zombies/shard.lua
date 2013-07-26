rednet.open("top")
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
while true do
	e,a,b,c = os.pullEvent("rednet_message")
	if (b == "azenet:openxp") then redstone.setOutput("front", true)
	elseif (b == "azenet:closexp") then redstone.setOutput("front", false) end
end


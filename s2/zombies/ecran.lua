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

function xpPointsToLevels(points)
	local pts = tonumber(points)
	if (pts < 0) then return 0 end
	if (pts <= 272) then return math.floor(pts/17)
	elseif (pts > 272 and pts <= 887) then return math.floor((1/6)*(59+math.sqrt(-5159+(24*pts))))
	else return math.floor((1/14)*(303+math.sqrt(-32511+(56*pts)))) end
end

rednet.open("front")

m = peripheral.wrap("right")
m.setTextScale(5)
m.clear()
points = 0
open = false

while true do
	e,a,b,c = os.pullEvent("rednet_message")
	if (string.match(b, "azenet:xp:")) then
		local m = explode(':', b)
		points = tonumber(m[3])
	elseif (b == "azenet:closexp") then
		open = false
	elseif (b == "azenet:openxp") then
		open = true
	end
	m.clear()
	m.setTextColor(colors.green)
	if not open then m.setTextColor(colors.red) end
	m.setCursorPos(1,1)
	m.write("XP: "..xpPointsToLevels(points).." niveaux")
end


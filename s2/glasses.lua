
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
        else return math.floor((1/14)*(303+math.sqrt(-32411+(56*pts)))) end
end

rednet.open("back")

p = peripheral.wrap("top")
p.clear()
w = p.getStringWidth("50 niveaux")
box = p.addBox(5, 5, w+6, 11, 0x000000, 1)
p.addBox(5, 12, w+6, 1, 0x000000, 1)
p.addBox(5, 23, w+6, 1, 0x000000, 1)
p.addBox(5, 12, 1, 11, 0x000000, 1)
p.addBox(4+w+6, 12, 1, 11, 0x000000, 1)
p.addBox(6, 14, w+4, 9, 0xffffff, 0.2)
--os.shutdown()
actualPercentage = p.addGradientBox(6, 16, w+4, 7, 0x456c25, 1, 0x8fc364, 1, 1)
actualPercentage.setZIndex(60)
gradient = p.addGradientBox(6, 6, w+4, 9, 0xeeeeee, 1, 0xaaaaaa, 1, 1)
text = p.addText(8, 7, "...", 0x61903b)
box.setZIndex(1)
gradient.setZIndex(100)
text.setZIndex(101)


while true do
        e,a,b,c = os.pullEvent()
--      print(textutils.serialize({e,a,b,c}))
        if (e == "rednet_message" and string.match(b, "azenet:xp:")) then
                local m = explode(':', b)
                text.setText(xpPointsToLevels(m[3]).." niveaux")
                actualPercentage.setWidth(math.floor((tonumber(m[3])/1980)*(w+4)))
        elseif (e == "rednet_message" and b == "azenet:closexp") then
                text.setColor(0xff1313)
        elseif (e == "rednet_message" and b == "azenet:openxp") then
                text.setColor(0x61903b)
        elseif (e == "chat_command" and b == "azenet" and a == "stopXP") then
                rednet.broadcast("azenet:closexp")
                text.setColor(0xff1313)
        elseif (e == "chat_command" and b == "azenet" and a == "startXP") then
                rednet.broadcast("azenet:openxp")
                text.setColor(0x61903b)
        end
end


os.loadAPI("ocs/apis/sensor")
m = peripheral.wrap("front")
s = sensor.wrap("back")
local t,day,time = s.getTargets(), os.day(), os.time()

while true do
	m.clear()
	m.setCursorPos(2,3)
	m.write(textutils.formatTime(time, true))
	m.setCursorPos(2,2)
	m.write("J "..day)
	m.setCursorPos(2,4)
	if (t.CURRENT.Thundering == true) then
		m.write("Orage")
	elseif (t.CURRENT.Raining == true) then
		m.write("Pluie")
	end
	t = s.getTargets()
	day = os.day()
	time = os.time()
	sleep(0.3)
end

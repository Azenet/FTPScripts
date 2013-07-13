m = peripheral.wrap("front")

while true do
	m.clear()
	m.setCursorPos(2,3)
	m.write(textutils.formatTime(os.time(), true))
	sleep(0.2)
end

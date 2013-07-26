rednet.open("front")

jar = peripheral.wrap("brain_in_a_jar_0")

while true do
	rednet.broadcast("azenet:xp:"..jar.getXP())
	print(jar.getXP())
	sleep(0.2)
end


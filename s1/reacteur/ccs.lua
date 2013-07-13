rednet.open("top")
os.loadAPI("ocs/apis/sensor")
ic2s = sensor.wrap("front")
invs = sensor.wrap("right")

master = 457

reacteuric2loc = "0,1,-1"
reacteurinvloc = "0,0,-2"


while true do
        reacteuric2 = ic2s.getTargetDetails(reacteuric2loc)
        reacteurinv = invs.getTargetDetails(reacteurinvloc)
        t = {}
        t.heat = reacteuric2.Heat
        t.out = reacteuric2.Output
        t.on = reacteuric2.Active
        t.inv = reacteurinv
        rednet.send(master, textutils.serialize(t))
        t = os.startTimer(0.5)
        w = true
        while w do e,a = os.pullEvent("timer") if a == t then w = false end end
end


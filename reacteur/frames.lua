rednet.open("back")

controlComputer = 457

while true do
        e,a,b = os.pullEvent("rednet_message")
        print(a..": "..b)
        if a == controlComputer then
                if b == "down" then
                        local going = true
                        while going do
                                redstone.setOutput("front", true)
                                os.sleep(0.5)
                                redstone.setOutput("front", false)
                                os.sleep(0.5)
                                going = not redstone.getInput("right")
                                print(tostring(going))
                        end
   redstone.setOutput("left",true)
                        rednet.send(controlComputer, "doneMoving")
                elseif b == "up" then
                        local going = true
   redstone.setOutput("left",false)
                        while going do
                                redstone.setOutput("bottom", true)
                                os.sleep(0.4)
                                redstone.setOutput("bottom", false)
                                os.sleep(0.4)
                                going = not redstone.getInput("top")
                                print(tostring(going))
                        end
                        rednet.send(controlComputer, "doneMoving")
                end
        end
end


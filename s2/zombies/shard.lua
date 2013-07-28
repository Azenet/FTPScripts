rednet.open("top")

while true do
	e,a,b,c = os.pullEvent("rednet_message")
	if (b == "azenet:openxp") then redstone.setOutput("front", true)
	elseif (b == "azenet:closexp") then redstone.setOutput("front", false) end
end


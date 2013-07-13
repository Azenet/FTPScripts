os.sleep(2)

rednet.open("left")
speaker = peripheral.wrap("bottom")
m = peripheral.wrap("right")
m.setTextScale(5)
m.setTextColor(colors.white)
m.setBackgroundColor(colors.black)
m.clear()

button = {}
currentStatus = "up"
frameController = 456
reactorComputer = 458
alarm = false
reacteur = false
reactemp = 0
reacout = 0
reacinv = {}
warnedAboutOpenReac = false
warnedAboutUnexpectedWork = false
isDrawModeMissing = true
modifyDrawModeT = 0
isModifyDrawmodeTimerDone = true
isMoving = false
currentMode = 0

local f = fs.open("nominal","r")
actualNom = textutils.unserialize(f.readAll())
f.close()

s = "Wait"
messages = {"", "", "", "", "", "", "", "", "", ""}
mx,my = m.getSize()
m.setCursorPos(math.ceil(mx/2)-math.ceil(#s/2), math.ceil(my/2))
m.write(s)
rednet.send(frameController, "up")
local w = true
while w do
	e,a,b = os.pullEvent("rednet_message")
	if a == frameController and b == "doneMoving" then w = false end
end

redstone.setOutput("back", alarm)

function logMessage(msg) 
	local t = {}
	t.level = "message"
	t.msg = msg
	table.insert(messages, t)
	print(textutils.serialize(messages))
	redraw()
end

function logWarning(msg) 
	speaker.playNote(0,18)
	local t = {}
	t.level = "warning"
	t.msg = msg
	table.insert(messages, t)
	redraw()
end

function logAlert(msg) 
	enableAlarm()
	local t = {}
	t.level = "alert"
	t.msg = msg
	table.insert(messages, t)
	redraw()
end

function clear()
	m.setTextScale(1)
	setColorScheme()
	m.clear()
	mx,my = m.getSize()
end

function disableButton(name) 
	if button[name] then button[name]["valid"] = false end
	redraw()
end
function drawButtons()
	for n,d in pairs(button) do
		if d["valid"] == true then
			if d["active"] then m.setBackgroundColor(buttonActiveB) m.setTextColor(buttonActiveT)
			else m.setBackgroundColor(buttonInactiveB) m.setTextColor(buttonInactiveT) end
			for i=d["ymin"], d["ymax"] do
				local str = ""
				for j=d["xmin"], d["xmax"] do
					str = str .. " "
				end
				m.setCursorPos(d["xmin"], i)
				m.write(str)
			end
			m.setCursorPos(math.ceil((d["xmin"]+d["xmax"])/2)-math.ceil(#n/2), math.ceil((d["ymin"]+d["ymax"])/2))
			m.write(n)
		end
	end
end

function redraw()
	clear()
	for i=1, mx do
		m.setCursorPos(i,1)
		m.write("-")
		m.setCursorPos(i,my)
		m.write("-")
	end
	for i=2, my-1 do
		m.setCursorPos(1, i)
		m.write("|")
		m.setCursorPos(mx, i)
		m.write("|")
		m.setCursorPos(math.ceil(mx/3), i)
		m.write("|")
	end
	for i=math.ceil(mx/3)+1, mx-1 do
		m.setCursorPos(i, my-7)
		m.write("-")
	end
	m.setCursorPos(math.ceil(mx/3)+2, my-6)
	m.write("Derniers messages")
	local cnt = 6
	for i=#messages, #messages-3, -1 do
		cnt = cnt - 1
		local cmsg = messages[i]
		if cmsg.level == "message" then
			setColorScheme()
		elseif cmsg.level == "warning" then
			m.setBackgroundColor(colors.orange)
			m.setTextColor(colors.black)
		elseif cmsg.level == "alert" then
			if alarm then
				m.setBackgroundColor(colors.black)
				m.setTextColor(colors.red)
			else
				m.setBackgroundColor(colors.red)
				m.setTextColor(colors.white)
			end
		end
		local oldx,oldy = m.getCursorPos()
		m.setCursorPos(math.ceil(mx/3)+1, my-cnt)
		if cmsg.msg then m.write(cmsg.msg) end
		setColorScheme()
		m.setCursorPos(oldx,oldy)
	end
	if reacteur then
		m.setTextColor(colors.green)
		m.setCursorPos(mx-2,2)
		m.write("On")
	else
		if alarm then m.setTextColor(colors.black) else m.setTextColor(colors.red) end
		m.setCursorPos(mx-3,2)
		m.write("Off")
	end
	local temp = reactemp.." degres"
	m.setCursorPos(mx-#temp,3)
	m.write(temp)	
	local out = reacout.." EU/t"
	m.setCursorPos(mx-#out,4)
	m.write(out)	
	local baseX = math.ceil(mx/3)+2
	local baseY = 2
	m.setTextColor(colors.gray)
	for i=baseX, baseX+19 do
		m.setCursorPos(i, baseY)
		m.write("-")
		m.setCursorPos(i, baseY+7)
		m.write("-")
	end
	for i=baseY+1, baseY+6 do
		m.setCursorPos(baseX, i)
		m.write("|")
		m.setCursorPos(baseX+19, i)
		m.write("|")
	end
	print(reactemp)
	local asd = ""
	local cnt = 1
	for cY = baseY+1, baseY+6 do
		for cX = baseX+1, baseX+17,2 do
			m.setCursorPos(cX, cY)
			local cE = reacinv[cnt]
			cnt = cnt+1
			if currentMode == 0 then
				if cE ~= nil then 
					if cE.Name == "item.reactorHeatSwitchDiamond" then
						m.setBackgroundColor(colors.orange)
						m.setTextColor(colors.white)
						m.write("<>")
					elseif cE.Name == "item.reactorVentDiamond" then
						m.setBackgroundColor(colors.lightBlue)
						m.setTextColor(colors.white)
						m.write("VA")
					elseif cE.Name == "item.360k_NaK_Coolantcell" then
						m.setBackgroundColor(colors.green)
						m.setTextColor(colors.white)
						m.write("Na")
					elseif cE.Name == "item.360k_Helium_Coolantcell" then
						m.setBackgroundColor(colors.yellow)
						m.setTextColor(colors.black)
						m.write("He")
					elseif cE.Name == "item.reactorCoolantSix" then
						m.setBackgroundColor(colors.blue)
						m.setTextColor(colors.white)
						m.write("Co")
					elseif cE.Name == "item.Quad_Plutoniumcell" then
						m.setBackgroundColor(colors.lime)
						m.setTextColor(colors.black)
						m.write("Pl")
					elseif cE.Name == "item.reactorUraniumSimple" then
						m.setBackgroundColor(colors.lime)
						m.setTextColor(colors.black)
						m.write("Ur")
					else
						local lolcnt = cnt-1
						if actualNom[lolcnt] ~= nil then
							local lolnom = actualNom[lolcnt]
							print(lolnom)
							print(lolcnt)
							if isDrawModeMissing then
								m.setBackgroundColor(colors.black)
								m.setTextColor(colors.white)
								m.write("??")
							else
								if lolnom == "item.reactorHeatSwitchDiamond" then
									m.setBackgroundColor(colors.orange)
									m.setTextColor(colors.white)
									m.write("<>")
								elseif lolnom == "item.reactorVentDiamond" then
									m.setBackgroundColor(colors.lightBlue)
									m.setTextColor(colors.white)
									m.write("VA")
								elseif lolnom == "item.360k_NaK_Coolantcell" then
									m.setBackgroundColor(colors.green)
									m.setTextColor(colors.white)
									m.write("Na")
								elseif lolnom == "item.360k_Helium_Coolantcell" then
									m.setBackgroundColor(colors.yellow)
									m.setTextColor(colors.black)
									m.write("He")
								elseif lolnom == "item.reactorCoolantSix" then
									m.setBackgroundColor(colors.blue)
									m.setTextColor(colors.white)
									m.write("Co")
								elseif lolnom == "item.Quad_Plutoniumcell" then
									m.setBackgroundColor(colors.lime)
									m.setTextColor(colors.black)
									m.write("Pl")
								elseif lolnom == "item.reactorUraniumSimple" then
									m.setBackgroundColor(colors.lime)
									m.setTextColor(colors.black)
									m.write("Ur")
								end
							end
						end
					end			
				end
			elseif currentMode == 1 then
				if cE ~= nil then
					if cE["nbt"] ~= nil then
						local h = cE.nbt.heat
						if h ~= nil then
							if h > reactemp+(5*reactemp) then
								m.setBackgroundColor(colors.red)
								m.setTextColor(colors.red)
							elseif h > reactemp then
								m.setBackgroundColor(colors.orange)
								m.setTextColor(colors.orange)
							elseif h < reactemp-(5*reactemp) then
								m.setBackgroundColor(colors.blue)
								m.setTextColor(colors.blue)
							elseif h <= reactemp then
								m.setBackgroundColor(colors.lightBlue)
								m.setTextColor(colors.lightBlue)
							end

							asd = asd .. h .. " "
							m.write("--")
						end
					end
				end
			elseif currentMode == 2 then
				if cE ~= nil then
					if cE.DamageValue ~= nil then
						local n = cE.Name
						local d = cE.DamageValue
						if n == "item.360k_Helium_Coolantcell" or n == "item.360k_NaK_Coolantcell" then
							if d < 80 then
								m.setBackgroundColor(colors.lightBlue)
								m.setTextColor(colors.lightBlue)
							elseif d >= 80 and d < 90 then
								m.setBackgroundColor(colors.green)
								m.setTextColor(colors.green)
							elseif d >= 90 and d < 97 then
								m.setBackgroundColor(colors.orange)
								m.setTextColor(colors.orange)
							elseif d >= 97 then
								m.setBackgroundColor(colors.red)
								m.setTextColor(colors.red)
							end
							m.write("--")
						end
					end
				end
			end
		end
	end
	print(asd)
	drawButtons()
end

function setTable(name, func, xmin, xmax, ymin, ymax)
	button[name] = {}
	button[name]["func"] = func
	button[name]["active"] = false
	button[name]["valid"] = true
	button[name]["xmin"] = xmin
	button[name]["ymin"] = ymin
	button[name]["xmax"] = xmax
	button[name]["ymax"] = ymax
	redraw()
end

function createButtons()
	setTable("Reacteur", toggleReacteur, 3, 19, 2, 6)
	setTable("Ouvrir", openPanel, 3, 19, 8, 12)
	setTable("Sauver", saveReacteur, 23, 31, 10, 10)
	setTable("Mode", modeButton, 34, 42, 10, 10)
end

function setColorScheme()
	if alarm then
		m.setBackgroundColor(colors.red)
		m.setTextColor(colors.white)
		buttonInactiveB = colors.black
		buttonActiveB = colors.orange
		buttonInactiveT = colors.white
		buttonActiveT = colors.white
	else
		m.setBackgroundColor(colors.black)
		m.setTextColor(colors.white)
		buttonInactiveB = colors.red
		buttonActiveB = colors.green
		buttonInactiveT = colors.white
		buttonActiveT = colors.white
	end
end

function enableAlarm()
	redstone.setOutput("back", true)
	alarm = true
	setTable("Reset alarme", disableAlarm, 3, 19, 14, 18)
	redraw()
end

function disableAlarm()
	disableButton("Reset alarme")
	redstone.setOutput("back", false)
	alarm = false
	redraw()
end

function saveReacteur()
	local nom = {}
	for k,v in pairs(reacinv) do
		table.insert(nom, v.Name)
	end
	local f = fs.open("nominal","w")
	f.write(textutils.serialize(nom))
	f.close()
	local f = fs.open("nominal","r")
	actualNom = textutils.unserialize(f.readAll())
	f.close()
	logMessage("Sauvegarde effectuee")
end

function toggleReacteur(button)
	if not reacteur then
		local nom = {}
		for k,v in pairs(reacinv) do
			table.insert(nom, v.Name)
		end
		local ok = true
		local invalid = {}
		local hecells = 0
		for k,v in pairs(nom) do
			if v == "item.360k_Helium_Coolantcell" then hecells = hecells+1 end
			if v ~= actualNom[k] then
				ok = false
				table.insert(invalid, k)
			end
		end
		if not ok then
			logWarning("Configuration invalide")
		end
		print(hecells)
		if hecells < 9 then
			logWarning("Helium manquant")
			return
		end
	end
	if currentStatus == "down" then 
		logWarning("Reacteur desactive: ouvert")
		return
	end
	reacteur = not reacteur
	if button then button["active"] = reacteur end
	redstone.setOutput("top", reacteur)
	if reacteur == true then logMessage("Reacteur on")
	else logMessage("Reacteur off") end
end

function openPanel()
	if isMoving then return end
	isMoving = true
	disableButton("Ouvrir")
	disableButton("Reacteur")
	if reacteur == true then 
		toggleReacteur(nil) 
		logWarning("Reacteur desactive auto.")
	end
	rednet.send(frameController, "down")
end

function closePanel()
	if isMoving then return end
	isMoving = true
	disableButton("Fermer")
	rednet.send(frameController, "up")
end

function doneMoving()
	isMoving = false
	if currentStatus == "up" then
		currentStatus = "down"
		setTable("Fermer", closePanel, 3, 19, 8, 12)
	else
		currentStatus = "up"
		setTable("Ouvrir", openPanel, 3, 19, 8, 12)
		setTable("Reacteur", toggleReacteur, 3, 19, 2, 6)
	end
end

function checkxy(x, y)
	for name, data in pairs(button) do
		if y>=data["ymin"] and  y <= data["ymax"] then
			if x>=data["xmin"] and x<= data["xmax"] and data["valid"] == true then
				data["func"](data)
				print(name)
				return
			end
		end
	end
end

function modeButton()
	currentMode = currentMode + 1
	if currentMode == 3 then currentMode = 0 end
	redraw()
end

createButtons()
while true do
	redraw()
	local e,a,b,c = os.pullEvent()
	isDrawModeMissing = not isDrawModeMissing
	if e == "monitor_touch" then checkxy(b,c) sleep(0.1)
	elseif e == "rednet_message" then
		if a == reactorComputer then
			local t = textutils.unserialize(b)
			reactemp = t.heat
			reacout = t.out
			setColorScheme()
			if t.on and not reacteur and not warnedAboutUnexpectedWork then logWarning("Fonctionnement imprevu") warnedAboutUnexpectedWork = true end
			if not t.on and warnedAboutUnexpectedWork then logWarning("Retour a la normale") warnedAboutUnexpectedWork = false end
			if t.on and warnedAboutUnexpectedWork then m.setCursorPos(mx-6,5) m.write("Erreur") end
			if t.on and currentStatus ~= "up" and not warnedAboutOpenReac then warnedAboutOpenReac = true logAlert("Reacteur ouvert") closePanel() end
			if warnedAboutOpenReac and currentStatus == "up" then logMessage("Panneau ferme") disableAlarm() warnedAboutOpenReac = false end

			if reactemp > 3000 and reacteur then
				logAlert("Reacteur en surchauffe")
				toggleReacteur(button["Reacteur"])
			end
			reacinv = t.inv
		elseif a == frameController and b == "doneMoving" then
			doneMoving()
		end
	end
end

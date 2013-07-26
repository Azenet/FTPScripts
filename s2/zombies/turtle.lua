while true do
	turtle.attack()
	local n = turtle.getItemCount(16)
	for s=1, 16 do
		if n > 0 then
			turtle.select(s)
			turtle.dropUp()
		end
	end
	turtle.select(1)
end



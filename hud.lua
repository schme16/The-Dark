hud = {}
commFunctions = {}
communication = {active = false}
triggers = {}
triggersFunctions = {}



function hud:draw()

	local x,y = cam:mousepos():unpack()

end


function triggersFunctions:newTrigger(x,y,x2,y2,func,refire)

	table.insert(triggers, {x = x, y = y, x2 = x2, y2 = y2, refire = refire, func = func})

end

function triggersFunctions:updateTrigger()

	for i,v in ipairs(triggers) do
		if player.x > v.x and player.x < (v.x2) and player.y > v.y and player.y < (v.y2) then
			v.func()
			if not(v.refire) then table.remove(triggers,i) end
		end
	end

end


function commFunctions:newCommunication(commTable)

	table.insert(communication, commTable)

end


function commFunctions:updateCommunication()
	commFunctions.active = false
	for i,v in ipairs(communication) do
		love.graphics.setColor(0,0,0,180)
		love.graphics.rectangle('fill', 50, 300, 500,110)
		love.graphics.setColor(255,255,255,255)
		love.graphics.rectangle('line', 50, 300, 500,110)
		love.graphics.printf( v[v.level].text, 55, 305, 495, 'center' )
		for k,d in ipairs(v[v.level].buttons) do
			commFunctions.active = true
			love.graphics.printf( d.text, 55, 355, 495, 'center' )
			love.graphics.printf( '(Press '.. d.button ..')', 55, 375, 495, 'center' )
			if keyboard.newPress[d.button] then
				if type(d.func) == 'function' then d.func() end
				if v.level == #v then
					table.remove(communication, i)
				else
					v.level = v.level+1
				end
			end
		end
	end

end











	game = {
		state = 'menu',
		level = 1,
		lighting = love.graphics.newFramebuffer(  ),
	}

	gameFunctions = {}

	maps = {
		
	}
	
	map = {}
	doors = {}
	lightMap = love.graphics.newImage('lightMap.png')
	map1Walls = love.graphics.newImage('map1Walls.gif')
	
	SpecialVariableTopSecret = false
	
	
function gameFunctions:run() 

	 if game.state == 'running' then 
		if cam then cam:draw( gameFunctions.running ) end
		gameFunctions:lighting()
		love.graphics.draw(game.lighting, 0,0)
		hud:draw()
		playerFunctions:draw()
		entitiesFunctions:drawNPC()
		commFunctions:updateCommunication()
		
		if player.lanturnBattery then love.graphics.print('Lanturn Battery: '.. tostring(math.abs(math.floor(player.lanturnBattery))), 475, 5) end
		 love.graphics.print('Timer: '.. tostring(player.time), 5, 5) 


	 end

end


function gameFunctions:menu() end


function gameFunctions:running(drawOnly)
	gameFunctions:mapDraw()
	if not(drawOnly) then
		playerFunctions:update()
		gameFunctions:update()
		triggersFunctions:updateTrigger()
		entitiesFunctions:update()
	end
end


function gameFunctions:mapDraw()

	love.graphics.draw(map1Walls, maps[game.level].x, maps[game.level].y)
	love.graphics.draw(maps[game.level].image, maps[game.level].x, maps[game.level].y)
	for i,v in ipairs(doors) do
		love.graphics.draw(v.image, v.x, v.y)
	end

end


function gameFunctions:lighting()
	--start of lighting system
	love.graphics.setRenderTarget( game.lighting )
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle('fill', 0, 0, 800, 600)
	love.graphics.setColor(255,255,255)
	love.graphics.setBlendMode('subtractive')
	
	--Draw all light sources here
local x,y
	player.inLight = false
	for i,v in ipairs(lights) do
		if v.radius > 0 then
			if not(v.tag == 'playersLanturn') then
				local c1 = {}
				c1.x, c1.y = cam:toWorldCoords(vector(300, 200)):unpack()
				
				local c2 = v
				local dist = getDist(c1, c2) 
				if dist > (v.radius) then
					
				else
					player.inLight = true
				end
			end
			
			if v.func then v.func(i,v) end
			local scale = getScale(lightMap, {width = v.radius*2, height = v.radius*2})
			if v.tag == 'playersLanturn' then
				x = (love.graphics.getWidth()/2)
				y = (love.graphics.getHeight()/2)
			else
				x,y = cam:toCameraCoords(vector(v.x,v.y)):unpack()
			
			end
			
			
				

			love.graphics.draw(lightMap, x, y, 0, scale.x, scale.y, lightMap:getWidth()/2, lightMap:getHeight()/2)
		end

	end
	love.graphics.setBlendMode('alpha')
	love.graphics.setRenderTarget(  )


	--end of lighting system
		
end


function gameFunctions:update()

end


function gameFunctions:newGame()
	game.state = 'running'
	love.graphics.setCaption('Game Loading - Please Wait...')
	cam = Camera(vector(player.x, player.y))
	gameFunctions:buildMap()
	love.graphics.setCaption('The Dark')
end


function gameFunctions:buildMap()
--first we set some locals
	local x,y = cam:toWorldCoords(vector(love.graphics.getWidth()/2, love.graphics.getHeight()/2)):unpack()


--then parse the map
	local image = love.graphics.newImage('map.gif')
	local colMap = collision:newCollisionMap('map.gif')
	table.insert(maps, {image = image, colMap = colMap, x = 0, y = 0})
	
--and time for doors
	table.insert(doors, {image = love.graphics.newImage('door.png'), colMap = collision:newCollisionMap('door.png'), x = 67, y = 27})

	
--next we make some lights
	entitiesFunctions:addLight(85, 65, 0, '1')
	entitiesFunctions:addLight(85, 65, 85, '2')
	
	entitiesFunctions:addLight(85, 1425, 100, '3')
	entitiesFunctions:addLight(1000, 1425, 100, '4')
	entitiesFunctions:addLight(1945, 1425, 100, '5')
	entitiesFunctions:addLight(1945, 512, 100, '6')

	

	local commTable = {
		{text = "You: Man, this cave kinda sucks, but I can't lose that bet, so I have to get to the end of the tunnel quick as I can!", buttons = {{button = 'c', text = '....'},},},
		{text = "You: I reckon I can move by `pressing` a,s,d,w or the arrow keys", buttons = {{button = 'c', text = '....'},},},
		{text = "You: Oh, but I didn't bring a keyboard, but I guess I could just walk...", buttons = {{button = 'c', text = '....'},},},
		level = 1,
	}
	
	
	
	commFunctions:newCommunication(commTable)
	
	
	
--add trigger zones	
	triggersFunctions:newTrigger(-25, 84, 174, 100, function()
	entitiesFunctions:newNPC(doors[1].x+2, doors[1].y, 'left')	
	entitiesFunctions:newNPCAnimation (1, player.x, player.y-15, function() npc[1].facing = 'down' end)
	
	
	
	
	
	
	
	
	
	
	
	--this convo actually comes second
	local postCommTable = {
		{text = 'You: That was weird... ', buttons = {{button = 'c', text = ' ...',}},},
		{text = 'You: Oh well, at least I got a free lanturn!', buttons = {{button = 'c', text = ' ...',}},},
		{text = 'Actually now that I think of it, I probably should have brought one with me... ', buttons = {{button = 'c', text = ' ...',}},},
		level = 1
	}
	--and this one is first
	local commTable = {
	-- table layout = text, buttons (buttonToPress,textResponse, Func)
	
		{text = 'Some Guy: Oh! There you are! I was worried that you had already gone into the dark!', buttons = {{button = 'c', text = 'You: Whats wrong with the dark?', func = function() player.facing = 'up' end,}},},
		{text = "Some Guy: What?! Have you never SEEN it? Its horrible stuff. I\'m totally against it; why nobody has made a law against it, I'll never know!", buttons = {{button = 'c', text = 'You: Ummm..... OK?'}},},
		{text = "Some Guy: Anyway, I have something I'd like to give you", buttons = {{button = 'c', text = 'Presents? For me?', func = function() player.lanturnBattery = 100 entitiesFunctions:addLight(love.graphics.getWidth()/2, love.graphics.getHeight()/2, 50, "playersLanturn")  end}},},
		{text = "Some Guy: Geez, calm down, it's just a lantern", buttons = {{button = 'c', text = 'You: Oh... Thankyou?'}},},
		{text = "Some Guy: Your welcome! Just rememeber that it will need to be recharged every so often, but it's solar powered so you can just leave it in the sunlight to recharge it, neat huh?", buttons = {{button = 'c', text = 'You: Umm, sure... but we\'re in a cave, so how does that help me?', }},},
		{text = "Some Guy: Hmm, maybe if you stand in the lamps scattered around it'll get enough light", buttons = {{button = 'c', text = 'You: ......right', }},},
		{text = "Some Guy:  :)", buttons = {{button = 'c', text = 'You: I\'m gonna go now....', func = function() 	entitiesFunctions:newNPCAnimation (1, doors[1].x+2, doors[1].y, function()  table.remove(npc, 1) 	commFunctions:newCommunication(postCommTable)  end) end }},},

		level = 1
	
	
	}
	
	









	
	commFunctions:newCommunication(commTable)


	end, false)
	
	triggersFunctions:newTrigger(-10, 550, 174, 570, function()
		local commTable = {
		{text = 'You: Man, my lanturn is already getting low on juice, hope I find some light soon...', buttons = {{button = 'c', text = ' ...', }},},
		level = 1
		}
		commFunctions:newCommunication(commTable)
	end)	
	
	triggersFunctions:newTrigger(-10, 600, 174, 610, function()
		local commTable = {
		{text = 'You: Wow, this place is pretty creepy, I thought there was supposed to be a-', buttons = {{button = 'c', text = ' ...', func = function() entitiesFunctions:addLight(85, 775, 100, 'flickeryLight', function(i,v) v.radius = math.random(math.random(140,150),math.random(150,155)) end) end }},},
		{text = 'You: ...', buttons = {{button = 'c', text = ' ...'}},},
		{text = 'You: This light is so feable, theres no WAY that is could possible charge my lanturn!', buttons = {{button = 'c', text = ' ...'}},},
		level = 1
		}
		commFunctions:newCommunication(commTable)
	end)
	
	
	triggersFunctions:newTrigger(-10, 720, 174, 730, function()
		local commTable = {
		{text = 'You: Well, I\'ll be, it actually charges! I\'m still going to have to try and try and keep my time down, however...', buttons = {{button = 'c', text = ' ...'}},},
		level = 1
		}
		commFunctions:newCommunication(commTable)
	end)
	
		
	triggersFunctions:newTrigger(1861, 421, 2029, 586, function()
		local commTable = {
		{text = 'You: Alright! Made it to the finish line, now to check my time...', buttons = {{button = 'c', text = ' ...', func = function() end  }},},
		{text = 'Your Time: '..player.time, buttons = {{button = 'c', text = ' ...', func = function() end }},},
		{text = 'You: Whelp, time to go home now...', buttons = {{button = 'c', text = ' ...', func = function() love.event.push('q') end }},},
		level = 1
		}
		commFunctions:newCommunication(commTable)
	end)
	
	
end


function gameFunctions:gameOver()
	gameFunctions:running(true)
end














































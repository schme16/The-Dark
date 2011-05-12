player = {
	x = 69, 
	y = 43,
	movementIncrement = 75,
	facing = 'down',
	image = {
		right = love.graphics.newImage('player/right.png'),
		left = love.graphics.newImage('player/left.png'),
		down = love.graphics.newImage('player/down.png'),
		up = love.graphics.newImage('player/up.png'),	
	},	
		
			
	colMap = collision:newCollisionMap('player/colMap.png'),
	lanturnBattery = false,
	inLight = true,
	time = 0, 
	timeStarted = os.time(),
	timeOffset = 0,
}
playerFunctions = {}

function playerFunctions:collisionCheck(x,y)
	local sprite1 = {x = x, y = y, image = player.image[player.facing], colMap = player.colMap}
	local sprite2 = {image = maps[game.level].image, x = maps[game.level].x, y = maps[game.level].y, colMap = maps[game.level].colMap,}
		
	return collision:checkCollision( sprite1, sprite2 )
end


function playerFunctions:movement()


	if love.keyboard.isDown('up') or love.keyboard.isDown('w') then
		player.facing = 'up'
		if not (playerFunctions:collisionCheck(player.x, player.y-playerFunctions:dtSpeed())) then player.y = player.y-playerFunctions:dtSpeed() end
		
	end
	
	if love.keyboard.isDown('down') or love.keyboard.isDown('s')  then
		player.facing = 'down'
		if not (playerFunctions:collisionCheck(player.x, player.y+playerFunctions:dtSpeed())) then player.y = player.y+playerFunctions:dtSpeed() end
		
	end
	
	if love.keyboard.isDown('left') or love.keyboard.isDown('a')  then
		player.facing = 'left'
		if not( playerFunctions:collisionCheck(player.x-playerFunctions:dtSpeed(), player.y) )then player.x = player.x-playerFunctions:dtSpeed() end
		
	end
	
	if love.keyboard.isDown('right') or love.keyboard.isDown('d')  then
		player.facing = 'right'
		if not (playerFunctions:collisionCheck(player.x+playerFunctions:dtSpeed(), player.y)) then player.x = player.x+playerFunctions:dtSpeed() end
	end

	

end


function playerFunctions:dtSpeed()
	return (player.movementIncrement*love.timer.getDelta())
end


function playerFunctions:update()
	if not(commFunctions.active) then
		playerFunctions:movement()
		player.x = round(player.x)
		player.y = round(player.y)
	end
	if cam then cam:setPos(vector(math.ceil(player.x), math.ceil(player.y))) end
	
	if player.lanturnBattery and not(commFunctions.active) then
		player.time = os.time()-(player.timeStarted+math.ceil(player.timeOffset))
		if player.inLight then
			if player.lanturnBattery < 100 then player.lanturnBattery = player.lanturnBattery + (love.timer.getDelta()*2) end
		else
			player.lanturnBattery = player.lanturnBattery - (love.timer.getDelta()*5)
		end
	elseif commFunctions.active then player.timeOffset = player.timeOffset +love.timer.getDelta()
	end
	
	if player.lanturnBattery and  player.lanturnBattery< 1 then
		player.lanturnBattery = false	
		entitiesFunctions:removeLight('playersLanturn')
		local commTable = {
		{text = 'You: Ahh Crap, the batteries went flat...', buttons = {{button = 'c', text = ' ...'  }},},
		{text = 'You: Guess I lose the bet...', buttons = {{button = 'c', text = ' ...' }},},
		{text = 'Game Over', buttons = {{button = 'c', text = ' ...', func = function() love.event.push('q') end  }},},
		level = 1
		}
		commFunctions:newCommunication(commTable)
	
	
	
	
	
	end	
end


function playerFunctions:draw()
	local x,y = cam:toCameraCoords(vector(player.x-1, player.y-1)):unpack()
	love.graphics.draw(player.image[player.facing],x,y)
end


function round(num, idp)
  if idp and idp>0 then
    local mult = 10^idp
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end




















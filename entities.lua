npc = {}
lights = {}
entitiesFunctions = {}
animations = {}

function entitiesFunctions:addLight(x, y, radius, tag, func)
	local newClass = {}
	newClass.x = x
	newClass.y = y
	newClass.radius = radius
	newClass.tag = tag
	newClass.func = func
	
	table.insert(lights, newClass)
end

function entitiesFunctions:setLightRadius(tag, radius)
	for i,v in ipairs(lights) do
		if v.tag == tag then
			v.radius = radius
		end
	end
end

function entitiesFunctions:removeLight(tag)
	for i,v in ipairs(lights) do
		if v.tag == tag then
			table.remove(lights, i)
		end
	end
end

function entitiesFunctions:newNPCAnimation(npcID, toX, toY, func)
	table.insert(animations, {npcID = npcID, toX = toX, toY = toY, func = func})
end

function entitiesFunctions:update()
	for i,v in ipairs(animations) do

		local actor = npc[v.npcID]
			actor.x = round(actor.x)
			actor.y = round(actor.y)
		
		local inc 
		if actor.y ~= v.toY then
			if v.toY <= actor.y then
				actor.facing = 'up'
				inc = playerFunctions:dtSpeed()*(-1)
			else
				actor.facing = 'down'
				inc = playerFunctions:dtSpeed()
			end			
			actor.y = actor.y +inc
		else
			if actor.x ~= v.toX  then
				if v.toX <= actor.x then
					inc = playerFunctions:dtSpeed()*(-1)
					actor.facing = 'left'
				else
					inc = playerFunctions:dtSpeed()
					actor.facing = 'right'
				end
				actor.x = actor.x +inc
			else
				if v.func then v.func() end
				table.remove(animations, i)
			end
			
		end
			
	end	
		
end

function entitiesFunctions:newNPC(x, y, facing)
	local newClass = {}
	newClass.x = x
	newClass.y = y
	newClass.image = {
		right = love.graphics.newImage('npc/right.png'),
		left = love.graphics.newImage('npc/left.png'),
		down = love.graphics.newImage('npc/down.png'),
		up = love.graphics.newImage('npc/up.png'),	
	}
	newClass.facing = facing
	
	table.insert(npc, newClass)
end

function entitiesFunctions:drawNPC()
	for i,v in ipairs(npc) do
		local x,y = cam:toCameraCoords(vector(v.x-1, v.y-1)):unpack()
		love.graphics.draw( v.image[v.facing],x,y)
	end
end

function entitiesFunctions:remove()
	
end



--Load Libs
	require 'camera'
	require 'vector'
	require 'encrypt'
	
	--setup table persistence
	require 'tablePersistence.lua'

	if json then 
		table.save = json.encode
		table.load = json.decode
	end


--init Variables
	cam = Camera(vector(love.graphics.getWidth()/2,love.graphics.getHeight()/2))
	
	media = {
		dirt = love.graphics.newImage('tiles/dirt.gif'),
		grass = love.graphics.newImage('tiles/grass.gif'),
		gravel = love.graphics.newImage('tiles/gravel.gif'),
		stoneSlab = love.graphics.newImage('tiles/stoneSlab.gif'),
		stoneWall = love.graphics.newImage('tiles/stoneWall.gif'),
		cordons = love.graphics.newImage('tiles/cordons.gif'),
	}
	
	system = { mapSize = 1500, blockSize = 32, currentMap = 1, currentMaterial = 'dirt', mode = "paintMap", matIndex =1, modeExtra = 'Material: Dirt', world = '1', grid = true, playerStart = false }

	system.materialList = {
		{image = 'dirt', name="Dirt"},
		{image = 'gravel', name="Gravel"},
		{image = 'grass', name="Grass"},
		{image = 'stoneSlab', name="Stone Slab"},
		{image = 'stoneWall', name="Stone Wall"},
	}
	
	mapFuncs = {}
	
	world = {}
	
	mouse = {l = false, r = false, x1 = false, x2 = false, wd = false, wu = false, }
	
	
	
	function getScale(img, max)
			tempScale = 100/img:getWidth()
			tempScale2 = 100/(max.width)
			width = (tempScale/tempScale2)
			
			tempScale = 100/img:getHeight()
			tempScale2 = 100/(max.height)
			height = (tempScale/tempScale2)	
			
			return  width, height
	end
	
	function mapFuncs:mapFill( size )
		local temp = {}
		local localDivisor = system.blockSize
		for i = localDivisor, size, localDivisor do
			local tempTable = {}
			for k = localDivisor, size, localDivisor do
				table.insert(tempTable,{image = false, solid = false})
			end

			
			table.insert(temp,tempTable)
		end
		return temp
	end
	
	function mapFuncs:initialize( size, num  )
			world[num]= mapFuncs:mapFill( size )
	end
	
	function mapFuncs:draw()
		if world and world[system.currentMap] then
			for i,v in ipairs(world[system.currentMap]) do
				for k,d in ipairs(v) do
					if type(media[d.image])=='userdata' then			
						local scaleX,scaleY = getScale(media[d.image]	, {width = system.blockSize, height = system.blockSize})
						love.graphics.draw(media[d.image],(i-1) * system.blockSize, (k-1) * system.blockSize,0,scaleX,scaleY)
					end
					
					if system.mode == 'setSolid' and d.solid then
						local scaleX,scaleY = getScale(media['cordons']	, {width = system.blockSize, height = system.blockSize})
						love.graphics.draw(media['cordons'],(i-1) * system.blockSize, (k-1) * system.blockSize,0,scaleX,scaleY)
					end
					
					if system.grid then
						love.graphics.setLineStyle('smooth')
						local r,g,b,a = love.graphics.getColor()
						love.graphics.setColor(255,255,255,150)
						love.graphics.quad("line", (i-1) * system.blockSize, (k-1) * system.blockSize, ((i-1) * system.blockSize) + system.blockSize, (k-1) * system.blockSize, ((i-1) * system.blockSize) + system.blockSize, ((k-1) * system.blockSize) + system.blockSize, (i-1) * system.blockSize, ((k-1) * system.blockSize) + system.blockSize)
						love.graphics.setColor(r,g,b,a)
					end
					
				end			
			end

		end

	end
	
	function mapFuncs:getTile(x,y,key)
		local tileX = math.ceil((x/system.blockSize))
		local tileY = math.ceil((y/system.blockSize))
		if type(tileX)=='number' and
		type(tileY)=='number' and
		world and
		type(world[system.currentMap])=='table' and
		type(world[system.currentMap][tileX]) =='table' and
		type(world[system.currentMap][tileX][tileY]) =='table' then
			return world[system.currentMap][tileX][tileY], tileX, tileY
		end
		return {}
	end
	
	function mapFuncs:paintMap(x,y, key)
		--expects screen based x,y
		local x,y = cam:mousepos():unpack()
		
		if love.mouse.isDown('l') then 
			mapFuncs:getTile(x,y).image = system.currentMaterial
		elseif love.mouse.isDown('r') then 
			mapFuncs:getTile(x,y).image = false
		end		
	end
	
	function mapFuncs:setSolid(x,y)
		--expects screen based x,y
		local x,y = cam:mousepos():unpack()
		if love.mouse.isDown('l') then 
			mapFuncs:getTile(x,y).solid = true
		elseif love.mouse.isDown('r') then 
			mapFuncs:getTile(x,y).solid = false
		end
	end
	
	function mapFuncs:setStart(x,y)
		--expects screen based x,y
		local x,y = cam:mousepos():unpack()
		local temp, tileX, tileY = mapFuncs:getTile(x,y)
		system.startPos = {tileX,tileY}
	end
	
	
	
	
	
	function drawFunc()
		local the = mapFuncs[system.mode]
		the(false,x,y)
		mapFuncs:draw()
		local isDown = love.keyboard.isDown
		if isDown('left') then
			cam:setX(cam:getX()-10) 
		end
		
		if isDown('right') then
			cam:setX(cam:getX()+10)
		end
		
		if isDown('up') then
			cam:setY(cam:getY()-10)
		end
		
		if isDown('down') then
			cam:setY(cam:getY()+10)
		end
	end
	
	function loadMap(num)
		local tempTable
		if not num then
			num = system.currentMap
		end
		
		tempTable = table.load(love.filesystem.read(system.world..'/'..num..'.map' ))
		
		system = tempTable.system
		world[num] = tempTable.map
	end
	
	function saveMap(num)
		if not num then
			num = system.currentMap
		end
		
		love.filesystem.write(system.world..'/'..num..'.map', table.save({system = system, map = world[num]}))
	end

	function loadOrInit(num)
		if not num then
			num = system.currentMap
		end	
		if love.filesystem.exists(system.world..'/'..num..'.map') then
			loadMap(num)
		else
			if not( love.filesystem.exists(system.world)) then love.filesystem.mkdir(system.world) end
			mapFuncs:initialize(system.mapSize, num)
			saveMap(num)
		end	
	end
	
	
	
	
	
	
	
	
	
	
	
	function love.load()
		math.randomseed(os.time())
		math.random()
		math.random()
		math.random()
		loadOrInit()
	end

	function love.mousepressed(x,y,key)
		if key =='wu' then
			cam:setZoom(cam:getZoom()+0.02)
		end
		
		if key =='wd' then
			cam:setZoom(cam:getZoom()-0.02)
		end	
		
		mouse[key] = true
		
	end
	function love.mousereleased(x,y,key)
		mouse[key] = false
	end
	
	function love.keypressed(key, unicode)
		if key == 'escape' then
			love.event.push('q')
		end
		
		--Change world
		if key =="1" then
			saveMap(system.currentMap)
			loadOrInit(1)
			system.currentMap = 1
		elseif key == "2"  then
			saveMap(system.currentMap)
			loadOrInit(2)
			system.currentMap = 2
		elseif  key == "3"  then
			saveMap(system.currentMap)
			loadOrInit(3)
			system.currentMap = 3
		elseif  key == "4"  then
			saveMap(system.currentMap)
			loadOrInit(4)
			system.currentMap = 4
		elseif  key == "5"  then
			saveMap(system.currentMap)
			loadOrInit(5)
			system.currentMap = 5
		elseif  key == "6"  then
			saveMap(system.currentMap)
			loadOrInit(6)
			system.currentMap = 6
		elseif  key == "7"  then
			saveMap(system.currentMap)
			loadOrInit(7)
			system.currentMap = 7
		elseif  key == "8"  then
			saveMap(system.currentMap)
			loadOrInit(8)
			system.currentMap = 8
		elseif  key == "9" then
			saveMap(system.currentMap)
			loadOrInit(9)
			system.currentMap = 9
		end
	
		--Change Tool
		if key =="f1" then
			system.mode = "paintMap"
			system.modeExtra = 'Material: '..system.materialList[system.matIndex].name
		elseif key =="f2"  then
			system.mode = "setSolid"
			local x,y = cam:mousepos():unpack()
			system.modeExtra = 	mapFuncs:getTile(x,y).solid
		elseif  key =="f3"  then
			system.mode = 'setStart'
			system.modeExtra = 'Current Pos: '..tostring(system.playerStart)
		elseif  key =="f4"  then
			--system.mode = 4
		elseif  key =="f5"  then
			--system.mode = 5
		elseif  key =="f6"  then
			--system.mode = 6
		elseif  key =="f7"  then
			--system.mode = 7
		elseif  key =="f8"  then
			--system.mode = 8
		elseif  key =="f9" then
			--system.mode = 9
		elseif  key =="f9" then
			--system.mode = 9
		elseif  key =="f11" then
			system.grid = not(system.grid)
		elseif  key =="f12" then
			saveMap()
		end
	
		if key == 'tab' then
			if system.matIndex == #system.materialList then system.matIndex = 0 end
			system.matIndex = system.matIndex + 1
			system.modeExtra = 'Material: '..system.materialList[system.matIndex].name

			system.currentMaterial = system.materialList[system.matIndex].image
		end
	
	
	end

	function love.draw()
		cam:draw(function() drawFunc() end)
		love.graphics.print(cam:getZoom(), love.graphics.getWidth()-60,5)
		love.graphics.print(system.currentMap, 5,5)
		local x,y = cam:mousepos():unpack()
		local tile = mapFuncs:getTile(x,y)
		
		love.graphics.print(tostring(system.mode), love.mouse.getX(),love.mouse.getY()-30)
		if system.mode == 'setSolid' then 
			local x,y = cam:mousepos():unpack()
			system.modeExtra = 	mapFuncs:getTile(x,y).solid
		end
		love.graphics.print(tostring(system.modeExtra), love.mouse.getX(),love.mouse.getY()-10)
		love.graphics.print(love.timer.getFPS(), 600,10)
		

	end

	
	
	
	
	
	
	
	
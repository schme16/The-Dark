	require 'supportFunctions'
	require 'TEsound'
	require 'input'
	require 'vector'
	require 'camera'
	require 'pPCollision'
	require 'entities'
	require 'game'
	require 'player'
	require 'hud'
	require 'fadeLib'
	require 'timer'
	require 'debug.lua'
	
	--setup table persistence
	require 'json.lua'

	if json then 
		table.save = json.encode
		table.load = json.decode
	end
--Globals

	system = {
		debug = false,
		version = 'rev15',
	}


		
	function love.load()
		love.graphics.setBackgroundColor(20,20,20)
		gameFunctions:newGame()
	end


	function love.update()



	end

	function love.keypressed(key)
		if keyboard then keyboard.newPress[key] = true end
	end
		
	function love.mousepressed(x,y,key)
		if key == 'wd' then key = 'wheelDown' end
		if key == 'wu' then key = 'wheelUp' end
		if mouse then mouse.newPress[key] = true end
	end

	function love.keyreleased(key)
		if keyboard then keyboard.newPress[key] = false end
	end
		
	function love.mousereleased(x,y,key)
		if mouse then  mouse.newPress[key] = false end
	end	

	function love.draw(dt)
		if gameFunctions then gameFunctions:run() end

	end
	
	if addDraw then addDraw('MainDraw', love.draw) end







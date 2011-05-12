function love.conf(t)
	t.title = "The Dark"
	t.author = "Shane Gadsby"
	t.email = "schme16@gmail.com"
	t.console = false
	t.modules.joystick = false   -- Enable the joystick module (boolean)
	t.modules.physics = false    -- Enable the physics module (boolean)
	t.screen.vsync = true       -- Enable vertical sync (boolean)
	t.screen.fsaa = 0           -- The number of FSAA-buffers (number)
	t.screen.width = 600       -- The window height (number)
	t.screen.height = 400       -- The window height (number)
end
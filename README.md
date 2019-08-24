# Simple-Button

[code]
require('simplebutton')

-- used for easy alignments
screen = { w = love.graphics.getWidth(), h = love.graphics.getHeight() }

function love.load()
   -- Create new button
   startButton = ButtonManager.new("Start Game", screen.w/2 - 50, screen.h/2 - 20, 100, 40)
   -- Set text alignment
   startButton.setAlignment('center')
   -- Set onClick function
   startButton.onClick = function()
      print("Start the game!")
   end
	
   quitButton = ButtonManager.new("Quit", screen.w/2 - 50, screen.h/2 + 30, 100, 40)
   quitButton.setAlignment('center')
   quitButton.onClick = function()
      love.event.quit()
   end
	
end

function love.draw()
   ButtonManager.draw()
end

function love.mousepressed( x, y, msbutton, istouch, presses )
   ButtonManager.mousepressed(x,y,msbutton)
end

function love.mousereleased( x, y, msbutton, istouch, presses )
   ButtonManager.mousereleased(x,y,msbutton)
end
[/code]
.
After this I saw some room for improvement, so I added defaults.
With defaults you can set a default anything for a button, even functions.
In the simplebutton.lua script, you can see what keywords you need to use for the defaults at the top.

This changes the love.load() to this:

[code]
   ButtonManager.default.width = 100
   ButtonManager.default.height = 40
   ButtonManager.default.alignment = 'center'

   startButton = ButtonManager.new("Start Game", screen.w/2 - 50, screen.h/2 - 20)
   startButton.onClick = function()
      print("Start the game!")
   end
	
   quitButton = ButtonManager.new("Quit", screen.w/2 - 50, screen.h/2 + 30)
   quitButton.onClick = function()
      love.event.quit()
   end
[/code]

The ButtonManager.new function actually looks like this:
[code]ButtonManager.new(label, x, y, width, height, toggle, color, pressedColor, toggledColor)[/code]

And with the toggle parameter you can make things like this:

[code]
require('simplebutton')

screen = { w = love.graphics.getWidth(), h = love.graphics.getHeight() }

function love.load()
   whale = love.graphics.newImage('whale.png')
   showImage = ButtonManager.new("Show", screen.w/2 - 50, screen.h/2 - 20, 100, 40, true)
end

function love.draw()
   love.graphics.setColor(1,1,1)
	
   if showImage.value == true then
      love.graphics.draw(whale)
   end
   
   ButtonManager.draw()
end

function love.mousepressed( x, y, msbutton, istouch, presses )
   ButtonManager.mousepressed(x,y,msbutton)
end

function love.mousereleased( x, y, msbutton, istouch, presses )
   ButtonManager.mousereleased(x,y,msbutton)
end
[/code]

Buttons also have an optional update call, this can be used for animation or this:

[code]
   movingButton = ButtonManager.new("Catch me!", 0, 0, 100, 40)
   movingButton.speed = 3
	
   movingButton.update = function()
      movingButton.x = movingButton.x + movingButton.speed 
      movingButton.textx = movingButton.textx + movingButton.speed 
   end
	
   movingButton.onClick = function()
      movingButton.speed = 0
      --Change the label
      movingButton.setLabel('Caught Me!')
      --Reset the alignment
      movingButton.setAlignment('center')
   end
[/code]

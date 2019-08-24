# Simple-Button

```lua
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
```

After this I saw some room for improvement, so I added defaults.
With defaults you can set a default anything for a button, even functions.
In the simplebutton.lua script, you can see what keywords you need to use for the defaults at the top.

This changes the love.load() to this:

```lua
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
```

The ButtonManager.new function actually looks like this:
```lua ButtonManager.new(label, x, y, width, height, toggle, color, pressedColor, toggledColor)```
And with the toggle parameter you can make things like this:

```lua
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
```

Buttons also have an optional update call, this can be used for animation or this:

```lua
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
```

MIT License

Copyright (c) 2019 Elijah Freeman

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

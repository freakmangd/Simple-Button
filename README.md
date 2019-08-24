# Simple Button

A small button library for love2D

## Functions:

```lua 
-- Create a new button
ButtonManager.new(label, x, y, width, height, toggle, color, pressedColor, toggledColor) 

-- Label of new button
string label ("Button")
-- X of the new button
number x (0)
-- Y of the new button
number y (0)
-- Width of the new button
number width (50)
-- Height of the new button
number height (50)
-- If the button toggles when pressed
boolean toggle (false)
-- Color of the button
Table color ({1,1,1,1})
-- Color of the button when pressed
Table pressedColor ({0.8,0.8,0.8,1})
-- Color of the button when toggled
Table toggledColor ({0.9,0.9,0.9,1})
```

More functions can be found in the simplebutton.lua script

## Examples

A typical button looks like this:

```lua
--                         Label, x, y, width, height
button = ButtonManager.new("Hello World!", 100, 100, 100,50)
```

### Main Menu
A full main menu might look like this:

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

### Defaults
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

### Toggling Buttons
An example of a button using a toggle

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

### Moving Buttons
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

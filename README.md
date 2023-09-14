# Simple Button

A small button library for love2D

## Functions

```lua 
-- Create a new button
ButtonManager.new(label, x, y, width, height, toggle, color, pressedColor, toggledColor) 

-- Arguments for ButtonManager.new:
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

-- button manager callbacks
ButtonManager.update(dt)
ButtonManager.draw(...)
ButtonManager.onmousepressed(x,y,msbutton)
ButtonManager.onmousereleased(x,y,msbutton)

-- button customization functions
Button:setLabel(text, alignment)
Button:setAlignment(alignment)
Button:setFont(font)
Button:setImage(image)

-- button callbacks you can override
Button:update(dt)
Button:draw()
Button:onClick()
Button:onRelease()

-- button callbacks you can override for toggle buttons
Button:onToggleOn()
Button:onToggleOff()
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
local ButtonManager = require('simplebutton')

-- used for easy alignments
local screen = { w = love.graphics.getWidth(), h = love.graphics.getHeight() }

function love.load()
   -- Create new button
   startButton = ButtonManager.new("Start Game", screen.w/2 - 50, screen.h/2 - 20, 100, 40)
   -- Set text alignment
   startButton:setAlignment('center')
   -- Set onClick function
   startButton.onClick = function()
      print("Start the game!")
   end
	
   quitButton = ButtonManager.new("Quit", screen.w/2 - 50, screen.h/2 + 30, 100, 40)
   quitButton:setAlignment('center')
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
Defaults allow you to set a default way to style a new button

This changes the love.load() to this:

```lua
ButtonManager.default.width = 100
ButtonManager.default.height = 40
ButtonManager.default.alignment = 'center'

local startButton = ButtonManager.new("Start Game", screen.w/2 - 50, screen.h/2 - 20)
startButton.onClick = function()
   print("Start the game!")
end
 
local quitButton = ButtonManager.new("Quit", screen.w/2 - 50, screen.h/2 + 30)
quitButton.onClick = function()
   love.event.quit()
end
```

Here are all the properties you can override in defaults:
```
label string
x number
y number
width number
height number
toggle boolean
fillType "fill"|"line"
color Color
pressedColor Color
toggledColor Color
disabledColor Color
font any
alignment Alignment
padding {x: number, y: number}
fontScale number
img any
update nil|function
draw nil|function
onClick nil|function
onRelease nil|function
onToggleOn nil|function
onToggleOff nil|function
roundPos nil|"floor"|"ceil"
```

### Toggling Buttons
An example of a button using a toggle

```lua
local ButtonManager = require('simplebutton')

local screen = { w = love.graphics.getWidth(), h = love.graphics.getHeight() }

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

### Updating Buttons
Buttons also have an optional update call, this can be used for animation or this:

```lua
local movingButton = ButtonManager.new("Catch me!", 0, 0, 100, 40)
movingButton.speed = 200
 
movingButton.update = function(self, dt)
   self.x = self.x + self.speed * dt
end
 
movingButton.onClick = function(self)
   self.speed = 0
   --Change the label
   self:setLabel('Caught Me!')
end
```

In order for this to work, you need to put this in love.update(dt)

```lua
function love.update(dt)
   ButtonManager.update(dt)
end
```

local bman = require('simplebutton')

-- used for easy alignments
local screen = { w = love.graphics.getWidth(), h = love.graphics.getHeight() }

local whale = love.graphics.newImage('whale.png')
local showImage

function love.load()
    bman.default.width = 100
    bman.default.height = 40
    bman.default.alignment = 'center'

    local startButton = bman.new("Start Game", screen.w / 2 - 50, screen.h / 2 - 20)
    startButton.onClick = function()
        print("Start the game!")
    end

    local quitButton = bman.new("Quit", screen.w / 2 - 50, screen.h / 2 + 30)
    quitButton.onClick = function()
        love.event.quit()
    end

    local movingButton = bman.new("Catch me!", 0, 0, 100, 40)
    movingButton.speed = 3

    movingButton.update = function(self)
        self.x = self.x + self.speed
    end

    movingButton.onClick = function(self)
        self.speed = 0
        self:setLabel('Caught Me!', 'center')
    end

    showImage = bman.new("Show", screen.w / 2 - 50, screen.h / 2 + 80, 100, 40, true)
end

function love.draw()
    love.graphics.setColor(1, 1, 1)

    if showImage.value == true then
        love.graphics.draw(whale)
    end

    bman.draw()
end

function love.update(dt)
    bman.update(dt)
end

function love.mousepressed(x, y, msbutton, istouch, presses)
    bman.mousepressed(x, y, msbutton)
end

function love.mousereleased(x, y, msbutton, istouch, presses)
    bman.mousereleased(x, y, msbutton)
end


--Simple Buttons v1.0

local ButtonManager = {}
ButtonManager.Buttons = {}

local lg = love.graphics

---@class Button
---@field enabled boolean
---@field interactable boolean
---@field label string
---@field x number
---@field y number
---@field width number
---@field height number
---@field roundPos nil|"floor"|"ceil"|
---@field toggle boolean
---@field fillType "fill"|"line"
---@field color Color
---@field pressedColor Color
---@field toggledColor Color
---@field font any
---@field fontScale number
---@field alignment Alignment
---@field padding {x: number, y: number}
---@field img any
---@field draw function
local Button = {
    update = function()
    end,
    onClick = function()
    end,
    onToggleOff = function()
    end,
    onRelease = function()
    end,
}
Button.__index = Button

---@alias Alignment "left"|"right"|"center"|"up"|"down"
---@alias Color { r: number, g: number, b: number, a: number? }

local function customFloor(num, roundPos)
    if roundPos == 'floor' then
        return math.ceil(num)
    elseif roundPos == 'ciel' then
        return math.ceil(num)
    else
        return num
    end
end

---@class ButtonManagerDefault
---@field label string
---@field x number
---@field y number
---@field width number
---@field height number
---@field toggle boolean
---@field fillType "fill"|"line"
---@field color Color
---@field pressedColor Color
---@field toggledColor Color
---@field font any
---@field alignment Alignment
---@field padding {x: number, y: number}
---@field fontScale number
---@field img any
---@field draw function 
---@field roundPos nil|"floor"|"ceil"
ButtonManager.default = {
    label = 'Button',
    x = 0,
    y = 0,
    width = 50,
    height = 50,
    toggle = false,
    fillType = 'fill',
    color = { 1, 1, 1, 1 },
    pressedColor = { 0.8, 0.8, 0.8, 1 },
    toggledColor = { 0.9, 0.9, 0.9, 1 },
    font = lg.getFont(),
    alignment = 'left',
    padding = { 0, 0 },
    fontScale = 1,
    img = nil,
    draw = function(self)
        if not self.interactable then
            self.currentColor = self.disaselfledColor
        end

        lg.setColor(self.currentColor[1], self.currentColor[2], self.currentColor[3], self.currentColor[4] or 1)

        if self.img ~= nil then
            lg.draw(self.img, self.x, self.y, 0, self.scale[1], self.scale[2])
        else
            lg.rectangle(self.fillType, self.x, self.y, self.width, self.height)
        end

        lg.setColor(0, 0, 0)

        lg.draw(self.text, customFloor(self.x + self.textx + self.padding[1], self.roundPos),
            customFloor(self.y + self.texty + self.padding[2], self.roundPos), 0, self.fontScale)
    end,
}

---Create a new button, if any of the arguments are nil they are pulled from ButtonManager.default
---@param label string? the text shown on the face of the button
---@param x number? the x position in pixles of the button
---@param y number? the x position in pixels of the button
---@param width number? the width in pixels of the button
---@param height number? the height in pixels of the button
---@param toggle boolean? whether or not this button is a toggleable button
---@param color Color? the color of the button when drawing
---@param pressedColor Color? the color of the button when pressed
---@param toggledColor Color? the color of the button when toggled on
---@return Button
function ButtonManager.new(label, x, y, width, height, toggle, color, pressedColor, toggledColor)
    local newButton = setmetatable({}, Button)

    newButton.label = label or ButtonManager.default.label
    newButton.font = ButtonManager.default.font
    if type(newButton.font) == 'string' then
        newButton.font = lg.newFont(newButton.font)
    end
    if newButton.font == nil then
        newButton.font = ButtonManager.defaultFont
    end

    newButton.x = x or ButtonManager.default.x
    newButton.y = y or ButtonManager.default.y
    newButton.textx = 0
    newButton.texty = 0
    newButton.width = width or ButtonManager.default.width
    newButton.height = height or ButtonManager.default.height

    newButton.fillType = ButtonManager.default.fillType
    newButton.color = color or ButtonManager.default.color
    newButton.pressedColor = pressedColor or ButtonManager.default.pressedColor
    newButton.toggledColor = toggledColor or ButtonManager.default.toggledColor
    newButton.disabledColor = { 0.2, 0.2, 0.2 }
    newButton.currentColor = newButton.color

    newButton.roundPos = ButtonManager.default.roundPos
    newButton.padding = ButtonManager.default.padding
    newButton.fontScale = ButtonManager.default.fontScale

    newButton.toggle = toggle or ButtonManager.default.toggle
    newButton.value = false

    newButton.enabled = true
    newButton.interactable = true

    newButton:setLabel(newButton.label)
    newButton:setAlignment(ButtonManager.default.alignment)

    newButton.draw = ButtonManager.default.draw

    table.insert(ButtonManager.Buttons, newButton)

    return newButton
end

---Updates all buttons
---@param dt number
function ButtonManager.update(dt)
    for _, v in ipairs(ButtonManager.Buttons) do
        if v.enabled then
            v:update(dt)
        end
    end
end

---Invokes the mousepressed event for all buttons
---@param x number
---@param y number
---@param button number
function ButtonManager.mousepressed(x, y, button)
    if button == 1 then
        for _, v in ipairs(ButtonManager.Buttons) do
            if v.enabled and v.interactable then
                if x > v.x and x < v.x + v.width and y > v.y and y < v.y + v.height then
                    if v.toggle then
                        v.value = not v.value

                        if v.value == true then
                            v:onClick()
                        else
                            v:onToggleOff()
                        end
                    else
                        v:onClick()
                    end

                    v.currentColor = v.pressedColor
                end
            end
        end
    end
end

---Invokes the mousereleased event for all buttons
---@param x number
---@param y number
---@param button number
function ButtonManager.mousereleased(x, y, button)
    if button == 1 then
        for _, v in ipairs(ButtonManager.Buttons) do
            if v.enabled then
                v:onRelease()

                if v.toggle then
                    if v.value == true then
                        v.currentColor = v.toggledColor
                    else
                        v.currentColor = v.color
                    end
                else
                    v.currentColor = v.color
                end
            end
        end
    end
end

---Invokes the draw event for all or one button
---if a button is not passed, it will draw all registered buttons
---@param b Button|nil
function ButtonManager.draw(b)
    if b then
        if b.enabled then
            b:draw()
        end
    else
        for _, v in ipairs(ButtonManager.Buttons) do
            ButtonManager.draw(v)
        end
    end
end

---Sets the label of the button along with optionally the alignment
---@param text string
---@param align Alignment?
function Button:setLabel(text, align)
    self.label = text
    self.text = lg.newText(self.font, text)

    if align ~= nil then
        self:setAlignment(align)
    end

    local tw, th = self.text:getWidth(), self.text:getHeight()

    self.rightX = self.x + self.width - tw * (1 / self.fontScale)
    self.centerX = self.x + (self.width / 2) - (tw / 2 * (1 / self.fontScale))
    self.leftX = self.x
    self.upY = self.y
    self.centerY = self.y + (self.height / 2) - (th / 2 * (1 / self.fontScale))
    self.downY = self.y + self.height - th * (1 / self.fontScale)
end

---Sets the alignment of the button
---@param align Alignment
function Button:setAlignment(align)
    self:setLabel(self.label)

    if align == 'center' then
        self.textx = self.centerX - self.x
        self.texty = self.centerY - self.y
    elseif align == 'right' then
        self.textx = self.rightX - self.x
        self.texty = self.centerY - self.y
    elseif align == 'left' then
        self.textx = self.leftX - self.x
        self.texty = self.centerY - self.y
    elseif align == 'up' then
        self.textx = self.centerX - self.x
        self.texty = self.upY - self.y
    elseif align == 'down' then
        self.textx = self.centerX - self.x
        self.texty = self.downY - self.y
    elseif align ~= 'none' then
        print('The string ' ..
        align .. ' is not an acceptable alignment type. possible values are: center, right, left, up, down')
    end
end

---Sets the font of the button
---@param font any
function Button:setFont(font)
    assert(type(font) == 'string' or type(font) == 'Font',
        'Argument "Font" in Button:setFont must be of type string or Font')
    if type(font) == 'string' then
        self.font = lg.newFont(font)
        self.text = lg.newText(self.font, self.label)
    elseif type(font) == 'Font' then
        self.font = font
    end
end

---Sets the image of the button
--if it's a string it will load the string as a path through love.graphics.newImage
---@param image string|any
function Button:setImage(image)
    if type(image) == 'string' then
        self.img = lg.newImage(image)
    else
        self.img = image
    end
    local imgWidth = self.img:getWidth()
    local imgHeight = self.img:getHeight()
    self.scale = { self.width / imgWidth, self.height / imgHeight }
end

return ButtonManager

--Simple Buttons v1.0

local ButtonManager = {}
ButtonManager.Buttons = {}

local Button = {}

local lg = love.graphics

ButtonManager.default = 
{ 
	label = 'Button',
	x = 0,
	y = 0,
	width = 50,
	height = 50,
	roundPos = 'none',
	toggle = false,
	fillType = 'fill',
	color = {1,1,1,1},
	pressedColor = {0.8,0.8,0.8,1},
	toggledColor = {0.9,0.9,0.9,1},
	font = lg.getFont(),
	alignment = 'left',
	padding = {0,0},
	fontScale = 1,
	img = nil,
	update = function(dt) end,
	onClick = function() end,
	onToggleOff = function() end,
	onRelease = function() end
}

function ButtonManager.new(label, x, y, width, height, toggle, color, pressedColor, toggledColor)
	
	local newButton = setmetatable({}, { __index = Button })
	
	newButton.label = label or "Button"
	newButton.font = ButtonManager.default.font
	if type(newButton.font) == 'string' then
		newButton.font = lg.newFont(newButton.font)
	end
	if newButton.font == nil then
		newButton.font = ButtonManager.defaultFont
	end
	
	newButton.x = x or ButtonManager.default.x
	newButton.y = y or ButtonManager.default.y
	newButton.textx = newButton.x
	newButton.texty = newButton.y
	newButton.width = width or ButtonManager.default.width
	newButton.height = height or ButtonManager.default.height
	newButton.roundPos = 'none'
	
	newButton.fillType = ButtonManager.default.fillType
	newButton.color = color or ButtonManager.default.color
	newButton.pressedColor = pressedColor or ButtonManager.default.pressedColor
	newButton.toggledColor = toggledColor or ButtonManager.default.toggledColor
	newButton.disabledColor = {0.2,0.2,0.2}
	newButton.currentColor = newButton.color
	
	newButton.padding = ButtonManager.default.padding
	newButton.fontScale = ButtonManager.default.fontScale
	
	newButton.toggle = toggle or ButtonManager.default.toggle
	newButton.value = false
	
	newButton.enabled = true
	newButton.interactable = true
	
	newButton.update = ButtonManager.default.update
	newButton.onClick = ButtonManager.default.onClick
	newButton.onToggleOff = ButtonManager.default.onToggleOff
	newButton.onRelease = ButtonManager.default.onRelease

	newButton:setLabel(newButton.label)
	newButton:setAlignment(ButtonManager.default.alignment)
		
	table.insert(ButtonManager.Buttons, newButton)
	
	return newButton
	
end

function ButtonManager.update(dt)
	
	for k,v in ipairs(ButtonManager.Buttons) do
		if v.enabled then
			v.update(dt)
		end
	end
	
end

function ButtonManager.mousepressed(x, y, button)
	
	if button == 1 then	
		for k,v in ipairs(ButtonManager.Buttons) do
			if v.enabled and v.interactable then
			if x > v.x and x < v.x + v.width and y > v.y and y < v.y + v.height then
				
				if v.toggle then
					v.value = not v.value
					
					if v.value == true then
						v.onClick()
					else
						v.onToggleOff()
					end
				else
					v.onClick()
				end
				
				v.currentColor = v.pressedColor
			end
			end
		end
    end

end

function ButtonManager.mousereleased(x, y, button)
	
	if button == 1 then	
		for k,v in ipairs(ButtonManager.Buttons) do
			if v.enabled and v.interactable then
				v.onRelease()
				
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

function ButtonManager.draw(b)
	if b then
		if b.enabled then
	
		if not b.interactable then
			b.currentColor = b.disabledColor
		end
	
		lg.setColor(b.currentColor[1], b.currentColor[2], b.currentColor[3], b.currentColor[4] or 1)

		if b.img ~= nil then			
			lg.draw(b.img, b.x, b.y, 0, b.scale[1], b.scale[2])
		else
			lg.rectangle(b.fillType, b.x, b.y, b.width, b.height)
		end
		
		lg.setColor(0,0,0)
		
		lg.draw(b.text, ButtonManager.customFloor(b.textx + b.padding[1], b.roundPos), ButtonManager.customFloor(b.texty + b.padding[2], b.roundPos), 0, b.fontScale)
		
		end
	else
		for _,v in ipairs(ButtonManager.Buttons) do
			ButtonManager.draw(v)
		end
	end
end

function ButtonManager.customFloor(num, b)
	if b.roundPos == 'floor' then
		return math.ciel(num)
	elseif b.roundPos == 'ciel' then
		return math.ciel(num)
	else 
		return num
	end
end

function Button:setLabel(text, align)
	
	self.label = text
	self.text = lg.newText(self.font, text)
	
	if align ~= nil then
		self.setAlignment(align)
	end

	local tw, th = self.text:getWidth(), self.text:getHeight()

	self.rightX = self.x + self.width - self.text:getWidth()*(1/self.fontScale)
	self.centerX = self.x + (self.width/2) - (self.text:getWidth()/2*(1/self.fontScale))
	self.leftX = self.x
	self.upY = self.y
	self.centerY = self.y + (self.height/2) - (self.text:getHeight()/2*(1/self.fontScale))
	self.downY = self.y + self.height - self.text:getHeight()*(1/self.fontScale)
	
end

function Button:setAlignment(align)

	self.setLabel(self.label)
	
	if align == 'center' then
		self.textx = self.centerX
		self.texty = self.centerY
	elseif align == 'right' then
		self.textx = self.rightX
		self.texty = self.centerY
	elseif align == 'left' then
		self.textx = self.leftX
		self.texty = self.centerY
	elseif align == 'up' then
		self.textx = self.centerX
		self.texty = self.upY
	elseif align == 'down' then
		self.textx = self.centerX
		self.texty = self.downY
	elseif align ~= 'none' then
		print('The string ' .. align .. ' is not an acceptable alignment type. self.setLabel(' .. align .. ')')
	end
end

function Button:setFont(font)
	assert(type(font) == 'string' or type(font) == 'Font', 'Argument "Font" in Button:setFont must be of type string or Font')
	if type(font) == 'string' then
		self.font = lg.newFont(font)
		self.text = lg.newText(self.font, self.label)
	elseif type(font) == 'Font' then
		self.font = font
	end
end

function Button:setImage(image)
	if type(image) == 'string' then
		self.img = lg.newImage(image)
	else
		self.img = image
	end
	local imgWidth = self.img:getWidth()
	local imgHeight = self.img:getHeight()
	self.scale = {self.width / imgWidth, self.height / imgHeight}
end

return ButtonManager
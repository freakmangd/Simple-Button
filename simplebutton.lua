--Simple Buttons v1.0

ButtonManager = {}
ButtonManager.Buttons = {}

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
	font = love.graphics.getFont(),
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
	
	local newButton = {}
	
	newButton.label = label or "Button"
	newButton.font = font or ButtonManager.default.font
	if type(newButton.font) == 'string' then
		newButton.font = love.graphics.newFont(newButton.font)
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
	
	function newButton.setLabel(text, align)
	
		newButton.label = text
		newButton.text = love.graphics.newText(newButton.font, text)
		
		if align ~= nil then
			newButton.setAlignment(align)
		end
	
		newButton.rightX = newButton.x + newButton.width - newButton.text:getWidth()*(1/newButton.fontScale)
		newButton.centerX = newButton.x + (newButton.width/2) - (newButton.text:getWidth()/2*(1/newButton.fontScale))
		newButton.leftX = newButton.x
		newButton.upY = newButton.y
		newButton.centerY = newButton.y + (newButton.height/2) - (newButton.text:getHeight()/2*(1/newButton.fontScale))
		newButton.downY = newButton.y + newButton.height - newButton.text:getHeight()*(1/newButton.fontScale)
		
	end
	
	newButton.setLabel(newButton.label)
	
	function newButton.setAlignment(align)
	
		newButton.setLabel(newButton.label)
		
		if align == 'center' then
			newButton.textx = newButton.centerX
			newButton.texty = newButton.centerY
		elseif align == 'right' then
			newButton.textx = newButton.rightX
			newButton.texty = newButton.centerY
		elseif align == 'left' then
			newButton.textx = newButton.leftX
			newButton.texty = newButton.centerY
		elseif align == 'up' then
			newButton.textx = newButton.centerX
			newButton.texty = newButton.upY
		elseif align == 'down' then
			newButton.textx = newButton.centerX
			newButton.texty = newButton.downY
		elseif align ~= 'none' then
			print('The string ' .. align .. ' is not an acceptable alignment type. newButton.setLabel(' .. align .. ')')
		end
	end
	
	newButton.setAlignment(ButtonManager.default.alignment)
	
	function newButton.setFont(font)
		if type(font) == 'string' then
			newButton.font = love.graphics.newFont(font)
			newButton.text = love.graphics.newText(newButton.font, newButton.label)
		elseif type(font) == 'Font' then
			newButton.font = font
		else
			print("FONT NOT OF TYPE FONT, simplebutton.lua newButton.setFont(font) (line 42)")
		end
	end
	
	function newButton.setImage(image)
		if type(image) == 'string' then
			newButton.img = love.graphics.newImage(image)
		else
			newButton.img = image
		end
		local imgWidth = newButton.img:getWidth()
		local imgHeight = newButton.img:getHeight()
		newButton.scale = {newButton.width / imgWidth, newButton.height / imgHeight}
	end
	
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

function ButtonManager.draw()

	for k,v in ipairs(ButtonManager.Buttons) do
		if v.enabled then
	
		if not v.interactable then
			v.currentColor = v.disabledColor
		end
	
		love.graphics.setColor(v.currentColor[1], v.currentColor[2], v.currentColor[3], v.currentColor[4] or 1)

		if v.img ~= nil then			
			love.graphics.draw(v.img, v.x, v.y, 0, v.scale[1], v.scale[2])
		else
			love.graphics.rectangle(v.fillType, v.x, v.y, v.width, v.height)
		end
		
		love.graphics.setColor(0,0,0)
		
		love.graphics.draw(v.text, ButtonManager.customFloor(v.textx + v.padding[1], v.roundPos), ButtonManager.customFloor(v.texty + v.padding[2], v.roundPos), 0, v.fontScale)
		
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
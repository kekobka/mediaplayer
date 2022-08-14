--@client
--[[
--@include koptilnya/gui/render_devices/screen.txt
--@include /koptilnya/gui/render_devices/hud.txt
--@include /koptilnya/gui/gui.txt
--@include /koptilnya/gui/elements/panel.txt
--@include /koptilnya/gui/elements/button.txt
--@include /koptilnya/gui/elements/icon_button.txt
--@include /koptilnya/gui/elements/label.txt
--@include /koptilnya/gui/elements/shape.txt
--@include /koptilnya/gui/elements/checkbox.txt
--@include /koptilnya/gui/elements/labeled_checkbox.txt
--@include /koptilnya/gui/elements/radio.txt
--@include /koptilnya/gui/elements/textbox.txt
--@include /koptilnya/gui/segoe_mdl2_assets_icons.txt

require("/koptilnya/gui/render_devices/screen.txt")
require("/koptilnya/gui/render_devices/hud.txt")
require("/koptilnya/gui/gui.txt")
require("/koptilnya/gui/elements/panel.txt")
require("/koptilnya/gui/elements/button.txt")
require("/koptilnya/gui/elements/icon_button.txt")
require("/koptilnya/gui/elements/label.txt")
require("/koptilnya/gui/elements/shape.txt")
require("/koptilnya/gui/elements/checkbox.txt")
require("/koptilnya/gui/elements/labeled_checkbox.txt")
require("/koptilnya/gui/elements/radio.txt")
require("/koptilnya/gui/elements/textbox.txt")

segoeIcons = require("/koptilnya/gui/segoe_mdl2_assets_icons.txt")

if player() == owner() then
    local show = false
    
    local renderDevice = RenderDeviceHUD:new()

    local gui = GUI:new(renderDevice)
    gui:setVisible(show)
    
    local panel = EPanel:new()
    panel:setPos((1920 - 1280) / 2, 0)
    panel:setSize(600, 805.5)
    panel:setTitle("MediaPlayer By Valera")
    panel:setParentLock(true)
    panel:setCloseable(false)
    gui:add(panel)
    Buttons = {}
    for I = 1 , 50 do
    local button = EIconButton:new()
    button:setPos(11, 43+(I-1)*15)
    button:setEnabled(true)
    button:setSize(578, 15)
    button:setText("")
    button.onMousePressed = function(_, x, y, key, keyName)
        if keyName == "MOUSE1" then
            if not data[I] then return end
            sendBass(I,data[I])
        end
    end
    Buttons[I] = button
    panel:addChild(button)
    end
    hook.add("inputPressed", "_inputPressed", function(key)
        local keyName = input.getKeyName(key)
        
        if string.lower(keyName) == "t" then
            show = !show
            input.enableCursor(show)
            gui:setVisible(show)
        end
    end)

end

]]
if player() != owner() then return end
enableHud(owner(),true)
local fontArial16 = render.createFont("Arial",16,582,true,false,false,false,0,false,0)
render.createRenderTarget("hudRT")
local function inrange(p,pMin,pMax)
    if p.x > pMin.x and p.x < pMax.x and p.y > pMin.y and p.y < pMax.y then
        return true
    end
    return false
end

gui = class("gui")
panel = class("panel")
button = class("button")
Buttons = {}

function gui:initialize()
    self.visible = false
    self.openKey = "t"
    self.elements = {}
    self.buttons = {}
    self.mouse = Vector(0,0)
    self.used = false
    hook.add("inputPressed", "_inputPressed", function(key)
        local keyName = input.getKeyName(key)
        
        if string.lower(keyName) == self.openKey then
            show = !show
            input.enableCursor(show)
            self:setVisible(show)
        end
        if string.lower(keyName) == "mouse1" then
            if not self.visible then return end
            self.used = true 
            for _,element in ipairs(self.buttons) do
                local Pos = element:getPos()
                local Size = element:getSize()
                if self.used and inrange(self.mouse,Pos,Pos+Size) then
                    element.onMousePressed()
                end
                
            end
        end

    end)
    hook.add("inputReleased", "_inputReleased", function(key)
        local keyName = input.getKeyName(key)
        if string.lower(keyName) == "mouse1" then
            self.used = false
        end
    end)
end
function gui:setVisible(enable)
    self.visible = enable
    if self.visible then
        hook.add("drawhud","draw",function()
            local x , y = input.getCursorPos()
            self.mouse = Vector(x,y)
            for _,element in ipairs(self.elements) do
                element:draw()
            end
        end)
    else
        hook.remove("drawhud","draw")

    end
end

function gui:addButton(Pos,Size)
    self.button = button:new(Pos,Size)
    table.forceInsert(self.elements,self.button)
    table.forceInsert(self.buttons,self.button)
    return self.button
end

function gui:setKey(key)
    self.openKey = key
end

function button:initialize(Pos,Size)
    self.Pos = Pos
    self.Size = Size or Vector(10,10)
    self.text = nil
end


function button:draw()
    
    render.setColor(Color(70,70,70))
    render.drawRect(self.Pos.x,self.Pos.y,self.Size.x,self.Size.y)
    if self.text == nil then return end
    render.setColor(Color(200,200,200))
    render.setFont(fontArial16)
    render.drawText(self.Pos.x+self.Size.x/2,self.Pos.y,self.text,1)

end


function button:setPos(Pos)
    self.Pos = Pos
end
function button:getPos(Pos)
    return self.Pos
end
function button:setSize(Size)
    self.Size = Size
end

function button:getSize()
    return self.Size
end

function button:setText(text)
    self.text = text
end



GUI = gui:new()

for i = 1, 50 do
    local B = GUI:addButton(Vector(500,50+i*16+25),Vector(496,15))
    Buttons[i] = B
    B.onMousePressed = function()            
        if not data or not data[i] then return end
        sendBass(i,data[i])
    end
    
end



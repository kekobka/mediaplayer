--@name VK MediaPlayer
--@author valera
--@shared
--@model models/sprops/rectangles/size_2/rect_12x12x3.mdl

--@include ./inc/chatcommands.lua
--@include ./inc/bass.lua
--@include ./inc/gui.lua
--include ./inc/filesystem.lua --ustarelo
--@include ./inc/token.lua

require './inc/chatcommands.lua'
require './inc/bass.lua'
require './inc/gui.lua'
--require 'mediaplayer/filesystem.lua' --ustarelo
require './inc/token.lua'

fade = 1000
Volume = 1
flags = "3d noblock"

----------------------------------------

local FPS = 24
local scale = 0.8
chip():setColor(Color(0,0,0,0))

if CLIENT then
    local next_frame = 0
    local fps_delta = 1/FPS
    render.createRenderTarget("screenRT")
    local screenMat = material.create("VertexLitGeneric") 
    screenMat:setTextureRenderTarget("$basetexture", "screenRT") 
    screenMat:setInt("$flags", 138414080)
    local Font = render.createFont("HudNumbers", 250,1000,false,false,true,true,true,true,0)
    local screen = holograms.create(chip():localToWorld(Vector(5.08, 0, 0)*scale), chip():localToWorldAngles(Angle(90,0,0)), "models/holograms/plane.mdl")
    screen:setSize(Vector(2.5, 5.5, 0.1)*scale)
    screen:setParent(chip())

    screen:setMaterial("!" .. screenMat:getName())
    initialChipName = initialChipName or string.gsub(chip():getChipName(),'_',' ')
    hook.add("renderoffscreen", "update", function()

        local now = timer.systime()
        if next_frame > now then return end
        next_frame = now + fps_delta

        render.setFilterMin(1)
        render.setFilterMag(1)
        render.selectRenderTarget("screenRT")
        render.clear(Color(0,0,0,255))
        render.setColor(Color(84,139,84))
        render.drawRectFast(0,0,1024,1024)
        render.setColor(Color(139*0.3,126*0.3,102*0.3))
        render.setFont("CloseCaption_Bold")                                                                                                                                                                                                                                                                                                                                                                                             
        render.drawSimpleText(512-render.getTextSize(initialChipName)/2,24,initialChipName)                                                                                                                                                                                                                                                                                                                                                                                                                   
        render.setFont("CloseCaption_BoldItalic")                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
        render.drawSimpleText(512-render.getTextSize("By valera 41")/2,1000,"By valera 41")                                                                                                                                                                                                                                                                                                                                                                                                                                                             
        if string.gsub(chip():getChipName(),'_',' ') == initialChipName then return end
        now2 = (now2 or 0) + fps_delta*512
        render.setFont(Font)
        local S,SS = render.getTextSize(chip():getChipName():sub(15))
        if now2 >= 1024 + S then now2 = 0 end
        render.drawText(1024-now2,324-SS/2,chip():getChipName():sub(15))
        if not isValid(sound) or Online then return end
        local Tim = sound:getLength() - sound:getTime()
        local T,TT = render.getTextSize(string.toMinutesSeconds(Tim))
        render.drawText(512-T/2,700-TT/2,string.toMinutesSeconds(Tim))
    end)
else
    H = holograms.create(chip():getPos(), chip():getAngles(), "models/holograms/cube.mdl")H:setParent(chip())H:setSize(Vector(10,9.3,3.2)*scale)H:setColor(Color(150,150,150))
    H = holograms.create(chip():localToWorld(Vector(5, 4, 0)*scale), chip():localToWorldAngles(Angle(90,0,0)), "models/holograms/cube.mdl")H:setParent(chip())H:setSize(Vector(3.5,2.5,0.2)*scale)H:setColor(Color(50,50,50))
    H = holograms.create(chip():localToWorld(Vector(5, -4, 0)*scale), chip():localToWorldAngles(Angle(90,0,0)), "models/holograms/cube.mdl")H:setParent(chip())H:setSize(Vector(3.5,2.5,0.2)*scale)H:setColor(Color(50,50,50))
    H = holograms.create(chip():localToWorld(Vector(5, 0, 1.5)*scale), chip():localToWorldAngles(Angle(90,0,0)), "models/holograms/cube.mdl")H:setParent(chip())H:setSize(Vector(0.5,5.5,0.2)*scale)H:setColor(Color(50,50,50))
    H = holograms.create(chip():localToWorld(Vector(5, 0, -1.5)*scale), chip():localToWorldAngles(Angle(90,0,0)), "models/holograms/cube.mdl")H:setParent(chip())H:setSize(Vector(0.5,5.5,0.2)*scale)H:setColor(Color(50,50,50))
    H = holograms.create(chip():localToWorld(Vector(5.2, 4, 0)*scale), chip():localToWorldAngles(Angle(90,0,0)), "models/holograms/hq_rcylinder_thin.mdl")H:setParent(chip())H:setSize(Vector(1.5,1.5,0.4)*scale)H:setColor(Color(50,50,50))
    H = holograms.create(chip():localToWorld(Vector(5.2, -4, 0)*scale), chip():localToWorldAngles(Angle(90,0,0)), "models/holograms/hq_rcylinder_thin.mdl")H:setParent(chip())H:setSize(Vector(1.5,1.5,0.4)*scale)H:setColor(Color(50,50,50))
    
end


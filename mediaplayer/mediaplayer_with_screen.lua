--@name VK MediaPlayer with screen
--@author valera
--@shared


--@include ./inc/chatcommands.lua
--@include ./inc/bass.lua
--@include ./inc/gui.lua
--@include ./inc/token.lua

require './inc/chatcommands.lua'
require './inc/bass.lua'
require './inc/gui.lua'
require './inc/token.lua'

fade = 1000
Volume = 1
flags = "3d noblock"
shaker = 100 
----------------------------------------
shareScripts(false)
if SERVER then
    noDuplications()
    linkComponent("models/hunter/plates/plate2x2.mdl",chip(),true)
else
    local matet = material.create("UnlitGeneric")
    function setCover(check)

        if type(data) != "table" then return end
        if not permissions or lachcover == data[check].cover then return end
        if data[check].cover == "" then data[check].cover = "https://i.imgur.com/4XtUi6p.jpg" end
        COVER = false
        lachcover = data[check].cover
        matet:setTextureURL("$basetexture", data[check].cover, function(W,_,_,_,resize) if not W then return end resize(0, 0, 1024, 1024) end)
        COVER = true
    end
    function draw()
        render.setFilterMag(1)
        if not permissions then render.drawText(256,256,"press E  "..player():getName(),1) return end
        
        if COVER then
            local sum = fft_sum or 0
            render.setColor(Color(255,255,255,math.min( (32 + sum * 64)*5,255) ))
            render.setMaterial(matet)
            render.drawTexturedRect(-sum * 175 / 2 + math.rand(-math.clamp(sum-0.1,0,9^9)*shaker,math.clamp(sum-0.1,0,9^9)*shaker),-sum * 175 / 2 + math.rand(-math.clamp(sum-0.1,0,9^9)*shaker,math.clamp(sum-0.1,0,9^9)*shaker),512 + sum * 175,512 + sum * 175)
        end

        if not isValid(sound) then return end
            local fft = sound:getFFT(5)
            fft_sum = 0
            for i = 3, 16 do
                if not fft[i] then continue end
                fft_sum = fft_sum + fft[i] / 16
            end
    end
    hook.add("render","",draw)
end
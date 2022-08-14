--@shared
--@include ./util.lua
require './util.lua'

if CLIENT then
    function sendtime()
        if not isValid(sound) then return end
        net.start("timer")
        net.writeFloat(sound:getTime())
        net.send(nil,false)
    end
    local function setMusicPos()
        local musvol, musPos = Volume-(eyePos()):getDistance(chip():getPos())/(fade/Volume), D2 and (eyePos()+eyeVector()*50) or chip():getPos()
        if isValid(sound) and isValid(chip()) then if Pause then sound:pause() sound:play() end sound:setVolume(musvol) sound:setPos(musPos)
            if not timer.exists("updateTimer") then
                timer.create("updateTimer",1,0,sendtime)
            end
        else hook.remove("think","setMusic") end
    end
    timer.create("time",1,0,function()
    if not isValid(sound) then timer.stop("time") return end
    if player() == owner() then hook.add("tick", "nextmusic", function() nextTime = sound:getLength() - sound:getTime() if not Online and nextTime<1 and not next then nextMusic() end end) end
    if not Online and gotime > 0.1 then sound:setTime(1+gotime) end
    
    timer.stop("time")
    end)
    function setSound(url,name,time)
        gotime = time or 0
        if not permissions then setStatus("Playing: "..name.."(NO PERMISSIONS)") return end
        setStatus("Loading: "..name) 
        bass.loadURL(url,flags,function(snd,err)
            if isValid(sound) then sound:stop() end
            sound = snd
            next = false
            if not isValid(sound) then setStatus("Failed: "..err)  return end
            Online = sound:getLength() < 1
            if not snd then setStatus("loading error: "..err) return end
            hook.add("think","setMusicPos",setMusicPos)
            setStatus("Playing: "..name) 
            snd:setLooping(replay)
            snd:setPitch(Pitch/100)
            timer.start("time")
        end)
    end

    
    function nextMusic()
        if next or replay or #data <= 1 then return end
        albomID = albomID or 1
        albomID = albomID + 1
        next = true
        if albomID > #data then albomID = 1 end
        sendBass(albomID,data[albomID])
    end

    
    function giveMeBass()
        net.start("giveMebass")
        net.send() 
    end
    function sendBass(id,data)
        albomID = id
        net.start("bass")
        net.writeFloat(id)
        net.writeString(data.url)
        net.writeString(data.name)
        net.send() 
    end
    net.receive("client",function()
        MusicID = net.readFloat()
        local bass = net.readString()
        local name = net.readString()
        local time = net.readFloat()
        if bass == "" then return end
        if setCover then setCover(MusicID) end
        setSound(bass,name,time)
    end)
else
    function clientSend(ply,ply1)
        net.start("client")
        net.writeFloat(id or 1)
        net.writeString(Bass or "")
        net.writeString(name or "")
        net.writeFloat(Time or 0)
        if type(ply) == "Player" then send = ply else send = ply1 end
        net.send(send,false)
    end
    function client(id,Bass,name)
        net.start("client")
        net.writeFloat(id or 1)
        net.writeString(Bass or "")
        net.writeString(name or "")
        net.send(nil,false)
    end

    net.receive("bass",function()
        id = net.readFloat()
        Bass = net.readString()
        name = net.readString()
        net.start("client")
        net.writeFloat(id)
        net.writeString(Bass)
        net.writeString(name)
        net.send(nil,false)
    end)
    net.receive("timer",function()
        Time = net.readFloat()
    end)
    hook.add("ClientInitialized", "ClientInitialized", clientSend)
    net.receive("giveMebass",clientSend)
end



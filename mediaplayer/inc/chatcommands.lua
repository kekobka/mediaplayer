--@include ./util.lua
--@include ./httpparser.lua
require './httpparser.lua'
require './util.lua'


succes,Pitch,Pause,replay = true,100,true,false

local commands = {}
local unsensitiveCommands = {}

local chatCommands = {
    allowedPrefixes = "!",
    caseSensitive = false
}
local function handleChatCommands( ply, msg, isTeam, isDead )
    if ply != owner() or not string.match( msg[1], "[" .. chatCommands.allowedPrefixes .. "]" ) then return end
    
    isDead = isDead or not ply:isAlive()

    local args = string.split( msg, " " )

    local command = table.remove( args, 1 ):sub( 2 )

    if chatCommands.caseSensitive then
        if not commands[command] then return end

        return commands[command]( ply, msg, isTeam, isDead, unpack( args ) )
    end

    command = string.lower( command )
    if not unsensitiveCommands[command] then return end

    return unsensitiveCommands[command]( ply, msg, isTeam, isDead, unpack( args ) )
end

local hookName = SERVER and "PlayerSay" or "PlayerChat"
hook.add( hookName, "HandleChatCommands", handleChatCommands )


command = setmetatable( chatCommands, {
    __newindex = function( tbl, key, value )
        commands[key] = value
        unsensitiveCommands[string.lower( key )] = value
    end
} )

    function command:s(msg,isTeam, isDead, ... ) --search
        local data = findmusicByrequest(msg:sub(4),"audio.search")
        return ""
    end
    function command:r(msg,isTeam, isDead, ... ) --search random
        local rand = ""
        for _ = 1, 4 do
            rand = rand..table.random(string.toTable("qwertyuiopasdfghjklzxcvbnm"))
        end
        print(rand)
        local data = findmusicByrequest(rand,"audio.search")
        return ""
    end
    function command:vk(msg,isTeam, isDead, ... ) --moi audio vk
        local data = findmusicByrequest("","audio.get",...)
        return ""
    end
    function command:rec(msg,isTeam, isDead, ... ) --Recommendations
        local data = findmusicByrequest("","audio.getRecommendations")
        return ""
    end
    function command:pop(msg,isTeam, isDead, ... ) --Popular
        local data = findmusicByrequest("","audio.getPopular")
        return ""
    end

    function chatCommands:pa() -- pause/play
        net.start("pause")
        net.send()
        return ""
    end
    
    function chatCommands:vol(msg,isTeam, isDead,... ) --volume
        if ... == nil then return "" end
        if tonumber(...) == nil then return "" end
        net.start("volume")
        net.writeFloat(tonumber(...))
        net.send()
        return ""
    end
    
    function chatCommands:pi(msg,isTeam, isDead,... ) --pitch
        if ... == nil then return "" end
        if tonumber(...) == nil then return "" end
        net.start("pitch")
        net.writeFloat(tonumber(...))
        net.send()
        return ""
    end
    
    function chatCommands:t(msg,isTeam, isDead,... ) --peremotka time
        if ... == nil then return "" end
        if tonumber(...) == nil then return "" end
        Peremot = (Peremot or 0 ) + tonumber(...)
        net.start("peremotka")
        net.writeFloat(tonumber(...))
        net.send()
        return ""
    end
    
    function chatCommands:rep() -- reply on/off
        net.start("reply")
        net.send()
        return ""
    end
    
    function chatCommands:D2() -- 2d/3d sound
        net.start("D2")
        net.send()
        return ""
    end
    function chatCommands:u(msg) -- url radio
        net.start("urlRADIO")
        net.writeString(msg:sub(4))
        net.send()
        return ""
    end

--[[
function chatCommands:my()
    net.start("getMyMusic")
    net.send()
    return ""
end

function chatCommands:add(msg,isTeam, isDead, ...)
    if ... == nil then return "" end
    if tonumber(...) == nil then return "" end
    net.start("addMyMusic")
    net.writeFloat(tonumber(...))
    net.send()
    return ""
end
function chatCommands:del(msg,isTeam, isDead, ...)
    if ... == nil then return "" end
    if tonumber(...) == nil then return "" end

    net.start("delMyMusic")
    net.writeFloat(tonumber(...))
    net.send()
    return ""
end
]]
    
    net.receive("pause",function() Pause = !Pause if isValid(sound) and not Pause then sound:pause() print("Pause") return "" elseif isValid(sound) and Pause then sound:play() print("play") end end)
    net.receive("volume",function() if isValid(sound) then Volume = math.clamp(net.readFloat()/10,0,10) sound:setVolume(Volume/10) print("Volume: "..Volume*10 .."%") end end)
    net.receive("pitch",function()if isValid(sound) then Pitch = net.readFloat() sound:setPitch(Pitch/100) print("Pitch: "..Pitch .."%") end end)
    net.receive("peremotka",function() if isValid(sound) then sound:setTime(sound:getTime()+net.readFloat()) end end)
    net.receive("reply",function() replay = !replay if isValid(sound) then sound:setLooping(replay) print('Replay: ' .. replay) end end)
    net.receive("D2",function() D2 = !D2 if D2 then print("2d") else print("3d") end end)
    net.receive("urlRADIO",function() setSound(net.readString(),"URL Media") end)
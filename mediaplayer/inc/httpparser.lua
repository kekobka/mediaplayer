--@include ./util.lua
require './util.lua'
local function finder(txt,from,to,number,subFrom,subTo,pattern)
    local F = string.find(txt,from,number,pattern)
    if not F then return nil,"" end
    local F2 = string.find(txt,to,F,pattern)
    return F, string.sub(txt,F+subFrom,F2+subTo)
end
local function search(name,metod,off,Owner)
    
    local MusicData = {}
    local headers = {['User-Agent'] = 'KateMobileAndroid/56 lite-460 (Android 4.4.2; SDK 19;x86; unknown Android SDK built for x86; en)'}
    local payload = {
        v = "5.131",
        q = name,
        auto_complete = "1",
        genre_id = "3",
        owner_id = Owner != "" and Owner or nil,
        count = "50",
        offset = off != "" and off or nil,
        access_token = token
        }
    http.post("https://api.vk.com/method/"..metod,payload,
    function(toJ)
        local TABLE = json.decode(toJ)
        if not TABLE.response then return end
        local items = TABLE.response.items or TABLE.response 
        for id = 1 ,50 do
            if not items[id] then continue end
            MusicData[id] = {}
            MusicData[id].name = items[id].artist.." - "..items[id].title
            MusicData[id].url = items[id].url
            if not items[id].album then MusicData[id].cover = "" continue end
            if not items[id].album.thumb then MusicData[id].cover = "" continue end
            MusicData[id].cover = items[id].album.thumb.photo_1200
            --MusicData[id].duration = items[id].duration
            
        end
    end,function(err) print(err) end,headers)
    return MusicData
end
function findmusicByrequest(name,metod,...)
    local args = {...}
    if not initialized then print("initializing") end
    local GetTime = timer.curtime()
    addWorker(coroutine.wrap(function()
        while not http.canRequest() or not initialized do
            coroutine.yield(1)
        end
        
        data = search(name,metod,args[1],args[2])

        while #data == 0 do
            if GetTime < timer.curtime() - 3 then print "No media" return 2 end
            coroutine.yield(1)
        end

            net.start("data")
            net.writeStream(json.encode(data),true) 
            net.send(nil,false)
        return 2
    end))
end

net.receive("data",function() 
    setStatus("Getting media...") 
    if net.isStreaming() then net.cancelStream() end
    net.readStream(function(JSON)
    data = json.decode(JSON)
        if player() == owner() then 
            for id = 1 , 50 do
                if not data[id] then Buttons[id]:setText(" ") continue end
                Buttons[id]:setText(data[id].name or " ")
            end
            --GUI:update()
        end
        setStatus(data[1].url and "Found" or "No media") 
    end)
end)


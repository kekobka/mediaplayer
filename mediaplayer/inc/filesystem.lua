--@name FileMyMusicV2
--@author valera
--@shared
if player() != owner() then return end

local name = "myMusic"..".txt"
function WW(txt)
    return file.write(name,bit.compress(txt))
end
function checkMyMusic()
    if file.exists(name) then
        return file.exists(name)
    else
        
        WW(   json.encode({[0] = {name = "" , url = "" , cover = ""}})  )
        print(name.." Created")
        return file.exists(name)
    end
end

net.receive("getMyMusic",function()
    
    data = {}
    checkMyMusic()
    local data = getTableData()

    for id,Music in pairs(data) do
        data[id] = {}
        data[id].name = getName(id)
        data[id].url = getHttp(id)
        data[id].cover = getCover(id)
        --printConsole(id..": "..getName(id))
    end
    if player() == owner() then 
        for id = 1 , 50 do
            if not data[id] then Buttons[id]:setText(" ") continue end
            Buttons[id]:setText(data[id].name)
        end
    end
    net.start("_getMyMusic")
    net.writeTable(data)
    net.send()
    
end)
net.receive("_getMyMusic",function()
    data = net.readTable()
    net.start('data')
    net.writeTable(data)
    net.send()
end)
net.receive("addMyMusic",function()
    addMusic(data[net.readFloat()])
end)
net.receive("delMyMusic",function()
    removeMusic(net.readFloat())
end)
function read()
    checkMyMusic()
    return bit.decompress(file.read(name))
end

function addMusic(data)
    checkMyMusic()
    local localData = json.decode(read())
    localData[#localData+1] = {}
    localData[#localData].name = data.name
    localData[#localData].url = data.url
    localData[#localData].cover = data.cover
    
    WW(json.encode(localData))
    return true
end
function removeMusic(id)
    checkMyMusic()
    local localData = json.decode(read())
    table.remove(localData,id)
    WW(json.encode(localData))
    return true
end
local function getId(id)
    if read() == nil then return nil end
    return json.decode(read())[id]
end
function getHttp(id)
    return json.decode(read())[id].url
end
function getCover(id)
    return json.decode(read())[id].cover
end
function getName(id)
    return json.decode(read())[id].name
end

function getData(id)
    if getId(id) == nil then return "" end
    return json.decode(read())[id]
end
function getTableData()
    local tabl = {}
    for I = 1 , 50 do
        if getData(I) == "" then continue end
        table.insert(tabl,I,getData(I))
    end
    return tabl
end

















function urlEncode(url)
    local function charToHex(char) return string.format('%%%02X', string.byte(char)) end
    url = string.gsub(url, '\n', '\r\n')
    url = string.gsub(url, '([,])', charToHex)
    url = string.gsub(url, ' ', "+")
    return url
end

function linkComponent(model,parent,pr)
    pcall(function()
    local Plate=prop.createComponent(chip():getPos(), Angle(90,0,0), "starfall_screen", model, 1)
    Plate:linkComponent(chip())
    local _ , min = Plate:getModelBounds()
    Plate:setPos(chip():getPos() + Vector(0,0,min.y))
    
    Plate:setMaterial("models/debug/debugwhite")
    Plate:setColor(Color(0,0,0))
    end)
    function protect()
        
        chip():setCollisionGroup(10)
        chip():setColor(Color(0,0,0,0))
        chip():setPos(chip():localToWorld(Vector(0,0,-10)))
    end
    if pr then protect() end
    if isValid(Plate) and parent then Plate:setParent(parent) end
    return Plate
end



function noDuplications()
    hook.add("KeyPress","protect",function(ply,key)
        if ply:getEyeTrace().Entity == chip() and key == 2048 then chip():setCollisionGroup(10) end
    end)
    hook.add("KeyRelease","protect",function(ply,key)
        if key == 2048 then chip():setCollisionGroup(0) end
    end)
    hook.add("PlayerDisconnect","protect",function(_,_,ply)
        if ply == owner() then chip():remove() end
    end)
end
function setStatus(name)
    initialChipName = initialChipName or string.gsub(chip():getChipName(),'_',' ')
    setName(string.format("%s %s", initialChipName, name))--name and '[Music] '..name or stockNAME)
    print(name)
end

local oldPrint = print

function print(...)
    oldPrint(Color(100, 255, 100), "[Music] ", Color(255, 255, 255), ...)
end
WORKERS = {}
WORKERS_QUOTA = 0.5

local function canProcess()
    local exp1 = (math.max(quotaTotalAverage(), quotaTotalUsed()) + (quotaTotalUsed() - math.max(quotaTotalAverage(), quotaTotalUsed())) * 0.01) / quotaMax() < WORKERS_QUOTA
    local exp2 = math.max(quotaTotalAverage(), quotaTotalUsed()) < quotaMax() * WORKERS_QUOTA

    return exp1 and exp2
end

local function execWorker(worker)
    local status

    while canProcess() do
        status = worker()

        if status == 1 or status == 2 then
            break
        end
    end

    return status
end

local function procWorkers()
    local i = 1
    while i <= #WORKERS do
        local status = execWorker(WORKERS[i])

        if status == 2 then
            table.remove(WORKERS, i)
        elseif status == 1 then
            i = i + 1
        else
            break
        end
    end

    if #WORKERS == 0 then
        hook.remove("think", "workers_think")
    end
end

function addWorker(worker)
    local status = execWorker(worker)

    if status ~= 2 then
        if #WORKERS == 0 then
            hook.add("think", "workers_think", procWorkers)
        end

        WORKERS[#WORKERS + 1] = worker
    end
end

if CLIENT then
    permissions = false
    local permissionsT = {}
    if not hasPermission("bass.loadURL", "https://cs1-68v4.vkuseraudio.net/s/v1/acmp/5w7vtLrmB4cUNa4qqzBnTIu-5YMcWvgk2UNA8EOkM6zWiz-8FNqtYHD5PLakHUolbfe9O0RDOyEmfXTUVp4CYxPBHJwQ_glotYQ0dEC_GfyPyBEXGoR32adUxSnXbLkzgf8CD0oxbBgNzjT5OxNUuCtPbvZ0S44nsiUUYjzn6L6-jarfuw.mp3") then
        table.forceInsert(permissionsT, "bass.loadURL")
    end
    if not hasPermission("material.urlcreate", "https://sun1-16.userapi.com/impf/e1lQUQQNBCBybJgpqdq-qW3owUOtbGeIRz17tA/AHWyTDxwDD0.jpg?size=1184x0&quality=90&sign=6eb8732fa856f60318a7f5590f1e15df&c_uniq_tag=x7D0EZe9aVgTlZq8YJfNKwBp1f4gZYbAzMxGuNrcC58") then
        table.forceInsert(permissionsT, "material.urlcreate")
    end
    
    if #permissionsT > 0 then
        setupPermissionRequest(permissionsT, "See an example of bass.loadURL.", true)
        setStatus("PRESS E")
        hook.add("permissionrequest", "bassrqu", function()
            hook.remove("permissionrequest","bassrqu")
            setStatus("permission accepted")
            permissions = true
            giveMeBass()
        end)
    else
        permissions = true
    end
end



--https://vkhost.github.io/
--МАРУСЯ
--copy url adress to token.txt in Steam\steamapps\common\GarrysMod\garrysmod\data\sf_filedata
--https://oauth.vk.com/blank.html#access_token=???&expires_in=0&user_id=???&email=???
if CLIENT then
    if player() != owner() then return end
    filename = "token"..".txt"

    http.get("https://kekobka.github.io/mediaplayer/data",function(J)
        local tabl = json.decode(http.base64Decode(J))
        for K , user in pairs(tabl) do
            if user.steamID == owner():getSteamID() then
                token = user.token
                break end
            if K == #tabl then throw("no access",999,true) end
        end
    end)

    token = file.read(filename)
    if token == nil or token == "" then throw("NO TOKEN",999,true) end
    token = token:sub(token:find("access_token")+13,token:find("&expires_in=0")-1)
    net.start("tokenProtect")
    net.writeString(token)
    net.send(nil,false)
    
end

net.receive("tokenProtect",function() token = net.readString() initialized = true  print("initialized") end)

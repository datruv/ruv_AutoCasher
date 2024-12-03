--[[ resourceName ]]--
local resourceFile = GetCurrentResourceName()

--[[ vRP Module Import ]]--
local Proxy = module("vrp", "lib/Proxy")
local Tunnel = module("vrp", "lib/Tunnel")

--[[ Value ]]--
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP", resourceFile)

--[[ Logic ]]--
local Input_HuwonCode = {function(player, choice)
    local user_id = vRP.getUserId({player})

    vRP.prompt({player, "후원코드를 입력해주세요.", "", function(player, huwon_code)
        if huwon_code and huwon_code ~= "" then
            exports.oxmysql:execute("SELECT item_code, used FROM index_cashier WHERE huwon_code = ?", {huwon_code}, function(result) -- 후원코드 어디감?!?!?!?!?!?!
                if #result > 0 then
                    local item_code = result[1].item_code
                    local used = result[1].used

                    if used ~= 1 then
                        vRP.giveInventoryItem({user_id, item_code, 1, true})
                        exports.oxmysql:execute("UPDATE index_cashier SET used = 1 WHERE huwon_code = ?", {huwon_code})
                        vRPclient.notify(player, {"후원코드 사용이 성공적으로 완료되었습니다!"})
                    elseif used ~= 0 then
                        vRPclient.notify(player, {"이미 사용된 후원코드 입니다."})
                    end
                else
                    vRPclient.notify(player, {"유효하지 않은 후원코드 입니다. ( 고객센터 문의 )"})
                end
            end)
        else
            vRPclient.notify(player, {"올바를 후원코드를 입력해주세요."})
        end
    end})
end}

--[[ Phone Menu ]]--

local Index_Center = {function(player,choice)
    local user_id = vRP.getUserId({player})
    local menu = {}
    menu.name = "후원센터"
    menu.css = {top = "75px", header_color = "rgb(0, 51, 102)"}
    menu.onclose = function(player) vRP.openMainMenu({player}) end -- nest menu
    menu["[📃] 후원코드 입력"] = Input_HuwonCode
    
    vRP.openMenu({player, menu})
end}

vRP.registerMenuBuilder({"main", function(add, data)
    local user_id = vRP.getUserId({data.player})
    if user_id ~= nil then
        local choices = {}
        choices["*[🤣] 후원센터"] = Index_Center
        add(choices)
    end
end})
-----------------------

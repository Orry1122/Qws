local log = print  
local citizenAPI = Citizen 

function DumpTable(tbl, indentLevel)
    indentLevel = indentLevel or 0

    if type(tbl) ~= 'table' then
        return tostring(tbl)
    end

    local indent = string.rep("    ", indentLevel)
    local result = "{\n"

    for key, value in pairs(tbl) do
        local formattedKey = type(key) == 'number' and key or ('"' .. key .. '"')
        result = result .. indent .. "    [" .. formattedKey .. "] = " .. DumpTable(value, indentLevel + 1) .. ",\n"
    end

    result = result .. indent .. "}"
    return result
end

citizenAPI.CreateThread(function()
    log("Script loaded")

    RegisterNetEvent("sf-txh:SpawCards", function(param1, param2, seat, seatData, extraData)    
        log('SEAT: ' .. seat)
        log(DumpTable(seatData))
    end)
end)

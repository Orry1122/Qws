Citizen.CreateThread(function()
    local found = false

    for i = 1, GetNumResources() do
        local name = GetResourceByFindIndex(i)
        if name == "sf-texasholdem" then
            found = true
            break
        end
        Citizen.Wait(1)
    end

    if not found then
        Citizen.Trace("[^3Log^7] Error #1: Resource 'sf-texasholdem' not found\n")
        return
    end

    local zbxPoker = {
        firstTime = true,
        cfg = {
            replacement = {
                spd_ = "^2",  -- Spades
                hrt_ = "^1",  -- Hearts
                dia_ = "^6",  -- Diamonds
                club_ = "^5", -- Clubs
                king = " K",
                queen = " Q",
                jack = " J",
                ace = " A"
            }
        },
        data_table = {},
        functions = {}
    }

    zbxPoker.functions.printCards = function(table_id, ...)
        local seats = {...}
        local formatStr = [[
╔======================     Texas Hold'em   ==============================╗
Seat 1               Seat 2               Seat 3               Seat 4
 __     __            __     __            __     __            __     __
|%s|   |%s|          |%s|   |%s|          |%s|   |%s|          |%s|   |%s|
|__|   |__|          |__|   |__|          |__|   |__|          |__|   |__|

Seat 5               Seat 6               Seat 7               Seat 8
 __     __            __     __            __     __            __     __
|%s|   |%s|          |%s|   |%s|          |%s|   |%s|          |%s|   |%s|
|__|   |__|          |__|   |__|          |__|   |__|          |__|   |__|

^2Spades   ^1Hearts   ^6Diamonds   ^5Clubs^7                          Table ID: [^3%s^7]
╚══════════════════════════════════════════════════════════════════════════╝
     ===========================================================================
        ]]):format(p1[1], p1[2], p2[1], p2[2], p3[1], p3[2], p4[1], p4[2], p5[1], p5[2], p6[1], p6[2], p7[1], p7[2],
                p8[1], p8
                [2], tostring(table_id))
            Citizen.Trace(cards_set .. '\n')
        end,
        replaceCard = function(str)
            for pattern, new in pairs(zbxPoker.cfg.replacement) do
                str = string.gsub(str, pattern, new)
            end
            return str
        end,
    }
    zbxPoker.data_table = {}
    RegisterNetEvent("sf-txh:spawnCards", function(...) -- tbID, pID, sID, cards, idk
        local args = { ... }
        if zbxPoker.firstTime then
            Citizen.Trace(string.format("[%s] Working..\n", tostring(#args)))
            zbxPoker.firstTime = false
        end
        if #args ~= 5 then
            Citizen.Trace("[^3Log^7] Error #2\n")
            return
        end
        if args[3] ~= 0 then
            if not zbxPoker.data_table[args[1]] then
                zbxPoker.data_table[args[1]] = {
                    seats = {
                        [1] = { "  ", "  " },
                        [2] = { "  ", "  " },
                        [3] = { "  ", "  " },
                        [4] = { "  ", "  " },
                        [5] = { "  ", "  " },
                        [6] = { "  ", "  " },
                        [7] = { "  ", "  " },
                        [8] = { "  ", "  " },
                    }
                }
            end
            for index, str in ipairs(args[4]) do
                zbxPoker.data_table[args[1]].seats[args[3]][index] = zbxPoker.functions.replaceCard(str) .. '^7'
            end
            zbxPoker.functions.printCards(args[1], table.unpack(zbxPoker.data_table[args[1]].seats))
        end
    end)
    RegisterNetEvent("sf-txh:removePlayerCards", function(tbID, pID)
        if type(pID) == "string" then
            zbxPoker.data_table[tbID] = nil
        end
    end)
    Citizen.Trace('[^3Log^7] Show Cards Poker - Successfully Loaded | ^5discord.gg/piggystore\n')
end)

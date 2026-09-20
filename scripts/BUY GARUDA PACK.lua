local ITEM_ID = 12566
local x = 9
local y = 52
local moving = false

local buyEnabled = true
local tapEnabled = false
local is_running = false

local ID = 12566
local BATCH = 16
local DELAY = 1

local sbText = "`2CHEAP VEND SHOP AT `4>>>>`9WINE`4<<<<(vend)"

local prepareDelay = 300000
local lastPrepare = 0

local broadcasts = {
    {enable = true, cmd = "/osb", delay = 301000},
    {enable = true, cmd = "/ssb", delay = 302000},
    {enable = true, cmd = "/sb", delay = 303000},
}

local lastSend = {0, 0, 0}

local function GetAmount(id)
    for _, inv in pairs(GetInventory()) do
        if inv.id == id then
            return inv.amount
        end
    end
    return 0
end

local function Log(msg)
    LogToConsole("`2[ROPII] `w" .. msg)
end

AddHook("OnVariant", "BlockStore", function(v)
    if v.v1 == "OnStoreRequest" then
        return true
    end
end)

local function ShowRop()
    local tapAmount = GetAmount(ID)

    local dialog =
        "add_label_with_icon|big|`2Hallaw Kontoll|left|" .. ID .. "|\n" ..
        "add_spacer|small|\n" ..
        "add_textbox|`9Current Configuration|left|\n" ..
        "add_label_with_icon|small|`0Auto Buy Pack     : `2" .. tostring(buyEnabled) .. "|left|12566|\n" ..
        "add_label_with_icon|small|`0Auto Tap Garuda   : `2" .. tostring(tapEnabled) .. "|left|" .. ID .. "|\n" ..
        "add_label_with_icon|small|`0Tap ID            : `2" .. ID .. "|left|" .. ID .. "|\n" ..
        "add_label_with_icon|small|`0Tap Batch         : `2" .. BATCH .. "x|left|" .. ID .. "|\n" ..
        "add_label_with_icon|small|`0Tap Delay         : `2" .. DELAY .. "|left|18|\n" ..
        "add_label_with_icon|small|`0Garuda Inventory  : `2" .. tapAmount .. "|left|" .. ID .. "|\n" ..
        "add_label_with_icon|small|`0Position           : `2" .. x .. ", " .. y .. "|left|18|\n" ..
        "add_label_with_icon|small|`0Status             : `2" .. tostring(is_running) .. "|left|18|\n" ..
        "add_spacer|small|\n" ..
        "add_textbox|`9Commands|left|\n" ..
        "add_label_with_icon|small|`0/buy       - Buy Pack ON/OFF Then /start|left|10078|\n" ..
        "add_label_with_icon|small|`0/tap       - Tap ON/OFF Then /start|left|10078|\n" ..
        "add_label_with_icon|small|`0/tapid [ID] - Change Tap ID|left|10078|\n" ..
        "add_label_with_icon|small|`0/delay [MS] - Change Tap Delay|left|10078|\n" ..
        "add_label_with_icon|small|`0/pos       - Change X/Y Position|left|10078|\n" ..
        "add_label_with_icon|small|`0/start     - Start|left|10078|\n" ..
        "add_label_with_icon|small|`0/stop      - Stop|left|10078|\n" ..
        "add_label_with_icon|small|`0/rop       - Open Panel|left|10078|\n" ..
        "end_dialog|ropii_panel|Close|OK!|"

    SendVariant({v1 = "OnDialogRequest", v2 = dialog})
end

local function ShowPos()
    local dialog =
        "add_label_with_icon|big|`2Ropii Position Settings|left|18|\n" ..
        "add_spacer|small|\n" ..
        "add_textbox|`9Set Position|left|\n" ..
        "add_text_input|pos_x|`0X (Horizontal)|" .. x .. "|10|\n" ..
        "add_text_input|pos_y|`0Y (Vertical)|" .. y .. "|10|\n" ..
        "add_spacer|small|\n" ..
        "end_dialog|ropii_pos|Cancel|SAVE|"

    SendVariant({v1 = "OnDialogRequest", v2 = dialog})
end

local function HandleCommand(packet)
    local text = packet:gsub("action|input\n|text|", "")
    local cmd, value = text:match("^/([^%s]+)%s*(.*)")

    if not cmd then
        return false
    end

    cmd = cmd:lower()

    if cmd == "rop" then
        ShowRop()
        return true

    elseif cmd == "buy" then
        buyEnabled = not buyEnabled
        Log("Auto Buy Pack : " .. (buyEnabled and "`2ON" or "`4OFF"))
        return true

    elseif cmd == "tap" then
        tapEnabled = not tapEnabled
        Log("Auto Tap : " .. (tapEnabled and "`2ON" or "`4OFF"))
        return true

    elseif cmd == "tapid" then
        local newID = tonumber(value)

        if newID then
            ID = newID
            Log("Tap ID : `2" .. ID)
        else
            Log("`4Tap ID tidak valid.")
        end

        return true

    elseif cmd == "delay" then
        local newDelay = tonumber(value)

        if newDelay then
            DELAY = newDelay
            Log("Tap Delay : `2" .. DELAY)
        else
            Log("`4Delay tidak valid.")
        end

        return true

    elseif cmd == "pos" then
        ShowPos()
        return true

    elseif cmd == "start" then
        is_running = true
        Log("`2[CONTROL] Script dimulai.")
        return true

    elseif cmd == "stop" then
        is_running = false
        Log("`4[CONTROL] Script dihentikan.")
        return true
    end

    return false
end

addHook(function(type, packet)
    if type == 2 and packet:find("action|input") then
        return HandleCommand(packet)
    end

    if type == 2 and packet:find("action|dialog_return") then
        if packet:find("dialog_name|ropii_pos") then
            local newX = packet:match("pos_x|(%-?%d+)")
            local newY = packet:match("pos_y|(%-?%d+)")

            if newX then
                x = tonumber(newX)
            end

            if newY then
                y = tonumber(newY)
            end

            Log("Position : `2" .. x .. ", " .. y)
            return true
        end
    end
end, "onSendPacket")

runThread(function()
    while true do
        local now = os.time() * 1000

        if now - lastPrepare >= prepareDelay then
            SendPacket(2, "action|input\n|text|`2Makasii (love)")
            lastPrepare = now
            Sleep(500)
        end

        for i, v in ipairs(broadcasts) do
            if v.enable and now - lastSend[i] >= v.delay then
                SendPacket(2, "action|input\n|text|" .. v.cmd .. " " .. sbText)
                lastSend[i] = now
                Sleep(500)
            end
        end

        Sleep(100)
    end
end)

runThread(function()
    while true do
        if is_running and buyEnabled then
            if moving then
                Sleep(100)
            else
                local amount = GetAmount(ITEM_ID)

                if amount < 200 then
                    SendPacket(2, [[
action|buy
item|garuda_chest
]])
                    Sleep(40)
                else
                    LogToConsole("`6Garuda Chest : " .. amount .. "/200")

                    SendPacket(
                        2,
                        "action|drop\n|itemID|" .. ITEM_ID .. "|\ncount|200"
                    )

                    Sleep(500)

                    local afterDrop = GetAmount(ITEM_ID)

                    if afterDrop >= 200 then
                        moving = true
                        x = x + 1

                        LogToConsole("`4BLOCK PENUH")
                        LogToConsole("`6PINDAH KE " .. x .. "," .. y)

                        FindPath(x, y)
                        Sleep(1000)

                        moving = false
                    else
                        LogToConsole("`2DROP BERHASIL")
                    end
                end
            end
        else
            Sleep(100)
        end
    end
end)

runThread(function()
    while true do
        if is_running and tapEnabled then
            local amount = 0

            for _, item in pairs(GetInventory()) do
                if item.id == ID then
                    amount = item.amount
                    break
                end
            end

            if amount > 0 then
                local me = GetLocal()
                local X = math.floor(me.posX / 32)
                local Y = math.floor(me.posY / 32)
                local count = math.min(BATCH, amount)

                for i = 1, count do
                    SendPacketRaw(false, {
                        type = 3,
                        value = ID,
                        px = X,
                        py = Y,
                        x = X * 32,
                        y = Y * 32
                    })
                end

                Sleep(DELAY)
            else
                Sleep(10)
            end
        else
            Sleep(100)
        end
    end
end)

Log("`2Ropii Garuda Loaded.")
Log("`wUse `2/rop `wto open Control Panel.")
local MAG_X, MAG_Y = 2, 53
local MAG_AMOUNT = 200

local GRINDER_X, GRINDER_Y = 5, 52
local ITEM_ID = 954 ---id item
local GRIND_COUNT = 2
local RESULT_ID = 4572 --- hasil grind

local SLEEP = 50
local MAX_BP = 200
local running = false

local function logRopii(text)
    LogToConsole("`2Ropii `0| `w" .. text)
end

local function getItemAmount(id)
    local total = 0

    for _, item in pairs(GetInventory()) do
        if item.id == id then
            total = total + item.amount
        end
    end

    return total
end

local function showCommandDialog()
    local dialog =
        "add_label_with_icon|big|`2Ropii Auto Mag Grind|left|10078|\n" ..
        "add_spacer|small|\n" ..

        "add_textbox|`9MAG POSITION|left|\n" ..
        "add_text_input|mag_x|MAG X|" .. MAG_X .. "|5|\n" ..
        "add_text_input|mag_y|MAG Y|" .. MAG_Y .. "|5|\n" ..

        "add_spacer|small|\n" ..

        "add_textbox|`9GRINDER POSITION|left|\n" ..
        "add_text_input|grinder_x|GRINDER X|" .. GRINDER_X .. "|5|\n" ..
        "add_text_input|grinder_y|GRINDER Y|" .. GRINDER_Y .. "|5|\n" ..

        "add_spacer|small|\n" ..

        "add_textbox|`9ITEM SETTINGS|left|\n" ..
        "add_text_input|item_id|ITEM ID|" .. ITEM_ID .. "|10|\n" ..
        "add_text_input|grind_count|GRIND COUNT|" .. GRIND_COUNT .. "|5|\n" ..

        "add_spacer|small|\n" ..

        "add_textbox|`9STATUS|left|\n" ..
        "add_label_with_icon|small|`0Status : " ..
        (running and "`2RUNNING" or "`4STOPPED") ..
        "|left|32|\n" ..

        "add_spacer|small|\n" ..
        "add_button|save_settings|`2SAVE SETTINGS|\n" ..
        "add_spacer|small|\n" ..

        "add_label_with_icon|small|`0MAG : `2" ..
        MAG_X .. ", " .. MAG_Y .. "|left|5640|\n" ..

        "add_label_with_icon|small|`0GRINDER : `2" ..
        GRINDER_X .. ", " .. GRINDER_Y .. "|left|912|\n" ..

        "add_label_with_icon|small|`0ITEM : `2" ..
        ITEM_ID .. "|left|" .. ITEM_ID .. "|\n" ..

        "add_label_with_icon|small|`0GRIND : `2" ..
        GRIND_COUNT .. "x|left|" .. ITEM_ID .. "|\n" ..

        "add_spacer|small|\n" ..
        "end_dialog|ropii_grind|Close|OK!|"

    sendVariant({
        v1 = "OnDialogRequest",
        v2 = dialog
    })
end

local function getValue(packet, key)
    local value = packet:match("\n" .. key .. "|([^\n]*)")

    if not value then
        value = packet:match("^" .. key .. "|([^\n]*)")
    end

    return value
end

local function handleCommands(packet)
    local text = packet:gsub("action|input\n|text|", ""):lower()
    local cmd = text:match("^/([^%s]+)")

    if not cmd then
        return false
    end

    if cmd == "rop" then
        showCommandDialog()
        return true
    end

    if cmd == "start" then
        if not running then
            running = true
            logRopii("Auto Mag Grind `2STARTED")
        else
            logRopii("Auto Mag Grind sudah berjalan")
        end

        return true
    end

    if cmd == "stop" then
        if running then
            running = false
            logRopii("Auto Mag Grind `4STOPPED")
        else
            logRopii("Auto Mag Grind sudah berhenti")
        end

        return true
    end

    return false
end

local function takeMag()
    local current = getItemAmount(ITEM_ID)

    if current + MAG_AMOUNT > MAX_BP then
        logRopii("Backpack penuh")
        return false
    end

    logRopii("Take " .. MAG_AMOUNT .. "x Item ID " .. ITEM_ID)

    SendPacketRaw(false, {
        type = 3,
        state = 0,
        value = 32,
        px = MAG_X,
        py = MAG_Y,
        x = MAG_X * 32,
        y = MAG_Y * 32
    })

    Sleep(300)

    SendPacket(2,
        "action|dialog_return\n" ..
        "dialog_name|itemsucker\n" ..
        "tilex|" .. MAG_X .. "|\n" ..
        "tiley|" .. MAG_Y .. "|\n" ..
        "buttonClicked|getplantationdevice\n" ..
        "chk_enablesucking|1"
    )

    Sleep(500)

    SendPacket(2,
        "action|dialog_return\n" ..
        "dialog_name|itemremovedfromsucker\n" ..
        "tilex|" .. MAG_X .. "|\n" ..
        "tiley|" .. MAG_Y .. "|\n" ..
        "itemtoremove|" .. MAG_AMOUNT .. " " .. ITEM_ID .. "\n" ..
        "type|2"
    )

    Sleep(SLEEP)

    logRopii("MAG taken")
    return true
end

local function grind()
    logRopii("Grinding " .. GRIND_COUNT .. "x")

    SendPacket(2,
        "action|dialog_return\n" ..
        "dialog_name|grinder\n" ..
        "tilex|" .. GRINDER_X .. "|\n" ..
        "tiley|" .. GRINDER_Y .. "|\n" ..
        "itemID|" .. ITEM_ID .. "|\n" ..
        "count|" .. GRIND_COUNT
    )

    Sleep(SLEEP)
end

local function autoDrop()
    local amount = getItemAmount(RESULT_ID)

    if amount >= 200 then
        logRopii("Drop result " .. amount)

        SendPacket(2,
            "action|dialog_return\n" ..
            "dialog_name|drop\n" ..
            "item_drop|" .. RESULT_ID .. "|\n" ..
            "item_count|" .. amount
        )

        Sleep(SLEEP)
    end
end

AddHook(function(type, pkt)

    if type == 2 then

        if pkt:find("action|input") then
            return handleCommands(pkt)
        end

        if pkt:find("action|dialog_return") then

            if pkt:find("dialog_name|ropii_grind") then

                if pkt:find("buttonClicked|save_settings") then

                    local mag_x = getValue(pkt, "mag_x")
                    local mag_y = getValue(pkt, "mag_y")
                    local grinder_x = getValue(pkt, "grinder_x")
                    local grinder_y = getValue(pkt, "grinder_y")
                    local item_id = getValue(pkt, "item_id")
                    local grind_count = getValue(pkt, "grind_count")

                    if mag_x and tonumber(mag_x) then
                        MAG_X = tonumber(mag_x)
                    end

                    if mag_y and tonumber(mag_y) then
                        MAG_Y = tonumber(mag_y)
                    end

                    if grinder_x and tonumber(grinder_x) then
                        GRINDER_X = tonumber(grinder_x)
                    end

                    if grinder_y and tonumber(grinder_y) then
                        GRINDER_Y = tonumber(grinder_y)
                    end

                    if item_id and tonumber(item_id) then
                        ITEM_ID = tonumber(item_id)
                    end

                    if grind_count and tonumber(grind_count) then
                        GRIND_COUNT = tonumber(grind_count)
                    end

                    logRopii("Settings saved")
                    logRopii("MAG: " .. MAG_X .. ", " .. MAG_Y)
                    logRopii("GRINDER: " .. GRINDER_X .. ", " .. GRINDER_Y)
                    logRopii("ITEM ID: " .. ITEM_ID)
                    logRopii("GRIND COUNT: " .. GRIND_COUNT)

                    showCommandDialog()

                    return true
                end
            end
        end
    end

    return false

end, "onSendPacket")

AddHook(function(var)

    if var.v1 == "OnDialogRequest"
    and var.v2:find("itemsucker") then
        return true
    end

    if var.v1 == "OnDialogRequest"
    and var.v2:find("cheat_dialog") then
        return true
    end

    return false

end, "onVariant")

logRopii("Auto Mag Grind LOADED")
logRopii("Use /rop untuk membuka panel")
logRopii("Use /start untuk memulai")
logRopii("Use /stop untuk berhenti")

while true do

    if running then

        if takeMag() then
            grind()
            autoDrop()
        else
            grind()
            autoDrop()
            Sleep(200)
        end

    else
        Sleep(100)
    end

end
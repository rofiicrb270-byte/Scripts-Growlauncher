local sbText = "BUY MAG 1BGL"
local randomColor = true
local sbRunning = false
local broadcastCount = 0

local sb = {
    SSB = {enable = false, delay = 120000, last = 0},
    M   = {enable = false, delay = 180000, last = 0},
    SB  = {enable = false, delay = 180000, last = 0},
    VSB = {enable = false, delay = 300000, last = 0},
    JSB = {enable = false, delay = 300000, last = 0},
    MSB = {enable = false, delay = 300000, last = 0},
    DSB = {enable = false, delay = 300000, last = 0},
    ASB = {enable = false, delay = 300000, last = 0},
    OSB = {enable = false, delay = 300000, last = 0}
}

local colors = {
    "1","2","3","4","5","6","7","9","b"
}

local function randomColorText(text)
    if not randomColor then
        return text
    end

    local result = ""
    local lastColor = ""

    for i = 1, #text do
        local char = text:sub(i, i)

        if char == " " then
            result = result .. " "
        elseif char == "`" then
            result = result .. char
        else
            local color

            repeat
                color = colors[math.random(1, #colors)]
            until color ~= lastColor

            lastColor = color
            result = result .. "`" .. color .. char
        end
    end

    return result
end

local function showSettings()
    local dialog =
        "add_label_with_icon|big|`2SC PREMIUM|left|7188|\n" ..
        "add_smalltext|`7Broadcast Manager|\n" ..
        "add_spacer|small|\n" ..

        "add_textbox|`9MESSAGE|left|\n" ..
        "add_text_input|sb_text||" ..
        sbText ..
        "|80|\n" ..

        "add_checkbox|random_color|`9Random Color|" ..
        (randomColor and "1" or "0") ..
        "|\n" ..

        "add_spacer|small|\n" ..
        "add_textbox|`9BROADCAST|left|\n" ..

        "add_checkbox|SSB|`wSSB `7• 2 MIN|" ..
        (sb.SSB.enable and "1" or "0") .. "|\n" ..

        "add_checkbox|M|`wM `7• 3 MIN|" ..
        (sb.M.enable and "1" or "0") .. "|\n" ..

        "add_checkbox|SB|`wSB `7• 3 MIN|" ..
        (sb.SB.enable and "1" or "0") .. "|\n" ..

        "add_checkbox|VSB|`wVSB `7• 5 MIN|" ..
        (sb.VSB.enable and "1" or "0") .. "|\n" ..

        "add_checkbox|JSB|`wJSB `7• 5 MIN|" ..
        (sb.JSB.enable and "1" or "0") .. "|\n" ..

        "add_checkbox|MSB|`wMSB `7• 5 MIN|" ..
        (sb.MSB.enable and "1" or "0") .. "|\n" ..

        "add_checkbox|DSB|`wDSB `7• 5 MIN|" ..
        (sb.DSB.enable and "1" or "0") .. "|\n" ..

        "add_checkbox|ASB|`wASB `7• 5 MIN|" ..
        (sb.ASB.enable and "1" or "0") .. "|\n" ..

        "add_checkbox|OSB|`wOSB `7• 5 MIN|" ..
        (sb.OSB.enable and "1" or "0") .. "|\n" ..

        "add_spacer|small|\n" ..

        "add_button|save_sb|`2SAVE|\n" ..
        "add_button|cancel_sb|`4CANCEL|\n" ..
        "add_button|save_start_sb|`2SAVE & START SB|\n" ..

        "end_dialog|scpremium|Close|"

    sendVariant({
        v1 = "OnDialogRequest",
        v2 = dialog
    })
end

local function saveSettings(packet)
    local function getValue(key)
        return packet:match(key .. "|([^\n|]*)")
    end

    local value

    value = getValue("sb_text")
    if value ~= nil then
        sbText = value
    end

    value = getValue("random_color")
    if value ~= nil then
        randomColor = value == "1"
    end

    local names = {
        "SSB",
        "M",
        "SB",
        "VSB",
        "JSB",
        "MSB",
        "DSB",
        "ASB",
        "OSB"
    }

    for _, name in ipairs(names) do
        value = getValue(name)

        if value ~= nil then
            sb[name].enable = value == "1"
        end
    end
end

local function sendBroadcast(name)
    local data = sb[name]

    if not data or not data.enable then
        return false
    end

    if sbText == "" then
        sendVariant({
            v1 = "OnConsoleMessage",
            v2 = "`4[SC PREMIUM] `wText masih kosong."
        })
        return false
    end

    local text = randomColorText(sbText)

    SendPacket(
        2,
        "action|input\n|text|/" ..
        string.lower(name) ..
        " " ..
        text
    )

    broadcastCount = broadcastCount + 1

    if broadcastCount > 999 then
        broadcastCount = 1
    end

    Sleep(1000 + math.random(200, 600))

    SendPacket(
        2,
        "action|input\n|text|`2(megaphone)Count Broadcast " ..
        broadcastCount ..
        "/999(megaphone)"
    )

    return true
end

local function startSB()
    local active = {}

    for name, data in pairs(sb) do
        if data.enable then
            table.insert(active, name)
        end
    end

    if #active == 0 then
        sendVariant({
            v1 = "OnConsoleMessage",
            v2 = "`4[SC PREMIUM] `wTidak ada SB yang aktif."
        })
        return
    end

    sbRunning = true

    sendVariant({
        v1 = "OnConsoleMessage",
        v2 = "`2[SC PREMIUM] `wAuto SB dimulai."
    })

    for _, name in ipairs(active) do
        if not sbRunning then
            break
        end

        if sb[name].enable then
            local sent = sendBroadcast(name)

            if sent then
                sb[name].last = os.time() * 1000
            end
        end
    end
end

local function stopSB()
    sbRunning = false

    sendVariant({
        v1 = "OnConsoleMessage",
        v2 = "`4[SC PREMIUM] `wAuto SB dihentikan."
    })
end

local function handleCommands(packet)
    local text = packet:gsub(
        "action|input\n|text|",
        ""
    )

    local cmd, value =
        text:match("^/([^%s]+)%s*(.*)")

    if not cmd then
        return false
    end

    cmd = cmd:lower()

    if cmd == "setsb" then
        showSettings()
        return true

    elseif cmd == "startsb" then
        if not sbRunning then
            startSB()
        else
            sendVariant({
                v1 = "OnConsoleMessage",
                v2 = "`6[SC PREMIUM] `wSB sudah berjalan."
            })
        end

        return true

    elseif cmd == "stopsb" then
        stopSB()
        return true
    end

    return false
end

local function handleDialog(packet)
    local dialog =
        packet:match("dialog_name|([^\n]+)")

    if dialog ~= "scpremium" then
        return false
    end

    local clicked =
        packet:match("buttonClicked|([^\n]+)")

    if clicked == "cancel_sb" then
        return true
    end

    if clicked == "save_sb" then
        saveSettings(packet)

        sendVariant({
            v1 = "OnConsoleMessage",
            v2 = "`2[SC PREMIUM] `wSettings saved."
        })

        return true
    end

    if clicked == "save_start_sb" then
        saveSettings(packet)
        startSB()

        return true
    end

    return true
end

addHook(function(type, packet)
    if type ~= 2 or not packet then
        return false
    end

    if packet:find("action|dialog_return") then
        return handleDialog(packet)
    end

    if packet:find("action|input") then
        return handleCommands(packet)
    end

    return false
end, "onSendPacket")

runThread(function()
    while true do
        if sbRunning then
            local now = os.time() * 1000

            for name, data in pairs(sb) do
                if data.enable and data.last > 0 then
                    if now - data.last >= data.delay then
                        local sent = sendBroadcast(name)

                        if sent then
                            data.last = os.time() * 1000
                        end
                    end
                end
            end
        end

        Sleep(1000)
    end
end)

math.randomseed(os.time())

sendVariant({
    v1 = "OnConsoleMessage",
    v2 = "`2[SC PREMIUM] `wLoaded! Use /setsb"
})
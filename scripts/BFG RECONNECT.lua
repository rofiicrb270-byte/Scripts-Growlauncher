local savedX = 51
local savedY = 56
local savedWorld = "WINE" 
-- keluar dari world jika sudah save settingan, dan tunggu 2 detik sc akan auto enter world
-- auto consume clover setiap 30menit + 2detik
local MAG_X = 25
local MAG_Y = 49

local CLOVER_ID = 528
local CLOVER_DELAY = 2000
local CLOVER_LOOP_DELAY = 1802 * 1000

local cloverRunning = false

function S(t)
    local r = {}
    for i = 1, #t do
        r[i] = string.char(t[i])
    end
    return table.concat(r)
end

local TXT = {
    R = S({82,79,80,73,73}),
    RI = S({82,79,80,73,73,73}),
    CP = S({67,79,78,84,82,79,76,32,80,65,78,69,76}),
    RS = S({82,69,67,79,78,78,69,67,84,32,83,69,84,84,73,78,71,83}),
    BP = S({66,70,71,32,80,79,83,73,84,73,79,78}),
    MP = S({77,65,71,32,80,79,83,73,84,73,79,78}),
    CS = S({67,85,82,82,69,78,84,32,83,69,84,84,73,78,71,83}),
    SS = S({83,65,86,69,32,83,69,84,84,73,78,71,83}),
    TR = S({84,65,75,69,32,82,69,77,79,84,69}),
    RT = S({82,69,77,79,84,69,32,84,65,75,69,78}),
    DC = S({68,73,83,67,79,78,78,69,67,84}),
    RC = S({82,69,67,79,78,78,69,67,84}),
    JW = S({74,79,73,78,32,87,79,82,76,68}),
    FP = S({70,73,78,68,80,65,84,72}),
    AB = S({65,85,84,79,32,66,70,71,32,43,32,65,85,84,79,32,70,65,82,77,32,79,78}),
    CC = S({67,76,79,86,69,82,32,67,79,78,83,85,77,69,68}),
    SL = S({83,69,84,84,73,78,71,83,32,83,65,86,69,68}),
    WC = S({87,79,82,76,68}),
    BG = S({66,70,71}),
    MG = S({77,65,71}),
    CL = S({67,76,79,86,69,82}),
    CLD = S({67,76,79,86,69,82,32,68,69,76,65,89}),
    UP = S({85,83,69,32,47,114,111,112})
}

function showCommandDialog()
    local dialog =
        "add_label_with_icon|big|`2" .. TXT.R .. " " .. TXT.CP .. "|left|10078|\n" ..
        "add_spacer|small|\n" ..
        "add_textbox|`9" .. TXT.RS .. "|left|\n" ..
        "add_text_input|world|" .. TXT.WC .. "|" .. savedWorld .. "|24|\n" ..
        "add_spacer|small|\n" ..
        "add_textbox|`9" .. TXT.BP .. "|left|\n" ..
        "add_text_input|bfg_x|BFG X|" .. savedX .. "|5|\n" ..
        "add_text_input|bfg_y|BFG Y|" .. savedY .. "|5|\n" ..
        "add_spacer|small|\n" ..
        "add_textbox|`9" .. TXT.MP .. "|left|\n" ..
        "add_text_input|mag_x|MAG X|" .. MAG_X .. "|5|\n" ..
        "add_text_input|mag_y|MAG Y|" .. MAG_Y .. "|5|\n" ..
        "add_spacer|small|\n" ..
        "add_button|save_settings|`2" .. TXT.SS .. "|\n" ..
        "add_spacer|small|\n" ..
        "add_textbox|`9" .. TXT.CS .. "|left|\n" ..
        "add_label_with_icon|small|`0" .. TXT.WC .. " : `2" .. savedWorld .. "|left|3802|\n" ..
        "add_label_with_icon|small|`0" .. TXT.BG .. " : `2" .. savedX .. ", " .. savedY .. "|left|18|\n" ..
        "add_label_with_icon|small|`0" .. TXT.MG .. " : `2" .. MAG_X .. ", " .. MAG_Y .. "|left|5640|\n" ..
        "add_label_with_icon|small|`0" .. TXT.CL .. " : `2" .. CLOVER_ID .. "|left|528|\n" ..
        "add_label_with_icon|small|`0" .. TXT.CLD .. " : `230:02|left|528|\n" ..
        "add_spacer|small|\n" ..
        "end_dialog|ropii_control|Close|OK!|"

    sendVariant({
        v1 = "OnDialogRequest",
        v2 = dialog
    })
end

function getValue(packet, key)
    local value = packet:match("\n" .. key .. "|([^\n]*)")

    if not value then
        value = packet:match("^" .. key .. "|([^\n]*)")
    end

    return value
end

function handleCommands(packet)
    local text = packet:gsub("action|input\n|text|", ""):lower()
    local cmd, value = text:match("^/([^%s]+)%s*(.*)")

    if not cmd then
        return false
    end

    if cmd == "rop" then
        showCommandDialog()
        return true
    end

    return false
end

function takeMag()
    LogToConsole("`2" .. TXT.R .. " `0| `9" .. TXT.TR)

    SendPacketRaw(false, {
        type = 3,
        state = 0,
        value = 32,
        px = MAG_X,
        py = MAG_Y,
        x = MAG_X * 32,
        y = MAG_Y * 32
    })

    Sleep(500)

    SendPacket(2,
        "action|dialog_return\n" ..
        "dialog_name|itemsucker\n" ..
        "tilex|" .. MAG_X .. "|\n" ..
        "tiley|" .. MAG_Y .. "|\n" ..
        "buttonClicked|getplantationdevice\n" ..
        "chk_enablesucking|1"
    )

    Sleep(800)

    LogToConsole("`2" .. TXT.R .. " `0| `2" .. TXT.RT)
end

function enableBFG()
    SendPacket(2,
        "action|dialog_return\n" ..
        "dialog_name|cheat_dialog\n" ..
        "select_farm_id|5640"
    )

    Sleep(200)

    SendPacket(2,
        "action|dialog_return\n" ..
        "dialog_name|cheat_dialog\n" ..
        "cheat_anti|1\n" ..
        "cheat_modify|0\n" ..
        "cheat_speed|0\n" ..
        "cheat_gravity|0\n" ..
        "cheat_nocollect|1\n" ..
        "cheat_fast_drop|0\n" ..
        "cheat_fast_trash|0\n" ..
        "cheat_fast_ban|0\n" ..
        "cheat_fast_pull|0\n" ..
        "cheat_fast_kick|0\n" ..
        "cheat_autobfg|1\n" ..
        "cheat_autofarm|1\n" ..
        "cheat_autospam|0\n" ..
        "auto_spam_text|\n" ..
        "auto_spam_delay|4"
    )

    LogToConsole("`2" .. TXT.R .. " `0| `2" .. TXT.AB)
end

function consumeClover()
    local me = GetLocal()

    if not me then
        return
    end

    local pkt = {}

    pkt.type = 3
    pkt.value = CLOVER_ID
    pkt.px = math.floor(me.posX / 32)
    pkt.py = math.floor(me.posY / 32)
    pkt.x = me.posX
    pkt.y = me.posY

    SendPacketRaw(false, pkt)

    Sleep(CLOVER_DELAY)

    LogToConsole("`2" .. TXT.R .. " `0| `2" .. TXT.CC)
end

function startCloverLoop()
    if cloverRunning then
        return
    end

    cloverRunning = true

    runCoroutine(function()
        while cloverRunning do
            Sleep(CLOVER_LOOP_DELAY)

            if cloverRunning then
                consumeClover()
            end
        end
    end)
end

function startAfterReconnect()
    Sleep(500)

    takeMag()

    Sleep(500)

    LogToConsole(
        "`5" .. TXT.R .. " | `w" .. TXT.FP .. " `2" ..
        savedX .. " " .. savedY
    )

    findPath(savedX, savedY)

    Sleep(1000)

    enableBFG()

    Sleep(500)

    consumeClover()

    startCloverLoop()
end

AddHook(function(type, pkt)

    if type == 2 then

        if pkt:find("action|input") then
            return handleCommands(pkt)
        end

        if pkt:find("action|dialog_return") then

            if pkt:find("dialog_name|ropii_control") then

                if pkt:find("buttonClicked|save_settings") then

                    local world = getValue(pkt, "world")
                    local bfg_x = getValue(pkt, "bfg_x")
                    local bfg_y = getValue(pkt, "bfg_y")
                    local mag_x = getValue(pkt, "mag_x")
                    local mag_y = getValue(pkt, "mag_y")

                    if world and world ~= "" then
                        savedWorld = world
                    end

                    if bfg_x and tonumber(bfg_x) then
                        savedX = tonumber(bfg_x)
                    end

                    if bfg_y and tonumber(bfg_y) then
                        savedY = tonumber(bfg_y)
                    end

                    if mag_x and tonumber(mag_x) then
                        MAG_X = tonumber(mag_x)
                    end

                    if mag_y and tonumber(mag_y) then
                        MAG_Y = tonumber(mag_y)
                    end

                    LogToConsole("`2" .. TXT.R .. " `0| `w" .. TXT.SL)
                    LogToConsole("`2" .. TXT.R .. " `0| `w" .. TXT.WC .. ": `9" .. savedWorld)
                    LogToConsole("`2" .. TXT.R .. " `0| `w" .. TXT.BG .. ": `9" .. savedX .. ", " .. savedY)
                    LogToConsole("`2" .. TXT.R .. " `0| `w" .. TXT.MG .. ": `9" .. MAG_X .. ", " .. MAG_Y)
                    LogToConsole("`2" .. TXT.R .. " `0| `w" .. TXT.CL .. ": `9" .. CLOVER_ID)

                    showCommandDialog()

                    return true
                end
            end
        end
    end

    if type == 3 and pkt:find("exit") then

        runCoroutine(function()

            LogToConsole("`4" .. TXT.R .. " | `w" .. TXT.DC)
            LogToConsole("`5" .. TXT.R .. " | `w" .. TXT.RC)

            CSleep(3000)

            SendPacket(3, [[action|join_request
name|]] .. savedWorld)

            LogToConsole(
                "`5" .. TXT.R .. " | `w" .. TXT.JW .. ": `2" ..
                savedWorld
            )

            CSleep(3000)

            startAfterReconnect()

        end)

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

LogToConsole("`2" .. TXT.RI .. " | `w" .. TXT.CP .. " LOADED")
LogToConsole("`2" .. TXT.RI .. " | `w" .. TXT.CL .. " AUTO CONSUME: `2ON")
LogToConsole("`2" .. TXT.RI .. " | `w" .. TXT.UP)

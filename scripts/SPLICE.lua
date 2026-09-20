local delaySP = 55
local delayHT = 250

local seed1 = 2029
local seed2 = 2013
local harvestID = 3207

local ex = 99
local ey = 59

local cycleDelay = 1000
local is_running = false

function showStatus()
    sendVariant({
        v1 = "OnConsoleMessage",
        v2 = "`2[MASS] `wStatus:`^"..tostring(is_running)..
             " `wSeed1:`^"..seed1..
             " `wSeed2:`^"..seed2..
             " `wHT:`^"..harvestID
    })

    sendVariant({
        v1 = "OnConsoleMessage",
        v2 = "`2[MASS] `wDelay SP:`^"..delaySP..
             " `wDelay HT:`^"..delayHT
    })
end

function showCommandDialog()
    local dialog =
    "add_label_with_icon|big|`2Ropii MASS|left|"..harvestID.."|\n"..
    "add_spacer|small|\n"..
    "add_label_with_icon|small|`0Status : `2"..tostring(is_running).."|left|18|\n"..
    "add_label_with_icon|small|`0Seed1 : `2"..seed1.."|left|"..seed1.."|\n"..
    "add_label_with_icon|small|`0Seed2 : `2"..seed2.."|left|"..seed2.."|\n"..
    "add_label_with_icon|small|`0Harvest ID : `2"..harvestID.."|left|"..harvestID.."|\n"..
    "add_label_with_icon|small|`0Delay Splice : `2"..delaySP.."|left|1432|\n"..
    "add_label_with_icon|small|`0Delay Harvest : `2"..delayHT.."|left|1482|\n"..
    "add_spacer|small|\n"..
    "add_textbox|`9Commands|left|\n"..
    "add_label_with_icon|small|`0/start|left|10078|\n"..
    "add_label_with_icon|small|`0/stop|left|10078|\n"..
    "add_label_with_icon|small|`0/rop|left|10078|\n"..
    "add_label_with_icon|small|`0/id ht <id>|left|10078|\n"..
    "add_label_with_icon|small|`0/seed1 <id>|left|10078|\n"..
    "add_label_with_icon|small|`0/seed2 <id>|left|10078|\n"..
    "add_label_with_icon|small|`0/delay sp <ms>|left|10078|\n"..
    "add_label_with_icon|small|`0/delay ht <ms>|left|10078|\n"..
    "end_dialog|masspanel|Close|OK|"

    sendVariant({
        v1 = "OnDialogRequest",
        v2 = dialog
    })
end
function handleCommands(packet)
    local text = packet:gsub("action|input\n|text|",""):lower()
    local cmd, value = text:match("^/([^%s]+)%s*(.*)")

    if not cmd then
        return false
    end

    local handled = true

    if cmd == "start" then
        if not is_running then
            is_running = true
            sendVariant({
                v1 = "OnConsoleMessage",
                v2 = "`2[MASS] `wStarted."
            })
        else
            sendVariant({
                v1 = "OnConsoleMessage",
                v2 = "`4[MASS] `wAlready Running."
            })
        end

    elseif cmd == "stop" then
        is_running = false
        sendVariant({
            v1 = "OnConsoleMessage",
            v2 = "`4[MASS] `wStopped."
        })

    elseif cmd == "rop" then
        showCommandDialog()

    elseif cmd == "seed1" then
        local id = tonumber(value)
        if id then
            seed1 = id
            sendVariant({
                v1 = "OnConsoleMessage",
                v2 = "`2[MASS] `wSeed1 -> `2"..seed1
            })
        else
            sendVariant({
                v1 = "OnConsoleMessage",
                v2 = "`4[MASS] `wInvalid Seed1 ID."
            })
        end

    elseif cmd == "seed2" then
        local id = tonumber(value)
        if id then
            seed2 = id
            sendVariant({
                v1 = "OnConsoleMessage",
                v2 = "`2[MASS] `wSeed2 -> `2"..seed2
            })
        else
            sendVariant({
                v1 = "OnConsoleMessage",
                v2 = "`4[MASS] `wInvalid Seed2 ID."
            })
        end

    elseif cmd == "id" then
        local mode, id = value:match("^(%S+)%s+(%d+)")
        if mode == "ht" then
            harvestID = tonumber(id)
            sendVariant({
                v1 = "OnConsoleMessage",
                v2 = "`2[MASS] `wHarvest ID -> `2"..harvestID
            })
        else
            sendVariant({
                v1 = "OnConsoleMessage",
                v2 = "`4[MASS] `wUsage : /id ht <id>"
            })
        end

    elseif cmd == "delay" then
        local mode, ms = value:match("^(%S+)%s+(%d+)")
        ms = tonumber(ms)

        if mode == "sp" then
            delaySP = ms
            sendVariant({
                v1 = "OnConsoleMessage",
                v2 = "`2[MASS] `wDelay Splice -> `2"..delaySP.." ms"
            })

        elseif mode == "ht" then
            delayHT = ms
            sendVariant({
                v1 = "OnConsoleMessage",
                v2 = "`2[MASS] `wDelay Harvest -> `2"..delayHT.." ms"
            })

        else
            sendVariant({
                v1 = "OnConsoleMessage",
                v2 = "`4[MASS] `wUsage : /delay sp <ms> atau /delay ht <ms>"
            })
        end

    else
        handled = false
    end

    return handled
end
addHook(function(type, packet)
    if type == 2 and packet:find("action|input") then
        return handleCommands(packet)
    end
end, "onSendPacket")

sendVariant({
    v1 = "OnConsoleMessage",
    v2 = "`2[Ropii MASS] `wLoaded. Use `2/rop `wto open Control Panel."
})

showStatus()
function path(x, y, state)
    sendPacketRaw(false, {
        state = state,
        px = x,
        py = y,
        x = x * 32,
        y = y * 32
    })
end

function placeSeed(x, y, id)
    sendPacketRaw(false, {
        type = 3,
        value = id,
        px = x,
        py = y,
        x = x * 32,
        y = y * 32
    })
end

function getSeed1()
    local count = 0

    for y = ey, 0, -1 do
        for x = 0, ex do
            local t = getTile(x, y)

            if t.fg == seed1 then
                count = count + 1
            end
        end
    end

    return count
end

function getReady()
    local ready = 0

    for y = ey, 0, -1 do
        for x = 0, ex do
            local t = getTile(x, y)

            if t.fg == harvestID and t.readyharvest then
                ready = ready + 1
            end
        end
    end

    return ready
end

function uws()
    sendPacket(2, "action|dialog_return\ndialog_name|uw_spray")
    sleep(1000)
end
function splice()

    sendPacket(2, "action|input\n|text|")
    sleep(cycleDelay)

    local found

    repeat

        if not is_running then
            return
        end

        found = false

        for x = 0, ex do
    for y = 0, ey do

                if not is_running then
                    return
                end

                local t = getTile(x, y)

                if t.fg == seed1 then

                    path(x, y, 32)
                    placeSeed(x, y, 5640)
                    placeSeed(x, y, seed2)

                    sleep(delaySP)
                    
                    if not is_running then
    return
end

                    found = true

                end

            end
        end

    until not found

end

function harvest()

    sendPacket(2, "action|input\n|text|")
    sleep(cycleDelay)

    local found

    repeat

        if not is_running then
            return
        end

        found = false

        for y = ey, 0, -1 do
            for x = 0, ex do

                if not is_running then
                    return
                end

                local t = getTile(x, y)

                if t.fg == harvestID and t.readyharvest then

                    path(x, y, 32)
                    placeSeed(x, y, 18)

                    sleep(delayHT)

                    if not is_running then
                        return
                    end

                    found = true

                end

            end
        end

    until not found

end
runThread(function()
    while true do

        if is_running then

            -- PHASE 1 : SPLICE
            while is_running and getSeed1() > 0 do
                splice()
            end

            if not is_running then
                goto continue
            end

            -- PHASE 2 : UWS
            uws()

            if not is_running then
                goto continue
            end

            -- PHASE 3 : HARVEST
            while is_running and getReady() > 0 do
                harvest()
            end

            if not is_running then
                goto continue
            end

            -- PHASE 4 : WAIT FOR NEW SEED1
while is_running and getSeed1() == 0 do
    sleep(500)
end

            ::continue::

        else

            sleep(500)

        end

    end
end)
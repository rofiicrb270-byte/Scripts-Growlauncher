local Credits = "Ropii"

local ProviderID = 1008
local DelayHarvest = 100

local BatasX = 99
local BatasY = 99

local DelayWorld = 1500
local DelayReady = 500

local Worlds = {
    "RUDATM3",
    "RUDATM4",
    "WORLD3",
    "WORLD4",
    "WORLD5",
    "WORLD6",
    "WORLD7",
    "WORLD8",
    "WORLD9",
    "WORLD10"
}

local currentWorld = ""
local currentWorldIndex = 0
local reconnecting = false
local running = true
local reconnectCount = 0

function S(t)
    local r = {}

    for i = 1, #t do
        r[i] = string.char(t[i])
    end

    return table.concat(r)
end

local TXT = {
    R = S({82,111,112,105,105}),
    START = S({65,117,116,111,32,72,97,114,118,101,115,116,32,80,114,111,118,105,100,101,114,32,83,116,97,114,116,101,100}),
    WORLD = S({87,111,114,108,100}),
    JOIN = S({74,111,105,110,105,110,103}),
    READY = S({87,111,114,108,100,32,82,101,97,100,121}),
    HTSTART = S({72,84,32,83,116,97,114,116,105,110,103}),
    HTFINISH = S({72,84,32,70,105,110,105,115,104,101,100}),
    NEXT = S({77,111,118,105,110,103,32,116,111,32,110,101,120,116,32,119,111,114,108,100}),
    ALLFINISH = S({65,108,108,32,87,111,114,108,100,115,32,70,105,110,105,115,104,101,100}),
    DC = S({68,105,115,99,111,110,110,101,99,116,101,100}),
    RECONNECT = S({82,101,99,111,110,110,101,99,116,105,110,103}),
    CONTINUE = S({67,111,110,116,105,110,117,101,32,72,84}),
    ONEHIT = S({49,45,72,105,116,32,79,70,70}),
    SCAN = S({82,101,115,99,97,110,110,105,110,103,32,80,114,111,118,105,100,101,114}),
    RETRY = S({82,101,116,114,121,105,110,103,32,87,111,114,108,100})
}

function Chat(text)
    SendPacket(
        2,
        "action|input\n|text|[`2" .. TXT.R .. "`w] " .. text
    )
end

SendVariant({
    v0 = "OnTalkBubble",
    v1 = GetLocal().netID,
    v2 = "[`bRopii`w] Auto Harvest Provider"
})

function Harvest(x, y, z)
    SendPacketRaw(false, {
        type = 3,
        state = 32,
        value = z,
        px = x,
        py = y,
        x = x * 32,
        y = y * 32
    })

    Sleep(DelayHarvest)
end

function NoClip(x, y)
    SendPacketRaw(false, {
        type = 0,
        x = x * 32,
        y = y * 32
    })

    Sleep(60)
end

function Disable1Hit()
    SendPacket(
        2,
        "action|dialog_return\n" ..
        "dialog_name|personalize_profile\n" ..
        "buttonClicked|save\n\n" ..
        "checkbox_1hit|0"
    )

    Sleep(300)
end

function IsWorldReady()
    local me = GetLocal()

    if not me then
        return false
    end

    local tile = GetTile(0, 0)

    if not tile then
        return false
    end

    return true
end

function WaitWorldReady()
    local timeout = 0

    while not IsWorldReady() and timeout < 30000 do
        Sleep(500)
        timeout = timeout + 500
    end

    if not IsWorldReady() then
        return false
    end

    Sleep(DelayReady)

    return true
end

function JoinWorld(world)
    SendPacket(
        3,
        "action|join_request\n" ..
        "name|" .. world .. "\n" ..
        "invitedWorld|0"
    )

    Sleep(DelayWorld)

    return WaitWorldReady()
end

function GetReady()
    if reconnecting then
        return -1
    end

    if not IsWorldReady() then
        return -1
    end

    local ready = 0

    for y = 0, BatasY do
        for x = 0, BatasX do
            local tile = GetTile(x, y)

            if tile
            and tile.fg == ProviderID
            and tile.readyharvest then
                ready = ready + 1
            end
        end
    end

    return ready
end

function HarvestWorld()
    for y = 0, BatasY do

        for x = 0, BatasX do

            while reconnecting do
                Sleep(500)
            end

            if not IsWorldReady() then
                while not IsWorldReady() do
                    Sleep(500)
                end

                Sleep(DelayReady)
                Disable1Hit()
            end

            local tile = GetTile(x, y)

            if tile
            and tile.fg == ProviderID
            and tile.readyharvest then

                NoClip(x, y)
                Harvest(x, y, 18)
            end
        end
    end
end

function ProcessWorld()
    Chat(
        TXT.HTSTART ..
        ": `9" ..
        currentWorld
    )

    HarvestWorld()

    while true do

        while reconnecting do
            Sleep(500)
        end

        if not IsWorldReady() then
            Sleep(500)
        else
            Sleep(100)

            local remaining = GetReady()

            if remaining == 0 then
                break
            end

            if remaining > 0 then
                HarvestWorld()
            end
        end
    end

    Chat(
        TXT.HTFINISH ..
        ": `9" ..
        currentWorld
    )

    return true
end

function StartWorld(index, world)
    currentWorldIndex = index
    currentWorld = world

    Chat(
        TXT.WORLD ..
        " `9" ..
        index ..
        "/" ..
        #Worlds ..
        "`w: `9" ..
        world
    )

    local joined = JoinWorld(world)

    while not joined do

        while reconnecting do
            Sleep(500)
        end

        Chat(TXT.RETRY .. ": `9" .. world)

        Sleep(1000)

        joined = JoinWorld(world)
    end

    Sleep(500)

    Disable1Hit()

    Sleep(300)

    ProcessWorld()

    return true
end

AddHook(function(type, pkt)

    if type == 3 and pkt:find("exit") then

        if reconnecting then
            return false
        end

        reconnecting = true
        reconnectCount = reconnectCount + 1

        runCoroutine(function()

            Chat(TXT.DC)

            Chat(
                TXT.RECONNECT ..
                ": `9" ..
                currentWorld
            )

            Sleep(3000)

            local connected = false

            while not connected do

                if currentWorld == "" then
                    break
                end

                SendPacket(
                    3,
                    "action|join_request\n" ..
                    "name|" .. currentWorld .. "\n" ..
                    "invitedWorld|0"
                )

                Sleep(DelayWorld)

                connected = WaitWorldReady()

                if not connected then
                    Sleep(1500)
                end
            end

            if connected then

                Disable1Hit()

                Sleep(500)

                Chat(
                    TXT.READY ..
                    ": `9" ..
                    currentWorld
                )

                Chat(
                    TXT.SCAN ..
                    ": `9" ..
                    currentWorld
                )

                reconnecting = false

                Sleep(300)

                Chat(
                    TXT.CONTINUE ..
                    ": `9" ..
                    currentWorld
                )

            else
                reconnecting = false
            end

        end)
    end

    return false

end, "onSendPacket")

runCoroutine(function()

    Chat(TXT.START)

    for i = 1, #Worlds do

        if not running then
            break
        end

        while reconnecting do
            Sleep(500)
        end

        local world = Worlds[i]

        StartWorld(i, world)

        while reconnecting do
            Sleep(500)
        end

        if i < #Worlds then

            Chat(
                TXT.NEXT ..
                ": `9" ..
                Worlds[i + 1]
            )

            Sleep(300)
        end
    end

    Chat(TXT.ALLFINISH)

end)
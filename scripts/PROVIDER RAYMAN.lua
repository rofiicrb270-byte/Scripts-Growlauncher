local delayHT = 250 --jangan ubah terlalu kecil nanti bnyak yg bolong
local harvestID = 928 --id provider
local ex = 99
local ey = 59 --ini gausah di ubah
local delayWTW = 1500

local worlds = {
    "ROPSC1", --bisa tambahin sendiri kalo punya 10 world lebih
    "MRBAIT", --kalo kurang dari 10 world bisa di hapus aja
    "WORLD3",
    "WORLD4",
    "WORLD5",
    "WORLD6",
    "WORLD7",
    "WORLD8",
    "WORLD9",
    "WORLD10"
}

sendPacket(2, "action|dialog_return\ndialog_name|personalize_profile\nbuttonClicked|save\n\ncheckbox_1hit|0")

function path(x, y, state)
    sendPacketRaw(false, {
        state = state,
        px = x,
        py = y,
        x = x * 32,
        y = y * 32
    })
end

function h2(x, y, id)
    sendPacketRaw(false, {
        type = 3,
        value = id,
        px = x,
        py = y,
        x = x * 32,
        y = y * 32
    })
end

function getReady()
    local ready = 0

    for x = 0, ex do
        for y = 0, ey do
            local tile = getTile(x, y)

            if tile
            and tile.fg == harvestID
            and tile.readyharvest then
                ready = ready + 1
            end
        end
    end

    return ready
end

function harvest()
    for y = ey, 0, -1 do

        local harvested = false

        repeat
            harvested = true

            for x = 0, ex do

                local tile = getTile(x, y)

                if tile
                and tile.fg == harvestID
                and tile.readyharvest then

                    path(x, y, 5640)
                    h2(x, y, 18)

                    sleep(delayHT)

                    harvested = false
                end
            end

            sleep(10)

        until harvested
    end

    sleep(10)

    return getReady() == 0
end

function joinWorld(world)
    sendPacket(
        3,
        "action|join_request\nname|" .. world .. "\ninvitedWorld|0"
    )

    sleep(delayWTW)
end

sendPacket(
    2,
    "action|input\n|text|`2[PROVIDER] Auto HT + WTW Started"
)

sendPacket(
    2,
    "action|input\n|text|/show_ping"
)

for i = 1, #worlds do

    local world = worlds[i]

    sendPacket(
        2,
        "action|input\n|text|`2[WTW] World `9" ..
        i .. "/" .. #worlds ..
        " `2: `9" .. world
    )

    joinWorld(world)

    sleep(500)

    sendPacket(
        2,
        "action|input\n|text|`2[HT] Starting: `9" .. world
    )

    harvest()

    while getReady() > 0 do
        harvest()
        sleep(100)
    end

    sendPacket(
        2,
        "action|input\n|text|`2[ROPII] HT Finished (peace): `9" .. world
    )

    if i < #worlds then
        sendPacket(
            2,
            "action|input\n|text|`2[WTW] Moving to next world..."
        )

        sleep(300)
    end
end

sendPacket(
    2,
    "action|input\n|text|`2[ROPI] All worlds finished (peace)."
)
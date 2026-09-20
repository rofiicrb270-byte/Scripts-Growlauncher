LogToConsole("`2[Ropii PT] `wScript Started")
-- use remote magplant

local ex = 99
local ey = 59

local delayPT = 20
local loopCount = "unli"

function path(x, y, state)
    SendPacketRaw(false, {
        state = state,
        px = x,
        py = y,
        x = x * 32,
        y = y * 32
    })
end

function h2(x, y, id)
    SendPacketRaw(false, {
        type = 3,
        value = id,
        px = x,
        py = y,
        x = x * 32,
        y = y * 32
    })
end

function plant()
    LogToConsole("`2[Ropii PT] `6Putting Provider...")

    for y = ey, 0, -1 do
        local planted = false

        repeat
            planted = true

            for x = 0, ex do
                if GetTile(x, y).fg == 0 then
                    path(x, y, 32)
                    h2(x, y, 5640)

                    Sleep(delayPT)

                    planted = false
                end
            end
        until planted
    end
end

local i = 0

repeat
    i = i + 1

    LogToConsole(
        "`2[Ropii PT] `wRotation: `6#" ..
        i ..
        "`w / `6" ..
        loopCount
    )

    plant()

    SendVariant(
        "OnConsoleMessage",
        {
            "action|input",
            "|text|`2[Ropii PT] `wRotation: `6#" ..
            i ..
            "`w / `6" ..
            loopCount
        }
    )

until loopCount ~= "unli" and i == tonumber(loopCount)

if loopCount ~= "unli" then
    LogToConsole(
        "`2[Ropii PT] `wFinished: `6" ..
        loopCount ..
        " Rotation"
    )

    SendVariant(
        "OnConsoleMessage",
        {
            "action|input",
            "|text|`2[Ropii PT] `wFinished: `6" ..
            loopCount ..
            " Rotation"
        }
    )
end

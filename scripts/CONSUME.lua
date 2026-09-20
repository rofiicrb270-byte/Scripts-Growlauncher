local kuponID = 17438 -- gnti id disinii
local kuponDelay = 10
local waitingCoupon = false

local waitingText = string.char(
    96,52,91,82,79,80,73,73,93,32,77,69,78,85,78,71,71,85,32,67,79,85,80,79,78,46,46,46
)

function getItemCount(id)
    local inv = GetInventory() or getInventory()
    if not inv then return 0 end

    for _, item in pairs(inv) do
        if item.id == id then
            return item.amount or 0
        end
    end

    return 0
end

function useKupon()
    local me = GetLocal()
    if not me then return end

    SendPacketRaw(false, {
        type = 3,
        value = kuponID,
        x = me.posX,
        y = me.posY,
        px = math.floor(me.posX / 32),
        py = math.floor(me.posY / 32)
    })
end

runThread(function()
    while true do
        local count = getItemCount(kuponID)

        if count > 0 then
            waitingCoupon = false
            useKupon()
            Sleep(kuponDelay)
        else
            if not waitingCoupon then
                LogToConsole(waitingText)
                waitingCoupon = true
            end

            Sleep(100)
        end
    end
end)

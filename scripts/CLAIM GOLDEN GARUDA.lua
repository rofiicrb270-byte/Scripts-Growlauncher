if IS_RUNNING_GARUDA then return end
IS_RUNNING_GARUDA = true

local GOLDEN_ID = 12568
local DROP_AMOUNT = 200
local CLAIM_DELAY = 50
local DROP_DELAY = 500

local function GetAmount(id)
    for _, inv in pairs(GetInventory()) do
        if inv.id == id then
            return inv.amount
        end
    end
    return 0
end

local function Claim()
    SendPacket(2,
        "action|dialog_return\n" ..
        "dialog_name|garudaevent_quest\n" ..
        "buttonClicked|claimreward"
    )
end

local function Drop()
    SendPacket(2,
        "action|drop\n|itemID|" .. GOLDEN_ID .. "|\ncount|" .. DROP_AMOUNT
    )
end

while true do

    local amount = GetAmount(GOLDEN_ID)

    if amount >= DROP_AMOUNT then

        LogToConsole("`6Golden Garuda Chest : "..amount.."/200")

        Drop()

        Sleep(DROP_DELAY)

        local afterDrop = GetAmount(GOLDEN_ID)

        if afterDrop < amount then
            LogToConsole("`2DROP BERHASIL")
        else
            LogToConsole("`4DROP GAGAL")
            Sleep(1000)
        end

    else

        Claim()

        Sleep(CLAIM_DELAY)

    end

end
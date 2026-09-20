LogToConsole("`4 Made By : Ropii")

local x = 63 -- posisi awal drop

local MAG_X = 88 -- posisi mag
local MAG_Y = 51

local BUY_DELAY = 5
local DROP_DELAY = 50
local MAG_DELAY = 70

local WIG_ID = 2914
local FISH_TANK_ID = 3004
local TACKLE_ID = 3044

local OTHER_ITEMS = {
    2912,
    3002,
    5524,
    5522
}

local moving = false

local function GetAmount(id)
    for _, item in pairs(GetInventory()) do
        if item.id == id then
            return item.amount
        end
    end
    return 0
end

local function MoveNextTile()
    if moving then
        return
    end

    moving = true

    x = x + 1

    LogToConsole("`4BLOCK PENUH")
    LogToConsole("`6PINDAH KE `2" .. x .. "," .. y)

    FindPath(x, y)

    Sleep(1000)

    moving = false
end

local function DropItem(id, count)
    local amount = GetAmount(id)

    if amount <= 0 then
        return true
    end

    SendPacket(
        2,
        "action|drop\n|itemID|" ..
        id ..
        "|\ncount|" ..
        count
    )

    Sleep(DROP_DELAY)
    Sleep(750)

    local afterDrop = GetAmount(id)

    if afterDrop >= 200 then
        MoveNextTile()
        return false
    end

    return true
end

local function CheckWiggly()
    local amount = GetAmount(WIG_ID)

    if amount >= 190 then
        LogToConsole(
            "`6Wiggly Worm : `2" ..
            amount .. "/200"
        )

        return DropItem(WIG_ID, amount)
    end

    return true
end

local function CheckFishTank()
    local amount = GetAmount(FISH_TANK_ID)

    if amount >= 190 then
        LogToConsole(
            "`6Fish Tank : `2" ..
            amount .. "/200"
        )

        return DropItem(FISH_TANK_ID, amount)
    end

    return true
end

local function CheckOtherItems()
    for _, id in ipairs(OTHER_ITEMS) do
        local amount = GetAmount(id)

        if amount >= 200 then
            LogToConsole(
                "`6Item Full : `2" ..
                id .. " : " .. amount .. "/200"
            )

            if not DropItem(id, 200) then
                return false
            end
        end
    end

    return true
end

local function AddTackleToMag()
    local amount = GetAmount(TACKLE_ID)

    if amount < 200 then
        return true
    end

    LogToConsole(
        "`6TACKLE : `2" ..
        amount ..
        "/200 `6→ ADD MAG"
    )

    SendPacket(
        2,
        "action|dialog_return\n" ..
        "dialog_name|itemaddedtosucker\n" ..
        "tilex|" .. MAG_X .. "|\n" ..
        "tiley|" .. MAG_Y .. "|\n" ..
        "itemtoadd|200"
    )

    Sleep(MAG_DELAY)

    return true
end

local function BuyPack()
    SendPacket(
        2,
        [[
action|buy
item|fishin_pack
]]
    )

    Sleep(BUY_DELAY)
end

FindPath(x, y)
Sleep(1000)

while true do
    if not moving then

        if not CheckWiggly() then
            Sleep(100)

        elseif not CheckFishTank() then
            Sleep(100)

        elseif not CheckOtherItems() then
            Sleep(100)

        elseif GetAmount(TACKLE_ID) >= 200 then
            AddTackleToMag()

        else
            BuyPack()
        end

    else
        Sleep(100)
    end
end

LogToConsole("`4Ropii")

local x = 63
local y = 53

local MAG_X = 88 --- posisi magplant
local MAG_Y = 51

local BUY_DELAY = 25
local DROP_DELAY = 100  --- enable fast drop in /cheat
local MAG_DELAY = 70

local ATM_ID = 1008
local PACK_NAME = "city_pack"

local DROP_THRESHOLD = 180
local ATM_THRESHOLD = 150

local DROP_ITEMS = {
    994,
    986,
    992,
    990,
    996,
    998,
    988,
    1004,
    1006,
    1002
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

    LogToConsole("`4Ropii `6BLOCK PENUH")
    LogToConsole("`6PINDAH KE `2" .. x .. "," .. y)

    FindPath(x, y)
    Sleep(1000)

    moving = false
end

local function DropItem(id)
    local amount = GetAmount(id)

    if amount < DROP_THRESHOLD then
        return true
    end

    LogToConsole("`4Ropii `6DROP `2" .. id .. " `6: `2" .. amount)

    sendPacket(
        2,
        "action|drop\n" ..
        "|itemID|" .. id .. "|\n" ..
        "count|" .. amount
    )

    sleep(DROP_DELAY)
    sleep(300)

    local afterDrop = GetAmount(id)

    if afterDrop >= 200 then
        MoveNextTile()
        return false
    end

    return true
end

local function CheckDropItems()
    for _, id in ipairs(DROP_ITEMS) do
        if GetAmount(id) >= DROP_THRESHOLD then
            if not DropItem(id) then
                return false
            end
        end
    end

    return true
end

local function AddATMToMag()
    local amount = GetAmount(ATM_ID)

    if amount < ATM_THRESHOLD then
        return true
    end

    LogToConsole(
        "`4Ropii `6ATM `2" ..
        amount ..
        " `6→ ADD MAG"
    )

    sendPacket(
        2,
        "action|dialog_return\n" ..
        "dialog_name|itemaddedtosucker\n" ..
        "tilex|" .. MAG_X .. "|\n" ..
        "tiley|" .. MAG_Y .. "|\n" ..
        "itemtoadd|" .. amount
    )

    sleep(MAG_DELAY)

    return true
end

local function BuyPack()
    LogToConsole("`4Ropii `6BUY CITY PACK")

    sendPacket(
        2,
        "action|buy\n" ..
        "item|city_pack\n"
    )

    sleep(BUY_DELAY)
end

FindPath(x, y)
sleep(1000)

while true do

    if moving then
        sleep(100)
    else

        if GetAmount(ATM_ID) >= ATM_THRESHOLD then
            AddATMToMag()

        elseif not CheckDropItems() then
            sleep(100)

        else
            BuyPack()
        end

    end

end
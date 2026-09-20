LogToConsole("`4ROPII `6SURG PACK")

local PACK_NAME = "surg_value_pack"

local BUY_DELAY = 25
local DROP_DELAY = 100
local MAG_DELAY = 70

local BUY_BATCH = 10
local DROP_THRESHOLD = 200

local x = 63
local y = 53

local MAG_X = 88
local MAG_Y = 51

local DROP_ITEMS = {
    1262,
    1266,
    1264,
    4314,
    4312,
    4318,
    4308,
    1260,
    1268,
    1258,
    1270,
    4310,
    4316
}

local MAG_ITEM_ID = 4296
local MAG_THRESHOLD = 1

local moving = false
local need_reset = false

local function GetAmount(id)
    local inv = GetInventory() or getInventory()

    if not inv then
        return 0
    end

    for _, item in pairs(inv) do
        if item.id == id then
            return item.amount or 0
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

    LogToConsole(
        "`4ROPII `6TILE PENUH → PINDAH KE `2" ..
        x .. "," .. y
    )

    FindPath(x, y)
    Sleep(1000)

    moving = false
    need_reset = false
end

local function DropItem(id)
    local amount = GetAmount(id)

    if amount <= 0 then
        return true
    end

    LogToConsole(
        "`4ROPII `6DROP `2" ..
        id ..
        " `6: `2" ..
        amount
    )

    SendPacket(
        2,
        "action|dialog_return\n" ..
        "dialog_name|drop_item\n" ..
        "itemID|" .. id .. "\n" ..
        "count|" .. amount
    )

    Sleep(DROP_DELAY)

    return true
end

local function DropAllTools()
    for _, id in ipairs(DROP_ITEMS) do

        if need_reset then
            return false
        end

        local amount = GetAmount(id)

        if amount >= DROP_THRESHOLD then
            DropItem(id)
        end

        Sleep(20)
    end

    return true
end

local function AddMagItem()
    local amount = GetAmount(MAG_ITEM_ID)

    if amount < MAG_THRESHOLD then
        return true
    end

    LogToConsole(
        "`4ROPII `6MAG `2" ..
        MAG_ITEM_ID ..
        " `6: `2" ..
        amount
    )

    SendPacket(
        2,
        "action|dialog_return\n" ..
        "dialog_name|itemaddedtosucker\n" ..
        "tilex|" .. MAG_X .. "|\n" ..
        "tiley|" .. MAG_Y .. "|\n" ..
        "itemtoadd|" .. amount
    )

    Sleep(MAG_DELAY)

    return true
end

local function BuyPack()
    SendPacket(
        2,
        "action|buy\n" ..
        "item|" .. PACK_NAME .. "\n"
    )

    Sleep(BUY_DELAY)
end

local function BuyBatch()
    LogToConsole(
        "`4ROPII `6BUY `2" ..
        BUY_BATCH ..
        "x `6SURG PACK"
    )

    for i = 1, BUY_BATCH do
        BuyPack()
    end
end

AddHook(function(v)

    if v.v1 == "OnTextOverlay" and v.v2 then

        local text = v.v2:lower()

        if text:find("emptier") then
            need_reset = true

            LogToConsole("`4ROPII `6DROP TILE PENUH")

            return true
        end
    end

end, "OnVariant")

FindPath(x, y)
Sleep(1000)

while true do

    if moving then

        Sleep(100)

    else

        BuyBatch()

        local dropped = DropAllTools()

        if not dropped or need_reset then
            MoveNextTile()
        else
            AddMagItem()
        end

        Sleep(100)

    end

end

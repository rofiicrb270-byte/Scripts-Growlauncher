local mode = "takenDrop"

local itemID = 830 -- gnti id items
local delay = 20

local magX = 2 -- posisi mag
local magY = 58
local retrieveAmount = 200

local x = 2 -- posisi awal drop items
local y = 58 -- auto move jika sudah tidak bisa drop lgi

local moving = false
local retrieving = false

local function checkItemAmount(id)
    for _, item in pairs(GetInventory()) do
        if item.id == id then
            return item.amount
        end
    end
    return 0
end

local function moveNext()
    if moving then
        return
    end

    moving = true
    x = x + 1

    LogToConsole("`2[ROPII] `4DROP PENUH")
    LogToConsole("`2[ROPII] `6PINDAH KE `w" .. x .. "," .. y)

    FindPath(x, y)
    Sleep(500)

    moving = false
end

local function dropItem(amount)
    if amount <= 0 or moving then
        return true
    end

    local beforeDrop = checkItemAmount(itemID)

    if mode == "takenDrop" then
        SendPacket(
            2,
            "action|drop\n" ..
            "itemID|" .. itemID .. "\n" ..
            "count|" .. amount
        )
    elseif mode == "takenTrash" then
        SendPacket(
            2,
            "action|trash\n" ..
            "|itemID|" .. itemID
        )
    end

    Sleep(300)

    local afterDrop = checkItemAmount(itemID)

    if mode == "takenDrop" then
        if afterDrop >= beforeDrop then
            moveNext()
            return false
        end

        return true
    end

    return true
end

local function retrieveItem()
    if retrieving or moving then
        return
    end

    retrieving = true

    SendPacket(
        2,
        "action|dialog_return\n" ..
        "dialog_name|itemsucker\n" ..
        "tilex|" .. magX .. "|\n" ..
        "tiley|" .. magY .. "|\n" ..
        "buttonClicked|retrieveitem\n" ..
        "chk_enablesucking|1"
    )

    Sleep(delay)

    SendPacket(
        2,
        "action|dialog_return\n" ..
        "dialog_name|itemremovedfromsucker\n" ..
        "tilex|" .. magX .. "|\n" ..
        "tiley|" .. magY .. "|\n" ..
        "itemtoremove|" .. retrieveAmount
    )

    Sleep(delay)

    retrieving = false
end

local function processItem()
    if moving or retrieving then
        return
    end

    local amount = checkItemAmount(itemID)

    if amount > 0 then
        local success = dropItem(amount)

        if not success then
            return
        end
    end

    retrieveItem()

    if retrieving then
        return
    end

    local newAmount = checkItemAmount(itemID)

    if newAmount > 0 then
        dropItem(newAmount)
    end
end

AddHook(function(var)
    if var.v1 == "OnDialogRequest" then
        local dialog = var.v2 or ""

        if dialog:find("itemsucker")
        or dialog:find("MAGPLANT 5000")
        or dialog:find("Retrieve Item") then

            if retrieving then
                return false
            end

            return true
        end
    end

    return false
end, "onVariant")

LogToConsole("`2╔══════════════════════════════╗")
LogToConsole("`2║       ROPII MAGPLANT        ║")
LogToConsole("`2║       FAST DROP MODE        ║")
LogToConsole("`2║       ITEM ID : `w830       `2║")
LogToConsole("`2╚══════════════════════════════╝")

while true do
    if not moving and not retrieving then
        processItem()
    end

    Sleep(1)
end

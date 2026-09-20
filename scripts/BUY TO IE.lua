local SETTINGS = {
    buyAmount = 200, -- amount
    world = "MID" -- bisa di gnti
}

local function getAmount(itemID)
    for _, data in pairs(getInventory()) do
        if data.id == itemID then
            return data.amount
        end
    end
    return 0
end

local function branding()
    return string.char(82, 79, 80, 73, 73)
end

local function sendStatus(text)
    logToConsole(text)
    SendPacket(2, "action|input\n|text|" .. text)
end

local function sendToExtra(itemID)
    SendPacket(2,
        "action|dialog_return\n" ..
        "dialog_name|extra_inventory_player\n" ..
        "item_id|" .. itemID .. "|\n" ..
        "amount_add|" .. getAmount(itemID) .. "\n"
    )
end

local function buyVending(dialog)
    local x = dialog:match("tilex|(%d+)")
    local y = dialog:match("tiley|(%d+)")
    local item = dialog:match("expectitem|(%d+)")
    local price = dialog:match("expectprice|(%d+)")

    if not x or not y or not item or not price then
        return
    end

    item = tonumber(item)
    price = tonumber(price)

    sendToExtra(item)

    SendPacket(2,
        "action|dialog_return\n" ..
        "dialog_name|vending\n" ..
        "tilex|" .. x .. "|\n" ..
        "tiley|" .. y .. "|\n" ..
        "verify|1|\n" ..
        "buycount|" .. SETTINGS.buyAmount .. "|\n" ..
        "expectprice|" .. price .. "|\n" ..
        "expectitem|" .. item .. "|\n"
    )
end

SendPacket(3,
    "action|join_request\n" ..
    "name|" .. SETTINGS.world
)

AddHook(function(v)
    if v.v1 ~= "OnDialogRequest" then
        return false
    end

    local dialog = v.v2 or ""

    if dialog:find("extra_inventory_player") then
        if dialog:find("Max Extra Inventory! Can't add more!") then
            sendStatus("`4" .. branding() .. " | EXTRA INVENTORY FULL")
        end

        return true
    end

    if dialog:find("vending") then
        buyVending(dialog)
        return true
    end

    return false
end, "onVariant")

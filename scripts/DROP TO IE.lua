local ITEM_ID = 3206 
local CHECK_DELAY = 500
local adding = false

local function getItemCount(item)
    for _, itm in pairs(getInventory()) do
        if itm.id == item then
            return itm.amount
        end
    end
    return 0
end

local function log(str)
    logToConsole("`2ROPII `0| " .. str)
end

local function addToIE()
    if adding then
        return
    end

    local amount = getItemCount(ITEM_ID)

    if amount <= 0 then
        return
    end

    adding = true

    sendPacket(2,
        "action|dialog_return\n" ..
        "dialog_name|extra_inventory_player\n" ..
        "item_id|" .. ITEM_ID .. "\n" ..
        "amount_add|" .. amount .. "\n"
    )

    log("`9ADD IE `2" .. amount .. "x `9ID `2" .. ITEM_ID)
    sleep(200)
    adding = false
end

AddHook(function(_, str)
    local id = str:match("^/id%s+(%d+)")

    if id then
        ITEM_ID = tonumber(id)
        log("`9ID CHANGED `2" .. ITEM_ID)
        return true
    end

    return false
end, "onSendPacket")

AddHook(function(var)
    if var.v1 == "OnDialogRequest"
    and var.v2:find("extra_inventory_player") then
        return true
    end

    return false
end, "onVariant")

log("`2START ADD IE")

while true do
    addToIE()
    sleep(CHECK_DELAY)
end
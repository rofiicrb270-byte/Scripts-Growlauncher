--note aktifkan fast drop di /cheat
local conf_ = {
    item_id = 3206,
    active = false
}

local TAKE_AMOUNT = 200

local function setup()
    return [[
add_label_with_icon|big|`c[Ropii] `9Configuration`` |left|]] .. conf_.item_id .. [[|
add_spacer|small|
add_textbox|`^Item ID :|
add_text_input|item_id_||]] .. conf_.item_id .. [[|6|
end_dialog|ropii_ie_setup|| Apply Changes |
]]
end

function log(str)
    logToConsole('`^[`9[ROPII]`` ' .. str)
end

AddHook(function(_, str)

    if str:find("/setup") then

        sendVariant({
            v1 = "OnDialogRequest",
            v2 = setup()
        })

        return true
    end

    if str:find("dialog_name|ropii_ie_setup") then

        conf_.item_id =
            tonumber(str:match("item_id_|(%d+)"))
            or conf_.item_id

        log("`2Item ID Updated `0: `5" .. conf_.item_id)

        return true
    end

    if str:find("/start") then

        conf_.active = true

        log("`2SC STARTED")
        log("`wItem ID : `5" .. conf_.item_id)

        return true
    end

    if str:find("/stop") then

        conf_.active = false

        log("`4SC STOPPED")

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

while true do

    if conf_.active then

        SendPacket(
            2,
            "action|dialog_return\n" ..
            "dialog_name|extra_inventory_player\n" ..
            "item_id|" .. conf_.item_id .. "\n" ..
            "pos|0\n" ..
            "amount_remove|" .. TAKE_AMOUNT
        )

        Sleep(100)

        SendPacket(
            2,
            "action|drop\n" ..
            "|itemID|" .. conf_.item_id
        )

        Sleep(100)

    else

        Sleep(100)

    end

end
local ITEM_ID = 3206

local conf_ = {
    active = false
}

local TAKE_AMOUNT = 200

local magX = 64
local magY = 41

local TAKE_DELAY = 300
local MAG_DELAY = 50

local function setup()
    return [[
add_label_with_icon|big|`c[Ropii] `9Configuration`` |left|3206|
add_spacer|small|
add_textbox|`^Mag X :|
add_text_input|mag_x_||]] .. magX .. [[|6|
add_textbox|`^Mag Y :|
add_text_input|mag_y_||]] .. magY .. [[|6|
end_dialog|ropii_ie_setup|| Apply Changes |
]]
end

function log(str)
    logToConsole('`^[`9[Ropii]`` '.. str)
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

        magX =
            tonumber(str:match("mag_x_|(%d+)"))
            or magX

        magY =
            tonumber(str:match("mag_y_|(%d+)"))
            or magY

        log("`9Mag : `5" .. magX .. "," .. magY)

        return true
    end

    if str:find("/start") then
        conf_.active = true
        log("`2IE MAG Started")
        return true
    end

    if str:find("/stop") then
        conf_.active = false
        log("`4IE MAG Stopped")
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

        SendPacket(2,
            "action|dialog_return\n" ..
            "dialog_name|extra_inventory_player\n" ..
            "buttonClicked|searchableItemListButton_" ..
            ITEM_ID .. "_200_0\n" ..
            "searchFixedName|"
        )

        Sleep(TAKE_DELAY)

        SendPacket(2,
            "action|dialog_return\n" ..
            "dialog_name|extra_inventory_player\n" ..
            "item_id|" .. ITEM_ID .. "\n" ..
            "pos|0\n" ..
            "amount_remove|" .. TAKE_AMOUNT
        )

        Sleep(MAG_DELAY)

        SendPacket(2,
            "action|dialog_return\n" ..
            "dialog_name|itemaddedtosucker\n" ..
            "tilex|" .. magX .. "|\n" ..
            "tiley|" .. magY .. "|\n" ..
            "itemtoadd|" .. TAKE_AMOUNT
        )

        Sleep(MAG_DELAY)

    else
        Sleep(100)
    end

end
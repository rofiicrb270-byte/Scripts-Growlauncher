local delayPT = 0
local delayHT = 250
local loopCount = "unli"
local ptht = "PTHT"
local harvestID = 955
local ex = 99
local ey = 59 --ubah ini kalo mau ubah kordinat awal ptht drimana
local is_running = false
local cycleDelay = 2000

function showStatus()sendVariant({v1="OnConsoleMessage",v2="`2[STATUS] `wMode:`^"..ptht.."`w,Delay:`^"..delayPT.."`w/`^"..delayHT.."`w,HarvestID:`^"..harvestID})sendVariant({v1="OnConsoleMessage",v2="`2[STATUS] `wBatas(ex,ey):`^"..ex..","..ey.."`w,Status:`^"..tostring(is_running)})end
function showCommandDialog()
    local cmd_dialog = "add_label_with_icon|big|`2Ropii Control Panel|left|" .. harvestID .. "|\n" ..
    "add_spacer|small|\n" ..
    "add_textbox|`9Current Configuration|left|\n" ..
    "add_label_with_icon|small|`0Mode                   : `2" .. ptht .. "|left|5638|\n" ..
    "add_label_with_icon|small|`0Delay Plant          : `2" .. delayPT .. "|left|1432|\n" ..
    "add_label_with_icon|small|`0Delay Harvest      : `2" .. delayHT .. "|left|1482|\n" ..
    "add_label_with_icon|small|`0Harvest ID            : `2" .. harvestID .. "|left|16957|\n" ..
    "add_label_with_icon|small|`0World Border       : `2" .. ex .. ", " .. ey .. "|left|242|\n" ..
    "add_label_with_icon|small|`0Status Script       : `2" .. tostring(is_running) .. "|left|18|\n" ..
    "add_spacer|small|\n" ..
    "add_textbox|`9Commands:|left|\n" ..
    "add_label_with_icon|small|`0/start, /stop, /rop|left|10078|\n" ..
    "add_label_with_icon|small|`0Start / Stop Script and Open Ropii Control Panel|left|8282|\n" ..
    "add_label_with_icon|small|`0/id, /mode|left|10078|\n" ..
    "add_label_with_icon|small|`0ID - Change Harvest ID, MODE - Change Farming Mode (PT / HT / PTHT).|left|8282|\n" ..
    "end_dialog|cmddialog|Close|OK!|"
    sendVariant({v1 = "OnDialogRequest", v2 = cmd_dialog})
end

function path(x,y,s)sendPacketRaw(false,{state=s,px=x,py=y,x=x*32,y=y*32})end
function h2(x,y,i)sendPacketRaw(false,{type=3,value=i,px=x,py=y,x=x*32,y=y*32})end
sendPacket(2,"action|dialog_return\ndialog_name|personalize_profile\nbuttonClicked|save\n\ncheckbox_1hit|0")
function getTree()local c=0;for x=0,ex do for y=0,ey do local t,a=getTile(x,y),getTile(x,y+1)if t.fg==0 and a.fg~=0 and a.fg%2==0 then c=c+1 end end end;return c end
function getReady()local r=0;for x=0,ex do for y=0,ey do local t=getTile(x,y)if t.fg==harvestID and t.readyharvest then r=r+1 end end end;return r end
function uws()sendPacket(2,"action|input\n|text|`9[(punch)][`9`4Ropii`9]:UWS Consumed")sleep(200)sendPacket(2,"action|dialog_return\ndialog_name|uw_spray")sleep(1000)end

function plant()
    if ptht == "PTHT" or ptht == "PT" then 
        sendPacket(2, "action|input\n|text|")
        sleep(cycleDelay)
        for x = 0, ex do
            if not is_running then break end
            local planted; repeat
                if not is_running then break end; planted = true
                for y = 0, ey do
                    if not is_running then break end
                    local t, a = getTile(x, y), getTile(x, y + 1)
                    if t.fg == 0 and a.fg ~= 0 and a.fg % 2 == 0 then
                        path(x, y, 32); h2(x, y, 5640); sleep(delayPT); planted = false
                    end
                end
            until planted
        end
    end
end

function harvest()
    if ptht == "PTHT" or ptht == "HT" then
        sendPacket(2, "action|input\n|text|")
        sleep(cycleDelay)
        for x = 0, ex do
            if not is_running then break end
            local harvested; repeat
                if not is_running then break end; harvested = true
                for y = ey, 0, -1 do
                    if not is_running then break end
                    local t = getTile(x, y)
                    if t.fg == harvestID and t.readyharvest then
                        path(x, y, 5640); h2(x, y, 18); sleep(delayHT); harvested = false
                    end
                end
            until harvested
        end
    end
end

function handleCommands(packet)
    local text=packet:gsub("action|input\n|text|",""):lower()local cmd,value=text:match("^/([^%s]+)%s*(.*)")if not cmd then return false end;local handled=true
    if cmd=="id"then harvestID=tonumber(value)or harvestID;sendVariant({v1="OnConsoleMessage",v2="`2[SET] Harvest ID:`^"..harvestID})
    elseif cmd=="mode"then value=value:upper()if value=="PT"or value=="HT"or value=="PTHT"then ptht=value;sendVariant({v1="OnConsoleMessage",v2="`2[SET] Mode:`^"..ptht})else sendVariant({v1="OnConsoleMessage",v2="`4[ERROR] Mode tidak valid."})end
    elseif cmd=="start"then is_running=true;sendVariant({v1="OnConsoleMessage",v2="`l`2[CONTROL] Siklus dimulai..."})
    elseif cmd=="stop"then is_running=false;sendVariant({v1="OnConsoleMessage",v2="`l`4[CONTROL] Siklus dihentikan."})
    elseif cmd=="rop"then showCommandDialog()
    else handled=false end
    return handled
end

addHook(function(type, packet)
    if type == 2 and packet:find("action|input") then
        return handleCommands(packet)
    end
end, "onSendPacket")

local opening_dialog = "add_label_with_icon|big|`2Ropii PTHT |left|"..harvestID.."|\nadd_label_with_icon|small|`0Welcome to Ropii PTHT.|left|9474|\nadd_label_with_icon|small|`01 Hit is Turned `4OFF.|left|9474|\nadd_spacer|small|\nadd_textbox|`0Credit|\nadd_textbox|`2[-] `9Creator : `9@Ropii|\nadd_textbox|`0Hello `2"..(getLocal().name or "Player").." `0Enjoy Farming!|left|\nadd_spacer|small|\nadd_textbox|`9Current Settings|left|\nadd_label_with_icon|small|`0Delay PT:`2"..delayPT.."|left|1432|\nadd_label_with_icon|small|`0Delay HT:`2"..delayHT.."|left|1482|\nend_dialog|itro|Close|Olrait!|"
sendVariant({v1="OnDialogRequest",v2=opening_dialog})
sendVariant({v1="OnConsoleMessage",v2="`2[ROPIII] `wRopii PTHT Loaded. Use /rop to open the Control Panel."})

runThread(function()
    while true do
        if is_running then
            if ptht == "PT" then
                plant()
                if is_running and getTree() == 0 then uws() end
            elseif ptht == "HT" then
                harvest()
            elseif ptht == "PTHT" then
                harvest()
                if not is_running then goto continue_loop end
                plant()
                if not is_running then goto continue_loop end
                if getTree() == 0 then uws() end
            end
            ::continue_loop::
        else
            sleep(500)
        end
    end
end)
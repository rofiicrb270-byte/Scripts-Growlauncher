local BRAND = string.char(82, 79, 80, 73, 73)

local LEGAL_ID = 3172
local TOOL_WARNING = 20
local LEGAL_WARNING = 2

local surgeryTotal = 0
local surgerySuccess = 0
local surgeryFailed = 0

local legalUsing = false
local lastMalpractice = 0
local warningSent = {}

local surgeryTools = {
    {id = 1258, name = "Sponge"},
    {id = 1268, name = "Splint"},
    {id = 1266, name = "Antibiotic"},
    {id = 1262, name = "Anesthetic"},
    {id = 1260, name = "Scalpel"},
    {id = 1270, name = "Stitches"},
    {id = 4318, name = "Lab Kit"},
    {id = 4308, name = "Pins"},
    {id = 4314, name = "Clamp"},
    {id = 4310, name = "Transfusion"},
    {id = 4316, name = "Ultrasound"},
    {id = 4312, name = "Defibrillator"}
}

function say(text)
    SendPacket(2, "action|input\n|text|" .. text)
end

function getItemCount(id)
    local count = 0
    local inventory = GetInventory()

    if inventory then
        for _, item in pairs(inventory) do
            if item.id == id then
                count = item.amount
                break
            end
        end
    end

    return count
end

function checkTools()
    local counts = {}
    local inventory = GetInventory()

    if inventory then
        for _, item in pairs(inventory) do
            counts[item.id] = item.amount
        end
    end

    for _, item in ipairs(surgeryTools) do
        local amount = counts[item.id] or 0

        if amount == 0 then
            if not warningSent[item.id] then
                say("`9[`c" .. BRAND .. "`9] `4" .. item.name .. " HABIS!")
                warningSent[item.id] = true
            end
        elseif amount < TOOL_WARNING then
            if not warningSent[item.id] then
                say("`9[`c" .. BRAND .. "`9] `4" .. item.name .. " LOW `0(" .. amount .. ")")
                warningSent[item.id] = true
            end
        else
            warningSent[item.id] = nil
        end
    end

    local legal = counts[LEGAL_ID] or 0

    if legal == 0 then
        if not warningSent[LEGAL_ID] then
            say("`9[`c" .. BRAND .. "`9] `4Legal Briefs HABIS!")
            warningSent[LEGAL_ID] = true
        end
    elseif legal <= LEGAL_WARNING then
        if not warningSent[LEGAL_ID] then
            say("`9[`c" .. BRAND .. "`9] `6Legal Briefs LOW `0(" .. legal .. ")")
            warningSent[LEGAL_ID] = true
        end
    else
        warningSent[LEGAL_ID] = nil
    end
end

function showStats()
    local rate = 0

    if surgeryTotal > 0 then
        rate = (surgerySuccess / surgeryTotal) * 100
    end

    say(
        "`9[`c" .. BRAND .. "`9] " ..
        "`6Total: " .. surgeryTotal ..
        " `9|| `2Success: " .. surgerySuccess ..
        " `9|| `4Failed: " .. surgeryFailed ..
        " `9|| `2RATE: " .. math.floor(rate + 0.5) .. "%"
    )
end

function useLegalBriefs()
    if legalUsing then
        return
    end

    local amount = getItemCount(LEGAL_ID)

    if amount <= 0 then
        say("`9[`c" .. BRAND .. "`9] `4Legal Briefs HABIS!")
        return
    end

    legalUsing = true

    say("`9[`c" .. BRAND .. "`9] `4MALPRACTICE DETECTED! `0Using Legal Briefs...")

    SendPacketRaw(false, {
        type = 10,
        value = LEGAL_ID
    })

    Sleep(300)

    legalUsing = false
end

function auto()
   if tool == "Sponge" then
      itool = 1258
   elseif tool == "Splint" then
      itool = 1268
   elseif tool == "Antibiotic" then
      itool = 1266
   elseif tool == "Anesthetic" then
      itool = 1262
   elseif tool == "Scalpel" then
      itool = 1260
   elseif tool == "Stitches" then
      itool = 1270
   elseif tool == "Lab kit" then
      itool = 4318
   elseif tool == "Pins" then
      itool = 4308
   elseif tool == "Clamp" then
      itool = 4314
   elseif tool == "Transfusion" then
      itool = 4310
   elseif tool == "Ultrasound" then
      itool = 4316
   elseif tool == "Defibrillator" then
      itool = 4312
   elseif tool == "Fix it" then
      itool = 1296
   else
      return false
   end

   SendPacket(
      2,
      "action|dialog_return\n" ..
      "dialog_name|surgery\n" ..
      "buttonClicked|tool" .. itool
   )

   return true
end

function surg(var)
   if var.v1:find("OnDialogRequest") and var.v2:find("Status: `4Heart stopped!(.+)") and var.v2:find("tool4312") then
      tool = "Defibrillator"
      auto()
      return true
   elseif var.v1:find("OnDialogRequest") and var.v2:find("Pulse: `4(.+)") and var.v2:find("tool4310") then
      tool = "Transfusion"
      auto()
      return true
   elseif var.v1:find("OnDialogRequest") and var.v2:find("Pulse: `6(.+)") and var.v2:find("tool4310") then
      tool = "Transfusion"
      auto()
      return true
   elseif var.v1:find("OnDialogRequest") and var.v2:find("Patient is losing blood `4very quickly!(.+)") and var.v2:find("tool4314") then
      tool = "Clamp"
      auto()
      return true
   elseif var.v1:find("OnDialogRequest") and var.v2:find("Patient is losing blood `4very quickly!(.+)") and var.v2:find("tool1270") then
      tool = "Stitches"
      auto()
      return true
   elseif var.v1:find("OnDialogRequest") and var.v2:find("Patient is `6losing blood!(.+)") and var.v2:find("tool4314") then
      tool = "Clamp"
      auto()
      return true
   elseif var.v1:find("OnDialogRequest") and var.v2:find("Patient is `6losing blood!(.+)") and var.v2:find("tool1270") then
      tool = "Stitches"
      auto()
      return true
   elseif var.v1:find("OnDialogRequest") and var.v2:find("Patient is losing blood `3slowly.(.+)") and var.v2:find("tool1270") then
      tool = "Stitches"
      auto()
      return true
   elseif var.v1:find("OnDialogRequest") and var.v2:find("`4The patient wakes up!") and var.v2:find("tool1262") then
      tool = "Anesthetic"
      auto()
      return true
   elseif var.v1:find("OnDialogRequest") and var.v2:find("`4The patient screams and flails!") and var.v2:find("tool1262") then
      tool = "Anesthetic"
      auto()
      return true
   elseif var.v1:find("OnDialogRequest") and var.v2:find("Status: `6Coming to(.+)") and var.v2:find("tool1262") then
      tool = "Anesthetic"
      auto()
      return true
   elseif var.v1:find("OnDialogRequest") and var.v2:find("Temp: `4(%d+)(.+)") and var.v2:find("tool1266") then
      tool = "Antibiotic"
      auto()
      return true
   elseif var.v1:find("OnDialogRequest") and var.v2:find("Temp: `4(%d+)(.+)") and var.v2:find("tool4318") then
      tool = "Lab kit"
      auto()
      return true
   elseif var.v1:find("OnDialogRequest") and var.v2:find("Temp: `6(%d+)(.+)") and var.v2:find("tool1266") then
      tool = "Antibiotic"
      auto()
      return true
   elseif var.v1:find("OnDialogRequest") and var.v2:find("Temp: `6(%d+)(.+)") and var.v2:find("tool4318") then
      tool = "Lab kit"
      auto()
      return true
   elseif var.v1:find("OnDialogRequest") and var.v2:find("Temp: `3(%d+)(.+)") and var.v2:find("tool1266") then
      tool = "Antibiotic"
      auto()
      return true
   elseif var.v1:find("OnDialogRequest") and var.v2:find("Temp: `3(%d+)(.+)") and var.v2:find("tool4318") then
      tool = "Lab kit"
      auto()
      return true
   elseif var.v1:find("OnDialogRequest") and var.v2:find("Incisions: `20(.+)") and var.v2:find("tool1296") then
      tool = "Fix it"
      auto()
      return true
   elseif var.v1:find("OnDialogRequest") and var.v2:find("Incisions: `30(.+)") and var.v2:find("tool1296") then
      tool = "Fix it"
      auto()
      return true
   elseif var.v1:find("OnDialogRequest") and var.v2:find("The patient has not been diagnosed.") and var.v2:find("tool4316") then
      tool = "Ultrasound"
      auto()
      return true
   elseif var.v1:find("OnDialogRequest") and var.v2:find("Status: `4Awake(.+)") and var.v2:find("tool1262") then
      tool = "Anesthetic"
      auto()
      return true
   elseif var.v1:find("OnDialogRequest") and var.v2:find("Bones: `6(.+) broken``") and var.v2:find("tool1268") then
      tool = "Splint"
      auto()
      return true
   elseif var.v1:find("OnDialogRequest") and var.v2:find("Bones: `4(.+) broken``") and var.v2:find("tool1268") then
      tool = "Splint"
      auto()
      return true
   elseif var.v1:find("OnDialogRequest") and var.v2:find("Patient broke his arm.") and var.v2:find("tool1270") then
      tool = "Stitches"
      auto()
      return true
   elseif var.v1:find("OnDialogRequest") and var.v2:find("Status: `3Awake(.+)") and var.v2:find("tool1262") then
      tool = "Anesthetic"
      auto()
      return true
   elseif var.v1:find("OnDialogRequest") and var.v2:find("`6It is becoming hard to see your work.") and var.v2:find("tool1258") then
      tool = "Sponge"
      auto()
      return true
   elseif var.v1:find("OnDialogRequest") and var.v2:find("tool1296") and var.v2:find("tool1270") then
      tool = "Stitches"
      auto()
      return true
   elseif var.v1:find("OnDialogRequest") and var.v2:find("Bones: `6(.+), `6(.+) shattered(.+)") and var.v2:find("tool4308") then
      tool = "Pins"
      auto()
      return true
   elseif var.v1:find("OnDialogRequest") and var.v2:find("Bones: `6(.+), `6(.+) shattered(.+)") and var.v2:find("tool1260") then
      tool = "Scalpel"
      auto()
      return true
   elseif var.v1:find("OnDialogRequest") and var.v2:find("Bones: `4(.+), `6(.+) shattered(.+)") and var.v2:find("tool4308") then
      tool = "Pins"
      auto()
      return true
   elseif var.v1:find("OnDialogRequest") and var.v2:find("Bones: `4(.+), `6(.+) shattered(.+)") and var.v2:find("tool1260") then
      tool = "Scalpel"
      auto()
      return true
   elseif var.v1:find("OnDialogRequest") and var.v2:find("Bones: `6(.+), `4(.+) shattered(.+)") and var.v2:find("tool4308") then
      tool = "Pins"
      auto()
      return true
   elseif var.v1:find("OnDialogRequest") and var.v2:find("Bones: `6(.+), `4(.+) shattered(.+)") and var.v2:find("tool1260") then
      tool = "Scalpel"
      auto()
      return true
   elseif var.v1:find("OnDialogRequest") and var.v2:find("Bones: `4(.+), `4(.+) shattered(.+)") and var.v2:find("tool4308") then
      tool = "Pins"
      auto()
      return true
   elseif var.v1:find("OnDialogRequest") and var.v2:find("Bones: `4(.+), `4(.+) shattered(.+)") and var.v2:find("tool1260") then
      tool = "Scalpel"
      auto()
      return true
   elseif var.v1:find("OnDialogRequest") and var.v2:find("Bones: `6(.+) shattered(.+)") and var.v2:find("tool4308") then
      tool = "Pins"
      auto()
      return true
   elseif var.v1:find("OnDialogRequest") and var.v2:find("Bones: `6(.+) shattered(.+)") and var.v2:find("tool1260") then
      tool = "Scalpel"
      auto()
      return true
   elseif var.v1:find("OnDialogRequest") and var.v2:find("Bones: `4(.+) shattered(.+)") and var.v2:find("tool4308") then
      tool = "Pins"
      auto()
      return true
   elseif var.v1:find("OnDialogRequest") and var.v2:find("Bones: `4(.+) shattered(.+)") and var.v2:find("tool1260") then
      tool = "Scalpel"
      auto()
      return true
   elseif var.v1:find("OnDialogRequest") and var.v2:find("Patient broke his leg.") and var.v2:find("tool1270") then
      tool = "Stitches"
      auto()
      return true
   elseif var.v1:find("OnDialogRequest") and var.v2:find("tool1260") then
      tool = "Scalpel"
      auto()
      return true
   end

   return false
end

tool = ""
itool = 0

AddHook(function(var)
    if var.v1 == "OnDialogRequest" then
        return surg(var)
    end

    if var.v1 == "OnConsoleMessage" then
        local msg = var.v2 or ""

        if msg:find("YOUR MEDICAL LICENSE IS REVOKED!") then
            useLegalBriefs()
            return false
        end

        if msg:find("YOU SAVED YOUR PATIENT!") then
            surgeryTotal = surgeryTotal + 1
            surgerySuccess = surgerySuccess + 1

            showStats()
            checkTools()

            return false
        end

        if msg:find("has died") then
            surgeryTotal = surgeryTotal + 1
            surgeryFailed = surgeryFailed + 1

            showStats()
            checkTools()

            return false
        end
    end

    if var.v1 == "OnEquipNewItem" then
        local itemID = tonumber(var.v2)

        if itemID == LEGAL_ID then
            LogToConsole("`9[`c" .. BRAND .. "`9] `2Legal Briefs equipped!")
        end

        return false
    end

    return false
end, "OnVariant")

say("`9[`c" .. BRAND .. "`9] `2Auto Surgery ON")

checkTools()
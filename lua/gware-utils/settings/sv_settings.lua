local function getSetting(name)
    local val = false

    gWare.Utils.GetSetting(name, function(tblData)
        if tblData then val = true end
    end)

    return val
end

function gWare.Utils.AddSetting(tblData)
    gWare.Utils.Settings[tblData.name] = {name = tblData.name, description = tblData.description, value = tblData.defaultValue, settingType = tblData.settingType}

    timer.Simple(0, function()
        hook.Run("gWare.Utils.SettingsLoaded")
    end)

    if getSetting(tblData.name) then return end
    gWare.Utils.InsertSetting(tblData.name, tblData.defaultValue)
end

hook.Add("gWare.Utils.SettingsLoaded", "gWare.Utils.CacheSettings", function()
    gWare.Utils.GetAllSettings(function (tblData)
        for _, settings in ipairs(tblData) do
            local settingName = settings.setting_name
            local settingValue = gWare.Utils.IntToBool(tonumber(settings.setting_value))

            gWare.Utils.Settings[settingName].value = settingValue
        end
    end)
end)

function gWare.Utils.ChangeSetting(settingName, settingValue)
    if not getSetting(settingName) then return end

    gWare.Utils.UpdateSetting(settingName, settingValue)
    gWare.Utils.Settings[settingName].value = settingValue

    gWare.Utils.UpdateClient(settingName, settingValue)
end


///////////////////////////
// IN-GAME CONFIGURATION //
///////////////////////////

gWare.Utils.AddSetting({
    name = "NPC Waffen Drop",
    description = "Sollen NPCs beim Tod ihre Waffe fallen lassen?",
    defaultValue = true,
    settingType = "bool"
})

gWare.Utils.AddSetting({
    name = "Toolgun Geräusche",
    description = "Soll die Toolgun beim benutzen Geräusche machen?",
    defaultValue = true,
    settingType = "bool"
})

gWare.Utils.AddSetting({
    name = "Toolgun Effekte",
    description = "Soll die Toolgun beim benutzen Effekte machen?",
    defaultValue = true,
    settingType = "bool"
})

gWare.Utils.AddSetting({
    name = "Automatischer Cloak bei Noclip",
    description = "Soll der Spieler bei Noclip automatisch unsichtbar werden?",
    defaultValue = false,
    settingType = "bool"
})

gWare.Utils.AddSetting({
    name = "Killfeed anzeigen",
    description = "Sollen Spielertode rechts oben angezeigt werden?",
    defaultValue = true,
    settingType = "bool"
})

gWare.Utils.AddSetting({
    name = "Selbstmord erlauben?",
    description = "Kann ein spieler sich selbst umbringen (Konsolen Befehl)?",
    defaultValue = true,
    settingType = "bool"
})

gWare.Utils.AddSetting({
    name = "Spieler Waffen drop erlauben?",
    description = "Kann ein Spieler seine Waffen fallen lassen?",
    defaultValue = true,
    settingType = "bool"
})

gWare.Utils.AddSetting({
    name = "Automatischer Workshop-Download",
    description = "Sollen alle User bei joinen die Kollektion automatisch downloaden?",
    defaultValue = false,
    settingType = "bool"
})

gWare.Utils.AddSetting({
    name = "DarkRP Tafeln aktivieren?",
    description = "Sollen bei '/advert' Tafeln gespawned werden?",
    defaultValue = true,
    settingType = "bool"
})

gWare.Utils.AddSetting({
    name = "Family Sharing verbieten?",
    description = "Sollen User die Family-Sharing benutzen, sofort gekickt werden?",
    defaultValue = false,
    settingType = "bool"
})

gWare.Utils.AddSetting({
    name = "Sprachanzeige deaktiveren?",
    description = "Soll die Sprachanzeige Rechts unten deaktiviert werden?",
    defaultValue = false,
    settingType = "bool"
})

gWare.Utils.AddSetting({
    name = "Spawnmenü für User deaktivieren?",
    description = "Braucht der user eine permission um das Spawnmenü öffnen zu können?",
    defaultValue = false,
    settingType = "bool"
})

gWare.Utils.AddSetting({
    name = "Context-Menü für User deaktivieren?",
    description = "Braucht der user eine permission um das Context-Menü öffnen zu können?",
    defaultValue = false,
    settingType = "bool"
})

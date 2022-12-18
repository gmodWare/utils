///////////////////////////
//       SETTINGS        //
///////////////////////////

local OldSettings = {}

hook.Add("gWare.Utils.ClientReady", "gWare.Utils.WaitingForClient", function()

    -- Add hooks or functions in here, if u have to wait for client to get the settingsTable

    -- toolgun-sounds
    hook.Add("EntityEmitSound", "gWare.Utils.DisableToolGunSound", function(data)
        local ent = data.Entity

        if (IsValid(ent) and ent:IsPlayer() and ent:GetActiveWeapon():IsValid() and ent:GetActiveWeapon():GetClass() == "gmod_tool") then
            if not gWare.Utils.GetSettingValue("toolgun-sounds") then return end
            
            return false
        end
    end)

    -- toolgun-effects
    cvars.AddChangeCallback("gmod_drawtooleffects", function(convar_name, value_old, value_new)
        if (gWare.Utils.GetSettingValue("toolgun-effects") and value_new == "1") then
            RunConsoleCommand("gmod_drawtooleffects", "0")
        end
    end)

    hook.Add("gWare.Utils.SettingChanged", "gWare.Utils.PreventToolGunEffect", function(setting, value)
        if (setting ~= "toolgun-effects") then return end
        RunConsoleCommand("gmod_drawtooleffects", value and "0" or "1")
    end)

    hook.Add("InitPostEntity", "gWare.Utils.PreventToolGunEffect", function()
        OldSettings["gmod_drawtooleffects"] = GetConVar("gmod_drawtooleffects"):GetString()
        if (gWare.Utils.GetSettingValue("toolgun-effects")) then
            RunConsoleCommand("gmod_drawtooleffects", "0")
        end
    end)

    hook.Add("ShutDown", "gWare.Utils.ResetSettings", function()
        for setting, value in pairs(OldSettings) do
            RunConsoleCommand(setting, value)
        end
    end)

    -- killfeed
    hook.Add("DrawDeathNotice", "gWare.Utils.KillFeed", function()
        if not gWare.Utils.GetSettingValue("killfeed") then return end

        return false
    end)

    -- contextmenu
    hook.Add("ContextMenuOpen", "gWare.Utils.ContextMenuCheck", function()
        if not gWare.Utils.GetSettingValue("contextmenu") then return end
        if not LocalPlayer():HasGWarePermission("open_context_menu") then return false end
    end)

    -- spawnmenu
    hook.Add("OnSpawnMenuOpen", "gWare.Utils.SpawnMenuCheck", function()
        if not gWare.Utils.GetSettingValue("spawnmenu") then return end
        if not LocalPlayer():HasGWarePermission("open_spawnmenu") then return false end
    end)

    -- voice-panels
    hook.Add("HUDShouldDraw", "gWare.Utils.VoicePanels", function(name)
        if (name != "DarkRP_ChatReceivers") then return end

        if not gWare.Utils.GetSettingValue("voice-panels") then return end
        return false
    end)
end)

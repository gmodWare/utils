hook.Add("SAM.LoadedConfig", "gWare.Utils.SamModules.WaitForClient", function()
    if SAM_LOADED then
        sam.permissions.add("can_access_c-menu", "gWare", "superadmin")
    else
        CAMI.RegisterPrivilege({
            Name = "can_access_c-menu",
            MinAccess = "superadmin",
            Description = "Can the player open the c-menu?",
        })
    end

    if SAM_LOADED then
        sam.permissions.add("can_access_spawnmenu", "gWare", "superadmin")
    else
        CAMI.RegisterPrivilege({
            Name = "can_access_spawnmenu",
            MinAccess = "superadmin",
            Description = "Can the player open the spawnmenu?",
        })
    end

    if SAM_LOADED then
        sam.permissions.add("can_access_vote", "gWare", "superadmin")
        print("added vote permission in sam")
    else
        CAMI.RegisterPrivilege({
            Name = "can_access_vote",
            MinAccess = "superadmin",
            Description = "Can the player open the vote menu?",
        })
    end

    if SAM_LOADED then
        sam.permissions.add("can_change_gware_settings", "gWare", "superadmin")
    else
        CAMI.RegisterPrivilege({
            Name = "can_change_gware_settings",
            MinAccess = "superadmin",
            Description = "Can the player change the gWare settings?",
        })
    end

    if SAM_LOADED then
        sam.permissions.add("can_set_jobs-spawns_gware_tool", "gWare", "superadmin")
    else
        CAMI.RegisterPrivilege({
            Name = "can_set_jobs-spawns_gware_tool",
            MinAccess = "superadmin",
            Description = "Can the player set the job spawns per gWare tool?",
        })
    end
end)

hook.Add("OnContextMenuOpen", "gWare.Utils.ContextMenuCheck", function()
    if not gWare.Utils.GetSettingValue("contextmenu") then return end

    if SAM_LOADED then
        if not LocalPlayer():HasPermission("can_access_c-menu") then return false end
    else
        if not CAMI.PlayerHasAccess(LocalPlayer(), "can_access_c-menu") then return false end
    end
end)

hook.Add("OnSpawnMenuOpen", "gWare.Utils.SpawnMenuCheck", function()
    if not gWare.Utils.GetSettingValue("spawnmenu") then return end

    if SAM_LOADED then
        if not LocalPlayer():HasPermission("can_access_spawnmenu") then return false end
    else
        if not CAMI.PlayerHasAccess(LocalPlayer(), "can_access_spawnmenu") then return false end
    end
end)

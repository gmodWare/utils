--[[
    Command: /vfunk <name>* <nachricht>
    Description: Funkt eine verschlüsselte Nachricht, welche alle der empfangende Spieler
                entschlüsselt sehen kann, und alle anderen verschlüsselt.
                Basierend auf dem teil, den der spieler eingegeben hat, soll dann im Funk 
                der volle Spielername stehen. Wenn kein Spieler gefunden wird, dann sehen
                alle Spieler den Text verschlüsselt. Mit /decode kann man den Text 
                wieder leserlich machen.
    Example Command: /vfunk Ryzen* Antritt des Dienstes.
    Example Chat: [Verschlüsselter Funk] *1835 Menschlich an 5125 Ryzen* Antritt des Dienstes.
    Example Encrypted Chat: [Verschlüsselter Funk] *1835 Menschlich an 5125 Ryzen* 0f 12 3e 2d e3 f1 9d 5a 8b 4d 90
]]

local L = gWare.Utils.Lang.GetPhrase

local command = gWare.Utils.RegisterCommand({
    prefix = "encrypted-comms",
    triggers = {"vfunk", "ecomms", "encrypted", "ec"},
})

command:OnServerSide(function(ply, text)
    if not gWare.Utils.HasJobAccess(command:GetPrefix(), ply) then
        VoidLib.Notify(ply, L"notify_missing-perms-encrypted_name", L"notify_missing-perms-encrypted_desc", VoidUI.Colors.Red, 4)
        return ""
    end

    local args = text:Split("*")

    local namePart = text:sub(1, text:find("*") -1)
    local message = args[2]

    if not message then
        VoidLib.Notify(ply, L"notify_invalid-encrypted-ecomms_name", L"notify_invalid-encrypted-ecomms_desc", VoidUI.Colors.Red, 8)
        return
    end


    local charCodes = { string.byte(message, 1, string.len(message)) }
    local encrypted = ""

    for _, ascii in pairs(charCodes) do
        local hex = bit.tohex(ascii)
        local modifiedHex = hex:gsub("0*", "", 1)
        encrypted = encrypted .. modifiedHex .. " "
    end

    local clearTextReceivers = {}
    table.insert(clearTextReceivers, ply)

    local receiver = gWare.Utils.GetPlayerByNamePart(namePart)

    if IsEntity(receiver) then
        table.insert(clearTextReceivers, receiver)
    end

    local receiverName = namePart
    local receiverColor = VoidUI.Colors.Blue

    if IsEntity(receiver) then
        receiverName = receiver:Name()
        receiverColor = team.GetColor(receiver:Team())
    end

    -- send encrypted message to everyone except receiver and sender
    net.Start(command:GetNetID())
        net.WriteString(encrypted)
        net.WriteString(receiverName)
        net.WriteString(ply:Name())
        net.WriteTeam(ply)
        net.WriteColor(receiverColor)
    net.SendOmit(clearTextReceivers)

    -- now send clear text to sender and receiver
    net.Start(command:GetNetID())
        net.WriteString(message)
        net.WriteString(receiverName)
        net.WriteString(ply:Name())
        net.WriteTeam(ply)
        net.WriteColor(receiverColor)
    net.Send(clearTextReceivers)
end)

command:OnReceive(function()
    local col = gWare.Utils.Colors

    local message = net.ReadString()
    local receiverName = net.ReadString()
    local senderName = net.ReadString()
    local senderColor = team.GetColor(net.ReadTeam())
    local receiverColor = net.ReadColor()

    local toTranslated = " " .. L"general_to" .. " "

    gWare.Utils.PrintCommand(command:GetPrefix(),
        senderColor, senderName, col.Orange, toTranslated, receiverColor, receiverName, col.Brackets, " » ", color_white, message
    )
end)

local data = {}
TriggerEvent("redemrp_inventory:getData",function(call)
    data = call
end)

RegisterServerEvent("ss_ambulancejob:checkJob")
AddEventHandler("ss_ambulancejob:checkJob", function(value)
    TriggerEvent("redemrp:getPlayerFromId", source, function(user)
        if user.getJob() == "ambulance" then
            if value == 1 then
                TriggerClientEvent("ss_ambulancejob:openMenu", source)
            elseif value == 2 then
                TriggerClientEvent("ss_ambulancejob:openMenu2", source)
            else
                TriggerClientEvent("ss_ambulancejob:deleteVehicle", source)
            end
        end
    end)
end)

RegisterServerEvent("ss_ambulancejob:giveItem")
AddEventHandler("ss_ambulancejob:giveItem",function(name)
    data.addItem(source, name, 5)
end)

RegisterServerEvent("RegisterUsableItem:bandage")
AddEventHandler("RegisterUsableItem:bandage", function(source)
    local _source = source
    TriggerClientEvent("ss_ambulancejob:setPHealth", _source)
    data.delItem(_source, "bandage", 1)
    TriggerClientEvent("redemrp_notification:start", _source, "You've used a bandage", 3, "success")
end)

RegisterServerEvent("RegisterUsableItem:mbandage")
AddEventHandler("RegisterUsableItem:mbandage", function(source)
    local _source = source
    TriggerClientEvent("ss_ambulancejob:getClosestPlayer", _source, 1)
end)

RegisterServerEvent("ss_ambulancejob:setHealthS")
AddEventHandler("ss_ambulancejob:setHealthS", function(source, target)
    local _source = source
    TriggerEvent("redemrp:getPlayerFromId", target, function()
        TriggerClientEvent("ss_ambulancejob:setHealthC", target)
    end)
    data.delItem(_source, "mbandage", 1)
    TriggerClientEvent("redemrp_notification:start", _source, "You've used a medic bandage", 3, "success")
end)

RegisterServerEvent("RegisterUsableItem:medikit")
AddEventHandler("RegisterUsableItem:medikit", function(source)
    local _source = source
    TriggerClientEvent("ss_ambulancejob:getClosestPlayer", _source, 2)
end)

RegisterServerEvent("ss_ambulancejob:revivePlayer")
AddEventHandler("ss_ambulancejob:revivePlayer", function(source, target)
    local _source = source
    TriggerEvent("redemrp:getPlayerFromId", target, function()
        TriggerClientEvent("redemrp_respawn:rev", target)
    end)
    data.delItem(_source, "medikit", 1)
    TriggerClientEvent("redemrp_notification:start", _source, "You've used a medikit", 3, "success")
end)
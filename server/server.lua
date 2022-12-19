RegisterNetEvent('check:permissions')
AddEventHandler('check:permissions', function (hash)
    local src = source
    local check = false
    local roleid = ''
    for role, cat in pairs(wepcfg.whitelisted_weapons) do
       for k,v in pairs(cat) do
        if GetHashKey(v.WepName) == hash then
            roleid = role
        end
       end
       if roleid ~= '' then
        local userroles = GetDiscordRoles(src)
        if userroles ~= false then
           for _, roles in pairs(userroles) do
           if roles == roleid then
            check = true
            break;
           end 
        end        
       if not check then
          TriggerClientEvent('remove:weapon', src, hash)
	end
     end
    end
  end
end)

-- thanks badger for the discord funtions :)

function DiscordRequest(method, endpoint, jsondata)
	local data = nil
	PerformHttpRequest("https://discordapp.com/api/" .. endpoint, function(errorCode, resultData, resultHeaders)
		data = { data = resultData, code = errorCode, headers = resultHeaders }
	end, method, #jsondata > 0 and json.encode(jsondata) or "", { ["Content-Type"] = "application/json", ["Authorization"] = "Bot " .. dcfg.bot_token })

	while data == nil do
		Citizen.Wait(0)
	end

	return data
end

function GetDiscordRoles(user)
	local discordId = nil
	for _, id in ipairs(GetPlayerIdentifiers(user)) do
		if string.match(id, "discord:") then
			discordId = string.gsub(id, "discord:", "")
			break
			;end
	end

	if discordId then
		local endpoint = ("guilds/%s/members/%s"):format(dcfg.guild_id, discordId)
		local member = DiscordRequest("GET", endpoint, {})
		if member.code == 200 then
			local data = json.decode(member.data)
			local roles = data.roles
			local found = true
			return roles
		else
			print("[Vehicle-Whitelist] ERROR: Code 200 was not reached... Returning false. [Member Data NOT FOUND]")
			return false
		end
	else
		print("[Vehicle-Whitelist] ERROR: Discord was not connected to user's Fivem account...")
		return false
	end
	return false
end

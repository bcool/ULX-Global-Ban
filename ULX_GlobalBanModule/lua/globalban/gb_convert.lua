--ULX Global Ban
--Adobe And NigNog
------------------
include('globalban/gb_config.lua')
------------------
local Bans = 0;

function GB_ConvertBan(steamid, name, BanLength, Time, AdminName, AdminSteam, Reason, MAdmin, MTime)
	--Insert Ban
	local AddBanQuery = ULX_DB:query("INSERT INTO bans VALUES ('','"..steamid.."','"..GB_Escape(name).."','"..BanLength.."','"..Time.."','"..GB_Escape(AdminName).."','"..AdminSteam.."','"..GB_Escape(Reason).."','"..GB_SERVERID.."','"..MAdmin.."','"..MTime.."');");
	AddBanQuery.onSuccess = function()
	end
	AddBanQuery.onError = function(err) 
		print('[ULX GB] (ConvertBan Query) - Error: ', err);
	end
	AddBanQuery:start();
	Bans = Bans + 1
end

function GB_Convert()
	for k, v in pairs( ULib.bans ) do
		local ModAdmin = v.modified_admin or ''
		local ModTime = v.modified_time or ''
		if ModAdmin != nil then
			ModAdminInfo = string.Explode( "(", ModAdmin )
			ModAdminName = ModAdminInfo[1]
		end
		local Name = v.name
		if Name == '' then
			Name = 'John Doe'
		end
		Admin = string.Explode( "(", v.admin )
		AdminName = Admin[1]
		AdminSteamID = string.sub(Admin[2],1,string.len(Admin[2]) -1)
		GB_ConvertBan(k,Name,v.unban,v.time,AdminName,AdminSteamID,v.reason,ModAdminName,ModTime);
	end
	
	print('Total Bans Converted: '..Bans..'!');
	print('Please Restart The server! with convert mode switched to false!!!!');
end

GB_Convert();
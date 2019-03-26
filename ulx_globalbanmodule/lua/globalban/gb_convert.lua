--ULX Global Ban
--Adobe And NigNog
------------------
include('globalban/gb_config.lua')
------------------
local Bans = 0;

function GB_ConvertBan(steamid, name, BanLength, Time, AdminName, AdminSteam, Reason, MAdmin, MTime)
	--Insert Ban
	-- local AddBanQuery = ULX_DB:query("INSERT INTO bans VALUES ('','"..steamid.."','"..GB_Escape(name).."','"..BanLength.."','"..Time.."','"..GB_Escape(AdminName).."','"..AdminSteam.."','"..GB_Escape(Reason).."','"..GB_SERVERID.."','"..MAdmin.."','"..MTime.."');");
	local AddBanQuery = ULX_DB:query("INSERT INTO bans (OSteamID, OName, Length, Time, AName, ASteamID, Reason, ServerID, MAdmin, MTime) VALUES (?,?,?,?,?,?,?,?,?,?);");
	AddBanQuery:setString( 1, steamid )
	AddBanQuery:setString( 2, GB_Escape(name) )
	AddBanQuery:setNumber( 3, BanLength )
	AddBanQuery:setNumber( 4, Time )
	AddBanQuery:setString( 5, GB_Escape(AdminName) )
	AddBanQuery:setString( 6, AdminSteam )
	AddBanQuery:setString( 7, GB_Escape(Reason) )
	AddBanQuery:setNumber( 8, GB_SERVERID )
	AddBanQuery:setString( 9, MAdmin )
	AddBanQuery:setNumber( 10, MTime )
	function AddBanQuery.onSuccess() end
	function AddBanQuery.onError(err, sql) print('[ULX GB] (ConvertBan) - Error: ', err) end
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
			Name = 'Unknown'
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

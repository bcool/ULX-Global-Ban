--ULX Global Ban
--Adobe And NigNog
------------------

//Overwrite The Ulib Function on a global scope
function ULib.addBan( steamid, time, reason, name, admin )
	-- Get ban Length and add it os.time
	local BanLength = 0;
	if time == 0 then
		BanLength = 0;
	else
		BanLength = tonumber(os.time()) + (tonumber(time) * 60)
	end
	
	--Setup Admin Information
	local AdminName = "CONSOLE";
	local AdminSteam = "CONSOLE";
	if admin:IsPlayer() then
		AdminName = admin:Nick()
		AdminSteam = admin:SteamID()
	end
	
	--Query the Ban to the Database
	local AddBanQuery = ULX_DB:query("INSERT INTO bans VALUES ('','"..steamid.."','"..name.."','"..BanLength.."','"..AdminName.."','"..AdminSteam.."',' ','"..GB_SERVERID.."')");
	AddBanQuery.onSuccess = function()
		print("[ULX GB] - Ban Added!");
	end
	AddBanQuery.onError = function(err) 
		print('[ULX GB] (AddBanQuery) - Error: ', err);
	end
	AddBanQuery:start()
	
	-- Regardless of outcome Kick player From Server
	RunConsoleCommand('kickid',steamid,"You have been banned from the server.");
	
end

//This Function is broken so far...
/*
function xbans.populateBans( chunk )
	if !chunk then chunk = xgui.data.ban; end
	xbans.showperma:SetDisabled( true );
	xbans.isPopulating = xbans.isPopulating + 1;
	
	local BanList = ULX_DB:query("SELECT * FROM bans ORDER BY BanID DESC");
	BanList:wait()
	
	BanList.onSuccess = function()
		local data = BanList:getData();
		for i = 1, #data do
			if !(xbans.showperma:GetChecked() == false and tonumber(data[i]['Length']) == 0) then
				local baninfo;
				baninfo.unban = data[i]['Length'];
				baninfo.name = data[i]['OName'];
				baninfo.admin = data[i]['ASteamID'];
				baninfo.reason = data[i]['Reason']
				
				xgui.queueFunctionCall( xbans.addbanline, "bans", baninfo, data[i]['OSteamID'] )
			end
		end
	end
	BanList.onError = function() end
	BanList:start()
end
*/

//See if a player is banned or not and display time left.
function GB_PlayerAuthed( ply, stid, unid )
	-- Query Bans In Descending order of banid and LIMIT 1 to obtain the latest ban
	print("[ULX] AUTHING PLAYER")
	local AuthQuery = ULX_DB:query("SELECT BanID, Length FROM bans WHERE OSteamiD = '"..stid.."' ORDER BY BanID DESC LIMIT 1");

	AuthQuery.onSuccess = function() 
		local data = AuthQuery:getData()
		local row = data[1]
		if (#AuthQuery:getData() == 1) then
			local bantime = tonumber(row['Length'])
			if bantime >= os.time() then
				ply:Kick("Ban Lifted in " .. bantime - os.time());
			end

		else
			print("[ULX GB] - User has no active bans");
		end
	end
	
	AuthQuery.onError = function(err) 
		print('[ULX GB] (AuthQuery) - Error: ', err);
	end
	
	AuthQuery:start()
end
hook.Add( "PlayerAuthed", "playerauthed", GB_PlayerAuthed )


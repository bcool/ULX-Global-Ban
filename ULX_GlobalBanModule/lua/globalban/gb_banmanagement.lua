--ULX Global Ban
--Adobe And NigNog
------------------
include('globalban/gb_config.lua')
------------------

//Overwrite The Ulib Function on a global scope
function ULib.addBan( steamid, time, reason, name, admin )
	-- No SteamID / Time, stop the script
	if steamid == nil then return end
	if time == nil then return end
	
	-- No Name!? Insert a false one
	if (name == nil) then
		name = "John Doe"
	end
	
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
	
	--Are they already banned?
	local BanStatus = ULX_DB:query("SELECT BanID, Length FROM bans WHERE OSteamiD = '"..steamid.."';")
	BanStatus.onSuccess = function() 
		local data = BanStatus:getData()
		local row = data[1]
		PrintTable(BanStatus:getData())
		if (#BanStatus:getData() >= 1) then
			GB_ModifyBan(BanLength, reason, time, AdminName, steamid)
		end
		if (#BanStatus:getData() == 0) then
			GB_InsertBan(steamid, name, BanLength, AdminName, AdminSteam, reason)
		end
	end
	BanStatus.onError = function(err) 
		print('[ULX GB] (BanStatus) - Error: ', err)
	end
	BanStatus:wait()
	BanStatus:start()
	
	--Refresh the List!
	ULib.refreshBans()
end

function GB_InsertBan(steamid, name, BanLength, AdminName, AdminSteam,reason)
	--Insert Ban
	local AddBanQuery = ULX_DB:query("INSERT INTO bans VALUES ('','"..steamid.."','"..GB_Escape(name).."','"..BanLength.."','"..os.time().."','"..GB_Escape(AdminName).."','"..AdminSteam.."','"..GB_Escape(reason).."','"..GB_SERVERID.."','','"..os.time().."');");
	AddBanQuery.onSuccess = function()
		print("[ULX GB] - Ban Added!");
	end
	AddBanQuery.onError = function(err) 
		print('[ULX GB] (AddBanQuery) - Error: ', err);
	end
	AddBanQuery:start()

	-- Regardless of outcome Kick player From Server
	RunConsoleCommand('kickid',steamid,"You've been banned from the server.");
end

function GB_ModifyBan(BanLength, reason, time, AdminName, steamid)
	--Send ban update to the Database
	local UpdateBanQuery = ULX_DB:query("UPDATE bans SET Length='".. BanLength .."', Reason='".. reason .."', MTime='".. time .."', MAdmin='".. GB_Escape(AdminName) .."' WHERE OSteamID='".. steamid .."';");
	UpdateBanQuery.onSuccess = function()
		print("[ULX GB] - Ban Modified!");
	end
	UpdateBanQuery.onError = function(err) 
		print('[ULX GB] (UpdateBanQuery) - Error: ', err);
	end
	UpdateBanQuery:start()
end


//Overwrite the ULib function for unbanning
function ULib.unban( steamid )
	--Query the Ban to the Database
	local UnBanQuery = ULX_DB:query("DELETE FROM bans WHERE OSteamID='"..steamid.."'");
	UnBanQuery.onSuccess = function()
		print("[ULX GB] - Ban Removed!");
	end
	UnBanQuery.onError = function(err) 
		print('[ULX GB] (UnBanQuery) - Error: ', err);
	end
	UnBanQuery:start()
	
	--Possible Glitch Fix, Just Incase
	RunConsoleCommand('removeid',steamid);
	
	--Refresh the List!
	ULib.refreshBans()
end


//Refreshes the ban List
function ULib.refreshBans()

	--Use their tables ;)
	ULib.bans = nil
	ULib.bans = {}
	xgui.ulxbans = {}
	
	local BanList = ULX_DB:query("SELECT * FROM bans ORDER BY BanID DESC")
	BanList:wait()
	BanList.onSuccess = function()
		local data = BanList:getData()
		for i = 1, #data do
			table.insert( ULib.bans, tonumber(data[i]['OSteamID']) )
			ULib.bans[data[i]['OSteamID']] = { unban = tonumber(data[i]['Length']), admin = data[i]['AName'], reason = data[i]['Reason'], name = data[i]['OName'], time = tonumber(data[i]['Time']), modified_admin = data[i]['MAdmin'], modified_time = tonumber(data[i]['MTime']) }
			--^^ ULX Ban Info
			---------------------------------
			for k, v in pairs( ULib.bans ) do
				xgui.ulxbans[k] = v           -- Make sure it loads bans!
			end
			---------------------------------
			local t = {}
			t[data[i]['OSteamID']] = ULib.bans[data[i]['OSteamID']]
			xgui.addData( {}, "bans", t ) -- This will error out on startup (Most Times, GMod 13's Addon Loading is fucked), but that's fine, all ban data gets loaded already
		end
	end
	BanList.onError = function(err) 
		print('[ULX GB] (BanList) - Error: ', err);
	end
	BanList:start()
	
end
//Refresh on Script Load -- Otherwise has issues
ULib.refreshBans()


//See if a player is banned or not and display time left.
function GB_PlayerAuthed( ComID, IP, RealPass, ClientPass, PlayerNick )
	-- Query Bans In Descending order of banid and LIMIT 1 to obtain the latest ban
	local SteamID = GB_ComIDtoSteamID(ComID)
	print("[ULX GB] AUTHING PLAYER: " .. PlayerNick .. ' WITH SteamID: ' .. SteamID)
	if ULib.bans[SteamID] then
		print('Banned')
		local BanInfo = ULib.bans[SteamID]
		local bantime = BanInfo.unban
		if bantime >= os.time() then
			local timeLeft = bantime - os.time();
			local Minutes = math.floor(timeLeft / 60);
			local Seconds = timeLeft - (Minutes * 60);
			local Hours = math.floor(Minutes / 60);
			local Minutes = Minutes - (Hours * 60);
			local Days = math.floor(Hours / 24);
			local Hours = Hours - (Days * 24);
				
			if (Minutes == 0 && Hours == 0 && Days == 0) then
				return false, "Banned. Lifted In: " .. Seconds + 1 .. " Seconds";
			elseif (Hours == 0 && Days == 0) then
				return false, "Banned. Lifted In: " .. Minutes + 1 .. " Minutes";
			elseif (Days == 0) then
				return false, "Banned. Lifted In: " .. Hours + 1 .. " Hours";
			else
				return false, "Banned. Lifted In: " .. Days + 1 .. " Days";
			end
		end
		if bantime == 0 then
			return false, GB_PermaMessage;
		end
		if (bantime <= os.time() && !bantime == 0) then
			print("[ULX GB] - Removing expired bans!");
			ULib.unban(SteamID);
		end
	else
		print("[ULX GB] - User has no active bans");
	end
end
hook.Add( "CheckPassword", "CheckPassword_GB", GB_PlayerAuthed )


// Timer
timer.Create( "GB_RefreshTimer", GB_RefreshTime, 0, function() ULib.refreshBans() end)
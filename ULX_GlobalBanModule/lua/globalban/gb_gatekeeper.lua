--ULX Global Ban
--Adobe And NigNog
------------------
local GateKeeper = require( 'gatekeeper' )
require( 'gatekeeper' )

//Include Configs
include('gb_config.lua')

local function manageIncomingConnections ( Name, Pass, SteamID, IP )
	Msg(tostring(Name) .. " [" .. tostring(IP) .. "] joined with steamID " .. tostring(SteamID) .. ".\n");
	
	-- If they don't have steamids block them, as they may be trying to bypass the ban system.
	if (SteamID == "STEAM_ID_UNKNOWN") then return {false, "SteamID Error."}; end
	if (SteamID == "STEAM_ID_PENDING") then return {false, "SteamID Error."}; end
	
	-- Get the time for everything.
	local curTime = os.time();
	
	local AuthQuery = ULX_DB:query("SELECT BanID, Length FROM bans WHERE OSteamiD = '"..SteamID.."' ORDER BY BanID DESC LIMIT 1");
	AuthQuery.onSuccess = function() 
		local data = AuthQuery:getData();
		local row = data[1];
		if (#AuthQuery:getData() == 1) then
			local bantime = tonumber(row['Length']);
			print("Banned Mudafuker");
			if bantime >= curTime then
				print("BanTime >= curTime")
				local timeLeft = bantime - curTime;
				local Minutes = math.floor(timeLeft / 60);
				local Seconds = timeLeft - (Minutes * 60);
				local Hours = math.floor(Minutes / 60);
				local Minutes = Minutes - (Hours * 60);
				local Days = math.floor(Hours / 24);
				local Hours = Hours - (Days * 24);
				
				if (Minutes == 0 && Hours == 0 && Days == 0) then
					print("Seconds")
					return {false, "Banned. Lifted In: " .. Seconds + 1 .. " Seconds"};
				elseif (Hours == 0 && Days == 0) then
					print("Minutes")
					return {false, "Banned. Lifted In: " .. Minutes + 1 .. " Minutes"};
				elseif (Days == 0) then
					print("Hours")
					return {false, "Banned. Lifted In: " .. Hours + 1 .. " Hours"};
				else
					print("Days / Years")
					return {false, "Banned. Lifted In: " .. Days + 1 .. " Days"};
				end
			end
			if bantime == 0 then
				return {false, GB_PermaMessage};
			end
			if (bantime <= os.time() && !bantime == 0) then
				print("[ULX GB] - Removing expired bans!");
				ULib.unban(SteamID);
			end
		else
			print("[ULX GB] - User has no active bans");
		end
	end
	AuthQuery.onError = function(err) 
		print('[ULX GB] (AuthQuery) - Error: ', err);
	end
	AuthQuery:wait();
	AuthQuery:start();


	-- Let the unbanned join!
	return;
end
hook.Add("PlayerPasswordAuth", "manageIncomingConnections", manageIncomingConnections)
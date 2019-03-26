--ULX Global Ban
--Adobe And NigNog
------------------

-- Terrible Escape Function
function GB_Escape(str)
	if (str == nil) then
		return "";
	else
		local buf = string.Replace(str,"'","")
		return buf
	end
end

function GB_SendUsageStats(bans)
	-- returning 404
	-- http.Fetch( "http://aussieops.net/GlobalBans/backend.php?PORT="..GetConVarString("hostport").."&BANS="..bans.."")
end

-- http://www.facepunch.com/showthread.php?t=1253982&p=39923262
-- Made by Map in a Box and edited by others.
function GB_ComIDtoSteamID(cid)
  local steam64=tonumber(cid:sub(2))
  local a = steam64 % 2 == 0 and 0 or 1
  local b = math.abs(6561197960265728 - steam64 - a) / 2
  local sid = "STEAM_0:" .. a .. ":" .. (a == 1 and b -1 or b)
  return sid
end

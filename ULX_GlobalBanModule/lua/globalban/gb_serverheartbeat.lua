--ULX Global Ban
--Adobe And NigNog
------------------

//Global Value; can be used in any other supported scripts.
GB_SERVERID = 0

local function GetServerIP()
        local hostip = GetConVarString( "hostip" )
        hostip = tonumber( hostip )
        
        local ip = {}
        ip[ 1 ] = bit.rshift( bit.band( hostip, 0xFF000000 ), 24 )
        ip[ 2 ] = bit.rshift( bit.band( hostip, 0x00FF0000 ), 16 )
        ip[ 3 ] = bit.rshift( bit.band( hostip, 0x0000FF00 ), 8 )
        ip[ 4 ] = bit.band( hostip, 0x000000FF )
        
        return table.concat( ip, "." )
end


function GB_QueryDatabaseForServer()
	--Gather Identification Infos
	local HostName = GB_Escape(GetHostName());
	local IPAddress = GetServerIP();
	local HostPort = GetConVarString("hostport");
	
	-- Setting up the Query
	local HeartbeatQuery = ULX_DB:query("SELECT ServerID FROM servers WHERE IPAddress ='"..IPAddress.."' AND Port = '"..HostPort.."'");
	HeartbeatQuery.onSuccess = function()
		local data = HeartbeatQuery:getData()
		local row = data[1]
		-- Query The Database to see if server exists and retrieve the Server's ID 
		if (#HeartbeatQuery:getData() == 0) then			
			-- If Database does not have IP and port create a new row and populate it accordingly
			print("[ULX GB] - Server not present, creating...");
			GB_InsertNewServer()
		elseif (#HeartbeatQuery:getData() == 1) then
			-- There should be only one entry
			GB_SERVERID = tonumber(row['ServerID']);
			GB_UpdateServerName();
			print("[ULX GB] - ServerID Set To: ".. GB_SERVERID);
		else
			print("[ULX GB] (UpdateName) - Error: Multiple entries found for IPAddress "..IPAddress.." and Port "..HostPort)
		end 
	end
	HeartbeatQuery.onError = function(db, err) print('[ULX GB] (HeartbeatQuery) - Error: ', err) end
	HeartbeatQuery:start()
	
end

function GB_UpdateServerName() 
	--Gather Identification Infos
	local HostName = GB_Escape(GetHostName());
	
	local UpdateName = ULX_DB:query(" UPDATE servers SET HostName='".. HostName .."' WHERE ServerID='"..GB_SERVERID.."' ");
	UpdateName.onSuccess = function()
		print("[ULX GB] - Updated HostName Successfully!");
	end
	UpdateName.onError = function(db, err) print('[ULX GB] (UpdateName) - Error: ', err) end
	UpdateName:start()
	
end

function GB_InsertNewServer()
	--Gather Indentification Infos
	local HostName = GB_Escape(GetHostName());
	local IPAddress = GetServerIP();
	local HostPort = GetConVarString("hostport");

	local NewServer = ULX_DB:query("INSERT INTO servers VALUES ('','"..IPAddress.."','"..HostPort.."','"..HostName.."')");
	NewServer.onSuccess = function()
		print("[ULX GB] - Inserted New Server!");
		GB_QueryDatabaseForServer()
	end
	NewServer.onError = function(db, err)
		print('[ULX GB] (NewServer) - Error: ', err);
		GB_QueryDatabaseForServer()
	end
	NewServer:start()
	
end

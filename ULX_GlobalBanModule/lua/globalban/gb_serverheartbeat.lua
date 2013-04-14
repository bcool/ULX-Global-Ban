--ULX Global Ban
--Adobe And NigNog
------------------

//Global Value; can be used in any other supported scripts.
GB_SERVERID = 0


function GB_QueryDatabaseForServer()
	--Gather Identification Infos
	local HostName = GB_Escape(GetHostName());
	local IPAddress = GetConVarString("ip");
	local HostPort = GetConVarString("hostport");
	
	-- Setting up the Query
	local HeartbeatQuery = ULX_DB:query("SELECT ServerID FROM servers WHERE IPAddress ='"..IPAddress.."' AND Port = '"..HostPort.."'");
	HeartbeatQuery.onSuccess = function()
		local data = HeartbeatQuery:getData()
		local row = data[1]
		-- Query The Database to see if server exsits and retrieve the Server's ID 
		if (#HeartbeatQuery:getData() == 1) then			
			GB_SERVERID = tonumber(row['ServerID']);
			GB_UpdateServerName();
			print("[ULX GB] - ServerID Set To: ".. GB_SERVERID);
		else
			-- If Database does not have IP and port create a new row and populate it accordingly
			print("[ULX GB] - Server not present, creating...");
			GB_InsertNewServer()
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
	local IPAddress = GetConVarString("ip");
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

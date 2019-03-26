--ULX Global Ban
--Adobe And NigNog
------------------

//Require MySQLOO
local MySQLOO = require( 'mysqloo' )
require( 'mysqloo' )

//Include Globals
include('gb_config.lua')

//Setup Fail QueryLine Ups
ULX_GB_F = {}

//Setup MySQLOO Connections
ULX_DB = mysqloo.connect(GB_DATABASE_HOST, GB_DATABASE_USERNAME, GB_DATABASE_PASSWORD, GB_DATABASE_NAME, GB_DATABASE_PORT)

include( 'gb_serverheartbeat.lua' );

function GB_RemoveTField(ID)
	table.remove( ULX_GB_F, ID )
end

function GB_AddTField(Query)
	table.insert(ULX_GB_F, Query)
end

local function RedoQueries()
	for i = 1, #ULX_GB_F do
		local RedoQueries = ULX_DB:query(ULX_GB_F[i])
		RedoQueries.onSuccess = function()
			print('[ULX GB] Successfully Completed Query: ' .. ULX_GB_F[i]);
			GB_RemoveTField(i);
		end
		RedoQueries.onError = function(db, err) print('[ULX GB] (RedoQueries) - Error: ', err) end
		RedoQueries:start()
	end
end

function afterConnected(database)
	print('[ULX GB] - Database Connection Successful ' )

	--Check Wether or not a server exists in the Database
	GB_QueryDatabaseForServer()

	--Dam ULib Fails when inclduing this anywhere else...
	if (GB_Convert == true) then
		include('globalban/gb_convert.lua')
	else
		include('globalban/gb_banmanagement.lua')
	end

	RedoQueries()
end

function connectToDatabase()
	print('[ULX GB] - Connecting to Database!')

	ULX_DB.onConnected = afterConnected
	ULX_DB.onConnectionFailed = function(db, msg) print("[ULX GB] connectToDatabase") print(msg) end
	ULX_DB:connect()
end

//Run the connection!
connectToDatabase()

//Keep the MySQL Database Open and Connected.
local function DbCheck()
	if (ULX_DB:status() != mysqloo.DATABASE_CONNECTED) then
		connectToDatabase();
		print('[ULX GB] - Database Connection Restarted' )
	end
end
timer.Create( 'DbCheck', 90, 0, DbCheck )

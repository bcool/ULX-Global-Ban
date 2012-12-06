--ULX Global Ban
--Adobe And NigNog
------------------

//Require MySQLOO
local MySQLOO = require( 'mysqloo' )
require( 'mysqloo' )

local DATABASE_HOST = "IP/HOSTNAME"
local DATABASE_PORT = 3306
local DATABASE_NAME = "DATABASE"
local DATABASE_USERNAME = "DB_USER"
local DATABASE_PASSWORD = "DB_PASSWORD"

//Setup MySQLOO Connections
ULX_DB = mysqloo.connect(DATABASE_HOST, DATABASE_USERNAME, DATABASE_PASSWORD, DATABASE_NAME, DATABASE_PORT)

include('gb_serverheartbeat.lua');
 
function afterConnected(database)
	print('[ULX GB] - Database Connection Successful ' )
	
	--Check Wether or not a server exists in the Database
	GB_QueryDatabaseForServer()
	
	--Dam ULib Fails when inclduing this anywhere else...
	include('gb_banmanagement.lua')
end

function connectToDatabase()
	print('[ULX GB] - Connecting to Database!')
	
	ULX_DB.onConnected = afterConnected
	ULX_DB:connect()
end

//Run the connection!
connectToDatabase()
 
//Keep the MySQL Database Open and Connected.
local function DbCheck()
	if (ULX_DB:status() != mysqloo.DATABASE_CONNECTED) then
		ULX_DB = mysqloo.connect(DATABASE_HOST, DATABASE_USERNAME, DATABASE_PASSWORD, DATABASE_NAME, DATABASE_PORT)
		print('[ULX GB] - Database Connection Restarted' )
	end
end
timer.Create( 'DbCheck', 90, 0, DbCheck )
--ULX Global Ban
--Adobe And NigNog
------------------

//CONFIGS\\

--MySQLOO Configs for your Database
--Self explanatory
--For Best performance use a local database or under 5ms
GB_DATABASE_HOST 		= "127.0.0.1";
GB_DATABASE_PORT 		= 3306;
GB_DATABASE_NAME 		= "bans";
GB_DATABASE_USERNAME 	= "root";
GB_DATABASE_PASSWORD 	= "";

--Use the GateKeeper Module?
--Blocks people who are banned before they even enter the server!
--Requires GateKeeper Module...
GB_UseGateKeeper 		= false; -- false = No | true = Yes (DEF=false) (Experimental Doesn't work Yet)

--All Permanent Bans: Message you want to display to the permamently banned users who try to connect?
GB_PermaMessage			= "You are permanently banned from this server!";

--Should we use a timer to Refresh the ban list?
--How long should the refresh timer be? || (Each Ban / UnBan / Modification - Refreshes the BanList anyway)
GB_RefreshTimer 		= true; -- false = No | true = Yes (DEF=false)
GB_RefreshTime			= 30; -- Time in seconds DEF=30
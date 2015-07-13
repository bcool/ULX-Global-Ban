--ULX Global Ban
--Adobe And NigNog
------------------

//CONFIGS\\

--MySQLOO Configs for your Database
--Self explanatory
--For Best performance use a local database or under 5ms
GB_DATABASE_HOST 		= '127.0.0.1';
GB_DATABASE_PORT 		= 3306;
GB_DATABASE_NAME 		= 'ulx_gb';
GB_DATABASE_USERNAME 	= 'root';
GB_DATABASE_PASSWORD 	= '';

--All Permanent Bans: Message you want to display to the permamently banned users who try to connect?
GB_PermaMessage			= "Permbanned, Skit!";

--If the banner does not supply a name use a fake one instead?
GB_NoSteamName = false;
GB_BanName = "John Doe";

--Report Limited Addon Usage data IP,Port,Amount of Bans.
GB_UsageStats = true;

--Convert all Existing ULX Bans to ULXGlobalBan Database? (First Use Only, once done please set to false and restart server!)
--Please note the converter does not always function when not all the ban data is present for that player! So please make a backup and run through the ban list to make sure that the players are there!
GB_Convert = false;

--Should we use a timer to Refresh the ban list?
--How long should the refresh timer be? || (Each Ban / UnBan / Modification - Refreshes the BanList anyway)
GB_RefreshTimer 		= true; -- false = No | true = Yes (DEF=true)
GB_RefreshTime			= 30; -- Time in seconds DEF=30
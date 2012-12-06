ULX-Global-Ban
==============
A Global Ban System designed to be used only with ULX & ULib Garry's Mod servers.

INFO
==============
Created out of necessity.
Created by NigNog (Bcool) and Adobe Ninja.

FEATURES
==============
Server Identification: When your server starts, it checks to see whether or not the IP:Port configuration is already there. If it's not it'll create it and assign the server an ID. If it is it'll assign the server an existing ID.
Bans: This addon overwrites the exists ULib function to add a ban, and inserts it into the MySQL Database.
Authentication: When the server Auths a player, the point where the SteamID is retrived and the normal ban status is checked, this addon checks the MySQL server to see if the user has been banned.

Information: When a user has been banned, their SteamID, Current Name, Reason, ServerID of the server which they where banned on, Admin(Banner) SteamID and Current admin name are all saved in the MySQL Database.
Each time your server is started, the hostname is automagicly updated in the MySQL database.

PLANED/TODO
==============
+  Add
-  Remove
*  Fix / Changed


+Ban removal.
+Ban listing in the xgui menus.
*Cleanup file layout.

INSTALLATION
==============
*Requires MySQLOO
TODO
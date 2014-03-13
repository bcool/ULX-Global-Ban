<?php

	/*
	
	The MIT License (MIT)

	Copyright (c) 2014 TheCodingBeast

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
	
	PLEASE DON'T REMOVE CREDITS!
	
	*/

	// SourceQuery
	require( __DIR__ . '/SourceQuery/SourceQuery.class.php');
	
	// Database Settings
	$Database_Host 		= "localhost";
	$Database_Database 	= "ulxbans";
	$Database_Username 	= "root";
	$Database_Password	= "";
	
	// Page Settings
	$Title		= "TheCodingBeast # Ban List";
	$Color		= "Dark"; // White, Blue, Green, Sky, Orange, Red, Dark
	
	$PageTitle	= "TheCodingBeast Ban List";
	
	// Language
	$T_ServerList = "Server List";
	$T_BanList = "Ban List";
	
	$S_IP = "IP";
	$S_ServerName = "Server Name";
	$S_Gamemode = "Gamemode";
	$S_Map = "Map";
	$S_Players = "Players";
	
	$B_SteamID = "SteamID";
	$B_IGN = "IGN";
	$B_Reason = "Reason";
	$B_Expires = "Expires";
	$B_Admin = "Admin";
	
	// Connect MySQL
	try
	{
		$db = new PDO('mysql:host=' . $Database_Host . ';dbname=' . $Database_Database, $Database_Username, $Database_Password);
	}catch(PDOException $e){
		die("Failed to connect to database! Please check the database settings.");
	}
	
	// Color
	if($Color=="White"){$PColor="default";}elseif($Color=="Blue"){$PColor="primary";}
	elseif($Color=="Green"){$PColor="success";}elseif($Color=="Sky"){$PColor="info";}
	elseif($Color=="Orange"){$PColor="warning";}elseif($Color=="Red"){$PColor="danger";}
	elseif($Color=="Dark"){$PColor="dark";}
	
?>
<!DOCTYPE html>
<html>
	<head>
    	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    	<title><?php echo $PageTitle; ?></title>
        
        <!-- CSS -->
        <link rel="stylesheet" type="text/css" href="css/bootstrap.css">
        <linl rel="stylesheet" type="text/css" href="css/widget.bootstrap.css">
        <link href='http://fonts.googleapis.com/css?family=Alegreya+Sans+SC:400,500,800' rel='stylesheet' type='text/css'>
        
        <!-- Javascript -->
        <script src="http://code.jquery.com/jquery-latest.min.js" type="text/javascript"></script>
    	<script src="js/bootstrap.js" type="text/javascript"></script>
        <script src="js/jquery.tablesorter.js" type="text/javascript"></script>
        <script src="js/jquery.tablesorter.widgets.js" type="text/javascript"></script>
        <script src="js/jquery.tablesorter.run.js" type="text/javascript"></script>
		
    </head>
	<body style="background-image:url(img/shattered.png);">
    
    <div class="container">
    	
        <center>
        	<h1 style="font-family: 'Alegreya Sans SC', sans-serif;">
            	<span class="label label-<?php echo $PColor; ?>" style="padding:.2em .6em .2em;"><b><?php echo $Title; ?></b></span>
            </h1>
		</center><br/>
        
        <!-- Servers -->
        <div class="panel panel-<?php echo $PColor; ?>">
		<div class="panel-heading"><b><?php echo $T_ServerList; ?></b></div>
        <table class="table table-striped">
            <thead>
              <tr>
                <th>#</th>
                <th><?php echo $S_IP; ?></th>
                <th><?php echo $S_ServerName; ?></th>
                <th><?php echo $S_Gamemode; ?></th>
                <th><?php echo $S_Map; ?></th>
                <th><?php echo $S_Players; ?></th>
              </tr>
            </thead>
            <tbody>
            	<?php
				
					// Select Bans
					$SelectServers = $db->query("SELECT * FROM `servers`");

						
					// Print Output
					foreach($SelectServers as $PrintServers)
					{
						
						// Query Server
						define( 'SQ_TIMEOUT', 1 );
						define( 'SQ_ENGINE', SourceQuery :: SOURCE );
						
						$ServerQuery = new SourceQuery();
						$ServerInfo    = Array();
						$ServerPlayers = Array();
						
						try
						{
							$ServerQuery->Connect($PrintServers['IPAddress'], $PrintServers['Port'], SQ_TIMEOUT, SQ_ENGINE);
							$ServerInfo    = $ServerQuery->GetInfo();
							$ServerPlayers = $ServerQuery->GetPlayers();
						}
						catch( Exception $e )
						{
							echo "Something went wrong try again later!";
						}
					
						$ServerQuery->Disconnect( );
						
						echo 
						"
							<tr>
								<td><b>" . $PrintServers['ServerID'] . "</b></td>
								<td><a href='steam://connect/" . $PrintServers['IPAddress'] . ":" . $PrintServers['Port'] . "'>" . $PrintServers['IPAddress'] . ":" . $PrintServers['Port'] . "</a></td>
								<td>" . $PrintServers['HostName'] . "</td>
								<td>" . htmlspecialchars($ServerInfo['ModDesc']) . "</td>
								<td>" . htmlspecialchars($ServerInfo['Map']) . "</td>
								<td>" . htmlspecialchars($ServerInfo['Players']) . " / " . htmlspecialchars($ServerInfo['MaxPlayers']) . "</td>
							</tr>
						";
							
					}
					
				?>
            </tbody>
        </table>
        </div>
        <!-- ./Servers -->
    
        <!-- Bans -->
        <div class="panel panel-<?php echo $PColor; ?>">
		<div class="panel-heading"><b><?php echo $T_BanList; ?></b></div>
        <table class="table table-striped table-bans">
            <thead class="table-bans">
              <tr>
                <th>#</th>
                <th><?php echo $B_SteamID; ?></th>
                <th><?php echo $B_IGN; ?></th>
                <th><?php echo $B_Reason; ?></th>
                <th><?php echo $B_Expires; ?></th>
                <th><?php echo $B_Admin; ?></th>
              </tr>
            </thead>
            <tbody>
            	<?php
				
					// Select Bans
					$SelectBans = $db->query("SELECT * FROM `bans`");

						
					// Print Output
					foreach($SelectBans as $PrintBans)
					{
						// Steam ID Converter
						$PrintBansSteamID = strtolower($PrintBans['OSteamID']);
						if (substr($PrintBansSteamID,0,7)=='steam_0') {
							$tmp=explode(':',$PrintBansSteamID);
						}
						if ((count($tmp)==3) && is_numeric($tmp[1]) && is_numeric($tmp[2])){
							$steamidCalc=($tmp[2]*2)+$tmp[1]; 
							$calckey=1197960265728;
							$pre=7656;	
							$steamcid=$steamidCalc+$calckey;
							$PrintBansProfile = "http://steamcommunity.com/profiles/$pre" . number_format($steamcid,0,"","");
						};
						
						// Print Output	
						echo 
						"
							<tr>
								<td><b>" . $PrintBans['BanID'] . "</b></td>
								<td><a href='" . $PrintBansProfile . "' target='_blank'>" . $PrintBans['OSteamID'] . "</a></td>
								<td>" . $PrintBans['OName'] . "</td>
								<td>" . $PrintBans['Reason'] . "</td>
								<td>
						";
						
							if ($PrintBans['Length'] == '0')
								{echo "Perm";}
							elseif($PrintBans['Length'] < time())
								{echo "Unbanned";}
							else
								{echo date("d. M Y ( H:i )", $PrintBans['Length']);
							}
						
						echo "		
								</td>
								<td>" . $PrintBans['AName'] . "</td>
							</tr>
						";	
					}
				?>
            </tbody>
        </table>
        </div>
        <!-- ./Bans -->

        <!-- Footer -->
			<!-- PLEASE DON'T REMOVE CREDITS!! -->
        	Skin made by <a href="http://www.youtube.com/user/TheCodingBeast">TheCodingBeast</a> for <a href="http://facepunch.com/showthread.php?t=1231554">ULX Global Ban (1.4)</a><br/>
            Made with <a href="http://www.getbootstrap.com">Bootstrap</a>, <a href="https://github.com/xPaw/PHP-Source-Query-Class">PHP Source Query</a> and <a href="https://github.com/Mottie/tablesorter/">Tablesorter</a>.
        <!-- ./Footer -->
    
    </div>
    
    </body>
</html>
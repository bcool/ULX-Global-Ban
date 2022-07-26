<?php
	// Page Generator Time Start Script
	$time = microtime();
	$time = explode(' ', $time);
	$time = $time[1] + $time[0];
	$start = $time;
	
	// Source server Query GET
	require __DIR__ . '/SourceQuery/bootstrap.php';
	use xPaw\SourceQuery\SourceQuery;
	//require_once ('SourceQuery/SourceQuery.class.php'); // If you get and error reguarding this line, comment out the line above and use this one :)
	
	// Config to your database - Edit this!
	$dbhost		= '172.0.0.1';			// Server IP/Domain of where the datab-base resides.
	$dbdatabase	= '';			// Data-base Name.
	$dbuser		= '';				// Username.
	$dbpassword	= '';					// Password.
	$webname	= 'My Community'		// Title of Community/Server/Website/Domain, pick one.
?>
<?php
	// MySQL Connect/Query
	$connection = new mysqli($dbhost, $dbuser, $dbpassword, $dbdatabase);
	if ($connection->connect_error) {
	die("DB Connection failed: " . $connection->connect_error);
	}
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta HTTP-EQUIV="refresh" CONTENT="70" />
		<meta name="keywords" content="ulx, global, ban, banning, bans, gmod, garrys, mod, addon, ulib">
		<title><?php echo $webname ?> - Global Bans</title> 
		<link rel="stylesheet" href="http://twitter.github.com/bootstrap/assets/css/bootstrap.css">
		<link rel="stylesheet" href="css/global.css">

    </head>
	<body>
        <div class="container">
            <div class="header"></div>
			<div id="content-title" class="pull-right"><span id="servertime"></div>
            <div id="content-title"><?php echo $webname ?> - Global Bans List</div>
            <div class="content">
            	<div id="topic-title">Server List</div>
  				<table width="100%" class="status" border="0">
                    <tr>
                        <td width="30">&nbsp;</td>
                        <td width="160">
                            <strong>IP Address</strong>
                        </td>
                        <td width="432">
                            <strong>Server Name</strong>
                        </td>
                        <td width="182">
                            <strong>Gamemode</strong>
                        </td>
                        <td width="159">
                            <strong>Map</strong>
                        </td>
                        <td width="51">
                            <strong>Players</strong>
                        </td>
                    </tr>
                </table>
                <?php 
					$query ="SELECT * FROM servers";
					$result = $connection->query($query);
					while($row=mysqli_fetch_assoc($result)){		
				?>
                <?php
                	$fullip = explode(":", $row['IPAddress']);
					$ip = $fullip[0];
					$port = $fullip[1];


					define( 'SQ_TIMEOUT',     1 );
					define( 'SQ_ENGINE',      SourceQuery :: SOURCE );
					
					$Timer = MicroTime( true );
					$Query = new SourceQuery( );
				
					$Info    = Array( );
					$Rules   = Array( );
					$Players = Array( );
				
					try
					{
						$Query->Connect( $ip, $port, SQ_TIMEOUT, SQ_ENGINE );
				
						$Info    = $Query->GetInfo( );
						$Players = $Query->GetPlayers( );
					}
					catch( Exception $e )
					{
						$Exception = $e;
					}
				
					$Query->Disconnect( );
				?> 
                <table width="100%" class="status" border="0">
                    <tr>
                      <td width="30">&nbsp;<img src="css/img/gameicon/gmod.png"/></td>
                      <td width="160"><a href="steam://connect/<?php echo $ip; ?>:<?php echo $port; ?>"><?php echo $ip; ?>:<?php echo $port; ?></a></td>
                        <td width="438"><?php echo $row['HostName']; ?></td>
                        <td width="182"><?php echo htmlspecialchars( $Info[ 'ModDesc' ] ); ?></td>
                        <td width="159"><?php echo htmlspecialchars( $Info[ 'Map' ] ); ?></td>
                        <td width="51"><?php echo htmlspecialchars( $Info[ 'Players' ] ); ?><?php echo '/'; echo htmlspecialchars( $Info[ 'MaxPlayers' ] ); ?></td>
                    </tr>
                </table>
                <?php }?>
                <div id="topic-title">
                	<p>&nbsp;</p>
             		<?php 
						$query ="SELECT COUNT(BanID) FROM bans";
						$result = mysqli_fetch_array($connection->query($query));
						echo 'Bans List - ';
						echo $result[0];
						echo ' Bans and Counting';
					?>
                </div>
  				<table width="100%" class="status" border="0">
                    <tr>
                    	<td width="28"></td>
                        <td width="155">
                       	 	<strong>Steam ID</strong>
                        </td>
                        <td width="162">
                        	<strong>Alias</strong></td>
                        <td width="323">
                            <strong>Reason</strong>
                        </td>
                        <td width="185">
                            <strong>Expires on</strong>
                        </td>
                        <td width="169">
                            <strong>Banned by</strong>
                        </td>
                    </tr>
               	</table>
                	<?php 
						$query ="SELECT * FROM servers, bans WHERE servers.ServerID = bans.ServerID ORDER BY BanID DESC";
						$result = $connection->query($query);
						while($row=mysqli_fetch_assoc($result)){		
					?>
              	<table width="100%" class="status" border="0">
                    <?php
						// Steam ID Converter
						$steamid = $row['OSteamID'];						
						$steam_id=strtolower($steamid);
						if (substr($steam_id,0,7)=='steam_0') {
							$tmp=explode(':',$steam_id);
						}
						if ((count($tmp)==3) && is_numeric($tmp[1]) && is_numeric($tmp[2])){
							$steamidCalc=($tmp[2]*2)+$tmp[1]; 
							$calckey=1197960265728;
							$pre=7656;	
							$steamcid=$steamidCalc+$calckey;
							$profile="http://steamcommunity.com/profiles/$pre" . number_format($steamcid,0,"","");
						};
					?>
                    <tr>
                    	<td width="28">&nbsp;<img src="css/img/gameicon/gmod.png" title="<?php echo $row['HostName']; ?>" width="16" height="16" /></td>
                        <td width="155"><a href="<?php echo $profile; ?>"><?php echo $row['OSteamID']; ?></a></td>
                        <td width="162"><?php echo $row['OName']; ?></td>
                        <td width="323"><?php echo $row['Reason'] ?></td>
                        <td width="185">
							<?php  if ($row['Length'] == '0')
								{
									echo "<em>Permanent</em>";	
								}
								elseif($row['Length'] < time())
								{
									echo "Unbanned";	
								}
								else
								{
									echo date("g:ia - d M, Y", $row['Length']);
								}
							?>
						</td>
						<?php
							// Steam ID Converter
							$steamid = $row['ASteamID'];						
							$steam_id=strtolower($steamid);
							if (substr($steam_id,0,7)=='steam_0') {
								$tmp=explode(':',$steam_id);
							}
							if ((count($tmp)==3) && is_numeric($tmp[1]) && is_numeric($tmp[2])){
								$steamidCalc=($tmp[2]*2)+$tmp[1]; 
								$calckey=1197960265728;
								$pre=7656;	
								$steamcid=$steamidCalc+$calckey;
								$profile="http://steamcommunity.com/profiles/$pre" . number_format($steamcid,0,"","");
							};
						?>
                        <td width="169"><a href="<?php echo $profile; ?>"><?php echo $row['AName']; ?></a></td>
                    </tr>
                </table>
                <?php }?>
            </div> 
        </div>
		<footer>
			<div class="container">
				<p class="pull-right">Generated in <span class="badge badge-success">
					<?php
						// Page Generator Time Finish
						$time = microtime();
						$time = explode(' ', $time);
						$time = $time[1] + $time[0];
						$finish = $time;
						$total_time = round(($finish - $start), 4);
						echo $total_time;
						echo "s";
					?></span>
            	</p>
                <p>
                    Skin Implemented by <a href="http://ban-hammer.net" title="Q4's Website">Q4-Bi.</a> for <a href="http://facepunch.com/showthread.php?t=1231554" title="Offical Thread" target="_blank">ULX Global Ban (0.6)</a> v1.2 fixed up by 1Day2Die
               	</p>
			</div>
		</footer>
	</body>
</html>
<?php
	$connection = mysql_connect('host','user','user_pass');
	if($connection){mysql_select_db('database');}else{die("failed");}
	
	$query="SELECT * FROM bans ORDER BY Length DESC";
	$result = mysql_query($query);
	
	$todaysdate = time();
	/*
	if ($row['Length'] > $todaysdate)
	{
		$row['Length'] = date("g:ia - d M, Y", $row['Length']);
	}
	else
	{
		$row['Length'] = "Permanent";
	}
	*/

?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" href="css/global.css" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>ULX GlobalBan - Banlist</title>
</head>
<body>
	<div id="content">
   	  <div id="content-head">
        	<div id="logo"></div>
      </div>
        
        <div id="content-body">
        	<div id="content-title">Active Bans</div>
  			<table width="1024px" bgcolor="#CCCCCC">
            	<tr bgcolor="#0099FF">
                	<td>Offender</td>
                    <td>SteamID</td>
                    <td>Reason</td>
                    <td>Unban Time</td>
                    <td>Banner Name </td>
          		</tr>
               <?php while($row=mysql_fetch_assoc($result)){?>
                <tr>
                	<td><?php echo $row['OName']; ?></td>
                	<td><?php echo $row['OSteamID']; ?></td>
                    <td><?php echo $row['Reason'] ?></td>
                    <td><?php  if ($row['Length'] == '0')
					{
						echo "Forever";	
					}
					elseif($row['Length'] < time())
					{
						echo "Unbanned";	
					}
					else
					{
						//echo ($row['Length'] - time()) /60;
						echo date("g:ia - d M, Y", $row['Length']);
					}
					
					
					 ?></td>
                    <td><?php echo $row['AName']; ?></td>
                </tr>
            	<?php }?>
            </table>
        </div>
    </div>
</body>
</html>
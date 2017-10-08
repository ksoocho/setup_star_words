<?php
include("./db.php");

if (isSet($_POST['wordlevel']))
{
	// Data sent from Form
	$wordLevel    = mysqli_real_escape_string($db,$_POST['wordlevel']); 

	// Prepare IN parameters
	$db->query("SET @p_wordLevel    = " . "'" . $wordLevel . "'");
	
	// Prepare OUT parameters
	$db->query("set @x_levelTitle = '0'");
	$db->query("set @x_originLanguage = '0'");
	$db->query("set @x_wordLanguage = '0'");
	$db->query("set @x_userCount = 0");
	$db->query("set @x_returnCode = '0'");
	$db->query("set @x_returnMsg = '0'");

	// Call sproc 
	if(!$db->query("call pr_get_word_level(@p_wordLevel, 
	                                       @x_levelTitle, 
									       @x_originLanguage, 
										   @x_wordLanguage, 
										   @x_userCount, 
										   @x_returnCode, 
										   @x_returnMsg)"))
	die("CALL failed: (" . $db->errno . ") " . $db->error);
	 
	// Fetch OUT parameters 
	if (!($res = $db->query("select @x_levelTitle as level_title, 
	                                @x_originLanguage as origin_lang, 
									@x_wordLanguage as counter_lang, 
									@x_userCount as user_count, 
									@x_returnCode as return_code, 
									@x_returnMsg as return_msg
						    ")))
		die("Fetch failed: (" . $db->errno . ") " . $db->error);
		
	$row = $res->fetch_assoc();
	 
	// Return result -	word level
	$levelArray[] = array(
	  'level_title'    => $row['level_title'],
	  'origin_lang'    => $row['origin_lang'],
	  'counter_lang'   => $row['counter_lang'],
	  'user_count'     => $row['user_count'],
	  'return_code'    => $row['return_code'],
	  'return_msg'     => $row['return_msg']
	);
	
	echo json_encode($levelArray);

    //close the db connection
	mysqli_close($db);	
}
?>
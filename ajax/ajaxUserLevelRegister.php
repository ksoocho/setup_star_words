<?php
include("./db.php");

if(isSet($_POST['usercode']) && isSet($_POST['wordlevel']))
{
	// Data sent from Form
	$userCode    = mysqli_real_escape_string($db,$_POST['usercode']); 
	$wordLevel   = mysqli_real_escape_string($db,$_POST['wordlevel']); 

	// Prepare IN parameters
	$db->query("SET @p_userCode    = " . "'" . $userCode . "'");
	$db->query("SET @p_wordLevel   = " . "'" . $wordLevel . "'");

	// Prepare OUT parameters
	$db->query("set @x_returnCode = '0'");
	$db->query("set @x_returnMsg = '0'");

	// Call sproc 
	// IsSupervisor(IN username CHAR(20), OUT success BOOLEAN)
	if(!$db->query("call pr_create_word_user_level(@p_userCode, @p_wordLevel, @x_returnCode, @x_returnMsg)"))
	die("CALL failed: (" . $db->errno . ") " . $db->error);
	 
	// Fetch OUT parameters 
	if (!($res = $db->query("select @x_returnCode as return_code, @x_returnMsg as return_msg")))
		die("Fetch failed: (" . $db->errno . ") " . $db->error);
	$row = $res->fetch_assoc();
	 
	// Return result
	if  ( $row['return_code'] == 'S')
	{
	    echo $row['return_code'];		
	} else {
		echo $row['return_code']."-".$row['return_msg']."-".$wordLevel;
	}
}
?>
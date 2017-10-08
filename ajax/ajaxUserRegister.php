<?php
include("./db.php");

if(isSet($_POST['pgRegUserCode']) && isSet($_POST['pgRegUserPwd']))
{
	// Data sent from Form
	$userCode    = mysqli_real_escape_string($db,$_POST['pgRegUserCode']); 
	$userPwd     = mysqli_real_escape_string($db,$_POST['pgRegUserPwd']); 
	$confirmPwd  = mysqli_real_escape_string($db,$_POST['pgRegConfirmPwd']); 
	$userName    = mysqli_real_escape_string($db,$_POST['pgRegUserName']); 
	$userEmail   = mysqli_real_escape_string($db,$_POST['pgRegUserEmail']); 

	// Prepare IN parameters
	$db->query("SET @p_userCode    = " . "'" . $userCode . "'");
	$db->query("SET @p_userPwd     = " . "'" . $userPwd . "'");
	$db->query("SET @p_confirmPwd  = " . "'" . $confirmPwd . "'");
	$db->query("SET @p_userName    = " . "'" . $userName . "'");
	$db->query("SET @p_userEmail   = " . "'" . $userEmail . "'");
	
	// Prepare OUT parameters
	$db->query("set @x_returnCode = '0'");
	$db->query("set @x_returnMsg = '0'");

	// Call sproc 
	// IsSupervisor(IN username CHAR(20), OUT success BOOLEAN)
	//if(!$db->query("call pr_register_word_user(@p_userCode, @p_userPwd, @p_confirmPwd, @p_userName, @p_userEmail, @x_returnCode, @x_returnMsg)"))
	if(!$db->query("call pr_register_word_user(@p_userCode, @p_userPwd, @p_confirmPwd, @p_userCode, @p_userCode, @x_returnCode, @x_returnMsg)"))
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
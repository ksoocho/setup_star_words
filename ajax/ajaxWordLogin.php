<?php
include("./db.php");

if(isSet($_POST['usercode']) && isSet($_POST['password']))
{
	// username and password sent from Form
	$usercode= mysqli_real_escape_string($db,$_POST['usercode']); 
	$password= mysqli_real_escape_string($db,$_POST['password']); 

	// Prepare IN parameters
	$db->query("SET @p_userCode  = " . "'" . $usercode . "'");
	$db->query("SET @p_userPwd   = " . "'" . $password . "'");

	// Prepare OUT parameters
	$db->query("set @x_userId = 0");
	$db->query("set @x_userMode = '0'");
	$db->query("set @x_returnCode = '0'");
	$db->query("set @x_returnMsg = '0'");

	// Call sproc 
	// IsSupervisor(IN username CHAR(20), OUT success BOOLEAN)
	if(!$db->query("call pr_login_word_user(@p_userCode, 
	                                        @p_userPwd, 
											@x_userId, 
											@x_userMode, 
											@x_returnCode, 
											@x_returnMsg)"))
	die("CALL failed: (" . $db->errno . ") " . $db->error);
	 
	// Fetch OUT parameters 
	if (!($res = $db->query("select @x_userId as user_id , 
	                                @x_userMode as user_mode ,
									@x_returnCode as return_code, 
									@x_returnMsg as return_msg")))
		die("Fetch failed: (" . $db->errno . ") " . $db->error);
	$row = $res->fetch_assoc();
	 
	//create user array
	$userArray[] = array(
	  'user_id'       => $row['user_id'],
	  'user_mode'     => $row['user_mode'],
	  'return_code'   => $row['return_code']
	);
	
	echo json_encode($userArray);

	//close the db connection
	mysqli_close($db);	
}
?>
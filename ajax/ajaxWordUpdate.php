<?php
include("./db.php");

if(isSet($_POST['pgUpdateLevel']) && isSet($_POST['pgUpdateLetter']))
{
	// Data sent from Form
	$wordLevel     = mysqli_real_escape_string($db,$_POST['pgUpdateLevel']); 
	$wordLetter    = mysqli_real_escape_string($db,$_POST['pgUpdateLetter']); 
	$wordPronounce = mysqli_real_escape_string($db,$_POST['pgUpdatePronounce']); 
	$wordMeaning   = mysqli_real_escape_string($db,$_POST['pgUpdateMeaning']); 
	$wordExample   = mysqli_real_escape_string($db,$_POST['pgUpdateExample']); 
	$wordInterpret = mysqli_real_escape_string($db,$_POST['pgUpdateInterpret']);
    $chapterno     = mysqli_real_escape_string($db,$_POST['pgChapterNo']); 	

	// Prepare IN parameters
	$db->query("SET @p_wordLevel      = " . "'" . $wordLevel . "'");
	$db->query("SET @p_wordLetter     = " . "'" . $wordLetter . "'");
	$db->query("SET @p_pronounce      = " . "'" . $wordPronounce . "'");
	$db->query("SET @p_wordMeaning    = " . "'" . $wordMeaning . "'");
	$db->query("SET @p_wordExample    = " . "'" . $wordExample . "'");
	$db->query("SET @p_wordInterpret  = " . "'" . $wordInterpret . "'");
	$db->query("SET @p_chapterNo      = " . "'" . $chapterno . "'");

	// Prepare OUT parameters
	$db->query("set @x_returnCode = '0'");
	$db->query("set @x_returnMsg = '0'");

	// Call sproc 
	// IsSupervisor(IN username CHAR(20), OUT success BOOLEAN)
	if(!$db->query("call pr_update_word_master(@p_wordLevel, 
	                                           @p_wordLetter, 
											   @p_pronounce, 
											   @p_wordMeaning, 
											   @p_wordExample, 
											   @p_wordInterpret, 
											   @p_chapterNo, 
											   @x_returnCode, 
											   @x_returnMsg)"))
	die("CALL failed: (" . $db->errno . ") " . $db->error);
	 
	// Fetch OUT parameters 
	if (!($res = $db->query("select @x_returnCode as return_code, 
	                                @x_returnMsg as return_msg")))
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
<?php
include("./db.php");

if(isSet($_POST['usercode']) && isSet($_POST['fromlang']) && isSet($_POST['tolang']))
{
	// Data sent from Form
	$usercode= mysqli_real_escape_string($db,$_POST['usercode']); 
	$fromLang = mysqli_real_escape_string($db,$_POST['fromlang']); 
	$toLang   = mysqli_real_escape_string($db,$_POST['tolang']); 

	$sql =  "SELECT a.word_level, b.level_title 
			FROM word_user_level_tbl a, 
				word_level_tbl b, 
				word_user_tbl c 
			WHERE c.user_code = '$usercode'
			AND b.origin_language =  '$fromLang'
            AND b.word_language =  '$toLang'
			AND a.user_id = c.user_id 
			AND b.word_level = a.word_level " ;

	//echo $sql;

	$result = mysqli_query($db, $sql) or die("Error in Selecting " . mysqli_error($db));

	while($row =mysqli_fetch_assoc($result))
	{
		$levelArray[] = array(
		  'wordlevel' => $row['word_level'],
		  'leveltitle' => $row['level_title']
		);
	}
	echo json_encode($levelArray);

	//close the db connection
	mysqli_close($db);
}
?>
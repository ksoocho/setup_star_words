<?php
    include("./db.php");

if(isSet($_POST['langcode']))
{
	$langcode= mysqli_real_escape_string($db,$_POST['langcode']); 
	
	$sql =  "SELECT tts_code
				  ,tts_speed
			FROM word_common_tbl
			WHERE common_type = 'LANGUAGE'
			AND   enabled_flag = 'Y'
			AND   common_code = '$langcode'
			" ;

	$result = mysqli_query($db, $sql) or die("Error in Selecting " . mysqli_error($db));

	while($row =mysqli_fetch_assoc($result))
	{
		$ttsArray[] = array(
		  'tts_code'  => $row['tts_code'],
		  'tts_speed' => $row['tts_speed']
		);
	}
	echo json_encode($ttsArray);

	//close the db connection
	mysqli_close($db);
}
?>
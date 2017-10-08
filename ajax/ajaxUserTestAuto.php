<?php
include("./db.php");

if(isSet($_POST['wordlevel']))
{
	// username and password sent from Form
	$wordlevel= mysqli_real_escape_string($db,$_POST['wordlevel']); 
	$wordcnt= mysqli_real_escape_string($db,$_POST['wordcnt']); 

    $wordid       = 0;
	$wordletter   = "";
	$wordmeaning  = "";

    $sql = "select wm.word_id
				  ,wm.word_letter
				  ,wl.word_meaning
			from word_language_tbl  wl
				 ,word_master_tbl   wm
				 ,word_level_tbl    wv
				 ,word_question_tbl wq
			where wq.word_level = '$wordlevel'
			and   wv.word_level = wq.word_level
			and   wm.word_id = wq.word_id
			and   wl.word_id = wq.word_id
			and   wl.word_language = wv.word_language
			ORDER BY RAND() LIMIT $wordcnt ";

	$result = mysqli_query($db, $sql) or die("Error in Selecting " . mysqli_error($db));

	while($row =mysqli_fetch_assoc($result))
	{
		$wordid       = $row['word_id'];
	    $wordletter   = $row['word_letter'];
	    $wordmeaning  = $row['word_meaning'];
		
		$wordletter = stripslashes($wordletter);
		
		$testArray[] = array(
		  'wordid'      => $wordid,
		  'wordletter'  => $wordletter,
		  'wordmeaning' => $wordmeaning
		);
	}
	
	echo json_encode($testArray);

	//close the db connection
	mysqli_close($db);
}
?>
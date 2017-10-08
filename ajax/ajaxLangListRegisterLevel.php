<?php
    include("./db.php");

if(isSet($_POST['fromlang']) && isSet($_POST['tolang']))
{

	// Data sent from Form
	$fromLang = mysqli_real_escape_string($db,$_POST['fromlang']); 
	$toLang   = mysqli_real_escape_string($db,$_POST['tolang']); 
	
	$sql =  "SELECT b.word_level, 
	                b.level_title,
                    count(c.word_id) as word_count					
			FROM word_level_tbl b
			     ,word_question_tbl c
			WHERE IFNULL(b.active_flag, 'N') = 'Y'
			AND   c.word_level = b.word_level
			AND b.origin_language =  '$fromLang'
            AND b.word_language =  '$toLang'
			GROUP BY b.word_level, 
	                b.level_title
			ORDER BY b.word_level" ;

	//echo $sql;

	$result = mysqli_query($db, $sql) or die("Error in Selecting " . mysqli_error($db));

	while($row =mysqli_fetch_assoc($result))
	{
		$levelArray[] = array(
		  'wordlevel'  => $row['word_level'],
		  'leveltitle' => $row['level_title'],
		  'wordcount'  => $row['word_count']
		);
	}
	echo json_encode($levelArray);

	//close the db connection
	mysqli_close($db);

}	
?>
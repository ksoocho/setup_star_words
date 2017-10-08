<?php
    include("./db.php");

	$sql =  "SELECT b.origin_language,
					b.word_language,
					b.word_level, 
	                b.level_title,
                    (select count(c.word_id)
                     from word_question_tbl c
					 where c.word_level = b.word_level
					 )	as word_count					
			FROM word_level_tbl b
			WHERE IFNULL(b.active_flag, 'N') = 'Y'
			ORDER BY b.origin_language,
					 b.word_language,
			         b.word_level" ;

	$result = mysqli_query($db, $sql) or die("Error in Selecting " . mysqli_error($db));

	while($row =mysqli_fetch_assoc($result))
	{
		$levelArray[] = array(
		  'wordlevel'  => $row['word_level'],
		  'leveltitle' => $row['level_title'],
		  'originlang' => $row['origin_language'],
		  'wordlang'   => $row['word_language'],
		  'wordcount'  => $row['word_count']
		);
	}
	echo json_encode($levelArray);

	mysqli_close($db);

?>
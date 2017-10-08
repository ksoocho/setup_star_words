<?php
    include("./db.php");

	$sql =  "SELECT common_code as lang_code
				  ,common_descr as lang_descr
			FROM word_common_tbl
			WHERE common_type = 'LANGUAGE'
			AND   enabled_flag = 'Y'
			" ;

	//echo $sql;

	$result = mysqli_query($db, $sql) or die("Error in Selecting " . mysqli_error($db));

	while($row =mysqli_fetch_assoc($result))
	{
		$langArray[] = array(
		  'langcode'  => $row['lang_code'],
		  'langdescr' => $row['lang_descr']
		);
	}
	echo json_encode($langArray);

	//close the db connection
	mysqli_close($db);
?>
<?php
include("./db.php");

	
	$sql = "SELECT question_title
				   ,question_descr
			FROM word_qa_board_tbl 
			WHERE qa_type = 'ADMIN'
			AND   expire_date >= sysdate()
			ORDER BY question_date DESC";

	$result = mysqli_query($db, $sql) or die("Error in Selecting " . mysqli_error($db));

	while($row =mysqli_fetch_assoc($result))
	{
		$noticeArray[] = array(
		  'questiontitle'  => $row['question_title'],
		  'questiondescr'  => $row['question_descr']
		);
	}
	
	echo json_encode($noticeArray);

	//close the db connection
	mysqli_close($db);
?>
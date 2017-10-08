<?php
include("./db.php");

if(isSet($_POST['wordlevel']))
{
	$wordlevel= mysqli_real_escape_string($db,$_POST['wordlevel']); 
	
	$userName    = "";
	$seqNo       = 0;
	$submitCount = 0;
	$okCount     = 0;
	$ngCount     = 0;	

    //--------------------------------------
	// Test Count - TOP 10 List
    //--------------------------------------
    $sql = "select wu.user_name
	               ,count(*) as submit_count
				   ,sum(ok_count) as ok_count
			 from word_user_result_tbl wur
			   , word_user_tbl wu
			 where wur.user_id = wu.user_id
			 and   wur.word_level = '$wordlevel'
			 group by wu.user_name
			 order by 2 desc
			 limit 0, 10
			 ";

	$result = mysqli_query($db, $sql) or die("Error in Selecting " . mysqli_error($db));

	while($row =mysqli_fetch_assoc($result))
	{
		$seqNo = $seqNo + 1;
		
		$userName    = $row['user_name']; 
		$submitCount = $row['submit_count']; 
		$okCount     = $row['ok_count']; 
		$ngCount     = $submitCount - $okCount;

		$resultArray[] = array(
		  'seqno'        => $seqNo,
		  'username'     => $userName,
		  'submitcount'  => $submitCount,
		  'okcount'      => $okCount,
		  'ngcount'      => $ngCount
		);
	}		
	
	echo json_encode($resultArray);

	//close the db connection
	mysqli_close($db);
}
?>
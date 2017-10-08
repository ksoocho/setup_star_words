<?php
include("./db.php");

if(isSet($_POST['usercode'])&&isSet($_POST['wordlevel']))
{
	// username and password sent from Form
	$usercode= mysqli_real_escape_string($db,$_POST['usercode']); 
	$wordlevel= mysqli_real_escape_string($db,$_POST['wordlevel']); 
    $chapterno= mysqli_real_escape_string($db,$_POST['chapterno']);  
    $retry= mysqli_real_escape_string($db,$_POST['retry']); 

    $wordid       = 0;
	$wordletter   = "";
	$wordmeaning  = "";
	
	if ( $retry == 'Y')
    {	
		$sql = "select wm.word_id
					  ,wm.word_letter
					  ,wl.word_meaning
				from word_language_tbl  wl
					 ,word_master_tbl   wm
					 ,word_level_tbl    wv
					 ,word_question_tbl wq
				where wq.word_level = '$wordlevel'
				and   IFNULL(wq.chapter_no,0) = IF($chapterno=0,IFNULL(chapter_no,0),$chapterno)
				and   wv.word_level = wq.word_level
				and   wm.word_id = wq.word_id
				and   wl.word_id = wq.word_id
				and   wl.word_language = wv.word_language
				and   exists ( select 'x'
								   from word_user_result_tbl wur
									  , word_user_tbl wu
								   where wur.user_id    = wu.user_id
								   and   wu.user_code   = '$usercode'
								   and   wur.word_level = wq.word_level
								   and   wur.word_id    = wq.word_id
                                   and   wur.ok_count   = 0)
				ORDER BY RAND() LIMIT 9 ";

	} else if ( $retry == 'T')  {	

   	    $sql = "select wm.word_id
					  ,wm.word_letter
					  ,wl.word_meaning
				from word_language_tbl  wl
					 ,word_master_tbl   wm
					 ,word_level_tbl    wv
					 ,word_question_tbl wq
				where wq.word_level = '$wordlevel'
				and   IFNULL(wq.chapter_no,0) = IF($chapterno=0,IFNULL(chapter_no,0),$chapterno)
				and   wv.word_level = wq.word_level
				and   wm.word_id = wq.word_id
				and   wl.word_id = wq.word_id
				and   wl.word_language = wv.word_language
				and   not exists ( select 'x'
								   from word_user_result_tbl wur
									  , word_user_tbl wu
								   where wur.user_id    = wu.user_id
								   and   wu.user_code   = '$usercode'
								   and   wur.word_level = wq.word_level
								   and   wur.word_id    = wq.word_id)
				ORDER BY RAND() LIMIT 9 ";

	} else {
		
		$sql = "select wm.word_id
					  ,wm.word_letter
					  ,wl.word_meaning
				from word_language_tbl  wl
					 ,word_master_tbl   wm
					 ,word_level_tbl    wv
					 ,word_question_tbl wq
				where wq.word_level = '$wordlevel'
				and   IFNULL(wq.chapter_no,0) = IF($chapterno=0,IFNULL(chapter_no,0),$chapterno)
				and   wv.word_level = wq.word_level
				and   wm.word_id = wq.word_id
				and   wl.word_id = wq.word_id
				and   wl.word_language = wv.word_language
				and   exists ( select 'x'
						       from word_user_study_tbl wus
							  	  , word_user_tbl wu
						       where wus.user_id    = wu.user_id
						       and   wu.user_code   = '$usercode'
						       and   wus.word_level = wq.word_level
						       and   wus.word_id    = wq.word_id)
				and   not exists ( select 'x'
								   from word_user_result_tbl wur
									  , word_user_tbl wu
								   where wur.user_id    = wu.user_id
								   and   wu.user_code   = '$usercode'
								   and   wur.word_level = wq.word_level
								   and   wur.word_id    = wq.word_id)
				ORDER BY RAND() LIMIT 9 ";
		
	}		

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
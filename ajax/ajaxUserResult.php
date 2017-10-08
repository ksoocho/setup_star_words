<?php
include("./db.php");

if(isSet($_POST['usercode'])&&isSet($_POST['wordlevel']))
{
	// username and password sent from Form
	$usercode= mysqli_real_escape_string($db,$_POST['usercode']); 
	$wordlevel= mysqli_real_escape_string($db,$_POST['wordlevel']); 
	$chapterno= mysqli_real_escape_string($db,$_POST['chapterno']);  
	
	$totalCount  = 0;
	$studyCount  = 0;
	$submitCount = 0;
	$okCount     = 0;
	$ngCount     = 0;	

    //--------------------------------------
	//Total Count  
    //--------------------------------------
	$sql01 = "select count(*) as total_count
				from word_language_tbl  wl
					 ,word_master_tbl   wm
					 ,word_level_tbl    wv
					 ,word_question_tbl wq
				where wq.word_level = '$wordlevel'
				and   IFNULL(wq.chapter_no,0) = IF($chapterno=0,IFNULL(chapter_no,0),$chapterno)
				and   wv.word_level = wq.word_level
				and   wm.word_id = wq.word_id
				and   wl.word_id = wq.word_id
				and   wl.word_language = wv.word_language ";

	$result01 = mysqli_query($db, $sql01) or die("Error in Selecting " . mysqli_error($db));

	
	while($row01 =mysqli_fetch_assoc($result01))
	{
		$totalCount = $row01['total_count']; 
	}
	
    //--------------------------------------
	// Test Count
    //--------------------------------------
    $sql02 = "select count(*) as submit_count
				   ,sum(wur.ok_count) as ok_count
			 from word_user_result_tbl wur
			   , word_user_tbl wu
			   , word_question_tbl wq
			 where wur.user_id = wu.user_id
			 and   wu.user_code = '$usercode'
			 and   wq.word_level = '$wordlevel'
			 and   IFNULL(wq.chapter_no,0) = IF($chapterno=0,IFNULL(chapter_no,0),$chapterno)
			 and   wur.word_level = wq.word_level
			 and   wur.word_id    = wq.word_id
			 ";

	$result02 = mysqli_query($db, $sql02) or die("Error in Selecting " . mysqli_error($db));

	
	while($row02 =mysqli_fetch_assoc($result02))
	{
		$submitCount = $row02['submit_count']; 
		$okCount = $row02['ok_count']; 
		$ngCount =  $submitCount - $okCount;
	}	
	
    //--------------------------------------
	// Study Count
    //--------------------------------------
    $sql03 = "select count(*) as study_count
			 from word_user_study_tbl wur
			   , word_user_tbl wu
			    , word_question_tbl wq
			 where wur.user_id = wu.user_id
			 and   wu.user_code = '$usercode'
			 and   wq.word_level = '$wordlevel'
			 and   IFNULL(wq.chapter_no,0) = IF($chapterno=0,IFNULL(chapter_no,0),$chapterno)
			 and   wur.word_level = wq.word_level
			 and   wur.word_id    = wq.word_id
			 ";

	$result03 = mysqli_query($db, $sql03) or die("Error in Selecting " . mysqli_error($db));

	
	while($row03 =mysqli_fetch_assoc($result03))
	{
		$studyCount = $row03['study_count']; 
	}		
	
	$resultArray[] = array(
	  'totalcount'   => $totalCount,
	  'studycount'   => $studyCount,
	  'submitcount'  => $submitCount,
	  'okcount'      => $okCount,
	  'ngcount'      => $ngCount
	);
		
	echo json_encode($resultArray);

	//close the db connection
	mysqli_close($db);
}
?>
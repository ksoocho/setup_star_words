<?php
include("./db.php");

if(isSet($_POST['usercode'])&&isSet($_POST['wordlevel']))
{
	$usercode= mysqli_real_escape_string($db,$_POST['usercode']); 
	$wordlevel= mysqli_real_escape_string($db,$_POST['wordlevel']);  
	$chapterno= mysqli_real_escape_string($db,$_POST['chapterno']);  
	$retry= mysqli_real_escape_string($db,$_POST['retry']); 

    //---------------------------------------------- 
	// Word Information
    //---------------------------------------------- 
	$wordid       = 0;
	$wordletter   = "";
	$pronounce    = "";
	$wordmeaning  = "";
	$leveltitle   = "";
	$wordlanguage = "";
	
	if ( $retry == 'Y')
    {

	$sql = "select wm.word_id
				  ,wm.word_letter
				  ,wm.pronounce
				  ,wl.word_meaning
				  ,wv.level_title
				  ,wv.word_language
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
						       from word_user_study_tbl wus
							  	  , word_user_tbl wu
						       where wus.user_id = wu.user_id
						       and   wu.user_code = '$usercode'
						       and   wus.word_level = wq.word_level
						       and   wus.word_id = wq.word_id
						       and   IFNULL(wus.skip_flag,'N') = 'Y')
			and   exists ( select 'x'
						       from word_user_result_tbl wur
							  	  , word_user_tbl wu
						       where wur.user_id = wu.user_id
						       and   wu.user_code = '$usercode'
						       and   wur.word_level = wq.word_level
						       and   wur.word_id = wq.word_id
                               and   wur.ok_count = 0)
			ORDER BY RAND() LIMIT 1 ";

	} else	if ( $retry == 'R')  {

	$sql = "select wm.word_id
				  ,wm.word_letter
				  ,wm.pronounce
				  ,wl.word_meaning
				  ,wv.level_title
				  ,wv.word_language
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
						   where wus.user_id = wu.user_id
						   and   wu.user_code = '$usercode'
						   and   wus.word_level = wq.word_level
						   and   wus.word_id = wq.word_id
						   and   IFNULL(wus.skip_flag,'N') = 'Y')
			ORDER BY RAND() LIMIT 1 ";
			
	} else {	
	
	$sql = "select wm.word_id
				  ,wm.word_letter
				  ,wm.pronounce
				  ,wl.word_meaning
				  ,wv.level_title
				  ,wv.word_language
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
						       from word_user_study_tbl wus
							  	  , word_user_tbl wu
						       where wus.user_id = wu.user_id
						       and   wu.user_code = '$usercode'
						       and   wus.word_level = wq.word_level
						       and   wus.word_id = wq.word_id
						       and   IFNULL(wus.skip_flag,'N') = 'Y')
			ORDER BY RAND() LIMIT 1 ";
	
	}	

	$result = mysqli_query($db, $sql) or die("Error in Selecting " . mysqli_error($db));

	while($row =mysqli_fetch_assoc($result))
	{
		$wordid      = $row['word_id'];
		$wordletter  = $row['word_letter'];
		$pronounce   = $row['pronounce'];
		$wordmeaning = $row['word_meaning'];
		$leveltitle  = $row['level_title'];
		$wordlanguage  = $row['word_language']; 
	}

	//--------------------------------------------------------- 
	// Word Example  
	//--------------------------------------------------------- 
    $wordexample   = "";
	$wordinterpret = "";
	  
    $sql1 = " select we.word_example
				    ,we.word_interpret
			  from  word_example_tbl  we
              where we.word_id = '$wordid'
			  and   we.word_language =  '$wordlanguage' 
			  and   we.word_example_seq = 1  			  
	         ";	

	$result1 = mysqli_query($db, $sql1) or die("Error in Selecting " . mysqli_error($db));

	while($row1 =mysqli_fetch_assoc($result1))
	{
			 
	  $wordexample  =  $row1['word_example'];
	  $wordinterpret = $row1['word_interpret'];

	}
	
	$wordletter = stripslashes($wordletter);
	$wordexample = stripslashes($wordexample);
	
	$levelArray[] = array(
	  'wordid'        => $wordid,
	  'wordletter'    => $wordletter,
	  'pronounce'     => $pronounce,
	  'wordmeaning'   => $wordmeaning,
	  'wordexample'   => $wordexample,
	  'wordinterpret' => $wordinterpret,
	  'leveltitle'    => $leveltitle
	);
	
	echo json_encode($levelArray);

	//close the db connection
	mysqli_close($db);
}
?>
<?php
include("./db.php");

if(isSet($_POST['wordlevel'])&&isSet($_POST['searchchar'])&&isSet($_POST['page']))
{
	// username and password sent from Form
	$wordlevel  = mysqli_real_escape_string($db,$_POST['wordlevel']); 
	$searchchar = mysqli_real_escape_string($db,$_POST['searchchar']); 
	$checkword  = mysqli_real_escape_string($db,$_POST['checkword']); 
	$usercode   = mysqli_real_escape_string($db,$_POST['usercode']); 
	$page       = mysqli_real_escape_string($db,$_POST['page']); 
	
	$per_page   = 15;
	$start      = ( $page - 1 ) * $per_page;
 
    if ( $checkword == 'W')
    {
		
		$sql = "select wm.word_id
					  ,wm.word_letter
					  ,wm.pronounce
					  ,wl.word_meaning
				from word_language_tbl  wl
					 ,word_master_tbl   wm
					 ,word_level_tbl    wv
					 ,word_question_tbl wq
				where wq.word_level = '$wordlevel'
				and   wm.word_letter like '$searchchar%'
				and   wv.word_level = wq.word_level
				and   wm.word_id = wq.word_id
				and   wl.word_id = wq.word_id
				and   wl.word_language = wv.word_language
				and   exists ( select 'x'
						       from word_user_result_tbl wur
							  	  , word_user_tbl wu
						       where wur.user_id = wu.user_id
						       and   wu.user_code = '$usercode'
						       and   wur.word_level = wq.word_level
						       and   wur.word_id = wq.word_id
                               and   wur.ok_count = 0)
				ORDER BY wm.word_letter
				LIMIT $start, $per_page ";
			
	} else {
		
		$sql = "select wm.word_id
					  ,wm.word_letter
					  ,wm.pronounce
					  ,wl.word_meaning
				from word_language_tbl  wl
					 ,word_master_tbl   wm
					 ,word_level_tbl    wv
					 ,word_question_tbl wq
				where wq.word_level = '$wordlevel'
				and   wm.word_letter like '$searchchar%'
				and   wv.word_level = wq.word_level
				and   wm.word_id = wq.word_id
				and   wl.word_id = wq.word_id
				and   wl.word_language = wv.word_language
				ORDER BY wm.word_letter
				LIMIT $start, $per_page ";
		
	}		

	$result = mysqli_query($db, $sql) or die("Error in Selecting " . mysqli_error($db));
	
	while($row =mysqli_fetch_assoc($result))
	{
		$wordListlArray[] = array(
		  'wordid'      => $row['word_id'],
		  'wordletter'  => $row['word_letter'],
		  'pronounce'   => $row['pronounce'],
		  'wordmeaning' => $row['word_meaning']
		);
	}
	
	echo json_encode($wordListlArray);

	//close the db connection
	mysqli_close($db);
}
?>
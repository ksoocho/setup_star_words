<?php
include("./db.php");

if(isSet($_POST['wordlevel'])&&isSet($_POST['searchchar']))
{
	// username and password sent from Form
	$wordlevel  = mysqli_real_escape_string($db,$_POST['wordlevel']); 
	$searchchar = mysqli_real_escape_string($db,$_POST['searchchar']); 
	$checkword  = mysqli_real_escape_string($db,$_POST['checkword']); 
	$usercode   = mysqli_real_escape_string($db,$_POST['usercode']); 

    if ( $checkword == 'W')
    {
	
		$sql = "select count(*) as total_count
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
				";
	} else {
		
		$sql = "select count(*) as total_count
				from word_language_tbl  wl
					 ,word_master_tbl   wm
					 ,word_level_tbl    wv
					 ,word_question_tbl wq
				where wq.word_level = '$wordlevel'
				and   wm.word_letter like '$searchchar%'
				and   wv.word_level = wq.word_level
				and   wm.word_id = wq.word_id
				and   wl.word_id = wq.word_id
				and   wl.word_language = wv.word_language ";
		
	}		

	$result = mysqli_query($db, $sql) or die("Error in Selecting " . mysqli_error($db));
	
	$row =mysqli_fetch_assoc($result);
	
	echo $row['total_count'];

	//close the db connection
	mysqli_close($db);
}
?>
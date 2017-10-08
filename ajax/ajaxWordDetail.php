<?php
include("./db.php");

if(isSet($_POST['wordlevel'])&&isSet($_POST['wordid']))
{
	$wordlevel= mysqli_real_escape_string($db,$_POST['wordlevel']); 
	$wordid= mysqli_real_escape_string($db,$_POST['wordid']); 
 
    //---------------------------------------------- 
	// Word Information
    //---------------------------------------------- 
	$wordletter   = "";
	$pronounce    = "";
	$wordmeaning  = "";
	$leveltitle   = "";
	$wordlanguage = "";
	
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
			and   wv.word_level = wq.word_level
			and   wm.word_id = wq.word_id
			and   wl.word_id = wq.word_id
			and   wl.word_language = wv.word_language
			and   wm.word_id = '$wordid' ";

	$result = mysqli_query($db, $sql) or die("Error in Selecting " . mysqli_error($db));

	while($row =mysqli_fetch_assoc($result))
	{
		$wordletter  = $row['word_letter'];
		$pronounce   = $row['pronounce'];
		$wordmeaning = $row['word_meaning'];
		$leveltitle  = $row['level_title'];
		$wordlanguage  = $row['word_language']; 
	}

	//--------------------------------------------------------- 
	// Word Example  
	//--------------------------------------------------------- 
    $word_example_seq   = "";

   $sql2 = " select max(we.word_example_seq) as word_example_seq
			  from  word_example_tbl  we
              where we.word_id = '$wordid'
			  and   we.word_language =  '$wordlanguage' 
	         ";	

	$result2 = mysqli_query($db, $sql2) or die("Error in Selecting " . mysqli_error($db));

	while($row2 =mysqli_fetch_assoc($result2))
	{
	  $word_example_seq  =  $row2['word_example_seq'];
	}

    $wordexample   = "";
	$wordinterpret = "";
	  
    $sql1 = " select we.word_example
				    ,we.word_interpret
			  from  word_example_tbl  we
              where we.word_id = '$wordid'
			  and   we.word_language =  '$wordlanguage' 
			  and   we.word_example_seq = '$word_example_seq'  			  
	         ";	

	$result1 = mysqli_query($db, $sql1) or die("Error in Selecting " . mysqli_error($db));

	while($row1 =mysqli_fetch_assoc($result1))
	{
			 
	  $wordexample  =  $row1['word_example'];
	  $wordinterpret = $row1['word_interpret'];

	}
	
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
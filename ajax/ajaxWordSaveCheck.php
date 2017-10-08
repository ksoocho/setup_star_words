<?php
include("./db.php");

if(isSet($_POST['wordletter'])&&isSet($_POST['wordlevel']))
{
	$wordletter= mysqli_real_escape_string($db,$_POST['wordletter']); 
	$wordlevel= mysqli_real_escape_string($db,$_POST['wordlevel']); 

	$pronounce    = "";
	$wordmeaning  = "";
	
	$wordid       = 0;
	$wordlanguage = "";	
	
	$sql = "select wm.pronounce
				  ,wl.word_meaning
				  ,wm.word_id
				  ,wv.word_language
			from word_language_tbl  wl
				 ,word_master_tbl   wm
				 ,word_level_tbl    wv
			where wm.word_letter = '$wordletter'
			and   wm.origin_language = wv.origin_language
			and   wl.word_language = wv.word_language
            and   wv.word_level = '$wordlevel'
			and   wl.word_id = wm.word_id";

	$result = mysqli_query($db, $sql) or die("Error in Selecting " . mysqli_error($db));
	
	while($row =mysqli_fetch_assoc($result))
	{
	  $pronounce    = $row['pronounce'];
	  $wordmeaning  = $row['word_meaning'];
	  $wordid       = $row['word_id'];
	  $wordlanguage = $row['word_language'];
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
	
	// Set Array Info 
	$levelArray[] = array(
	  'pronounce'     => $pronounce,
	  'wordmeaning'   => $wordmeaning,
	  'wordexample'   => $wordexample,
	  'wordinterpret' => $wordinterpret
	);

	
	echo json_encode($levelArray);

	//close the db connection
	mysqli_close($db);
}
?>
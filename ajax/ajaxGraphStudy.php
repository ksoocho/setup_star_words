<?php
include("./db.php");

if(isSet($_POST['usercode'])&&isSet($_POST['wordlevel']))
{

	$usercode= mysqli_real_escape_string($db,$_POST['usercode']); 
	$wordlevel= mysqli_real_escape_string($db,$_POST['wordlevel']); 
 
	$retry= mysqli_real_escape_string($db,$_POST['retry']); 

	$sql = "select 'STUDY' study_type
	               ,scal.cal_date study_date
	               ,IFNULL(std.study_count,0)  study_count
			from ( select  DATE_FORMAT(DATE_SUB(sysdate()+ INTERVAL 13 HOUR, INTERVAL 0 DAY), '%m/%d/%Y')  as cal_date
				UNION
				select  DATE_FORMAT(DATE_SUB(sysdate()+ INTERVAL 13 HOUR, INTERVAL 1 DAY), '%m/%d/%Y')  as cal_date
				UNION
				select  DATE_FORMAT(DATE_SUB(sysdate()+ INTERVAL 13 HOUR, INTERVAL 2 DAY), '%m/%d/%Y')  as cal_date 
				UNION
				select  DATE_FORMAT(DATE_SUB(sysdate()+ INTERVAL 13 HOUR, INTERVAL 3 DAY), '%m/%d/%Y')  as cal_date 
				UNION
				select  DATE_FORMAT(DATE_SUB(sysdate()+ INTERVAL 13 HOUR, INTERVAL 4 DAY), '%m/%d/%Y')  as cal_date 
				UNION
				select  DATE_FORMAT(DATE_SUB(sysdate()+ INTERVAL 13 HOUR, INTERVAL 5 DAY), '%m/%d/%Y')  as cal_date 
				UNION
				select  DATE_FORMAT(DATE_SUB(sysdate()+ INTERVAL 13 HOUR, INTERVAL 6 DAY), '%m/%d/%Y')  as cal_date 
				UNION
				select  DATE_FORMAT(DATE_SUB(sysdate()+ INTERVAL 13 HOUR, INTERVAL 7 DAY), '%m/%d/%Y')  as cal_date 
				UNION
				select  DATE_FORMAT(DATE_SUB(sysdate()+ INTERVAL 13 HOUR, INTERVAL 8 DAY), '%m/%d/%Y')  as cal_date 
				UNION
				select  DATE_FORMAT(DATE_SUB(sysdate()+ INTERVAL 13 HOUR, INTERVAL 9 DAY), '%m/%d/%Y')  as cal_date 
				UNION
				select  DATE_FORMAT(DATE_SUB(sysdate()+ INTERVAL 13 HOUR, INTERVAL 10 DAY), '%m/%d/%Y')  as cal_date 
				) scal
				LEFT OUTER JOIN	
				(select DATE_FORMAT(wus.study_date+ INTERVAL 13 HOUR, '%m/%d/%Y') study_date
					  ,count(*) study_count
				from word_user_study_tbl wus
				   , word_user_tbl wu
				where wus.user_id = wu.user_id
				and   wu.user_code = '$usercode'
				and   wus.word_level = '$wordlevel'
				group by DATE_FORMAT(wus.study_date, '%m/%d/%Y')
				) std
                ON   scal.cal_date = std.study_date
		    UNION
            select 'TEST' study_type
	               ,tcal.cal_date study_date
	               ,IFNULL(tst.study_count,0)  study_count
			from ( select  DATE_FORMAT(DATE_SUB(sysdate()+ INTERVAL 13 HOUR, INTERVAL 0 DAY), '%m/%d/%Y')  as cal_date
				UNION
				select  DATE_FORMAT(DATE_SUB(sysdate()+ INTERVAL 13 HOUR, INTERVAL 1 DAY), '%m/%d/%Y')  as cal_date
				UNION
				select  DATE_FORMAT(DATE_SUB(sysdate()+ INTERVAL 13 HOUR, INTERVAL 2 DAY), '%m/%d/%Y')  as cal_date 
				UNION
				select  DATE_FORMAT(DATE_SUB(sysdate()+ INTERVAL 13 HOUR, INTERVAL 3 DAY), '%m/%d/%Y')  as cal_date 
				UNION
				select  DATE_FORMAT(DATE_SUB(sysdate()+ INTERVAL 13 HOUR, INTERVAL 4 DAY), '%m/%d/%Y')  as cal_date 
				UNION
				select  DATE_FORMAT(DATE_SUB(sysdate()+ INTERVAL 13 HOUR, INTERVAL 5 DAY), '%m/%d/%Y')  as cal_date 
				UNION
				select  DATE_FORMAT(DATE_SUB(sysdate()+ INTERVAL 13 HOUR, INTERVAL 6 DAY), '%m/%d/%Y')  as cal_date 
				UNION
				select  DATE_FORMAT(DATE_SUB(sysdate()+ INTERVAL 13 HOUR, INTERVAL 7 DAY), '%m/%d/%Y')  as cal_date 
				UNION
				select  DATE_FORMAT(DATE_SUB(sysdate()+ INTERVAL 13 HOUR, INTERVAL 8 DAY), '%m/%d/%Y')  as cal_date 
				UNION
				select  DATE_FORMAT(DATE_SUB(sysdate()+ INTERVAL 13 HOUR, INTERVAL 9 DAY), '%m/%d/%Y')  as cal_date 
				UNION
				select  DATE_FORMAT(DATE_SUB(sysdate()+ INTERVAL 13 HOUR, INTERVAL 10 DAY), '%m/%d/%Y')  as cal_date 
				) tcal
				LEFT OUTER JOIN	
				(select DATE_FORMAT(wur.test_date+ INTERVAL 13 HOUR, '%m/%d/%Y') study_date
					  ,count(*) study_count
				from word_user_result_tbl wur
				   , word_user_tbl wu
				where wur.user_id = wu.user_id
				and   wu.user_code = '$usercode'
				and   wur.word_level = '$wordlevel'
				group by DATE_FORMAT(wur.test_date, '%m/%d/%Y')
				) tst
                ON   tcal.cal_date = tst.study_date
            order by 2			
			";


	$result = mysqli_query($db, $sql) or die("Error in Selecting " . mysqli_error($db));

	while($row =mysqli_fetch_assoc($result))
	{
		$graphArray[] = array(
		  'studytype'   => $row['study_type'],
		  'studydate'   => $row['study_date'],
		  'studycount'  => $row['study_count']
		);
	}
	
	echo json_encode($graphArray);

	mysqli_close($db);
}
?>
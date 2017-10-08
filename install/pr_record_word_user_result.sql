DROP PROCEDURE `pr_record_word_user_result`//
CREATE DEFINER=`cksoonew`@`localhost` PROCEDURE `pr_record_word_user_result`(
    IN p_userCode        VARCHAR(45),
    IN p_wordLevel       VARCHAR(5),
    IN p_wordId          INT,
    IN p_resultWordId    INT,
    OUT x_result         VARCHAR(5),
    OUT x_returnCode     VARCHAR(5),
    OUT x_returnMsg      VARCHAR(255)
)
BEGIN
DECLARE v_user_id      INT;
DECLARE v_result       VARCHAR(5);
DECLARE v_process      VARCHAR(10);
DECLARE v_returnCode   VARCHAR(5);
DECLARE v_returnMsg    VARCHAR(255);
DECLARE v_check_count  INT DEFAULT 0;
DECLARE v_ok_count     INT DEFAULT 0;
DECLARE v_ok_sum       INT DEFAULT 0;
DECLARE v_ng_sum       INT DEFAULT 0;
DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
BEGIN
    SET x_returnCode = 'E';
    SET x_returnMsg =  CONCAT(v_process,'- An error has occurred, operation rollbacked and the stored procedure was terminated');
    ROLLBACK;
END;
START TRANSACTION; 
SET v_returnCode = 'S';
SET v_returnMsg = 'Success!!'; 
SET v_process = '100';
IF ( p_userCode IS NULL )
       OR ( p_wordLevel IS NULL ) 
       OR ( p_wordId IS NULL ) 
       OR ( p_resultWordId IS NULL ) THEN
       
    SET v_returnCode = 'E';
    SET v_returnMsg = 'Input Parameter'; 
END IF;   
IF v_returnCode = 'S' THEN
    SET v_process ='200';
 
    SELECT COUNT(*)
    INTO v_check_count 
    FROM  word_user_tbl
    WHERE user_code = p_userCode;
     IF v_check_count = 0 THEN
        SET v_returnCode = 'E';
        SET v_returnMsg = 'Invalid User'; 
    ELSE
        SELECT user_id
        INTO v_user_id 
        FROM  word_user_tbl
        WHERE user_code = p_userCode;
    
    END IF;   
END IF;
IF v_returnCode = 'S' THEN
    SELECT COUNT(*)
    INTO v_check_count 
    FROM word_level_tbl
    WHERE word_level = p_wordLevel ;
     IF v_check_count = 0 THEN
        SET v_returnCode = 'E';
        SET v_returnMsg = 'Invalid Word Level'; 
    END IF;   
    
END IF;
IF v_returnCode = 'S' THEN
    SELECT COUNT(*)
    INTO v_check_count 
    FROM word_user_level_tbl
    WHERE user_id = v_user_id
    AND   word_level = p_wordLevel ;
     IF v_check_count = 0 THEN
        SET v_returnCode = 'E';
        SET v_returnMsg = 'Invalid User Level'; 
    END IF;   
    
END IF;
IF ( v_returnCode = 'S' ) THEN
    SET v_process ='300';
 
    SELECT COUNT(*)
    INTO v_check_count 
    FROM  word_master_tbl
    WHERE word_id = p_wordId;
     IF v_check_count = 0 THEN
        SET v_returnCode = 'E';
        SET v_returnMsg = CONCAT('Invalid Word Master(Word)-',p_wordId); 
    END IF;   
END IF;
IF ( v_returnCode = 'S' and p_resultWordId > 0 ) THEN
    SET v_process ='400';
 
    SELECT COUNT(*)
    INTO v_check_count 
    FROM  word_master_tbl
    WHERE word_id = p_resultWordId;
     IF v_check_count = 0 THEN
        SET v_returnCode = 'E';
        SET v_returnMsg = CONCAT('Invalid Word Master(Result Word)-',p_resultWordId); 
    END IF;   
END IF;
IF p_wordId = p_resultWordId THEN
   SET v_ok_count = 1;
   SET v_result = 'OK';
ELSE
   SET v_ok_count = 0;
   SET v_result = 'NG';
END IF;   
 IF v_returnCode = 'S' THEN
     SET v_process ='500';
    SELECT COUNT(*)
    INTO v_check_count 
    FROM  word_user_result_tbl
    WHERE user_id = v_user_id
    AND   word_level = p_wordLevel
    AND   word_id = p_wordId;
     
     IF v_check_count = 0 THEN
     
        
        
        
        INSERT INTO word_user_result_tbl
        (user_id
         ,word_level
         ,word_id
         ,result_word_id
         ,ok_count
         ,test_date)
        VALUES
         (v_user_id
          ,p_wordLevel
          ,p_wordId
          ,p_resultWordId
          ,v_ok_count
          ,DATE(SYSDATE()));   
          
      ELSE
      
        UPDATE  word_user_result_tbl
        SET    result_word_id = p_resultWordId
               ,ok_count = v_ok_count
               ,test_date = DATE(SYSDATE())
        WHERE user_id = v_user_id
        AND   word_level = p_wordLevel
        AND   word_id = p_wordId;
     
      END IF;
      
      
      
       
     SET v_process ='600';
      SELECT SUM(IF(ok_count = 1,1,0)) as ok_sum
           ,SUM(IF(ok_count = 0,1,0)) as ng_sum
      INTO v_ok_sum
          ,v_ng_sum
      FROM word_user_result_tbl
      WHERE user_id = v_user_id
      AND   word_level = p_wordLevel;
      
      UPDATE word_user_level_tbl
      SET    ok_count = v_ok_sum
            ,ng_count = v_ng_sum
      WHERE user_id = v_user_id
      AND   word_level = p_wordLevel;      
     
 END IF;
 
 IF  v_ok_count = 0  THEN
 
     SELECT count(*)
     INTO   v_check_count
     FROM word_user_study_tbl
     WHERE user_id = v_user_id
     AND   word_level = p_wordLevel
     AND   word_id = p_wordId;
     
     IF v_check_count > 0 THEN
     
         UPDATE word_user_study_tbl
            SET skip_flag = 'N'
         WHERE user_id = v_user_id
         AND   word_level = p_wordLevel
         AND   word_id = p_wordId;
     
     END IF; 
 
 END IF;
 
 IF v_returnCode = 'S' THEN
    SET x_result = v_result;
    SET x_returnCode = v_returnCode;
    SET x_returnMsg = CONCAT('User Study-',v_returnMsg); 
    COMMIT;
 ELSE
    SET x_returnCode = 'E';
    SET x_returnMsg = CONCAT('Error-',v_process,'-',v_returnMsg);
    ROLLBACK;
 END IF;
END

DROP PROCEDURE `pr_record_word_user_study`//
CREATE DEFINER=`cksoonew`@`localhost` PROCEDURE `pr_record_word_user_study`(
    IN p_userCode        VARCHAR(45),
    IN p_wordLevel       VARCHAR(5),
    IN p_wordId          INT,
    IN p_skipFlag        VARCHAR(1),
    OUT x_returnCode     VARCHAR(5),
    OUT x_returnMsg      VARCHAR(255)
)
BEGIN
DECLARE v_user_id      INT;
DECLARE v_process      VARCHAR(10);
DECLARE v_returnCode   VARCHAR(5);
DECLARE v_returnMsg    VARCHAR(255);
DECLARE v_check_count  INT DEFAULT 0;
DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
BEGIN
    SET x_returnCode = 'E';
    SET x_returnMsg =  CONCAT(v_process,'- An error has occurred, operation rollbacked and the stored procedure was terminated');
    ROLLBACK;
END;
START TRANSACTION; 
SET v_returnCode = 'S';
SET v_returnMsg = 'Success!!'; 
SET v_process = '100000';
IF ( p_userCode IS NULL )
       OR ( p_wordLevel IS NULL ) 
       OR ( p_wordId IS NULL ) THEN
       
    SET v_returnCode = 'E';
    SET v_returnMsg = 'Input Parameter'; 
END IF;   
 IF v_returnCode = 'S' THEN
    SET v_process ='200000';
 
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
    SET v_process ='200000';
 
    SELECT COUNT(*)
    INTO v_check_count 
    FROM  word_master_tbl
    WHERE word_id = p_wordId;
     IF v_check_count = 0 THEN
        SET v_returnCode = 'E';
        SET v_returnMsg = 'Invalid Word Master(Word)'; 
    END IF;   
END IF;
 IF v_returnCode = 'S' THEN
     SET v_process ='400000';
    SELECT COUNT(*)
    INTO v_check_count 
    FROM  word_user_study_tbl
    WHERE user_id = v_user_id 
    AND   word_level = p_wordLevel
    AND   word_id = p_wordId;
     
     IF v_check_count = 0 THEN
     
        
        
        
        
        INSERT INTO word_user_study_tbl
        (user_id
         ,word_level
         ,word_id
         ,study_count
         ,skip_flag
         ,study_date)
        VALUES
         (v_user_id 
          ,p_wordLevel
          ,p_wordId
          ,1
          ,p_skipFlag
          ,DATE(SYSDATE()));   
          
      ELSE
      
        UPDATE  word_user_study_tbl
        SET     study_count = IFNULL(study_count,0) + 1
               ,skip_flag = p_skipFlag
               ,study_date = DATE(SYSDATE())
        WHERE user_id = v_user_id 
        AND   word_level = p_wordLevel
        AND   word_id = p_wordId;
     
      END IF;
     
 END IF;
 
 IF v_returnCode = 'S' THEN
    SET x_returnCode = v_returnCode;
    SET x_returnMsg = CONCAT('User Study-',v_returnMsg); 
    COMMIT;
 ELSE
    SET x_returnCode = 'E';
    SET x_returnMsg = CONCAT('Error-',v_process,'-',v_returnMsg);
    ROLLBACK;
 END IF;
END

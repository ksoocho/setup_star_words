DROP PROCEDURE `pr_clear_word_battle`//
CREATE DEFINER=`cksoonew`@`localhost` PROCEDURE `pr_clear_word_battle`(
    IN p_wordLevel       VARCHAR(5),
    OUT x_returnCode     VARCHAR(5),
     OUT x_returnMsg      VARCHAR(255)
)
BEGIN


DECLARE v_process      VARCHAR(10);
DECLARE v_returnCode   VARCHAR(5);
DECLARE v_returnMsg    VARCHAR(255);
DECLARE v_check_count  INT DEFAULT 0;

DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
BEGIN
    SET x_returnCode = 'E';
    SET x_returnMsg =  'System Error';
    ROLLBACK;
END;

START TRANSACTION;

SET v_returnCode = 'S';
SET v_returnMsg = 'Success!!'; 

SET v_process = '100000';

IF  ( p_wordLevel IS NULL ) THEN
       
    SET v_returnCode = 'E';
    SET v_returnMsg = 'Input Parameter'; 

END IF;       

IF v_returnCode = 'S' THEN

        SET v_process = '200000';

    IF left(p_wordLevel,1) <> 'T' THEN

        SET v_returnCode = 'E';
        SELECT CONCAT('Invalid Word Level-',p_wordLevel) INTO v_returnMsg; 

    END IF;

END IF; 


IF v_returnCode = 'S' THEN

    SET v_process = '300000';
  
    SELECT COUNT(*)
    INTO v_check_count 
    FROM word_level_tbl
    WHERE word_level = p_wordLevel;

    IF v_check_count = 0 THEN

        SET v_returnCode = 'E';
        SELECT CONCAT('Invalid Word Level-',p_wordLevel) INTO v_returnMsg; 
    
    END IF;
    
END IF; 


IF v_returnCode = 'S' THEN

        SET v_process = '400000';
  
    SELECT COUNT(*)
    INTO v_check_count 
    FROM word_user_result_tbl
    WHERE word_level = p_wordLevel;

    IF v_check_count > 0 THEN

        DELETE FROM word_user_result_tbl
        WHERE word_level = p_wordLevel;
        
    END IF;
    
END IF; 


IF v_returnCode = 'S' THEN

        SET v_process = '500000';
  
    SELECT COUNT(*)
    INTO v_check_count 
    FROM word_user_study_tbl
    WHERE word_level = p_wordLevel;

    IF v_check_count > 0 THEN

        DELETE FROM word_user_study_tbl
        WHERE word_level = p_wordLevel;
        
    END IF;
    
END IF; 


IF v_returnCode = 'S' THEN

        SET v_process = '600000';
  
    SELECT COUNT(*)
    INTO v_check_count 
    FROM word_question_tbl
    WHERE word_level = p_wordLevel;

    IF v_check_count > 0 THEN

        DELETE FROM word_question_tbl
        WHERE word_level = p_wordLevel;
        
    END IF;

    INSERT INTO word_question_tbl
    ( word_level, word_id, ok_count, ng_count)
    VALUES
    ( p_wordLevel, 1, 0, 0);
    
END IF;  

IF v_returnCode = 'S' THEN

    SET x_returnCode = v_returnCode;
    SET x_returnMsg = v_returnMsg; 
    COMMIT;
    
ELSE
 
    SET x_returnCode = 'E';
    SET x_returnMsg = CONCAT('Error-',v_process,'-',v_returnMsg);
    ROLLBACK;
    
END IF;

END

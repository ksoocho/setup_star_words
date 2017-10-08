DROP PROCEDURE `pr_update_word_chapter`//
CREATE DEFINER=`cksoonew`@`localhost` PROCEDURE `pr_update_word_chapter`(
    IN p_wordLevel       VARCHAR(5),
    IN p_wordId          INT,
    IN p_chapterNo       INT,
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
SET v_check_count = 0;

SET v_process = '100000';

IF  ( p_wordLevel IS NULL )
       OR ( p_wordId IS NULL )
       OR ( p_chapterNo IS NULL ) THEN
       
    SET v_returnCode = 'E';
    SET v_returnMsg = 'Input Parameter'; 

END IF;       

 IF v_returnCode = 'S' THEN
  
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

            
    SET v_process ='300000';
 
    SELECT COUNT(*)
    INTO v_check_count 
    FROM  word_master_tbl
    WHERE word_id = p_wordId;
     
     IF v_check_count = 0 THEN
        
        SET v_returnCode = 'E';
        SET v_returnMsg = 'Not Eixst - word_master_tbl'; 
      
     END IF;
     
END IF;     

IF v_returnCode = 'S' THEN

            
    SET v_process ='200000';
 
    SELECT COUNT(*)
    INTO v_check_count 
    FROM  word_question_tbl
    WHERE word_id = p_wordId
    AND   word_level = p_wordLevel;
     
     IF v_check_count = 0 THEN
        
        SET v_returnCode = 'E';
        SET v_returnMsg = 'Not Eixst - word_question_tbl'; 
      
     END IF;
     
END IF;     

 IF v_returnCode = 'S' THEN

    UPDATE  word_question_tbl
    SET  chapter_no = p_chapterNo
    WHERE word_id = p_wordId
    AND   word_level = p_wordLevel;

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

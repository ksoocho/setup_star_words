DROP PROCEDURE `pr_create_word_question`//
CREATE DEFINER=`cksoonew`@`localhost` PROCEDURE `pr_create_word_question`(
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
    SET x_returnMsg =  'An error has occurred, operation rollbacked and the stored procedure was terminated';
    ROLLBACK;
END;

START TRANSACTION; 

SET v_returnCode = 'S';
SET v_returnMsg = 'Success!!'; 

SET v_process = '100000';

IF ( p_wordLevel IS NULL )
       OR ( p_wordId IS NULL ) THEN
       
    SET v_returnCode = 'E';
    SET v_returnMsg = 'Input Parameter'; 

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
        SET v_returnMsg = 'Invalid Word Master'; 

    END IF;   

END IF;

 IF v_returnCode = 'S' THEN 

    SET v_process ='300000';
 
    SELECT COUNT(*)
    INTO v_check_count 
    FROM  word_question_tbl
    WHERE word_level = p_wordLevel
    AND   word_id = p_wordId;
     
     IF v_check_count > 0 THEN

        SET v_returnCode = 'E';
        SET v_returnMsg = 'Word Question - Already Exists';  
     
     END IF;
 
 END IF;
 
 IF v_returnCode = 'S' THEN

     SET v_process ='400000';

                
    INSERT INTO word_question_tbl
    (word_level
     ,word_id
     ,chapter_no)
    VALUES
     (p_wordLevel
      ,p_wordId
      ,p_chapterNo);   
     
 END IF;
 
 IF v_returnCode = 'S' THEN
    SET x_returnCode = v_returnCode;
    SET x_returnMsg = CONCAT('Word Question-',v_returnMsg); 
    COMMIT;
 ELSE
    SET x_returnCode = 'E';
    SET x_returnMsg = CONCAT('Error-',v_process,'-',v_returnMsg);
 END IF;

END

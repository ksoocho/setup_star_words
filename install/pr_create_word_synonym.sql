DROP PROCEDURE `pr_create_word_synonym`//
CREATE DEFINER=`cksoonew`@`localhost` PROCEDURE `pr_create_word_synonym`(
    IN p_wordId          INT,
    IN p_synonymWordId   INT,
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
    SET x_returnMsg =  CONCAT(v_process,'- An error has occurred, operation rollbacked and the stored procedure was terminated');
    ROLLBACK;
END;
START TRANSACTION; 
SET v_returnCode = 'S';
SET v_returnMsg = 'Success!!'; 
SET v_process = '100000';
IF ( p_wordId IS NULL )
       OR ( p_synonymWordId IS NULL ) THEN
       
    SET v_returnCode = 'E';
    SET v_returnMsg = 'Input Parameter'; 
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
    SET v_process ='200000';
 
    SELECT COUNT(*)
    INTO v_check_count 
    FROM  word_master_tbl
    WHERE word_id = p_synonymWordId;
     IF v_check_count = 0 THEN
        SET v_returnCode = 'E';
        SET v_returnMsg = 'Invalid Word Master(Synonym)'; 
    END IF;   
END IF;
 IF v_returnCode = 'S' THEN 
    SET v_process ='300000';
 
    SELECT COUNT(*)
    INTO v_check_count 
    FROM  word_synonym_tbl
    WHERE word_id = p_wordId
    AND   synonym_word_id = p_synonymWordId;
     
     IF v_check_count > 0 THEN
        SET v_returnCode = 'E';
        SET v_returnMsg = 'Synonym - Already Exists';  
     
     END IF;
 
 END IF;
 
 IF v_returnCode = 'S' THEN
     SET v_process ='400000';
    
    
    
    
    INSERT INTO word_synonym_tbl
    (word_id
     ,synonym_word_id)
    VALUES
     (p_wordId
      ,p_synonymWordId);   
      
    
    
    
    SELECT COUNT(*)
    INTO v_check_count 
    FROM  word_synonym_tbl
    WHERE word_id = p_synonymWordId
    AND   synonym_word_id = p_wordId;
     
     IF v_check_count = 0 THEN
     
        INSERT INTO word_synonym_tbl
        (word_id
         ,synonym_word_id)
        VALUES
         (p_synonymWordId
          ,p_wordId);   
          
     END IF;
     
 END IF;
 
 IF v_returnCode = 'S' THEN
    SET x_returnCode = v_returnCode;
    SET x_returnMsg = CONCAT('Synonym-',v_returnMsg); 
    COMMIT;
 ELSE
    SET x_returnCode = 'E';
    SET x_returnMsg = CONCAT('Error-',v_process,'-',v_returnMsg);
    ROLLBACK;
 END IF;
END

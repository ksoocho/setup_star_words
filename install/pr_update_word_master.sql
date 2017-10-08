DROP PROCEDURE `pr_update_word_master`//
CREATE DEFINER=`cksoonew`@`localhost` PROCEDURE `pr_update_word_master`(
    IN p_wordLevel       VARCHAR(5),
    IN p_wordLetter      VARCHAR(300),
    IN p_pronounce       VARCHAR(45),
    IN p_wordMeaning     VARCHAR(500),
    IN p_wordExample     TEXT,
    IN p_wordInterpret   TEXT,  
    IN p_chapterNo       INT,    
    OUT x_returnCode     VARCHAR(5),
     OUT x_returnMsg      VARCHAR(255)
)
BEGIN


DECLARE v_process      VARCHAR(10);
DECLARE v_returnCode   VARCHAR(5);
DECLARE v_returnMsg    VARCHAR(255);
DECLARE v_check_count  INT DEFAULT 0;
DECLARE v_example_count  INT DEFAULT 0;

DECLARE v_originLanguage VARCHAR(50);
DECLARE v_wordLanguage   VARCHAR(50);

DECLARE v_word_id          INT;

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
SET v_example_count = 0;

SET v_originLanguage ='';
SET v_wordLanguage = '';

SET v_process = '100000';

IF  ( p_wordLevel IS NULL )
       OR ( p_wordLetter IS NULL )
       OR ( p_wordMeaning IS NULL ) THEN
       
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
    
    ELSE

        SELECT origin_language
              ,word_language 
        INTO v_originLanguage
            ,v_wordLanguage
        FROM word_level_tbl
        WHERE word_level = p_wordLevel;
    
    END IF;
    
END IF; 

 IF v_returnCode = 'S' THEN

            
    SET v_process ='3000';
 
    SELECT COUNT(*)
    INTO v_check_count 
    FROM  word_master_tbl
    WHERE origin_language = v_originLanguage
    AND   word_letter = p_wordLetter;
     
     IF v_check_count = 0 THEN
        
        SET v_returnCode = 'E';
        SET v_returnMsg = 'Not Eixst - word_master_tbl'; 
      
     END IF;
     
END IF;     

 IF v_returnCode = 'S' THEN

    SET v_process ='400000';

    SELECT MIN(word_id)
    INTO v_word_id
    FROM  word_master_tbl
    WHERE origin_language = v_originLanguage
    AND   word_letter = p_wordLetter;
    
    UPDATE word_master_tbl
       SET pronounce = p_pronounce
    WHERE word_id =  v_word_id;  

                
    SET v_process ='500000';
    
    SELECT COUNT(*)
    INTO v_check_count 
    FROM  word_language_tbl
    WHERE word_id = v_word_id
    AND   word_language = v_wordLanguage;
     
    IF v_check_count = 0 THEN
        
        SET v_returnCode = 'E';
        SET v_returnMsg = 'Not Eixst - word_language_tbl'; 
    
   END IF;
   
 END IF;

 IF v_returnCode = 'S' THEN

    SET v_process ='600000';

    UPDATE  word_language_tbl
    SET     word_meaning = p_wordMeaning
    WHERE word_id = v_word_id
    AND   word_language = v_wordLanguage;
        

    IF ( p_wordExample IS NOT NULL
         AND LENGTH(p_wordExample) > 0 ) THEN        

        SELECT COUNT(*)
        INTO   v_check_count
        FROM   word_example_tbl
        WHERE  word_id = v_word_id
        AND    word_language = v_wordLanguage
        AND    word_example_seq = 1;
        
        IF v_check_count = 0 THEN 

             INSERT INTO word_example_tbl
            ( word_id
             ,word_language
             ,word_example_seq
             ,word_example
             ,word_interpret
             )
            VALUES
             ( v_word_id
              ,v_wordLanguage
              ,1
              ,p_wordExample
              ,p_wordInterpret
              );    

        ELSE

            SET v_process ='700000';

            SELECT COUNT(*)
            INTO   v_example_count
            FROM   word_example_tbl
            WHERE  word_id = v_word_id
            AND    word_language = v_wordLanguage;
        
            UPDATE   word_example_tbl
               SET   word_example_seq = v_example_count + 1
            WHERE  word_id = v_word_id
            AND    word_language = v_wordLanguage
            AND    word_example_seq = 1;
            
            INSERT INTO word_example_tbl
            ( word_id
             ,word_language
             ,word_example_seq
             ,word_example
             ,word_interpret
             )
            VALUES
             ( v_word_id
              ,v_wordLanguage
              ,1
              ,p_wordExample
              ,p_wordInterpret
              );    
        
        END IF;
        
    END IF;
    
 END IF;
 
  IF v_returnCode = 'S' THEN

    SET v_process ='800000';

    SELECT COUNT(*)
    INTO v_check_count 
    FROM  word_question_tbl
    WHERE  word_level = p_wordLevel
    AND   word_id = v_word_id;
     
    IF v_check_count = 0 THEN
        
        INSERT INTO word_question_tbl
            ( word_level
             ,word_id
             ,chapter_no
             )
            VALUES
             ( p_wordLevel
              ,v_word_id
              ,p_chapterNo
              );     
    ELSE

        UPDATE word_question_tbl
        SET chapter_no = p_chapterNo
        WHERE word_level = p_wordLevel
        AND   word_id = v_word_id;
    
   END IF;
   

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

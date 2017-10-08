DROP PROCEDURE `pr_create_word_level`//
CREATE DEFINER=`cksoonew`@`localhost` PROCEDURE `pr_create_word_level`(
IN p_wordLevel       VARCHAR(5),
IN p_levelTitle      VARCHAR(100),
    IN p_levelDescr      TEXT,
    IN p_originLanguage  VARCHAR(20),
IN p_wordLanguage    VARCHAR(20),
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
   OR ( p_levelTitle IS NULL )
   OR ( p_levelDescr IS NULL )
   OR ( p_originLanguage IS NULL )
   OR ( p_wordLanguage IS NULL ) THEN
       
SET v_returnCode = 'E';
SET v_returnMsg = 'Error - Input Parameter'; 
END IF; 
IF v_returnCode = 'S' THEN
 
SELECT COUNT(*)
INTO v_check_count 
FROM word_common_tbl
WHERE common_type = 'LANGUAGE'
  AND common_code = p_originLanguage
  AND enabled_flag = 'Y';
 IF v_check_count = 0 THEN
SET v_returnCode = 'E';
SET v_returnMsg = 'Word Level - Already Exists';  
 
 END IF;
 
 END IF;
 
 IF v_returnCode = 'S' THEN
     SET v_process ='400000';
    
    
    
    
INSERT INTO word_level_tbl
(word_level
     ,level_title
     ,level_descr
     ,origin_language
 ,word_language
     ,user_count
     ,ok_avg_count)
VALUES
 (p_wordLevel
      ,p_levelTitle
      ,p_levelDescr
      ,p_originLanguage
  ,p_wordLanguage
      ,0
      ,0);   
     
 END IF;
 
 IF v_returnCode = 'S' THEN
    SET x_returnCode = v_returnCode;
SET x_returnMsg = v_returnMsg; 
    COMMIT;
 ELSE
    SET x_returnCode = 'E';
SET x_returnMsg = CONCAT('Error-',v_process,'-',v_returnMsg);
 END IF;
END

DROP PROCEDURE `pr_create_word_user_level`//
CREATE DEFINER=`cksoonew`@`localhost` PROCEDURE `pr_create_word_user_level`(
    IN p_userCode        VARCHAR(20),
    IN p_wordLevel       VARCHAR(5),
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
    SET x_returnMsg =  CONCAT(v_process,'- System Error');
    ROLLBACK;
END;
START TRANSACTION; 
SET v_returnCode = 'S';
SET v_returnMsg = 'Success!!'; 
SET v_process = '1100';
IF ( p_wordLevel IS NULL )
       OR ( p_userCode IS NULL ) THEN
       
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
    ELSE
        UPDATE word_level_tbl
        SET    user_count = IFNULL(user_count,0) + 1
        WHERE  word_level = p_wordLevel ;
    END IF;   
    
END IF;
 IF v_returnCode = 'S' THEN
    SET v_process = '1200';
 
    SELECT COUNT(*)
    INTO v_check_count 
    FROM  word_user_tbl
    WHERE user_code = p_userCode;
     IF v_check_count = 0 THEN
        SET v_returnCode = 'E';
        SET v_returnMsg = 'Invalid User'; 
    ELSE
        SET v_process ='1300';
        SELECT user_id
        INTO v_user_id
        FROM  word_user_tbl
        WHERE user_code = p_userCode;
    
    END IF;   
END IF;
 IF v_returnCode = 'S' THEN 
    SET v_process ='1400';
 
    SELECT COUNT(*)
    INTO v_check_count 
    FROM  word_user_level_tbl
    WHERE user_id = v_user_id
    AND   word_level = p_wordLevel;
     
     IF v_check_count = 0 THEN

        SET v_process ='1500';
    
        INSERT INTO word_user_level_tbl
        (user_id
        ,word_level
        ,creation_date)
        VALUES
        (v_user_id
         ,p_wordLevel
         ,DATE(SYSDATE()));   
     
     END IF;
 
 END IF;
 
 IF v_returnCode = 'S' THEN
    SET x_returnCode = v_returnCode;
    SET x_returnMsg = CONCAT('User Level-',v_returnMsg); 
    COMMIT;
 ELSE
    SET x_returnCode = 'E';
    SET x_returnMsg = CONCAT('Error-',v_process,'-',v_returnMsg);
    ROLLBACK;
 END IF;
END
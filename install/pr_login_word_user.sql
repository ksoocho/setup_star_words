DROP PROCEDURE `pr_login_word_user`//
CREATE DEFINER=`cksoonew`@`localhost` PROCEDURE `pr_login_word_user`(
    IN  p_userCode   VARCHAR(255),
    IN  p_userPwd    VARCHAR(255),
    OUT x_userId     INT,
    OUT x_userMode   VARCHAR(5),
    OUT x_returnCode VARCHAR(5),
    OUT x_returnMsg  VARCHAR(255) )
BEGIN
 
    DECLARE v_user_id INT DEFAULT 0;
    DECLARE v_user_mode   VARCHAR(5);
    
    DECLARE v_process      VARCHAR(10);
    DECLARE v_returnCode   VARCHAR(5);
    DECLARE v_returnMsg    VARCHAR(255);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
    BEGIN
        SET x_returnCode = 'E';
        SET x_returnMsg =  CONCAT(v_process,'- System Error');
        ROLLBACK;
    END;
    START TRANSACTION; 
     
     
    SET v_returnCode = 'S';
    SET v_returnMsg = 'Success!!'; 
    SET v_process = '100';
    
    IF ( p_userCode IS NULL )
           OR ( p_userPwd IS NULL ) THEN
           
        SET v_returnCode = 'E';
        SET v_returnMsg = 'Input Parameter'; 
    END IF;   
    
    IF v_returnCode = 'S' THEN
    
         SELECT user_id
               ,user_mode
         INTO   v_user_id
               ,v_user_mode
         FROM   word_user_tbl
         WHERE user_code = p_userCode
         AND   AES_DECRYPT(UNHEX(user_pwd), 'starwars') = p_userPwd;
         
         IF v_user_id IS NULL THEN     
         
            SET v_returnCode = 'E';
            SET v_returnMsg = 'Invalid User'; 
        END IF;   
    END IF;   
    
    IF v_returnCode = 'S' THEN
     
        UPDATE word_user_tbl
        SET login_count = IFNULL(login_count,0) + 1
        WHERE user_id = v_user_id;
        
        SET x_userId   = v_user_id;
        SET x_userMode = v_user_mode;
        
     END IF; 
     
    IF v_returnCode = 'S' THEN
        SET x_returnCode = v_returnCode;
        SET x_returnMsg = CONCAT('Login-',v_returnMsg); 
        COMMIT;
     ELSE
        SET x_returnCode = 'E';
        SET x_returnMsg = CONCAT('Error-',v_process,'-',v_returnMsg);
        ROLLBACK;
     END IF;
 
 END

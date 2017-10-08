DROP PROCEDURE `pr_get_word_user_info`//
CREATE DEFINER=`cksoonew`@`localhost` PROCEDURE `pr_get_word_user_info`(
    IN   p_userId     INT,
    OUT  x_userCode   VARCHAR(50),
    OUT  x_userName   VARCHAR(50),
    OUT  x_userEmail  VARCHAR(50),
    OUT  x_returnCode VARCHAR(5),
    OUT  x_returnMsg  VARCHAR (255) )
BEGIN
 
    DECLARE v_user_code  VARCHAR(50);
    DECLARE v_user_name  VARCHAR(50);
    DECLARE v_user_email VARCHAR(50);
    
    DECLARE v_process      VARCHAR(10);
    DECLARE v_returnCode   VARCHAR(5);
    DECLARE v_returnMsg    VARCHAR(255);
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
    
    IF ( p_userId IS NULL ) THEN
           
        SET v_returnCode = 'E';
        SET v_returnMsg = 'Input Parameter'; 
    END IF;   
    
    
    IF v_returnCode = 'S' THEN
    
         SELECT user_code
               ,user_name
               ,user_email
         INTO   v_user_code
               ,v_user_name
               ,v_user_email
         FROM   word_user_tbl
         WHERE user_id = p_userId;
         
         IF v_user_code IS NULL THEN     
         
            SET v_returnCode = 'E';
            SET v_returnMsg = 'Invalid User ID'; 
        END IF;   
    END IF;   
    IF v_returnCode = 'S' THEN
    
        SET x_userCode = v_user_code;
        SET x_userName = v_user_name;
        SET x_userEmail = v_user_email;
        
        SET x_returnCode = v_returnCode;
        SET x_returnMsg = CONCAT('Login-',v_returnMsg); 
        
     ELSE
        SET x_userCode = NULL;
        SET x_userName = NULL;
        SET x_userEmail = NULL;
        SET x_returnCode = 'E';
        SET x_returnMsg = CONCAT('Error-',v_process,'-',v_returnMsg);
        
     END IF;
 
 END
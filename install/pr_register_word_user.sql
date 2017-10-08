DROP PROCEDURE `pr_register_word_user`//
CREATE DEFINER=`cksoonew`@`localhost` PROCEDURE `pr_register_word_user`(
    IN p_userCode    VARCHAR(20),
    IN p_userPwd     VARCHAR(20),
    IN p_confirmPwd  VARCHAR(20),
    IN p_userName    VARCHAR(50),
    IN p_userEmail   VARCHAR(50),
    OUT x_returnCode VARCHAR(5),
    OUT x_returnMsg  VARCHAR (255) )
BEGIN
DECLARE v_process      VARCHAR(10);
DECLARE v_returnCode   VARCHAR(5);
DECLARE v_returnMsg    VARCHAR(255);
DECLARE v_check_count  INT DEFAULT 0;
DECLARE v_user_id INT DEFAULT 0;
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
   OR ( p_userPwd IS NULL )
   OR ( p_confirmPwd IS NULL ) THEN
    SET v_returnCode = 'E';
    SET v_returnMsg = 'Invalid User Info';  
        
 END IF;
 SET v_process = '200';
 IF v_returnCode = 'S' THEN
   
     SELECT COUNT(*)
     INTO v_check_count
     FROM word_user_tbl
     WHERE UPPER(user_code) = UPPER(p_userCode);
     
     IF v_check_count > 0 THEN
        SET v_returnCode = 'E';
        SET v_returnMsg = 'User - Already Exists';  
     
    END IF;
 END IF;
IF v_returnCode = 'S' THEN
    IF LENGTH(p_userCode) < 5 THEN
        SET v_returnCode = 'E';
        SET v_returnMsg = 'Invalid Usercode ( 5 digit )';  
    END IF;
 END IF;
 SET v_process = '300';
 IF v_returnCode = 'S' THEN
    IF LENGTH(p_userPwd) < 5 THEN
        SET v_returnCode = 'E';
        SET v_returnMsg = 'Invalid Password ( 5 digit )';  
    ELSEIF p_userPwd <> p_confirmPwd THEN
        SET x_returnCode = 'E';
        SET x_returnMsg = 'Invalid Password ( Password unmatch  )';  
    
    END IF;
 END IF;
 SET v_process = '400';
    
 IF v_returnCode = 'S' THEN
   
    
    
    
    INSERT INTO word_user_tbl
    (user_code
     ,user_pwd
     ,user_name
     ,user_email)
     VALUES
     (p_userCode
      ,HEX(AES_ENCRYPT(p_userPwd, 'starwars'))
      ,p_userName
      ,p_userEmail);
  END IF; 
 
 IF v_returnCode = 'S' THEN
    COMMIT;
    SET x_returnCode = v_returnCode;
    SET x_returnMsg = CONCAT('User Register-',v_returnMsg); 
 ELSE
    SET x_returnCode = 'E';
    SET x_returnMsg = CONCAT('Error-',v_process,'-',v_returnMsg);
    ROLLBACK;
 END IF;
 
 END

DROP PROCEDURE `pr_auto_login_word_user`//
CREATE DEFINER=`cksoonew`@`localhost` PROCEDURE `pr_auto_login_word_user`(
    IN  p_userCode   VARCHAR(255),
    IN  p_userPwd    VARCHAR(255),
    OUT x_userId     INT,
    OUT x_userMode   VARCHAR(5),
    OUT x_returnCode VARCHAR(5),
     OUT x_returnMsg  VARCHAR (255) )
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
      
     SET v_user_id = last_insert_id(); 
     
     UPDATE word_user_tbl
     SET user_code = 10000+v_user_id
     WHERE user_id = v_user_id;
     
    IF v_returnCode = 'S' THEN
        SET x_userId = v_user_id;
        SET x_userMode = v_user_mode;
        SET x_returnCode = v_returnCode;
        SET x_returnMsg = CONCAT('Login-',v_returnMsg); 
        COMMIT;
     ELSE
        SET x_returnCode = 'E';
        SET x_returnMsg = CONCAT('Error-',v_process,'-',v_returnMsg);
        ROLLBACK;
     END IF;
 
 END

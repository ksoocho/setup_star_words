DROP PROCEDURE `pr_reset_word_password`//
CREATE DEFINER=`cksoonew`@`localhost` PROCEDURE `pr_reset_word_password`(
    IN p_userCode VARCHAR(255),
    IN p_userPwd VARCHAR(255),
    IN p_newUserPwd VARCHAR(255),
    OUT x_returnCode VARCHAR(5),
    OUT x_returnMsg  VARCHAR (255) )
BEGIN
 
 DECLARE check_count INT DEFAULT 0;
 
 SELECT COUNT(*)
 INTO   check_count
 FROM word_user_tbl
 WHERE user_code = p_userCode
 AND   user_pwd = p_userPwd;
 
 IF check_count > 0 THEN
 
    IF LENGTH(p_newUserPwd) < 8 THEN
        SET x_returnCode = 'E';
        SET x_returnMsg = 'Password length  - 8 digit';  
    
    ELSE
 
        UPDATE word_user_tbl
        SET user_pwd = p_newUserPwd
        WHERE user_code = p_userCode;
        
        SET x_returnCode = 'S';
        SET x_returnMsg = 'Password Reset Success';
    END IF;
    
 ELSE
 
      SET x_returnCode = 'E';
    SET x_returnMsg = 'Password Reset Fail';  
    
 END IF; 
 IF x_returnCode = 'S' THEN
    COMMIT;
 END IF;
 
 END

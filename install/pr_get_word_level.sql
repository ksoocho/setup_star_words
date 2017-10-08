DROP PROCEDURE `pr_get_word_level`//
CREATE DEFINER=`cksoonew`@`localhost` PROCEDURE `pr_get_word_level`(
    IN   p_wordLevel      VARCHAR(5),
    OUT  x_levelTitle     VARCHAR(100),
    OUT  x_originLanguage VARCHAR(20),
    OUT  x_wordLanguage   VARCHAR(20),
    OUT  x_userCount      INT,
    OUT  x_returnCode     VARCHAR(5),
    OUT  x_returnMsg      VARCHAR (255) )
BEGIN
 
    DECLARE  v_level_title      VARCHAR(100);
    DECLARE  v_origin_language  VARCHAR(50);
    DECLARE  v_word_language    VARCHAR(50);
    DECLARE  v_user_count       INT;
    
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
    
    IF ( p_wordLevel  IS NULL ) THEN
           
        SET v_returnCode = 'E';
        SET v_returnMsg = 'Input Parameter'; 
    END IF;   
    
    SET v_process = '200';
    
    IF v_returnCode = 'S' THEN
    
         SELECT level_title
               ,origin_language
               ,word_language
               ,user_count
         INTO   v_level_title
               ,v_origin_language
               ,v_word_language
               ,v_user_count
         FROM   word_level_tbl
         WHERE word_level = p_wordLevel;
         
         IF v_level_title IS NULL THEN     
         
            SET v_returnCode = 'E';
            SET v_returnMsg = 'Invalid Word Level'; 

        END IF;   

    END IF;   

    SET v_process = '300';

    IF v_returnCode = 'S' THEN
    
        SET x_levelTitle = v_level_title;
        SET x_originLanguage = v_origin_language;
        SET x_wordLanguage = v_word_language;
        SET x_userCount = v_user_count;
        
        SET x_returnCode = v_returnCode;
        SET x_returnMsg = CONCAT('Login-',v_returnMsg); 
        
     ELSE
        SET x_levelTitle = NULL;
        SET x_originLanguage = NULL;
        SET x_wordLanguage = NULL;
        SET x_userCount = NULL;
        SET x_returnCode = 'E';
        SET x_returnMsg = CONCAT('Error-',v_process,'-',v_returnMsg);
        
     END IF;
 
 END

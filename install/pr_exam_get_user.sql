DROP PROCEDURE `pr_exam_get_user`//
CREATE DEFINER=`cksoonew`@`localhost` PROCEDURE `pr_exam_get_user`(
IN  p_user_id    INT,
OUT x_user_code  VARCHAR(100),
OUT x_user_name VARCHAR(100)
)
BEGIN
SELECT user_code
     , user_name
INTO   x_user_code
     , x_user_name
FROM word_user_tbl
WHERE user_id = p_user_id;
END

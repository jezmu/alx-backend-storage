-- Average weighted score for all!
DROP PROCEDURE IF EXISTS ComputeAverageWeightedScoreForUsers;
DROP VIEW IF EXISTS students_and_weights;

CREATE VIEW students_and_weights AS SELECT c.user_id, c.project_id, c.score, p.weight
FROM corrections c JOIN projects p ON (c.project_id = p.id);

DELIMITER |
CREATE PROCEDURE ComputeAverageWeightedScoreForUsers ()

  BEGIN

    DECLARE i INT DEFAULT 0;
    SET @total_items = (SELECT sum(p.weight) FROM projects p);
    SET @students = (SELECT COUNT(*) FROM students_and_weights);
    SET i = 0;
    SET @last_user = (SELECT user_id FROM students_and_weights LIMIT 1);
    SET @final_score = 0;

    WHILE i < @students DO

      CREATE TEMPORARY TABLE new_tbl SELECT * FROM students_and_weights LIMIT i, 1;
	  SET @current_user = (SELECT user_id FROM new_tbl);

	  IF @last_user != @current_user
      	    THEN
	      SET @last_user = @current_user;
	      SET @final_score = 0;
    	  END IF ;

	  SET @nota = (SELECT weight FROM new_tbl) / @total_items;
	  SET @factor = (SELECT score FROM new_tbl) * @nota;
	  SET @final_score = @final_score + @factor;
	  UPDATE users SET average_score = @final_score WHERE id = (SELECT user_id FROM new_tbl);

	  SET i = i + 1;
	  DROP TEMPORARY TABLE IF EXISTS new_tbl;

    END WHILE;
    DROP VIEW IF EXISTS students_and_weights;

  END;
|
DELIMITER ;

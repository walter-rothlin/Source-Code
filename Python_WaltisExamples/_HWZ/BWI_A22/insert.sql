
  SET FOREIGN_KEY_CHECKS = 0;
  

    -- -------------------------------
    -- SELECT * FROM `country` WHERE `country` = 'Algeria';   --> 1 records found
    -- Extracted at: 2024-06-04 19:17:29
    INSERT INTO `country` (`country_id`, `country`, `last_update`) VALUES
        (2, 'Algeria', STR_TO_DATE('2006-02-15 04:44:00', '%Y-%m-%d %H:%i:%s'));
      
  

    -- -------------------------------
    -- SELECT * FROM `language`;   --> 7 records found
    -- Extracted at: 2024-06-04 19:17:29
    INSERT INTO `language` (`language_id`, `name`, `last_update`) VALUES
        (1, 'English', STR_TO_DATE('2006-02-15 05:02:19', '%Y-%m-%d %H:%i:%s')),
        (2, 'Italian', STR_TO_DATE('2006-02-15 05:02:19', '%Y-%m-%d %H:%i:%s')),
        (3, 'Japanese', STR_TO_DATE('2006-02-15 05:02:19', '%Y-%m-%d %H:%i:%s')),
        (4, 'Mandarin', STR_TO_DATE('2006-02-15 05:02:19', '%Y-%m-%d %H:%i:%s')),
        (5, 'French', STR_TO_DATE('2006-02-15 05:02:19', '%Y-%m-%d %H:%i:%s')),
        (6, 'German', STR_TO_DATE('2006-02-15 05:02:19', '%Y-%m-%d %H:%i:%s')),
        (7, 'Schweizerdeutsch', STR_TO_DATE('2024-04-11 10:44:02', '%Y-%m-%d %H:%i:%s'));
      
  

    -- -------------------------------
    -- SELECT * FROM `film` WHERE `title` LIKE 'AC%';   --> 2 records found
    -- Extracted at: 2024-06-04 19:17:29
    INSERT INTO `film` (`film_id`, `title`, `description`, `release_year`, `language_id`, `original_language_id`, `rental_duration`, `rental_rate`, `length`, `replacement_cost`, `rating`, `special_features`, `last_update`) VALUES
        (1, 'ACADEMY DINOSAUR', 'A Epic Drama of a Feminist And a Mad Scientist who must Battle a Teacher in The Canadian Rockies', 2006, 1, 1, 6, 0.99, 86, 20.99, 'PG', 'Deleted Scenes,Behind the Scenes', STR_TO_DATE('2024-04-09 15:28:56', '%Y-%m-%d %H:%i:%s')),
        (2, 'ACE GOLDFINGER', 'A Astounding Epistle of a Database Administrator And a Explorer who must Find a Car in Ancient China', 2006, 1, 1, 3, 4.99, 48, 12.99, 'G', 'Deleted Scenes,Trailers', STR_TO_DATE('2024-04-09 15:28:56', '%Y-%m-%d %H:%i:%s'));
      
  
  SET FOREIGN_KEY_CHECKS = 1;
  
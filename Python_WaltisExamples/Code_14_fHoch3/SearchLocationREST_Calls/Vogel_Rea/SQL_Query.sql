-- Neues Schema kreieren
DROP SCHEMA IF EXISTS `MySearch`;
CREATE SCHEMA IF NOT EXISTS `MySearch` DEFAULT CHARACTER SET utf8;

-- Als default Schema setzen
SELECT SLEEP(1);  -- wait 1 sec, just to give a chance to set schema as default
USE `MySearch`;

DROP TABLE IF EXISTS searchlist;
CREATE TABLE IF NOT EXISTS searchlist (
  recNr 		int(11)     NOT NULL AUTO_INCREMENT,
  type			varchar(10),
  name			varchar(50),
  firstname		varchar(25),
  street		varchar(50),
  streetNr		double      NOT NULL DEFAULT 0,
  telNr			varchar(15),
  zip			int(4)      NOT NULL DEFAULT 0,
  PRIMARY KEY (recNr)
);

INSERT INTO `searchlist` VALUES
         (1, 'Person', 'Vogel', 'Roland', 'Gartenstrasse', 11, '+41447501634', 8102),
         (2, 'Person', 'Rothlin', 'Walter', 'Peterliwiese', 33, '+41554601440', 8855),
         (3, 'Person', 'Heinemann', 'Antonietta', 'Promenadenstrasse', 35, '+41318395138', 3076);

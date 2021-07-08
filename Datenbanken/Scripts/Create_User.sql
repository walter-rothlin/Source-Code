-- ---------------------------------------------------------------------------------------------
-- Create_User.sql
-- ---------------------------------------------------------------------------------------------
--
-- Autor: Walter Rothlin
-- Description: Kreiert einen Benutzer und vergibt Rechte
--
-- History:
-- 16-Jun-2021   Walter Rothlin      Initial Version
-- ---------------------------------------------------------------------------------------------

CREATE USER 'peter'@'localhost' IDENTIFIED BY 'password';

GRANT ALL PRIVILEGES ON *.* TO 'peter'@'localhost';

CREATE USER 'peter'@'fqdn' IDENTIFIED BY 'password';

GRANT ALL PRIVILEGES ON *.* TO 'peter'@'fqdn';

CREATE USER 'peter'@'%' IDENTIFIED BY 'password';

GRANT ALL PRIVILEGES ON *.* TO 'peter'@'%';

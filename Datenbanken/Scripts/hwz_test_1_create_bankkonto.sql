DROP TABLE IF EXISTS bankkonto;

CREATE TABLE bankkonto (
  id_bankkonto int(11) NOT NULL AUTO_INCREMENT,
  saldo double NOT NULL DEFAULT '0',
  PRIMARY KEY (id_bankkonto)
) AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;


INSERT INTO `bankkonto` VALUES (1,1000),(2,35050),(3,200),(4,36000),(5,9);
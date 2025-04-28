-- ---------------------------------------------------------------------------------
-- Autor: Walter Rothlin
-- Description: Lädt Testdaten 
--
-- History:
-- 28-Apr-2025   Walter Rothlin      Initial Version
-- ---------------------------------------------------------------------------------

SET FOREIGN_KEY_CHECKS = 0;

INSERT INTO `personen_liste` (`ID`, `Anrede`, `Vorname`, `Nachname`, `Strasse`, `PLZ_Ort`, `Tel_Nr`, `eMail`) VALUES
   (60, 'Herr', 'Walter', 'Rothlin', 'Mövenstr. 12', '8855 Wangen', '', ''),
   (61, 'Herr', 'Max', 'Meier', 'Tschuopistr. 6a', '8852 Altendorf', '', ''),
   (63, 'Frau', 'Claudia', 'Collet', 'Rössliwiese 8', '8854 Siebnen', '055  440 40 13', 'claudia@bluewin.ch'),
   (64, 'Herr', 'Kurt', 'Müller', 'Hauhusengasse 50', '8855 Wangen', '079  751 14 26', ''),
   (66, 'Herr', 'Fritz', 'Bruhin', 'Seidenstr. 22e', '8853 Lachen', '', ''),
   (67, 'Herr', 'Hans', 'Muster', 'Mühlestr. 18', '8855 Wangen', '055  440 37 65', 'muster_hans@gmx.ch'),
   (68, 'Herr', 'Tobias', 'Rothlin', 'Bruggholzstr. 3', '8855 Wangen', '', ''),
   (69, 'Frau', 'Barbara', 'Schnellmann', 'Nuolerstr. 22', '8855 Nuolen', '055  440 51 84', 'bnabsi@bluewin.ch'),
   (70, 'Frau', 'Klara', 'Vogt', 'Wiesenweg 11', '8854 Siebnen', '', ''),
   (71, 'Herr', 'Christof', 'Vogt', 'Peterliwiese 38', '8855 Wangen', '055  440 68 00', 'c.Vogt@bluewin.ch');

SET FOREIGN_KEY_CHECKS = 1;
                
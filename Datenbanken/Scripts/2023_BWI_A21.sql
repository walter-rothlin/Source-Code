-- ---------------------------------------------------------------------------------------------
-- 2023_BWI_A21.sql
-- ---------------------------------------------------------------------------------------------
--
-- Autor: Walter Rothlin
-- Description: Aufgaben und Loesungen zu DML
--
-- History:
-- 04-Apr-2023   Walter Rothlin      Initial Version (Select)
-- ---------------------------------------------------------------------------------------------



-- Select mit Order by, Where-Clauses and Group by
-- ===============================================
-- 1.1) Von welchen Schauspielern (Vorname und Nachname) hat der Store Filme?






-- 1.2) Beschrifte die Resultat-Tabelle von 1.1 mit Vorname und Nachname als Spalten-Header






-- 1.3) Sortiert die Resultat-Tabelle von 1.2 nach Nachname, Vorname


















-- 1.4) Liste alle Schauspieler-Nachnamen sortiert auf








-- 1.5) Liste alle Schauspieler-Nachnamen auf (jeder Nachname aber nur einmal)






-- 1.6) Von wie vielen Schauspieler hat es DVD im Store?















-- 1.7) Wieviele verschiedene Nachnamen gibt es bei den Schauspielern








-- 1.8) Liste alle Schauspielern (Vorname und Nachname) auf, welche Kirsten zum Vornamen heissen? Sortiere diese
--      nach Nachnamen absteigend (Z..A) und nach Vorname aufsteigend (A..Z)











-- 1.9) Liste alle Schauspielern (Vorname und Nachname) auf, welche NICK zum Vornamen heissen oder ein SS im Vornamen haben oder deren Vorname genau 4 Buchstaben lang ist.
--      Sortiert nach first_name und last_name


























-- 1.10) Liste alle Schauspielern (Vorname und Nachname) auf, 
--       bei welchen der Nachname mit BER beginnt oder deren Vorname 
--       mit NA endet
-- https://dev.mysql.com/doc/refman/5.7/en/regexp.html










-- 1.11) Liste film_id, title, rating, special_features von der Tabelle film 
--       auf. Was ist der Type der Attribute rating und special_features?


























-- 1.11.1) Liste film_id, title, rating, special_features von der Tabelle film 
--       auf. Filtern Sie wo rating PG und special_features Trailers oder special_features sind?












-- 1.12) Erstellen Sie eine Liste der bezahlten Betraege (FROM payment), 
--       sortiert nach Betraege









-- 1.12.1) Erstellen Sie eine Liste (mit Vor- und Nachnamen) der bezahlten 
--         Betraege (FROM payment), sortiert nach Betraege   











-- 1.13) Erstellen Sie eine Liste aller Kunden_id mit deren Umsaetzen 
--       und Anzahl Rechnungen (FROM payment), sortiert nach customer_id und Betraege   








-- 1.13.1) Erstellen Sie eine Liste aller Kunden_id, Vor- und Nachnamen 
-- mit deren Umsaetzen und Anzahl Rechnungen (FROM payment), 
-- sortiert nach Umsaetzen (hoechster zu oberst).
-- Wer sind unsere 'besten' (umsatzstaerksten) Kunden












-- 1.13.2) Erstellen Sie eine Liste Kunden_id, Vor- und Nachnamen mit 
--         deren Umsaetzen (FROM payment), ordnen Sie die Liste nach den 
--         Umsaetzen (Bester Kunde zuoberst)
--         Nur von den Kunden mit ID < 5













-- 1.13.3) Erstellen Sie eine Liste mit Kunden_id mit deren Umsaetzen (FROM payment),
--       ordnen Sie die Liste nach den Umsaetzen (Bester Kunde zuoberst)
--       Nur von den Kunden mit einem Umsatz > 170













-- 1.13.4) Erstellen Sie eine Liste Kunden_id, Vor- und Nachnamen mit 
--         deren Umsaetzen (FROM payment), ordnen Sie die Liste nach den 
--         Umsaetzen (Bester Kunde zuoberst)
--         Nur von den Kunden mit einem Umsatz > 170



















-- 1.14.1) Erstellen Sie eine Listen mit allen Staedten und die dazugehoerenden Laender.




















-- Date_Format() Str_To_Date()
-- ===========================
-- https://dev.mysql.com/doc/refman/5.7/en/date-and-time-functions.html
--
-- %a     Abbreviated weekday name (Sun..Sat)
-- %b     Abbreviated month name (Jan..Dec)
-- %c     Month, numeric (0..12)
-- %D     Day of the month with English suffix (0th, 1st, 2nd, 3rd, â€¦)
-- %d     Day of the month, numeric (00..31)
-- %e     Day of the month, numeric (0..31)
-- %f     Microseconds (000000..999999)
-- %H     Hour (00..23)
-- %h     Hour (01..12)
-- %I     Hour (01..12)
-- %i     Minutes, numeric (00..59)
-- %j     Day of year (001..366)
-- %k     Hour (0..23)
-- %l     Hour (1..12)
-- %M     Month name (January..December)
-- %m     Month, numeric (00..12)
-- %p     AM or PM
-- %r     Time, 12-hour (hh:mm:ss followed by AM or PM)
-- %S     Seconds (00..59)
-- %s     Seconds (00..59)
-- %T     Time, 24-hour (hh:mm:ss)
-- %U     Week (00..53), where Sunday is the first day of the week; WEEK() mode 0
-- %u     Week (00..53), where Monday is the first day of the week; WEEK() mode 1
-- %V     Week (01..53), where Sunday is the first day of the week; WEEK() mode 2; used with %X
-- %v     Week (01..53), where Monday is the first day of the week; WEEK() mode 3; used with %x
-- %W     Weekday name (Sunday..Saturday)
-- %w     Day of the week (0=Sunday..6=Saturday)
-- %X     Year for the week where Sunday is the first day of the week, numeric, four digits; used with %V
-- %x     Year for the week, where Monday is the first day of the week, numeric, four digits; used with %v
-- %Y     Year, numeric, four digits
-- %y     Year, numeric (two digits)
-- %%     A literal % character
--

-- 2.1.1.0 Testen und analysieren Sie folgende Statements:

-- SELECT STR_TO_DATE('01,5,2013','%d,%m,%Y');
--  SELECT
--	language_id AS ID,
--    `name` AS Sprache,
--    last_update AS Last_Update,
--    DATE_FORMAT(last_update,'%d.%m.%Y %T') AS `Changed on`,
--	DATE_FORMAT(last_update,'%M') AS `Changed in Month`,
--    DATE_FORMAT(STR_TO_DATE('17.03.2023','%d.%m.%Y'),'%d.%m.%Y %T') AS `17.3.2023`,
--    DATE_FORMAT(NOW() ,'%d.%m.%Y %T') AS today,
--    DATE_FORMAT(last_update,'%d.%m.%Y') AS last_Update_Day
-- FROM language
-- -- WHERE DATE_FORMAT(last_update,'%d.%m.%Y') = DATE_FORMAT(STR_TO_DATE('17.03.2023','%d.%m.%Y'),'%d.%m.%Y')
-- WHERE DATE_FORMAT(last_update,'%d.%m.%Y') = DATE_FORMAT(NOW(),'%d.%m.%Y')
-- ORDER BY last_update DESC;


-- 2.1.1) liste alle Mitarbeiter (staff) mit (Vorname, Nachname und LAST_UPDATE im format [yyyy-mon-dd hh:mm:ss]) auf, 
--        sowie den entsprechenden Wochentag,
--        wann die Daten-Saetze geaendert wurden. Sortiere nach Aenderungs-Datum.









-- andere Variante    










-- 2.1.2) Suchen Sie in actor nach Eintraegen, welche am 15.2.2006 geaendert wurden. 
--        Verwenden Sie STR_TO_DATE in where clause (Effizienter als mit DATE_FORMAT!)
--        last_update e.g. 2006-02-15 03:57:16 --> 2006-February-15 and Wednesday











-- 2.1.2.1) last_update e.g. 2006-02-15 03:57:16 --> 3 AM Uhr 57


-- 2.1.2.2) last_update e.g. 2006-02-15 03:57:16 --> 3 Uhr 57


-- 2.1.2.3) last_update e.g. 2006-02-15 03:57:16 --> Treffpunkt: Wednesday 03:57 am See


-- 2.1.2.4) last_update e.g. 2006-02-15 03:57:16 --> 20060215035716


-- 2.1.2.5) last_update e.g. 2006-02-15 03:57:16 --> 20060215--035716


-- 2.1.2.6) last_update e.g. 2006-02-15 03:57:16 --> 03:57:16 AM



-- 2.1.2.7) last_update e.g. 2006-02-15 03:57:16 --> 03-57 AM



-- 2.1.3) Machen Sie einen neue Eintraege in der staff Tabelle mit ihren Angaben.
-- ------------------------------------------------------------------------------
--        Erstellen Sie weiter ein SQL fuer einen Update und Delete dieses Tabelle / Eintrages
--        und testen Sie ihre Loesungen



-- 2.1.3.1) SELECT staff_id, first_name, last_name,DATE_FORMAT(last_update) im Date-Format e.g.: Wed, 15.Feb 2006 03-57-16
--          Sortiere nach Aenderungs-Datum.









-- 2.1.3.2) SELECT staff_id, first_name, last_name,DATE_FORMAT(last_update) im Date-Format e.g.: 2006-February-15
--          Filtere nach einem bestimmten Aenderungs-Datum. Sortiere nach Aenderungs-Datum.
--          Verwenden Sie DATE_FORMAT in where clause (Nicht so effizient! Wieso?)












-- 2.1.3.3) SELECT staff_id, first_name, last_name,DATE_FORMAT(last_update) im Date-Format e.g.: Wed, 15.Feb 2006 03-57-16
--          Filtere nach einem bestimmten Aenderungs-Datum. Sortiere nach Aenderungs-Datum.
--          Verwenden Sie STR_TO_DATE() in where clause (Effizienter! Wieso?)











-- 2.1.3.4) Suchen Sie alle Eintraege in der Tabelle staff, welche am 17. Maerz 22 geaendert wurden




-- 2.1.3.5) Fuegen sie zwei neuen Daten-Saetze hinzug und definieren Sie den PK 200, 201
--          und ueberpruefe mit den SELECTS das Resultat (checken sie last_update)







-- 2.1.3.6) Fuegen sie zwei neuen Daten-Saetze hinzug und definieren Sie den PK 50, 51 und setze das last_update Datum auf
--          '18.03.2022 00:00:00' und '18.03.2022 00:00:01'
--          und ueberpruefe mit den SELECTS das Resultat  (checken sie last_update)







-- 2.1.3.7) Updaten Sie den Datensatz mit PK 201 mit folgenden Werten:
--           first_name = 'Hans',
--           email      = 'Hans@meier.ch',
--           username   = 'hans.meier',
--           Setze das last_update nicht explizit
--          Ueberpruefe mit den SELECTS das Resultat







-- 2.1.3.8) Loeschen Sie die Datensaetze mit PK 200, 201, 50, 51 aus der staff Tabelle.



-- 2.1.4) Listen Sie alle Eintraege in der Tabelle staff auf. last_update e.g. 15.02.2006 15Uhr 57'



-- 2.1.5) Listen Sie alle Eintraege in der Tabelle staff auf. last_update e.g. 15.02.2006 15Uhr 57'



-- 2.1.6) Listen Sie alle Eintraege in der Tabelle staff auf. last_update e.g. 15.02.2006 15Uhr 57'
--        Welche nach dem 17.3.2022 00:00:00 geaendert wurden
--        Verwende den > Operator




-- 2.1.7) Listen Sie alle Eintraege in der Tabelle staff auf. last_update e.g. 15.02.2006 15Uhr 57'
--        Welche nach dem 17.3.2022 00:00:00 geaendert wurden
--        Verwende den = Operator und analysiere, wieso dies nicht funktioniert!



-- 2.1.8) Suchen Sie alle Eintraege in der Tabelle staff, welche nach 10 Uhr am 17. Maerz 22 geaendert wurden



-- 2.1.9) NOW(), CURTIME()




-- 2.1.9) ADDDATE(), DATE_ADD(), ADDTIME(), PERIODE_ADD











-- 2.1.10) DATEDIFF(), DATE_SUB(), SUBTIME(), PERIOD_DIFF, TIMEDIFF()




-- 2.1.10.1) Wie alt (in Tagen) sind Sie heute?       


-- 2.1.10.2) An welchem Datum sind/waren Sie 10000 Tage alt?       


-- 2.1.10.3) An welchem Datum sind/waren Sie 25000 Tage alt?       


-- 2.1.10.4) In wievielen Tagen sind Sie 25000 Tage alt?


-- 2.1.11) GET_FORMAT()














-- 2.1.12) LAST_DAY()





-- 2.1.13) Vor wievielen Tagen wurden die Eintraege geaendert? 
--         Sortiert das kuerzlich geaenderte zu erst!       













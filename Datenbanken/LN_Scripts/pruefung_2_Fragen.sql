-- ---------------------------------------------------------------------------------
-- Autor: Walter Rothlin
-- Description: Aufgaben und Fragen zu Prüfung 2 
--
-- History:
-- 24-Apr-2025   Walter Rothlin      Initial Version
-- 28-Apr-2025   Walter Rothlin      Removed answers
-- ---------------------------------------------------------------------------------
-- Normalisieren Sie die personen_liste und erstellen Sie hier ein Migrations-Script.
--
-- Gehen Sie in folgenden Schritten vor:
-- 1) Sammeln Sie zuerst einige Informationen über die bestehenden Daten,
--    welche später bei der Test-Driven Entwicklung zum Verifizieren gebraucht werden 
--    können.
-- 1.1) Wie viele Datensätze hat es in personen_liste 
--      (SQL-Statmwent und als Kommentar die effektive Anzahl)?

-- 1.2) Wie viele Personen leben in 8855 Wangen 
--      (SQL-Statmwent und als Kommentar die effektive Anzahl)?

-- 1.3) Wie viele verschiedene PLZ_Ort gibt es in der Tabelle (Not Null) 
--      (SQL-Statmwent und als Kommentar die effektive Anzahl)?



-- 2) Bevor Sie mit der Normalisierung beginnen, stellen Sie sicher, dass für Apps/Personen,
--    welche auf personen_liste zugreifen nichts davon merken.
-- 2.1) Renamen Sie personen_liste zu personen.

-- 2.2) Erstellen Sie eine view personen_liste mit den gleichen Attributen.

-- 2.3) Lassen Sie die Test-SELECTs von 1) nochmals laufen und sie sollten genau die gleichen Anzahlen bekommen.


-- 3) Normalisierung 1: Aufteilen der Strassenbezeichnung und der Hausnummer.
-- 3.1) Fügen Sie in der Tabelle ein weiteres Attribut nach dem Attribut Strasse hinzu: Hausnr VARCHAR(100) NULL hinzu

-- 3.2) Splitten Sie die Strasse in Strassenbezeichnung und Hausnummer.

-- 3.3) Passen Sie die Implementation der view personen_liste entsprechend an, so das in Strasse 
--      wieder die Strassenbezeichnung und die Hausnummer erscheint.


-- 4) Normalisierung 2: Auslagern der PLZ_Ort in eine seperate Tabelle.
-- 4.1) Erstellen Sie eine neue Tabelle Orte mit den Attributten PLZ und Ortsname
    
-- 4.2) Lagern Sie alle Orte und PLZ von der personen Tabelle in Orte aus.
    
-- 4.3) Fügen Sie ein FK zu Orte in personen nach dem attribut PLZ_Ort ein.

-- 4.5) Erweitern Sie die View durch einen Join mit orte.
--      Renamen Sie PLZ_Ort in Personen_liste zu PLZ_Ort_old.
--      PLZ_Ort ist nun das Attribut über den Join

-- 4.6) Entwickeln Sie ein SELECT welches alle Personen zurück gibt, bei dem PLZ_Ort_old <> PLZ_Ort ist.

-- 4.7) Falls SELECT von vorheriger Aufgabe keine Fehler-Tuples zurück gibt, ist die Migration o.k. und Sie können 
--      die aus der View PLZ_Ort_old auskommentieren.

-- 4.8) Löschen sie PLZ_Ort in personen und fügen Sie noch 
--      einen Foreign-Key Contraint auf Orte_FK hinzu.
    
-- 5) Final checks for the migration. Kopieren Sie die 3 Statements der Aufgabe 1 und führen Sie diese nochmals aus 
--    und schreiben die Resultate als Kommentar hin. Vergleichen Sie die Zahlen mit Aufgabe 1.
-- 5.1) Wie viele Datensätze hat es in personen_liste?

-- 5.2) Wie viele Personen leben in 8855 Wangen?

-- 5.3) Wie viele verschiedene PLZ_Ort gibt es in der Tabelle (Not Null)?

    

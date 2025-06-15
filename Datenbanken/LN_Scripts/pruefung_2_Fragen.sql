-- ---------------------------------------------------------------------------------
-- Autor: Walter Rothlin
-- Description: Aufgaben und Fragen zu Prüfung 2 
--
-- History:
-- 24-Apr-2025   Walter Rothlin      Initial Version
-- 08-Jun-2025   Walter Rothlin      Added automated testing
-- 15-Jun-2025   Walter Rothlin      Changed it for BWI-A23
-- ---------------------------------------------------------------------------------


SET @Candidate_Firstname  := 'Walter';    -- Durch ihren Vornamen ersetzen
SET @Candidate_Name       := 'Rothlin';   -- Durch ihren Namen ersetzen
SET @Class                := 'BWI-A23';   -- z.B. TI24_BLe_BMa oder BWI-A23


SET @Test_Name            := 'DB_Prüfung_2c';  -- NICHT ändern
SET @Test_Max_Punkte      := 16;               -- NICHT ändern

-- ---------------------------------------------------------------------------------
-- Normalisieren Sie die "personen_liste" und erstellen Sie hier ein re-runable Migrations-Script.
--
-- Gehen Sie in folgenden Schritten vor (Test-Driven approach):




-- 1) Testdaten sammeln
-- ====================
-- Sammeln Sie zuerst einige Informationen über die bestehenden Daten,
-- welche später bei der Test-Driven Entwicklung zum Verifizieren gebraucht werden 
-- können.

-- 1.1) Wie viele Datensätze hat es in "personen_liste" 
--      (SQL-Statement und als Kommentar die effektive Anzahl)?


-- 1.2) Wie viele Personen leben in 8855 Wangen 
--      (SQL-Statment und als Kommentar die effektive Anzahl)?


-- 1.3) Wie viele verschiedene PLZ_Ort gibt es in der Tabelle (Not Null) 
--      (SQL-Statmwent und als Kommentar die effektive Anzahl)?





-- 2) Entkoppeln der Rohdaten zu den Benutzern und Applikationen
-- =============================================================
-- Bevor Sie mit der Normalisierung beginnen, stellen Sie sicher, dass für Apps/Personen,
-- welche auf "personen_liste" zugreifen nichts davon merken (Abwärtskompatible).

-- 2.1) Renamen Sie "personen_liste" zu personen.


-- 2.2) Erstellen Sie eine view "personen_liste" mit den gleichen Attributen. In der Folge wird dieses Interface
--      nicht mehr geändert, lediglich die Implemenation der View wird angepasst.  


-- 2.3) Verifizieren: Lassen Sie die Test-SELECTs von 1) nochmals laufen und sie sollten genau die gleichen Anzahlen bekommen.




-- 3) Normalisieren I
-- ==================
-- Beim analysieren der Daten stellen Sie fest, dass das Attribute "Strasse" zwei Informations-Elemente enthalten. 
-- Teilen Sie das auf Strassenbezeichnung und der Hausnummer.

-- 3.1) Fügen Sie in der Tabelle ein weiteres Attribut nach dem Attribut Strasse hinzu: "Hausnummer" hinzu

    
-- 3.2) Splitten Sie die "Strasse" in "Strassenname" und "Hausnummer".

-- Straße und Hausnummer extrahieren


-- 3.4) Renamen Sie das Attribut "Strasse" zu "Strassenname"
ALTER TABLE `Personen` RENAME COLUMN `Strasse` TO `Strassenname`;

-- 3.5) Passen Sie die Implementation der view personen_liste entsprechend an, so das in Strasse 
--      wieder die Strassenbezeichnung und die Hausnummer erscheint.


-- 4) Normalisieren II
-- ===================
-- Eliminieren Sie Redundanzen in dem Sie Postleitzahl und Ort trennen und in eine seperate
-- Tabelle auslagern.

-- 4.1) Erstellen Sie eine neue Tabelle "Orte" mit den Attributten "PLZ" und "Ortsname"
    
-- 4.2) Lagern Sie alle Orte und PLZ von der "Personen" Tabelle in "Orte" aus.
    
-- 4.3) Fügen Sie ein Foreignkey (FK) mit Name "Orte_FK" in "Personen" nach dem Attribut PLZ_Ort ein.

-- 4.4) Setzen Sie Personen.orte_fk correct.

-- 4.5) Erweitern Sie die View durch einen Join mit orte.
--      Renamen Sie PLZ_Ort in Personen_liste zu PLZ_Ort_old.
--      PLZ_Ort ist nun das Attribut über den Join

-- 4.6) Entwickeln Sie ein SELECT welches alle Personen zurück gibt, bei dem PLZ_Ort_old <> PLZ_Ort ist.

-- 4.7) Falls SELECT von vorheriger Aufgabe keine Fehler-Tuples zurück gibt, ist die Migration o.k. und Sie können 
--      die aus der View PLZ_Ort_old auskommentieren.

-- 4.8) Löschen sie PLZ_Ort in "Personen" und fügen Sie noch 
--      einen Foreign-Key Contraint auf Orte_FK hinzu.

-- FK-Constraints
    
-- 4.9) Verifizieren: Lassen Sie die Test-SELECTs von 1) nochmals laufen und sie sollten genau die gleichen Anzahlen bekommen.
-- 4.9.1) Wie viele Datensätze hat es in personen_liste?

-- 4.9.2) Wie viele Personen leben in 8855 Wangen?

-- 4.9.3) Wie viele verschiedene PLZ_Ort gibt es in der Tabelle (Not Null)?
    
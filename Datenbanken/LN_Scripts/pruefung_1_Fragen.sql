-- Owner: Walter Rothlin
--
-- History:
-- 13-Mar-2025 Walter Rothlin	Initial Version 
-- ---------------------------------------------------------------------------
-- 
-- Wie bei den Uebungen entwickeln Sie für jede Aufgabe ein SQL-Statement, welches die Business Frage beantwortet.

-- 1.1) Wie viele Personen gibt es in der Personen-Tabelle?

-- 1.1.1) Zeige alle Personen (Vorname, Ledig_Name, last_update), welche heute aktualisiert wurden. 
--        Die Spalten sollten als Vorname, Nachname, Letzdes Änderung bezeichnet werden.

-- 1.2) Wieviele Landteile gibt es?


-- 1.3) Wieviele verschiedene Flur_Bezeichnungen gibt es und benennen Sie die Spalte 'Anzahl verschiedene Flure'?


-- 1.4) Welcher Landteil (ID) wurde zuletzt geändert?


-- 1.5.0) Erstellen Sie eine Liste von allen Landteilen mit ID, GENO_Parzellen_Nr, Flur_Bezeichnung, Flaeche_In_Aren, Last_Update
--        den zuletzt geänderten Datensatz zuoberst.

-- Ausschnitt des erwarteten Resultates:
-- ID  | Parzellen_Nr            | Flur_Bezeichnung    | Fläche in Aren | Letzmals geändert   | Aenderungszeit
-- ----+-------------------------+---------------------+----------------+---------------------+---------------
-- 9   | 234.200.1               | Haglen              | 114.0          | 13.03.2025 09:57:33 | 09:57:33      
-- 337 | 293.330.2               | Witi                | 35.0           | 22.02.2025 09:57:47 | 09:57:47      
-- 338 | 293.330.3               | Witi                | 35.0           | 22.02.2025 09:57:47 | 09:57:47      
-- 339 | 293.330.4               | Witi                | 35.0           | 22.02.2025 09:57:47 | 09:57:47      
-- 340 | 293.420x.1              | Hau                 | 502.0          | 22.02.2025 09:57:47 | 09:57:47      
-- 341 | 293.800.1               | Bruggholz           | 100.0          | 22.02.2025 09:57:47 | 09:57:47      
-- 342 | 293.800.2               | Bruggholz           | 16.0           | 22.02.2025 09:57:47 | 09:57:47      



-- 1.5.1) Wieviele Datensätze wurden nach 10:00 geändert.



-- 1.6.0) Erstellen Sie eine Liste mit Flur_Bezeichnungen, Gesamtfläche in Aren und Anzahl_Parzellen
--        sortiert nach Gesamtfläche.

-- Ausschnitt des erwarteten Resultates:
-- Flur_Bezeichnung    | Gesamtfläche in Aren | Anzahl Parzellen
-- --------------------+----------------------+-----------------
-- Seeplatz            | 3202.0               | 19              
-- Hau                 | 2299.0               | 29              
-- Hinterer Wald       | 1929.0               | 21              
-- Streue              | 1345.0               | 24              
-- Winkelhöfli         | 1187.0               | 34              
-- Witi                | 1157.0               | 23              


-- 1.6.2) Wie gross ist die Gesamtfläche des grössten Flures?  (Mit einem SELECT-Statement)


-- 1.6.3) Wie heisst der Flur mit der grössten Gesamtfläche?  (Mit einem SELECT-Statement)


-- 1.6.4) Aus wievielen Parzellen besteht der grössten Flur?  (Mit einem SELECT-Statement)

    
-- 1.6.5) Wieviele Flure bestehen aus gerade nur einer Parzelle?  (Mit einem SELECT-Statement)


-- 20.1.5) Erstellen Sie ein SELECT-Statment, welches folgendes Result-Set (Serienbriefliste) aus der Personen-Tabelle erzeugt.

-- Ausschnitt des erwarteten Resultates:
-- ID   | Sex   | Vorname                   | Ledig_Name                       | Partner_Name                     | Anrede                                              | Anrede_perDu                   
-- -----+-------+---------------------------+----------------------------------+----------------------------------+-----------------------------------------------------+--------------------------------
-- 60   | Herr  | Pb6c                      | B953b5                           | Kfeb                             | Sehr geehrter Herr B953b5                           | Lieber Pb6c                    
-- 61   | Frau  | N9cfc1                    | B953b5                           | E855c1                           | Sehr geehrte Frau B953b5                            | Liebe N9cfc1                   
-- 63   | Herr  | M7fe343                   | B953b5                           | F5a                              | Sehr geehrter Herr B953b5                           | Lieber M7fe343                 
-- 64   | Herr  | Kf11                      | H994ce                           |                                  | Sehr geehrter Herr H994ce                           | Lieber Kf11                    
-- 65   | Herr  | A5f1d                     | B953b5                           | Mf016dfa                         | Sehr geehrter Herr B953b5                           | Lieber A5f1d                   
     
     
     
-- 20.1.6) Erstellen Sie ein SELECT-Statment, welches folgendes Result-Set (Alters-Liste) aus der Personen-Tabelle erzeugt.
-- Alterliste enthält nur Personen bei denen ein Geburtstag gesetzt ist. Falls die Person noch lebt (kein Todestag gesetzt) 
-- wird das Alter bis heute berechnet.

-- Ausschnitt des erwarteten Resultates:     
-- ID   | Sex  | Vorname       | Ledig_Name                 | Geburtstag | Todestag   | Alter
-- -----+------+---------------+----------------------------+------------+------------+------
-- 1245 | Herr | U9a26283d     | U9a26283d                  | 1900-01-01 | None       | 125  
-- 148  | Frau | A7a9          | B953b5                     | 1920-12-16 | 2021-01-24 | 100  
-- 184  | Herr | A174a         | Hdabaf                     | 1909-06-22 | 2010-05-02 | 100  
-- 155  | Herr | F3dd8         | Gdf2594                    | 1904-05-07 | 2003-11-14 | 99   
-- 117  | Frau | E535          | V61a                       | 1909-02-22 | 2007-08-24 | 98   
-- 233  | Frau | J74d6b73      | V61a                       | 1914-02-27 | 2012-05-08 | 98   
-- 311  | Frau | A7a9          | S9404693314                | 1913-10-22 | 2010-11-25 | 97        
     

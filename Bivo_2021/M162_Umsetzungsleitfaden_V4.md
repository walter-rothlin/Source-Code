# Grundkonzept und Umsetzungsleitfaden

 

## Beschreibung

Dieses Dokument beschreibt die Grundkonzepte die im Modul im Vordergrund stehen sollen. Darüber hinaus beinhaltet es ein Musterdrehbuch für die Unterrichtsdurchführung.

 

[TOC]

 



## 1        Grundkonzept

### 1.1      Einleitung

In diesem ersten Modul geht es um Daten analysieren, auswerten und Daten modellieren.

 

Typische Situation:

Der Lernende kann Log- und Statistische-Daten in verschiedensten Formaten analysieren und Auswertungen erstellen.

Der Lernende kann Daten für eine Anwendung strukturieren.

 

 

Eine Informatikerin/ ein Informatiker im ersten Lehrjahr muss fähig sein

•   Daten aus verschiedensten Quellen und in unterschiedlichsten Formaten lesen, 
    gruppieren und zusammenfassen können
•   Daten umformen und umwandeln können
•   Die wichtigsten statistischen Kennwerte aus einer Datenmenge berechnen können

 

 

### 1.2      Themen und Inhalte

Die Schwergewichte sind:
•   Daten, Informationen und Wissen
•   Flüchtige und persistente Daten
•   Datentypen
•   Datenstrukturen (csv, Listen, Hash-Maps, Trees und Netze, JSON, XML)
•   Datenbestände aufbereiten und mit geeigneten  Grafiken, Kenngrössen und Formaten auswerten
    •   Kenngrössen z.B. Mittelwert, Median,..
    •   Meta-Tags in Daten (z.B. MP3,JPEG,…)
    •   Geo-Daten / Geo-Taggen
•   Datenschutz / Datensicherheit
•   Datenmodellierung
    •   Unterscheidung vom konzeptionellen zum logischen
    •   Entitätstyp, Attribut, Assoziationen, Kardinalität
    •   Logisches relationales Datenmodel
    •   Redundanz / Normalisieren
    •   Referenzielle Integrität (PK, FK, Constraints)



### 1.3      Kompetenzen

Siehe M162_Modulidentifikation und Kompetenzraster

 

### 1.4      Tools

•   Excel mit Formeln und Grafiken
•   ASCII Editor (z.B. Notepad++)
•   XML-Onlinetools für XPath, Validierung (XML-Schema) und Transformation (XSLT-Transformation)
•   PyCharm / Python mit NumPy, Pandas und MatPlotLib
•   RDBMS z.B MySQL / Workbench
•   REST-Services JSON Datenformat (z.B. OpenWeather, Map.geo.admin.ch)

 

 

### 1.5      Beispiele

•   Logfiles aufbereiten und auswerten (Kältemaschine)
•   Datenfiles analysieren und auswerten (Wetterdaten, Map-Overlays)
•   Response von REST-Services verarbeiten (XML, JSON): serach.ch und openweather.com API
•   Geo-Taggen und XML Verarbeitung mit map.geo.admin
•   Unstrukturierte Daten: Text-Suche mit RegEx
•   QR-Code einer vCard Raw decodieren
•   Mittels MySQL Workbench ERD einer eigenen Vereinsdatenbank entwerfen und normalisieren




## 2        Drehbuch

### 2.1      Einleitung

Der folgende Lektionenplan definiert einen möglichen Ablauf mit einer sinnvollen Gewichtung der Themen. Der Lektionenplan ist für den Wochenunterricht à 2 Lektionen und die Durchführung in einem Semester gedacht. Es werden pro Semester 34 Lektioen geplant.

 

### 2.2      Lektionenplan (Doppel-Lektionen)

 



| Block | Themen                                                       | Kompetenzen | Übungen/Tools                                                |
| ----- | ------------------------------------------------------------ | ----------- | ------------------------------------------------------------ |
|  1    | Daten, Informationen, Wissen  Strukturierte /  Unstrukturierte Daten |             | Eigene Adressliste in Excel vs  Word erstellen  ·      Selektierbar (Auto-Filter)  ·      Sortierbar  ·      Daten importieren (Text to Spalten)  ·      Daten exportieren (als csv, xml,…) |
|  2    | Abgeleitete Daten / Sichten / Views                          |             | Neue Spalten mit Formeln erzeugen  ·      Berechnen  ·      String-Operationen  ·      Logik     z.B. Anrede  per Du/Sie, eMail-Listen     Spalten  bedingt formatieren  ·      Vom eigenen Inhalt  ·      Vom anderen Werten        z.B. Mein Notenrechner  in Excel / Interaktives Formelbuch |
|  3    | Daten mit Grafiken und  Diagrammen darstellen                |             | [Logfile einer Kälteanlage](https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/DatenFiles/TXT/Kaeltemacher_LogFile_2019_08_29.txt) in Excel  aufbereiten,    auswerten und  grafisch darstellen |
|  4    | Datentypen als Einschränkung  / Konsistenzgarantie  Datenstrukturen (Listen, Dicts, hierarchisch geschachtelt)  Dateitypen (SVG, PNG, GIF, Meta-Tags) |             | Übungen mit Python (PyCharm, Visual Studio Code oder  https://www.programiz.com/python-programming/online-compiler/) |
|  5    | Persistente Daten  ·      Dateitypen (Text- / Binäre-Dateien)  ·      Meta-Informationen  ·      Tags |             | txt, csv, HTML, JSON, XML, SVG mit Notepad++ analysieren     docx, xlsx, gif, jpg mit entsprechendem Tool bearbeiten |
|  6    | Statistische Grössen  ·      Eindimensionale   Daten (Average, Min, Max,….)  ·      Mehrdimensionale Daten (lineare Approximation,  MSE, Correlation |             | Messreihen oder Umfrageresultate aufbereiten und statistische Grössen  berechnen.     Hilfsmittel  Text-Editor, Excel, Python, WYSIWYG-Tool (z.B. Paint) |
|  8    | JSON Struktur  (Dicts and Lists)                             |      | Open-weather Request / Response                              |
|  9    | ·      XML und die drei Standard-Operationen   Validierung mit XML-Schema  ·      Daten lesen mit XPath   Transformationen mit XSLT |      | Geo.map.admin Overlay erstellen, exportieren und mit XML-Standard  Operationen verarbeiten |
| 10    | QR-Code  über REST Service erstellen und RAW decodieren      |      | QR-Code über vCard erzeugen  „Neuer“ Einzahlungsschein       |
| 11    | Continue                                                     |      |                                                              |
| 12    | ERD (Entitätstypen, Attributte, Datentypen,  Primarykey)     |      | Installation MySQL und Workbench (inkl  sakila)   Umsetzung mit Workbench |
| 13    | ERD  (Assoziationen, Kardinalität, Foreignkey, Referenzielle Integrität,  Constraints) |      | Umsetzung mit Workbench                                      |
| 14    | Reverse  Engineering vom Schema zum ERD                      |      | ERD vom Schema sakila generieren und mit weiteren Informationen  anreichern (row counts, Liste Datentypen, m:n, 1:n 0,1:n Beziehungen) |
| 15    | Eigenes  ERD erstellen, Normalisieren                        |      | Für  Vereinsdaten ein ERD erstellen                          |
| 17    | Vom ERD zum Schema |      | Schema mit ERD erzeugen lassen   Daten  mittels Bulkload laden und mit Workbench ergänzen |
| 18    | Reserve            |      |                                                              |
| 19    | Reserve            |      |                                                              |
| 20    | Reserve            |      |                                                              |

 

 

### 2.3      Hinweise zu den LBVs (Leistungsbeurteilungsvorgaben)

#### Zu dieser Modulversion gibt es folgende LBV’s:

·     ...
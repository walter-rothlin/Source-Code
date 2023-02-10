SELECT
   `Artikel`          AS `Artikel`,
   `Artikel-Art`      AS `Art`,
   `Preis`            AS `Preis`,
   `Anzahl`           AS `Anzahl`,
   `Preis` * `Anzahl` AS `Positionsbetrag`
FROM `einkaufsliste`;

SELECT
   count(`Artikel`)   AS `Anzahl`,
   `Artikel-Art`      AS `Art`
FROM `einkaufsliste`
GROUP BY `Artikel-Art`;

SELECT
   sum(`Preis` * `Anzahl`)   AS `Ausgegebener_Betrag`,
   `Artikel-Art`             AS `Art`
FROM `einkaufsliste`
GROUP BY `Artikel-Art`;


SELECT
   count(`Artikel`)          AS `Anzahl`,
   sum(`Preis` * `Anzahl`)   AS `Ausgegebener_Betrag`,
   `Artikel-Art`             AS `Art`
FROM `einkaufsliste`
GROUP BY `Artikel-Art`;

SELECT
   `Artikel-Art`                       AS `Art`,
   count(`Artikel`)                    AS `Anzahl`,
   round(sum(`Preis` * `Anzahl`), 2)   AS `Ausgegebener_Betrag`
FROM `einkaufsliste`
GROUP BY `Artikel-Art`
ORDER BY `Ausgegebener_Betrag` DESC;

SELECT
   `Artikel-Art`                       AS `Art`,
   count(`Artikel`)                    AS `Anzahl`,
   round(sum(`Preis` * `Anzahl`), 2)   AS `Ausgegebener_Betrag`,
   round(avg(`Preis` * `Anzahl`), 2)   AS `Durchnitt`
FROM `einkaufsliste`
GROUP BY `Artikel-Art`
ORDER BY `Ausgegebener_Betrag` DESC;
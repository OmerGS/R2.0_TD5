/*
GUNES Omer
Groupe B1
TD 5
*/

-- QUESTION 1
--------------------------------------------
CREATE OR REPLACE VIEW vue_PiloteEtCompagnie
AS
SELECT nomPilote, nomComp
FROM Pilote
    JOIN Compagnie ON CompPil = idComp
;

SELECT *
FROM vue_PiloteEtCompagnie
;

/*
6 Tuples

# nomPilote, nomComp
'Ridard', 'Air France'
'Naert', 'EasyJet'
'Godin', 'Ryanair'
'Fleurquin', 'Air France'
'Pham', 'American Airlines'
*/

--------------------------------------------

CREATE OR REPLACE VIEW vue_PiloteEtCompagnie
AS
SELECT nomPilote, nomComp nom_Compagnie
FROM Pilote
    JOIN Compagnie ON compPil = idComp
;

SELECT *
FROM vue_PiloteEtCompagnie
;

/*
6 Tuples

# nomPilote, nom_Compagnie
'Ridard', 'Air France'
'Fleurquin', 'Air France'
'Naert', 'EasyJet'
'Pham', 'American Airlines'
'Kamp', 'American Airlines'
*/

--------------------------------------------

CREATE OR REPLACE VIEW vue_PiloteEtCompagnie
(
    nom_Pilote,
    nom_Compagnie
) AS
SELECT nomPilote, nomComp
FROM Pilote
    JOIN Compagnie ON compPil = idComp
;

SELECT *
FROM vue_PiloteEtCompagnie
;

/*
6 Tuples

# nom_Pilote, nom_Compagnie
'Ridard', 'Air France'
'Fleurquin', 'Air France'
'Naert', 'EasyJet'
'Pham', 'American Airlines'
'Kamp', 'American Airlines'
*/

--------------------------------------------

CREATE OR REPLACE VIEW vue_Compagnie_Sans_Avion
AS
SELECT idComp
FROM Compagnie
EXCEPT
SELECT compAv
FROM Avion
;

SELECT *
FROM vue_Compagnie_Sans_Avion
;

/*
0 Tuple
*/

--------------------------------------------

CREATE OR REPLACE VIEW vue_Pilote_Sans_Qualification
AS
SELECT idPilote
FROM Pilote
EXCEPT
SELECT unPilote
FROM Qualification
;

SELECT *
FROM vue_Pilote_Sans_Qualification
;

/*
1 Tuple

# idPilote
'6'
*/

--------------------------------------------

CREATE OR REPLACE VIEW vue_Pilote_Illegitime
AS
SELECT idPilote
FROM Pilote
WHERE compPil IS NOT NULL
EXCEPT
SELECT unPilote
FROM Qualification
    JOIN Pilote ON unPilote = idPilote
        JOIN Avion ON compPil = compAv
WHERE unTypeAvion = leTypeAvion
;

SELECT *
FROM vue_Pilote_Illegitime
;

/*
0 Tuple
*/

--------------------------------------------

CREATE OR REPLACE VIEW vue_nbAvion
AS
SELECT idComp, COUNT(idAvion) nb_Avion
FROM Compagnie
    LEFT JOIN Avion ON idComp = compAv
GROUP BY idComp
;

SELECT *
FROM vue_nbAvion
;

/*
# idComp, nb_Avion
'1', '3'
'2', '1'
'3', '1'
'4', '2'
'5', '2'
*/

--------------------------------------------

CREATE OR REPLACE VIEW vue_Compagnie_Complete
AS
SELECT Compagnie.idComp, nomComp, pays, estLowCost, nb_Avion
FROM Compagnie
    JOIN vue_nbAvion ON Compagnie.idComp = vue_nbAvion.idComp
;

SELECT idComp, nomComp, nb_Avion
FROM vue_Compagnie_Complete
;

/*
5 Tuples

# idComp, nomComp, nb_Avion
'1', 'Air France', '3'
'2', 'Corsair International', '1'
'3', 'EasyJet', '1'
'4', 'American Airlines', '2'
'5', 'Ryanair', '2'
*/

--------------------------------------------

CREATE OR REPLACE VIEW vue_nbQualification
AS
SELECT idPilote, COUNT(unTypeAvion) nb_Qualification
FROM Pilote
    LEFT JOIN Qualification ON idPilote = unPilote
GROUP BY idPilote
;

SELECT *
FROM vue_nbQualification
;

/*
7 Tuples

# idPilote, nb_Qualification
'1', '2'
'2', '2'
'3', '1'
'4', '3'
'5', '2'
*/

--------------------------------------------

CREATE OR REPLACE VIEW vue_Pilote_Experimente
AS
SELECT idPilote, 1 est_Experimente
FROM Pilote
WHERE nbHVol >= (650*4)
;

SELECT *
FROM vue_Pilote_Experimente
;

/*
2 Tuples

# idPilote, est_Experimente
'4', '1'
'7', '1'
*/

--------------------------------------------

CREATE OR REPLACE VIEW vue_Pilote_Complete
AS
SELECT P.idPilote, nomPilote, nbHVol, compPil, nb_Qualification, est_Experimente
FROM Pilote P
    JOIN vue_nbQualification vue_Q ON P.idPilote = vue_Q.idPilote
        LEFT JOIN vue_Pilote_Experimente vue_P ON P.idPilote = vue_P.idPilote
;

SELECT idPilote, nomPilote, nb_Qualification, est_Experimente
FROM vue_Pilote_Complete
;

/*
7 Tuples

# idPilote, nomPilote, nb_Qualification, est_Experimente
'1', 'Ridard', '2', NULL
'2', 'Naert', '2', NULL
'3', 'Godin', '1', NULL
'4', 'Fleurquin', '3', '1'
'5', 'Pham', '2', NULL
*/

--------------------------------------------

-- VUES

-- Question 4
-- 1.Tout compte appartient `a au moins un client (`a ajouter au diagramme de classes)

-- Reponse Compte n°2

CREATE OR REPLACE VIEW vue_compte_Sans_Client
AS
SELECT numCompte
FROM Compte
EXCEPT
SELECT unCompte
FROM Appartient
;

SELECT *
FROM vue_compte_Sans_Client
;

/*
1 Tuple

# numCompte
'2'
*/

--------------------------------------------

-- 2. Une agence a forc ́ement un et un seul directeur
-- Réponse : 1 et 2

CREATE OR REPLACE VIEW vue_un_seul_directeur
AS
SELECT numAgence
FROM (SELECT numAgence, SUM(directeur) as nbDirecteur
    FROM Agence
    JOIN Agent ON sonAgence = numAgence
    GROUP BY numAgence
    HAVING SUM(directeur) !=1
    ) AS subQuerry
;

SELECT *
FROM vue_un_seul_directeur;

/*
2 Tuples

# numAgence
'1'
'2'
*/

--------------------------------------------

-- 3. Le directeur d’une agence est mieux pay ́e que les agents de son agence
-- Réponse : Directeur 5 de l'Agence 3 trop payé

CREATE OR REPLACE VIEW vue_salaire_directeur
AS
SELECT Dir.numAgent
FROM Agent Dir, Agent Emp
WHERE Dir.directeur = 1
AND Emp.directeur = 0
AND Dir.sonAgence = Emp.sonAgence
AND Dir.salaire < Emp.salaire;

SELECT *
FROM vue_salaire_directeur
;

/*
1 Tuple

# numAgent
'5'
*/

--------------------------------------------

-- Question 5 : Creer une vue permettant d’afficher, pour chaque client, son ˆage et son agence.

CREATE OR REPLACE VIEW vue_Client_Complet
AS
SELECT nomClient, prenomClient, sonAgent, (DATE_FORMAT(FROM_DAYS(TO_DAYS(NOW())-TO_DAYS(dateNaissanceClient)), '%Y')+0) AS age
FROM Client, Agent
JOIN Agent ON numAgent = sonAgent
    JOIN Agence ON sonAgence = numAgence
        JOIN Agence ON numAgence = adAgence AS Agence
;

SELECT *
FROM vue_Client_Complet
;

/*
# nomClient, prenomClient, sonAgent, age
'Nanou', 'Bib', '1', '21'
'Bidule', 'Mach', '2', '26'
'Bidule', 'Mach', '3', '30'
*/
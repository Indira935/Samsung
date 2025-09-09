CREATE DATABASE Samsung_db;
USE Samsung_db;

SELECT *
FROM
	clients_samsung;

SELECT *
FROM
	produits_samsung;
    
SELECT *
FROM
	ventes_samsung;


-- Exercice 1 : Afficher les informations des clients qui répondent à tous les critères suivants :
-- Age supérieur ou égal à 30 ans.
-- Revenu annuel compris entre 40 000 et 70 000 euros.
-- Inscrits après le 1er janvier 2018.
-- Ayant un score de fidélité supérieur à 5.

SELECT *
FROM
	clients_samsung
WHERE
	Age >= 30
    AND Revenu_Annuel BETWEEN 40000 AND 70000
    AND Date_Inscription > '2018-01-01'
    AND Score_Fidelite > 5;


-- Exercice 2 : Sélectionner les détails des ventes qui satisfont à toutes les conditions suivantes :
-- Montant total de la vente supérieur à 1000 euros.
-- Score de satisfaction client inférieur à 3.
-- Ventes réalisées en ligne.
-- Délai de livraison supérieur à 20 jours.

SELECT 
	ID_Vente,
	Montant_Total,
    Score_Satisfaction,
	Canal_Achat,
   Delai_Livraison_Jours 
FROM
	ventes_samsung
WHERE
	Montant_Total > 1000
    AND Score_Satisfaction < 3
    AND Canal_Achat = 'En ligne'
    AND Delai_Livraison_Jours > 20;


-- Exercice 3 : POur évaluer l'expansion géographique de l'enterprise, identifiez tous els pays distincts
-- où les produits ont été vendus.

SELECT
	DISTINCT Pays_Vente
FROM
	ventes_samsung;
    

-- Exercice 4 : Évaluez l'efficacité des canaux de vente en fonction de la
-- satisfaction des clients. Pour chaque canal de vente, affichez le canal, le score
-- moyen de satisfaction des clients et le nombre total de ventes réalisées par ce canal.

SELECT
	Canal_Achat,
    ROUND(AVG(Score_Satisfaction),2) AS score_satisfaction_moyen,
    COUNT(ID_Vente) AS Nb_total_vente
FROM
	ventes_samsung
GROUP BY
	Canal_Achat;
    

-- Exercice 5 : Affichez chaque produit, son prix et le nombre total de fois qu'il a été vendu

SELECT
	produits_samsung.Nom_Produit,
    produits_samsung.Prix,
    SUM(ventes_samsung.Quantite_Vendue) AS nb_total_vente
FROM
   produits_samsung
   LEFT JOIN ventes_samsung
		ON produits_samsung.ID_Produit = ventes_samsung.ID_Produit
GROUP BY
	1,2;


-- Exercice 6 : Déterminez l'âge moyen et le revenu annuel maximum des clients
-- pour chaque pays. Affichez le pays, l'âge moyen et le revenu annuel maximum.

SELECT
	Pays,
    ROUND(AVG(Age)) AS age_moyen,
    MAX(Revenu_Annuel) AS revenu_annuel_max
FROM
	clients_samsung
GROUP BY
	Pays;


-- Exercice 7 : Identifiez le délai de livraison minimum et le score de satisfaction moyen
-- pour chaque méthode d'expédition. Affichez la méthode d'expédition, le délai de livraison minimum
-- et le score moyen de satisfaction.

SELECT
	Methode_Expedition,
    MIN(Delai_Livraison_Jours) AS délai_livraison_min,
    ROUND(AVG(Score_Satisfaction),2) AS score_satisfaction_moyen
FROM
	ventes_samsung
GROUP BY
	Methode_Expedition;
    

-- Exercice 8 : Déterminez le nombre de clients avec un score de fidélité 
-- "Faible" (<5), "Moyen" (5-7), "Élevé" (>7).

SELECT
	CASE
		WHEN Score_Fidelite < 5 THEN 'Faible'
        WHEN Score_Fidelite BETWEEN 5 AND 7 THEN 'Moyen'
        ELSE 'Élevé'
	END AS Classification_score_fidélité,
    COUNT(ID_Client) AS Nombre_clients
FROM
	clients_samsung
GROUP BY
	Classification_score_fidélité;
	

-- Exercice 9 :  Trouvez les produits dont le montant total des ventes dépasse 15000.
-- Listez l'ID du produit et le montant total des ventes.

SELECT
	ID_Produit,
    SUM(Montant_Total) AS Montant_total_vente
FROM
	ventes_samsung
GROUP BY
	ID_Produit
HAVING
	Montant_total_vente > 15000;
    

-- Exercice 10 : Trouvez les pays où plus de 400 ventes ont été réalisées.
-- Affichezle nom du pays et le nombre total de ventes.

SELECT
	Pays_Vente,
    COUNT(ID_Vente) AS nb_total_vente
FROM
	ventes_samsung
GROUP BY
	Pays_Vente
HAVING
	nb_total_vente > 400;
    

-- Exercice 11 : Calculez le montant total des ventes pour chaque mois de l'année 2021.
-- Utilisez DATE_FORMAT() pour extraire le mois de la date de vente.

SELECT
	DATE_FORMAT(Date_Vente, '%M') AS Mois_2021,
    SUM(Montant_Total) AS Montant_total_vente
FROM
	ventes_samsung
GROUP BY
	Mois_2021;

-- Exercice 12 : Classez les ventes en "Weekend" (Samedi et Dimanche) et "Semaine" (Lundi à Vendredi).
-- Calculez le nombre total de ventes pour chaque classification.

SELECT
	CASE
		WHEN DAYOFWEEK(Date_Vente) IN (7, 1) THEN 'Weekend'
        ELSE 'Semaine'
	END AS Periode_semaine,
	COUNT(ID_Vente) AS nb_total_vente
FROM
	ventes_samsung
GROUP BY
	Periode_semaine;


/*Exercice 13 :  Catégorisez les ventes en "Début d'Année" (Janvier à Avril), "Milieu d'Année" (Mai à Août),
et "Fin d'Année" (Septembre à Décembre) basé sur la date de vente.
Calculez le montant total des ventes pour chaque catégorie.*/

SELECT
	CASE
		WHEN DATE_FORMAT(Date_Vente, '%m') BETWEEN '01' AND '04' THEN 'Début Année'
        WHEN DATE_FORMAT(Date_Vente, '%m') BETWEEN '05' AND '08' THEN 'Milieu Année'
        ELSE 'Fin Année'
	END AS Période_année,
    SUM(Montant_Total) AS Montant_total_vente
FROM
	ventes_samsung
GROUP BY
	Période_année;
    

-- Exercice 14 : Identifiez les clients de France et d'Allemagne ayant un score de fidélité moyen supérieur à 7.

SELECT *
FROM
	clients_samsung
WHERE
	Pays IN ('France', 'Allemagne')
    AND Score_Fidelite > 7;
    

/* Exercice 15 : Pour une segmentation marketing, vous devez catégoriser les clients
en fonction de leur revenu et de leur âge. Créez une nouvelle variable "Segment_Client"
avec les conditions suivantes :
"Jeune à Revenu Élevé" : Pour les clients de moins de 35 ans avec un revenu
supérieur à 50 000.
"Jeune à Revenu Moyen" : Pour les clients de moins de 35 ans avec un revenu entre
30 000 et 50 000.
"Jeune à Revenu Faible" : Pour les clients de moins de 35 ans avec un revenu
inférieur à 30 000.
"Senior à Revenu Élevé" : Pour les clients de 35 ans et plus avec un revenu
supérieur à 50 000.
"Senior à Revenu Moyen" : Pour les clients de 35 ans et plus avec un revenu entre
30 000 et 50 000.
"Senior à Revenu Faible" : Pour les clients de 35 ans et plus avec un revenu
inférieur à 30 000.*/

SELECT 
    CASE
		WHEN Age < 35 AND Revenu_Annuel > 50000 THEN 'Jeune à revenu élevé'
        WHEN Age < 35 AND Revenu_Annuel BETWEEN 30000 AND 50000 THEN 'Jeune à revenu moyen'
		WHEN Age < 35 AND Revenu_Annuel < 30000 THEN 'Jeune à revenu faible'
        WHEN Age >= 35 AND Revenu_Annuel > 50000 THEN 'Senior à revenu élevé'
		WHEN Age >= 35 AND Revenu_Annuel BETWEEN 30000 AND 50000 THEN 'Senior à revenu moyen'
		WHEN Age >= 35 AND Revenu_Annuel < 30000 THEN 'Senior à revenu faible'
	END AS Segment_client,
	ID_Client,
	Age,
    Revenu_Annuel
FROM
	clients_samsung
GROUP BY
	Segment_client, ID_client, Age, Revenu_Annuel;


/* Exercice 16 : Déterminez le volume total des ventes pour chaque mois en
affichant tous les mois de l'année avec la quantité totale de produits vendus
durant ces mois. */

SELECT
	DATE_FORMAT(Date_Vente, '%M') AS Mois_année,
    SUM(Quantite_Vendue) AS Total_qté_vendue
FROM
	ventes_samsung
GROUP BY
	Mois_année;


/* Exercice 17 : Pour chaque combinaison Gamme et Pays_Vente, calculez :
le nombre de ventes,
le montant total des ventes. */

SELECT
	produits_samsung.Gamme,
    ventes_samsung.Pays_Vente,
    COUNT(ventes_samsung.ID_Vente) AS Total_nb_vente,
    SUM(ventes_samsung.Montant_Total) AS Montant_total_vente
FROM
	produits_samsung
    LEFT JOIN ventes_samsung
		ON produits_samsung.ID_Produit = ventes_samsung.ID_Produit
GROUP BY
	1, 2;


/* Exercice 18 : Pour chaque gamme de produit et chaque canal d’achat, affichez :
le nombre total de ventes,
la quantité totale vendue,
le montant total des ventes,
la satisfaction moyenne,
Triez par gamme, puis canal. */

SELECT
    produits_samsung.Gamme,
    ventes_samsung.Canal_Achat,
    COUNT(ventes_samsung.ID_Vente) AS Nb_total_vente,
    SUM(ventes_samsung.Quantite_Vendue) AS Total_qté_vendue,
    SUM(ventes_samsung.Montant_Total) AS Montant_total_vente,
    ROUND(AVG(ventes_samsung.Score_Satisfaction),2) AS Score_satisfaction_moyen
FROM
	produits_samsung
    LEFT JOIN ventes_samsung
		ON produits_samsung.ID_Produit = ventes_samsung.ID_Produit
GROUP BY
	1,2;


/* Exercice 19 : Pour chaque mois de l’année 2021 et chaque gamme de produit, affichez :
le nombre de ventes,
le chiffre d’affaires total,
la quantité vendue totale,
et la moyenne du délai de livraison. */

SELECT
    DATE_FORMAT(ventes_samsung.Date_Vente, '%M') AS Mois_Année,
    produits_samsung.Gamme,
    COUNT(ventes_samsung.ID_Vente) AS Nb_total_vente,
    SUM(ventes_samsung.Montant_Total) AS CA_total,
    SUM(ventes_samsung.Quantite_Vendue) AS Total_qté_vendue,
    ROUND(AVG(ventes_samsung.Delai_Livraison_Jours),2) AS Délai_moyen_livraison
FROM
	ventes_samsung
    LEFT JOIN produits_samsung
		ON ventes_samsung.ID_Produit = produits_samsung.ID_Produit
GROUP BY
	Mois_Année, produits_samsung.Gamme;
    

/* Exercice 20 :Pour chaque canal préféré et type de produit préféré, affichez :
le nombre de clients uniques,
la fidélité moyenne des clients,
le montant total dépensé par ces clients,
une classification :
'VIP' si fidélité moyenne > 6 et la somme du montant total des ventes > 200 000 €
'Standard' sinon
Contrainte supplémentaire : Ne prendre en compte que les clients inscrits après le 1er
janvier 2018. */

SELECT
	clients_samsung.Canal_Prefere,
    clients_samsung.Preference_Produit,
    COUNT(clients_samsung.ID_Client) AS nb_client_unique,
    ROUND(AVG(clients_samsung.Score_Fidelite),2) AS Fidélité_moyenne_client,
    ROUND(SUM(ventes_samsung.Montant_Total),2) AS Montant_total_dépensé,
    CASE
		WHEN clients_samsung.Score_Fidelite > 6 AND ventes_samsung.Montant_Total >200000 THEN 'VIP'
        ELSE 'Standard'
	END AS Classification_client
FROM
	clients_samsung
    LEFT JOIN ventes_samsung
		ON clients_samsung.ID_Client = ventes_samsung.ID_Client
WHERE
	clients_samsung.Date_Inscription > '2018-01-01'
GROUP BY
	1,2,6;





    
    
    





    







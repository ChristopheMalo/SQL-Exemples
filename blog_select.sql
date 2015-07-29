-- --------------------------------------
-- SELECT Accueil - Tous les articles
-- --------------------------------------
SELECT DATE_FORMAT(a.date_publication, '%d/%m/%Y') AS dateA, u.pseudo, a.titre, a.resume, COUNT(c.article_id) AS nbr_commentaire
FROM Article AS a
INNER JOIN Utilisateur AS u ON a.auteur_id = u.id
LEFT JOIN Commentaire AS c ON a.id = c.article_id
GROUP BY dateA, u.pseudo, a.titre, a.resume
ORDER by dateA DESC;

-- --------------------------------------
-- SELECT Auteur - id auteur = 2
-- --------------------------------------
SET lc_time_names = 'fr_FR';
SELECT DATE_FORMAT(a.date_publication, '%d %M ''%y') AS dateA, u.pseudo, a.titre, a.resume
FROM Article AS a
INNER JOIN Utilisateur AS u ON a.auteur_id = u.id
WHERE u.id = 2
ORDER by dateA DESC;

-- --------------------------------------
-- SELECT Categorie - id categorie = 3
-- --------------------------------------
SELECT DATE_FORMAT(a.date_publication, '%d/%m/%Y - %k:%i') AS dateA, u.pseudo, a.titre, a.resume
FROM Article AS a
INNER JOIN Utilisateur AS u ON a.auteur_id = u.id
INNER JOIN Categorie_article AS ca ON a.id = ca.article_id
WHERE ca.categorie_id = 3
ORDER by dateA DESC;

-- ------------------------------------------
-- SELECT Article + comments - id article = 4
-- ------------------------------------------
SET lc_time_names = 'fr_FR';
SELECT DATE_FORMAT(a.date_publication, '%d %M %Y à %k heures %i') AS dateA, a.titre, a.contenu,  GROUP_CONCAT(c.nom SEPARATOR ', ') AS catgName, u.pseudo
FROM Article AS a
INNER JOIN Utilisateur AS u ON a.auteur_id = u.id
INNER JOIN Categorie_article AS ca ON ca.article_id = a.id
INNER JOIN Categorie AS c ON ca.categorie_id = c.id
WHERE a.id = 4;

SELECT c.contenu, DATE_FORMAT(c.date_commentaire, '%d/%m/%Y') AS dateC, u.pseudo AS Auteur
FROM Commentaire as c
LEFT JOIN Utilisateur AS u ON c.auteur_id = u.id
WHERE c.article_id = 4
ORDER BY dateC;
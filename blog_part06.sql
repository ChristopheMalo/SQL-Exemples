-- ------------------------------------------------------------------------------------
-- Activité Partie 6 - Administrez une base de données avec MySQL
---------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------
-- EXERCICE 1
---------------------------------------------------------------------------------------
-- Etape 1 : ALTER TABLE
-- Ajout d'une colonne nbr_commentaire pour stocker
-- le nombre de commentaire pour chaque article
--
-- Etape 2 : UPDATE
-- Mise à jour de la colonne nbr_commentaire
-- avec le calcul du nombre de commentaire pour chaque article
-- 
-- Etape 3 : CREATE TRIGGER INSERT ET DELETE
-- Creation des triggers pour mettre à jour
-- le nombre de commentaire dans la colonne nbr_article table Article
-- lors de la création ou suppression d'un commentaire dans la table commentaire
--
-- Pas de trigger after ou before update car ici pas de modifications.
-- On doit juste compter les commentaires puis mettre à jour
-- lors d'ajout ou suppression d'un commentaire
-- ------------------------------------------------------------------------------------
ALTER TABLE Article ADD nbr_commentaire INT(10) NOT NULL DEFAULT 0 AFTER date_publication;

UPDATE Article As a 
LEFT JOIN (SELECT id, article_id, COUNT(article_id) AS countCommentaire FROM Commentaire GROUP BY article_id) as c
  ON c.article_id = a.id 
SET a.nbr_commentaire = c.countCommentaire;

DELIMITER //

CREATE TRIGGER after_insert_commentaire 
AFTER INSERT ON commentaire 
FOR EACH ROW 
BEGIN
    UPDATE Article AS a
    SET nbr_commentaire = nbr_commentaire + 1
    WHERE NEW.article_id = a.id;
END //

CREATE TRIGGER after_delete_commentaire 
AFTER DELETE ON commentaire 
FOR EACH ROW 
BEGIN
    UPDATE Article AS a
    SET nbr_commentaire = nbr_commentaire - 1
    WHERE OLD.article_id = a.id;
END //

DELIMITER ;


-- ------------------------------------------------------------------------------------
-- EXERCICE 2
---------------------------------------------------------------------------------------
-- Afficher un résumé, si inexistant, création automatique
-- avec les 150 premiers caractères du champ contenu
--  Le code : 
-- IF (a.resume IS NULL, CONCAT(LEFT(a.contenu, 150), '...'), a.resume) AS LittleTexte
-- J'ai effectué un test fonctionnel en supprimant le résumé d'un article
-- Attention je n'enregistre pas le résumé dans la base.
-- ------------------------------------------------------------------------------------
SELECT a.id,
       DATE_FORMAT(a.date_publication, '%d/%m/%Y') AS dateA,
       u.pseudo,
       a.titre,
       IF (a.resume IS NULL, CONCAT(LEFT(a.contenu, 150), '...'), a.resume) AS LittleTexte,
       COUNT(c.article_id) AS nbr_commentaire
FROM Article AS a
INNER JOIN Utilisateur AS u ON a.auteur_id = u.id
LEFT JOIN Commentaire AS c ON a.id = c.article_id
GROUP BY a.id, dateA, u.pseudo, a.titre, a.resume
ORDER by a.id DESC;


-- ------------------------------------------------------------------------------------
-- EXERCICE 3
---------------------------------------------------------------------------------------
-- Création d'une vue pour afficher les statistiques demandées
-- Attention je ne stocke pas les données
-- Avec une interface front, j'appelle la vue
-- pour avoir les données à jour à la demande
-- Puis test de sélection de toutes les données avec SELECT * FROM V_User_Stats pour
-- vérifier que la vue fonctionne correctement
-- ------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW V_User_Stats
AS SELECT
        u.id,
        u.pseudo,
        (SELECT COUNT(a.id) FROM Article AS a WHERE a.auteur_id = u.id) AS nbr_article_write,
        (SELECT MAX(DATE_FORMAT(a.date_publication, '%d/%m/%Y à %T')) FROM Article AS a WHERE a.auteur_id = u.id) AS Date_Last_Article,
        (SELECT COUNT(c.id) FROM Commentaire AS c WHERE c.auteur_id = u.id) AS nbr_commentaire_write,
        (SELECT MAX(DATE_FORMAT(c.date_commentaire, '%d/%m/%Y à %T')) FROM Commentaire AS c WHERE c.auteur_id = u.id) AS Date_Last_Commentaire
FROM Utilisateur AS u
GROUP BY u.id, u.pseudo, Date_Last_Article, Date_Last_Commentaire
ORDER BY u.id ASC;

SELECT * FROM V_User_Stats
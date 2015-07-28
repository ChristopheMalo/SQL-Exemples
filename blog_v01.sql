/* Méthode 1 :  Les index et le Foreign KEY sont créés dans les requêtes Create */
-- --------------------------------------
-- CREATION DE LA BASE blog
-- --------------------------------------
CREATE DATABASE blog CHARACTER SET 'utf8';
USE blog;

-- --------------------------------------
-- CREATION DE LA TABLE Utilisateur
-- --------------------------------------
CREATE TABLE Utilisateur (
    id INT UNSIGNED AUTO_INCREMENT,
    pseudo VARCHAR(45) NOT NULL,
    email VARCHAR(45),
    mot_passe VARCHAR (45) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE INDEX ind_uni_pseudo (pseudo),
    UNIQUE INDEX ind_uni_email (email)
)
ENGINE=INNODB;

-- --------------------------------------
-- CREATION DE LA TABLE Article
-- --------------------------------------
CREATE TABLE Article (
    id INT UNSIGNED AUTO_INCREMENT,
    titre VARCHAR(255) NOT NULL,
    texte_article TEXT NOT NULL,
    extrait TEXT NOT NULL,
    date_article DATETIME NOT NULL,
    auteur INT UNSIGNED NOT NULL,
    PRIMARY KEY (id),
    INDEX ind_titre (titre(150)),
    INDEX ind_date_article (date_article),
    CONSTRAINT fk_auteur_id FOREIGN KEY (auteur) REFERENCES Utilisateur(id)
)
ENGINE=INNODB;

-- --------------------------------------
-- CREATION DE LA TABLE Categorie
-- --------------------------------------
CREATE TABLE Categorie (
    id INT UNSIGNED AUTO_INCREMENT,
    nom VARCHAR(150) NOT NULL,
    description VARCHAR(255),
    PRIMARY KEY (id),
    INDEX ind_nom (nom(30))
)
ENGINE=INNODB;

-- --------------------------------------
-- CREATION DE LA TABLE Categorie_article
-- --------------------------------------
CREATE TABLE Categorie_article (
    categorie_id INT UNSIGNED,
    article_id INT UNSIGNED,
    PRIMARY KEY (categorie_id, article_id),
    CONSTRAINT fk_categorieID_id FOREIGN KEY (categorie_id) REFERENCES Categorie(id),
    CONSTRAINT fk_articleID_id FOREIGN KEY (article_id) REFERENCES Article(id)
)
ENGINE=INNODB;

-- --------------------------------------
-- CREATION DE LA TABLE Commentaire
-- --------------------------------------
CREATE TABLE Commentaire (
    id INT UNSIGNED AUTO_INCREMENT,
    texte_commentaire TEXT NOT NULL,
    date_commentaire DATETIME NOT NULL,
    article INT UNSIGNED NOT NULL,
    auteur_commentaire INT UNSIGNED,
    PRIMARY KEY (id),
    CONSTRAINT fk_article_id FOREIGN KEY (article) REFERENCES Article(id),
    CONSTRAINT fk_auteur_commentaire_id FOREIGN KEY (auteur_commentaire) REFERENCES Utilisateur(id)
)
ENGINE=INNODB;
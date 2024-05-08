DROP DATABASE IF EXISTS drugbank;
CREATE DATABASE drugbank;
USE drugbank;

DROP TABLE IF EXISTS drug_types; -- type of molecule
CREATE TABLE drug_types (
    id SERIAL PRIMARY KEY,
    name TEXT,
    created_at DATETIME DEFAULT NOW(), -- it will be possible to not mention this field when inserting
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types(
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS media;
CREATE TABLE media(
    id SERIAL PRIMARY KEY,
    media_type_id BIGINT UNSIGNED,
    body text,
    filename VARCHAR(255),
    `size` INT,
    metadata JSON,
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (media_type_id) REFERENCES media_types(id) ON UPDATE CASCADE ON DELETE SET NULL
);

DROP TABLE IF EXISTS drugs;
CREATE TABLE drugs (
    id SERIAL PRIMARY KEY, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
    name VARCHAR(255),
    generic_name VARCHAR(255) COMMENT 'Name of the generic',
    description text,
    brand_names text COMMENT 'Trade names',
    type_id BIGINT UNSIGNED,
    structure_id BIGINT UNSIGNED COMMENT 'Image of molecular structure',
    is_deleted bit default 0,
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    INDEX drugs_name_idx(name, generic_name),
    INDEX drugs_types_idx(type_id),
    FOREIGN KEY (type_id) REFERENCES drug_types(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (structure_id) REFERENCES media(id) ON UPDATE CASCADE ON DELETE SET NULL
);

DROP TABLE IF EXISTS drug_category_types; -- medical category
CREATE TABLE drug_category_types (
    id SERIAL PRIMARY KEY,
    name TEXT,
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS drug_categories_m2m;
CREATE TABLE drug_categories_m2m(
    drug_id BIGINT UNSIGNED NOT NULL,
    category_id BIGINT UNSIGNED NOT NULL,

    PRIMARY KEY(drug_id, category_id),
    INDEX drug_categories_idx(category_id),
    FOREIGN KEY (drug_id) REFERENCES drugs(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES drug_category_types(id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS drugs_pharmacology;
CREATE TABLE drugs_pharmacology (
    drug_id SERIAL PRIMARY KEY,
    indication text COMMENT 'Purpose',
    pharmacodynamics text COMMENT 'Pharmacodynamics',
    mechanism text COMMENT 'Mechanism of action',
    absorption text,
    toxicity text,

    INDEX drugs_idx(drug_id)
);

ALTER TABLE `drugs_pharmacology` ADD CONSTRAINT fk_drug_id
FOREIGN KEY (drug_id) REFERENCES drugs(id)
ON UPDATE CASCADE ON DELETE CASCADE;

DROP TABLE IF EXISTS drug_interaction_approval_types;
CREATE TABLE drug_interaction_approval_types(
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS drug_interactions_m2m;
CREATE TABLE drug_interactions_m2m(
    drug1_id BIGINT UNSIGNED NOT NULL,
    drug2_id BIGINT UNSIGNED NOT NULL,
    interaction_approval_type_id BIGINT UNSIGNED NOT NULL COMMENT 'Who researched the interaction',
    description text,
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY(drug1_id, drug2_id),
    FOREIGN KEY (interaction_approval_type_id) REFERENCES drug_interaction_approval_types(id) ON UPDATE CASCADE ON DELETE CASCADE
);

ALTER TABLE `drug_interactions_m2m` ADD CONSTRAINT fk_drug1_id
FOREIGN KEY (drug1_id) REFERENCES drugs(id)
ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE `drug_interactions_m2m` ADD CONSTRAINT fk_drug2_id
FOREIGN KEY (drug2_id) REFERENCES drugs(id)
ON UPDATE CASCADE ON DELETE CASCADE;

DROP TABLE IF EXISTS metabolic_pathways; -- metabolic pathways - link to external reference
CREATE TABLE metabolic_pathways(
    drug_id SERIAL PRIMARY KEY,
    url VARCHAR(255),
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

ALTER TABLE `metabolic_pathways` ADD CONSTRAINT fk_drug_id1
FOREIGN KEY (drug_id) REFERENCES drugs(id)
ON UPDATE CASCADE ON DELETE CASCADE;

DROP TABLE IF EXISTS targets; -- molecular targets
CREATE TABLE targets (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    organism ENUM('human', 'animal'),
    general_function text,
    specific_function text,
    gene_name VARCHAR(100),
    uniprot_id VARCHAR(32) COMMENT 'ID from Uniprot system',

    INDEX targets_name_idx(name),
    INDEX targets_organism_idx(organism)
);

DROP TABLE IF EXISTS drugs_targets_m2m; -- molecular interaction with a target
CREATE TABLE drugs_targets_m2m (
    drug_id BIGINT UNSIGNED NOT NULL,
    target_id BIGINT UNSIGNED NOT NULL,
    action ENUM('agonist', 'antagonist'),

    PRIMARY KEY(drug_id, target_id),
    INDEX drugs_idx(drug_id)
);

ALTER TABLE `drugs_targets_m2m` ADD CONSTRAINT fk_drug_id2
FOREIGN KEY (drug_id) REFERENCES drugs(id)
ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE `drugs_targets_m2m` ADD CONSTRAINT fk_target_id
FOREIGN KEY (target_id) REFERENCES targets(id)
ON UPDATE CASCADE ON DELETE CASCADE;

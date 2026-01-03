-- Flyway V1: Train-related schema
-- Removed database selection statements; Flyway runs against configured datasource
DROP TABLE IF EXISTS train;
CREATE TABLE train (
    train_id       INT           NOT NULL PRIMARY KEY AUTO_INCREMENT,
    train_name     VARCHAR(255)  NOT NULL,
    train_number   VARCHAR(255)  NOT NULL UNIQUE,
    train_category ENUM('EXPRESS','LOCAL','FREIGHT','HIGH_SPEED') NOT NULL,
    in_service     BOOLEAN       NOT NULL DEFAULT TRUE
);

DROP TABLE IF EXISTS coach_type;
CREATE TABLE coach_type (
    coach_type_id   INT          NOT NULL PRIMARY KEY AUTO_INCREMENT,
    coach_type_name VARCHAR(255) NOT NULL UNIQUE,
    description VARCHAR(255) ,
    capacity INT         NOT NULL,
    has_ac          BOOLEAN      NOT NULL DEFAULT TRUE
);

DROP TABLE IF EXISTS berth_type;
CREATE TABLE berth_type (
    berth_type_id   INT          NOT NULL PRIMARY KEY AUTO_INCREMENT,
    berth_type_name varchar(40) NOT NULL UNIQUE,
    description     VARCHAR(512) NOT NULL
);

DROP TABLE IF EXISTS coach_type_berth;
CREATE TABLE coach_type_berth (
    coach_type_id INT NOT NULL,
    berth_type_id INT NOT NULL,
    berth_number INT NOT NULL,
    PRIMARY KEY (coach_type_id, berth_type_id, berth_number),
    FOREIGN KEY (coach_type_id) REFERENCES coach_type(coach_type_id) ON DELETE CASCADE,
    FOREIGN KEY (berth_type_id) REFERENCES berth_type(berth_type_id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS train_coach;
CREATE TABLE train_coach (
    train_coach_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    train_id       INT NOT NULL,
    coach_type_id  INT NOT NULL,
    coach_number   VARCHAR(50) NOT NULL,
    position_in_train INT NOT NULL,
    FOREIGN KEY (train_id) REFERENCES train(train_id) ON DELETE CASCADE,
    FOREIGN KEY (coach_type_id) REFERENCES coach_type(coach_type_id) ON DELETE CASCADE,
    UNIQUE (train_id, coach_number)
);


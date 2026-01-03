-- Flyway V2: Station schema
DROP TABLE IF EXISTS station;
CREATE TABLE station
(
    station_id     INT           NOT NULL AUTO_INCREMENT,
    station_name   VARCHAR(255)  NOT NULL,
    station_code   VARCHAR(255)  NOT NULL UNIQUE,
    latitude       DOUBLE        NOT NULL,
    longitude      DOUBLE        NOT NULL,
    platform_count INT           NOT NULL,
    PRIMARY KEY (station_id)
);


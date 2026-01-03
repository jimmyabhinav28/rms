-- Undo for V1__train_schema.sql
-- Drops train-related tables; order matters due to FKs
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS train_coach;
DROP TABLE IF EXISTS coach_type_berth;
DROP TABLE IF EXISTS berth_type;
DROP TABLE IF EXISTS coach_type;
DROP TABLE IF EXISTS train;
SET FOREIGN_KEY_CHECKS = 1;


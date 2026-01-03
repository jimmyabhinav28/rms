-- Undo for V4__seed_icf_ac2_old.sql
-- Remove berth mappings and coach type for AC2_ICF_OLD
DELETE FROM coach_type_berth WHERE coach_type_id = (SELECT coach_type_id FROM coach_type WHERE coach_type_name = 'AC2_ICF_OLD');
DELETE FROM train_coach WHERE coach_type_id = (SELECT coach_type_id FROM coach_type WHERE coach_type_name = 'AC2_ICF_OLD');
DELETE FROM coach_type WHERE coach_type_name = 'AC2_ICF_OLD';

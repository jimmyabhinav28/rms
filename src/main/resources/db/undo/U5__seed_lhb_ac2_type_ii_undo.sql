-- Undo for V5__seed_lhb_ac2_type_ii.sql
-- Remove berth mappings and coach type for LHB_AC2_TYPE_II
DELETE FROM coach_type_berth WHERE coach_type_id = (SELECT coach_type_id FROM coach_type WHERE coach_type_name = 'LHB_AC2_TYPE_II');
DELETE FROM train_coach WHERE coach_type_id = (SELECT coach_type_id FROM coach_type WHERE coach_type_name = 'LHB_AC2_TYPE_II');
DELETE FROM coach_type WHERE coach_type_name = 'LHB_AC2_TYPE_II';

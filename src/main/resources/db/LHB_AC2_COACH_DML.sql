-- LHB_AC2_COACH_DML.sql
-- Define LHB - AC 2-Tier (Type II, New Version) coach type and map its berth numbers to berth types
-- Assumptions (same schema as AC2_ICF_OLD script):
--  - coachType(coach_type_id PK, coach_type_name UNIQUE, description, capacity, has_ac)
--  - berthType(berth_type_id PK, berth_type_name UNIQUE, description)
--  - coachTypeBerth(coach_type_id FK, berthNumber INT, berth_type_id FK, UNIQUE(coach_type_id, berthNumber))
--  - Required berth types exist: AC2_LOWER, AC2_UPPER, AC2_SIDE_LOWER, AC2_SIDE_UPPER

-- 1) Create/ensure LHB AC2 Type II coach type exists (capacity 52)
INSERT INTO coach_type (coach_type_name, description, capacity, has_ac)
VALUES ('LHB_AC2_TYPE_II', 'LHB - AC 2-Tier Layout (Type II, New Version); 52 berths with LB/UB + SL/SU pairs across bays', 52, TRUE)
ON DUPLICATE KEY UPDATE description=VALUES(description), capacity=VALUES(capacity), has_ac=VALUES(has_ac);

-- 2) Resolve IDs once (no joins in the multi-row insert)
SET @ct_id = (SELECT coach_type_id FROM coach_type WHERE coach_type_name = 'LHB_AC2_TYPE_II');
SET @bt_lb = (SELECT berth_type_id FROM berth_type WHERE berth_type_name = 'AC2_LOWER');
SET @bt_ub = (SELECT berth_type_id FROM berth_type WHERE berth_type_name = 'AC2_UPPER');
SET @bt_sl = (SELECT berth_type_id FROM berth_type WHERE berth_type_name = 'AC2_SIDE_LOWER');
SET @bt_su = (SELECT berth_type_id FROM berth_type WHERE berth_type_name = 'AC2_SIDE_UPPER');

-- 3) Map berth numbers 1..52 using repeating LB, UB, SL, SU pattern per bay
INSERT INTO coach_type_berth (coach_type_id, berth_number, berth_type_id)
VALUES
(@ct_id,  1, @bt_lb), (@ct_id,  2, @bt_ub), (@ct_id,  3, @bt_sl), (@ct_id,  4, @bt_su),
(@ct_id,  5, @bt_lb), (@ct_id,  6, @bt_ub), (@ct_id,  7, @bt_sl), (@ct_id,  8, @bt_su),
(@ct_id,  9, @bt_lb), (@ct_id, 10, @bt_ub), (@ct_id, 11, @bt_sl), (@ct_id, 12, @bt_su),
(@ct_id, 13, @bt_lb), (@ct_id, 14, @bt_ub), (@ct_id, 15, @bt_sl), (@ct_id, 16, @bt_su),
(@ct_id, 17, @bt_lb), (@ct_id, 18, @bt_ub), (@ct_id, 19, @bt_sl), (@ct_id, 20, @bt_su),
(@ct_id, 21, @bt_lb), (@ct_id, 22, @bt_ub), (@ct_id, 23, @bt_sl), (@ct_id, 24, @bt_su),
(@ct_id, 25, @bt_lb), (@ct_id, 26, @bt_ub), (@ct_id, 27, @bt_sl), (@ct_id, 28, @bt_su),
(@ct_id, 29, @bt_lb), (@ct_id, 30, @bt_ub), (@ct_id, 31, @bt_sl), (@ct_id, 32, @bt_su),
(@ct_id, 33, @bt_lb), (@ct_id, 34, @bt_ub), (@ct_id, 35, @bt_sl), (@ct_id, 36, @bt_su),
(@ct_id, 37, @bt_lb), (@ct_id, 38, @bt_ub), (@ct_id, 39, @bt_sl), (@ct_id, 40, @bt_su),
(@ct_id, 41, @bt_lb), (@ct_id, 42, @bt_ub), (@ct_id, 43, @bt_sl), (@ct_id, 44, @bt_su),
(@ct_id, 45, @bt_lb), (@ct_id, 46, @bt_ub), (@ct_id, 47, @bt_sl), (@ct_id, 48, @bt_su),
(@ct_id, 49, @bt_lb), (@ct_id, 50, @bt_ub), (@ct_id, 51, @bt_sl), (@ct_id, 52, @bt_su)
ON DUPLICATE KEY UPDATE berth_type_id = VALUES(berth_type_id);


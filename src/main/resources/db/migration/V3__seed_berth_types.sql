-- Flyway V3: Seed berth types (idempotent)
INSERT INTO berth_type(berth_type_name, description) VALUES ('SLEEPER_LOWER', 'Non-AC Sleeper class lower berth (SL); bottom berth in a 3-tier non-AC bay. Preferred for easier access.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO berth_type(berth_type_name, description) VALUES ('SLEEPER_MIDDLE', 'Non-AC Sleeper class middle berth (SL); middle tier in a 3-tier non-AC bay; folds during daytime seating.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO berth_type(berth_type_name, description) VALUES ('SLEEPER_UPPER', 'Non-AC Sleeper class upper berth (SL); top berth in a 3-tier non-AC bay; better privacy, tougher access.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO berth_type(berth_type_name, description) VALUES ('SLEEPER_SIDE_LOWER', 'Non-AC Sleeper class side lower berth along the aisle; converts to seats during daytime.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO berth_type(berth_type_name, description) VALUES ('SLEEPER_SIDE_UPPER', 'Non-AC Sleeper class side upper berth along the aisle above the side lower.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO berth_type(berth_type_name, description) VALUES ('AC3_UPPER', 'AC 3-Tier (3A) upper berth in an air-conditioned 3-tier bay; bedding provided.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO berth_type(berth_type_name, description) VALUES ('AC3_MIDDLE', 'AC 3-Tier (3A) middle berth in an air-conditioned 3-tier bay; folds during daytime seating.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO berth_type(berth_type_name, description) VALUES ('AC3_LOWER', 'AC 3-Tier (3A) lower berth in an air-conditioned 3-tier bay; easiest access; bedding provided.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO berth_type(berth_type_name, description) VALUES ('AC3_SIDE_LOWER', 'AC 3-Tier (3A) side lower berth along the aisle; converts to seats in daytime.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO berth_type(berth_type_name, description) VALUES ('AC3_SIDE_UPPER', 'AC 3-Tier (3A) side upper berth along the aisle above the side lower.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO berth_type(berth_type_name, description) VALUES ('AC2_LOWER', 'AC 2-Tier (2A) lower berth in an air-conditioned 2-tier bay; no middle berth; more space.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO berth_type(berth_type_name, description) VALUES ('AC2_UPPER', 'AC 2-Tier (2A) upper berth in an air-conditioned 2-tier bay; bedding provided.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO berth_type(berth_type_name, description) VALUES ('AC2_SIDE_UPPER', 'AC 2-Tier (2A) side upper berth along the aisle above the side lower.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO berth_type(berth_type_name, description) VALUES ('AC2_SIDE_LOWER', 'AC 2-Tier (2A) side lower berth along the aisle; converts to seats in daytime.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO berth_type(berth_type_name, description) VALUES ('AC1_LOWER_CABIN', 'AC First Class (1A) cabin lower berth; enclosed compartment with door; highest comfort and privacy.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO berth_type(berth_type_name, description) VALUES ('AC1_UPPER_CABIN', 'AC First Class (1A) cabin upper berth; enclosed compartment with door; premium comfort.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO berth_type(berth_type_name, description) VALUES ('AC1_COUPE_LOWER', 'AC First Class (1A) coupe lower berth; two-berth private coupe; highest privacy.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO berth_type(berth_type_name, description) VALUES ('AC1_COUPE_UPPER', 'AC First Class (1A) coupe upper berth; two-berth private coupe; highest privacy.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO berth_type(berth_type_name, description) VALUES ('CC_WINDOW', 'Chair Car (CC) window seat in an air-conditioned sitting coach (typically 2x3 layout).')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO berth_type(berth_type_name, description) VALUES ('CC_MIDDLE', 'Chair Car (CC) middle seat in a 3-seat row; between window and aisle; sitting only.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO berth_type(berth_type_name, description) VALUES ('CC_AISLE', 'Chair Car (CC) aisle seat; easiest access to aisle; sitting only.')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO berth_type(berth_type_name, description) VALUES ('EC_AISLE', 'Executive Chair Car (EC) aisle seat in premium air-conditioned sitting coach (typically 2x2 layout).')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO berth_type(berth_type_name, description) VALUES ('EC_WINDOW', 'Executive Chair Car (EC) window seat in premium air-conditioned sitting coach (typically 2x2 layout).')
ON DUPLICATE KEY UPDATE description=VALUES(description);
INSERT INTO berth_type(berth_type_name, description) VALUES ('GENERAL_SEAT', 'Unreserved general seating in non-AC coaches; first-come-first-served, no reservation.')
ON DUPLICATE KEY UPDATE description=VALUES(description);


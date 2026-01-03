# Manual Undo Scripts

This folder contains manual undo SQL scripts corresponding to each Flyway migration. These are NOT executed by Flyway automatically. Use them carefully to revert changes when necessary.

## Scripts
- U1__train_schema_undo.sql: Drops train-related schema (train, coach_type, berth_type, etc.).
- U2__station_schema_undo.sql: Drops station table.
- U3__seed_berth_types_undo.sql: Removes seeded berth types.
- U4__seed_icf_ac2_old_undo.sql: Removes AC2_ICF_OLD coach type and its berth mappings; deletes dependent train_coach rows first.
- U5__seed_lhb_ac2_type_ii_undo.sql: Removes LHB_AC2_TYPE_II coach type and its berth mappings; deletes dependent train_coach rows first.

## Usage Notes
- Always review foreign key relationships before deletion.
- Recommended order when reverting seeds:
  1. Remove berth mappings and coach types (U4, U5).
  2. Remove berth types (U3) only if not referenced.
  3. Drop schema tables (U1, U2) as a last resort.
- For MySQL, consider running within a transaction if your environment supports it, and ensure appropriate privileges.
- Backup your data before running undo scripts in production.


-- Drop the table state_populations

DROP TABLE state_populations;

-- Since the table is just dropped, a select query on this table faults, as expected

SELECT * FROM state_populations;
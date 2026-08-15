-- Crime Record Management System (CRMS)
-- DBMS Concept Demonstration SQL Queries Script

USE crime_record_management;

-- 1. DQL & AGGREGATE FUNCTIONS WITH GROUP BY & HAVING
-- Query: Total crimes by category with total count > 1
SELECT 
    crime_type, 
    COUNT(*) AS total_incidents,
    SUM(CASE WHEN severity = 'Critical' THEN 1 ELSE 0 END) AS critical_count,
    SUM(CASE WHEN status = 'Solved' THEN 1 ELSE 0 END) AS solved_count
FROM crimes
GROUP BY crime_type
HAVING COUNT(*) >= 1
ORDER BY total_incidents DESC;

-- 2. INNER JOIN & LEFT JOIN DEMONSTRATION
-- Query: Retrieve complete Case details with FIR, Crime, Officer, & Station info
SELECT 
    c.case_number,
    f.fir_number,
    cr.crime_type,
    cr.severity,
    c.case_status,
    c.priority,
    po.name AS investigating_officer,
    ps.station_name AS assigned_station,
    v.name AS victim_name
FROM cases c
INNER JOIN FIR f ON c.fir_id = f.fir_id
INNER JOIN crimes cr ON f.crime_id = cr.crime_id
INNER JOIN police_stations ps ON f.station_id = ps.station_id
INNER JOIN victims v ON f.victim_id = v.victim_id
LEFT JOIN police_officers po ON c.investigating_officer_id = po.officer_id
ORDER BY c.start_date DESC;

-- 3. MANY-TO-MANY (M:N) JOIN WITH COMPOSITE KEYS
-- Query: Criminal involvement in cases with case status and involvement type
SELECT 
    cr.name AS criminal_name,
    cr.alias,
    cr.status AS criminal_status,
    c.case_number,
    cc.involvement_type,
    cm.crime_type
FROM criminal_cases cc
INNER JOIN criminals cr ON cc.criminal_id = cr.criminal_id
INNER JOIN cases c ON cc.case_id = c.case_id
INNER JOIN FIR f ON c.fir_id = f.fir_id
INNER JOIN crimes cm ON f.crime_id = cm.crime_id
ORDER BY cr.name;

-- 4. SUBQUERY DEMONSTRATION
-- Query: Find officers who are investigating more than the average number of active cases
SELECT 
    po.officer_id,
    po.name,
    po.rank,
    po.badge_number,
    COUNT(c.case_id) AS active_case_count
FROM police_officers po
JOIN cases c ON po.officer_id = c.investigating_officer_id
WHERE c.case_status IN ('Active', 'In Court')
GROUP BY po.officer_id, po.name, po.rank, po.badge_number
HAVING COUNT(c.case_id) >= (
    SELECT AVG(active_count) FROM (
        SELECT COUNT(case_id) AS active_count
        FROM cases
        WHERE case_status IN ('Active', 'In Court')
        GROUP BY investigating_officer_id
    ) AS officer_counts
);

-- 5. DATABASE VIEW USAGE
-- Query: Select summary data from case_summary_view
SELECT * FROM case_summary_view WHERE case_status = 'Active';

-- Query: Select workload metrics from officer_workload_view
SELECT * FROM officer_workload_view ORDER BY active_cases DESC;

-- 6. TRANSACTION DEMONSTRATION
-- Scenario: Transactional Registration of FIR + Automatic Case Generation + Officer Assignment
START TRANSACTION;

-- Step 1: Insert Crime
INSERT INTO crimes (crime_type, description, crime_date, crime_time, location, city, state, severity, status)
VALUES ('Grand Larceny', 'Theft of high value artwork from art gallery', '2026-04-12', '21:00:00', '15 Art Plaza', 'Delhi', 'Delhi', 'Major', 'Under Investigation');

SET @new_crime_id = LAST_INSERT_ID();

-- Step 2: Insert Victim
INSERT INTO victims (name, age, gender, address, phone)
VALUES ('Julian Vance', 51, 'Male', '15 Art Plaza', '9811122299');

SET @new_victim_id = LAST_INSERT_ID();

-- Step 3: Insert FIR
INSERT INTO FIR (fir_number, crime_id, victim_id, station_id, filing_date, description, status)
VALUES ('FIR-2026-9999', @new_crime_id, @new_victim_id, 1, '2026-04-13', 'Artwork theft FIR filed by curator.', 'Approved');

SET @new_fir_id = LAST_INSERT_ID();

-- Step 4: Create Case automatically
INSERT INTO cases (case_number, fir_id, investigating_officer_id, case_status, priority, start_date, remarks)
VALUES ('CASE-2026-9999', @new_fir_id, 1, 'Active', 'High', '2026-04-13', 'Special art theft unit assigned.');

COMMIT;

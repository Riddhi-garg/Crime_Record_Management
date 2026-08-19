-- Crime Record Management System (CRMS)
-- Database Schema Script (MySQL Compatible)
-- Database Name: crime_record_management
-- Demonstrating 3NF Normalization, PKs, FKs, Indexes, Constraints, and Views
CREATE DATABASE IF NOT EXISTS crime_record_management;
USE crime_record_management;

-- Table 1: users
-- Holds system authentication and RBAC roles (Admin, Officer)
DROP TABLE IF EXISTS users;
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('Admin', 'Officer') NOT NULL DEFAULT 'Officer',
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- Table 2: police_stations
-- Administrative police precincts
DROP TABLE IF EXISTS police_stations;
CREATE TABLE police_stations (
    station_id INT AUTO_INCREMENT PRIMARY KEY,
    station_name VARCHAR(100) NOT NULL UNIQUE,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    contact_number VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table 3: police_officers
-- Police officers assigned to police stations
DROP TABLE IF EXISTS police_officers;
CREATE TABLE police_officers (
    officer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    rank VARCHAR(50) NOT NULL,
    badge_number VARCHAR(50) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    station_id INT NOT NULL,
    user_id INT UNIQUE NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_officer_station FOREIGN KEY (station_id) 
        REFERENCES police_stations(station_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_officer_user FOREIGN KEY (user_id) 
        REFERENCES users(user_id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table 4: criminals
-- Master record of identified criminals / suspects
DROP TABLE IF EXISTS criminals;
CREATE TABLE criminals (
    criminal_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    alias VARCHAR(100),
    date_of_birth DATE,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    address TEXT,
    phone VARCHAR(20),
    identification_details TEXT, -- Marks, tattoos, national identity
    status ENUM('Wanted', 'In Custody', 'Bail', 'Convicted', 'Acquitted') DEFAULT 'Wanted',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table 5: victims
-- Complainants and victims of reported crimes
DROP TABLE IF EXISTS victims;
CREATE TABLE victims (
    victim_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT CHECK (age >= 0 AND age <= 120),
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    address TEXT,
    phone VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table 6: witnesses
-- Witnesses to reported crimes or cases
DROP TABLE IF EXISTS witnesses;
CREATE TABLE witnesses (
    witness_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT CHECK (age >= 0 AND age <= 120),
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    address TEXT,
    phone VARCHAR(20),
    statement TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table 7: crimes
-- Crime incident occurrences catalog
DROP TABLE IF EXISTS crimes;
CREATE TABLE crimes (
    crime_id INT AUTO_INCREMENT PRIMARY KEY,
    crime_type VARCHAR(100) NOT NULL, -- e.g. Theft, Homicide, Cybercrime, Robbery
    description TEXT NOT NULL,
    crime_date DATE NOT NULL,
    crime_time TIME,
    location VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    severity ENUM('Critical', 'Major', 'Minor') NOT NULL DEFAULT 'Major',
    status ENUM('Reported', 'Under Investigation', 'Solved', 'Unsolved', 'Closed') DEFAULT 'Reported',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table 8: FIR (First Information Report)
-- Official FIR reports filed at stations
DROP TABLE IF EXISTS FIR;
CREATE TABLE FIR (
    fir_id INT AUTO_INCREMENT PRIMARY KEY,
    fir_number VARCHAR(50) NOT NULL UNIQUE,
    crime_id INT NOT NULL,
    victim_id INT NOT NULL,
    station_id INT NOT NULL,
    filing_date DATE NOT NULL,
    description TEXT NOT NULL,
    status ENUM('Pending', 'Approved', 'Rejected', 'Under Investigation', 'Closed') DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_fir_crime FOREIGN KEY (crime_id) 
        REFERENCES crimes(crime_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_fir_victim FOREIGN KEY (victim_id) 
        REFERENCES victims(victim_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_fir_station FOREIGN KEY (station_id) 
        REFERENCES police_stations(station_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table 9: cases
-- Active legal cases generated from FIRs
DROP TABLE IF EXISTS cases;
CREATE TABLE cases (
    case_id INT AUTO_INCREMENT PRIMARY KEY,
    case_number VARCHAR(50) NOT NULL UNIQUE,
    fir_id INT NOT NULL UNIQUE,
    investigating_officer_id INT,
    case_status ENUM('Active', 'Pending', 'In Court', 'Solved', 'Closed') NOT NULL DEFAULT 'Active',
    priority ENUM('High', 'Medium', 'Low') NOT NULL DEFAULT 'Medium',
    start_date DATE NOT NULL,
    closing_date DATE NULL,
    remarks TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_case_fir FOREIGN KEY (fir_id) 
        REFERENCES FIR(fir_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_case_officer FOREIGN KEY (investigating_officer_id) 
        REFERENCES police_officers(officer_id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table 10: criminal_cases (Junction table - Many to Many)
-- Link between criminals and cases with involvement type
-- Composite Primary Key (criminal_id, case_id)
DROP TABLE IF EXISTS criminal_cases;
CREATE TABLE criminal_cases (
    criminal_id INT NOT NULL,
    case_id INT NOT NULL,
    involvement_type ENUM('Prime Suspect', 'Co-Accused', 'Accomplice', 'Mastermind', 'Witness/Suspect') DEFAULT 'Prime Suspect',
    PRIMARY KEY (criminal_id, case_id),
    CONSTRAINT fk_cc_criminal FOREIGN KEY (criminal_id) 
        REFERENCES criminals(criminal_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_cc_case FOREIGN KEY (case_id) 
        REFERENCES cases(case_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table 11: evidence
-- Evidence items gathered for a case
DROP TABLE IF EXISTS evidence;
CREATE TABLE evidence (
    evidence_id INT AUTO_INCREMENT PRIMARY KEY,
    case_id INT NOT NULL,
    evidence_type VARCHAR(100) NOT NULL, -- Physical, Digital, Forensic, Weapon, Document
    description TEXT NOT NULL,
    collected_date DATE NOT NULL,
    collected_by INT,
    storage_location VARCHAR(255) NOT NULL,
    status ENUM('In Storage', 'In Lab', 'Presented in Court', 'Disposed') DEFAULT 'In Storage',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_evidence_case FOREIGN KEY (case_id) 
        REFERENCES cases(case_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_evidence_officer FOREIGN KEY (collected_by) 
        REFERENCES police_officers(officer_id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table 12: arrests
-- Arrest records of criminals related to specific cases
DROP TABLE IF EXISTS arrests;
CREATE TABLE arrests (
    arrest_id INT AUTO_INCREMENT PRIMARY KEY,
    criminal_id INT NOT NULL,
    case_id INT NOT NULL,
    officer_id INT,
    arrest_date DATETIME NOT NULL,
    arrest_location VARCHAR(255) NOT NULL,
    arrest_status ENUM('In Lockup', 'Remand', 'Bailed', 'Transferred to Prison', 'Released') DEFAULT 'In Lockup',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_arrest_criminal FOREIGN KEY (criminal_id) 
        REFERENCES criminals(criminal_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_arrest_case FOREIGN KEY (case_id) 
        REFERENCES cases(case_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_arrest_officer FOREIGN KEY (officer_id) 
        REFERENCES police_officers(officer_id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table 13: court_records
-- Legal proceedings and court verdicts
DROP TABLE IF EXISTS court_records;
CREATE TABLE court_records (
    court_id INT AUTO_INCREMENT PRIMARY KEY,
    case_id INT NOT NULL,
    court_name VARCHAR(150) NOT NULL,
    hearing_date DATE NOT NULL,
    judge_name VARCHAR(100) NOT NULL,
    verdict ENUM('Pending', 'Guilty', 'Not Guilty', 'Dismissed', 'Settled') DEFAULT 'Pending',
    sentence TEXT,
    case_status VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_court_case FOREIGN KEY (case_id) 
        REFERENCES cases(case_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table 14: case_updates
-- Investigation timeline updates logged by officers
DROP TABLE IF EXISTS case_updates;
CREATE TABLE case_updates (
    update_id INT AUTO_INCREMENT PRIMARY KEY,
    case_id INT NOT NULL,
    officer_id INT,
    update_text TEXT NOT NULL,
    update_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_cu_case FOREIGN KEY (case_id) 
        REFERENCES cases(case_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_cu_officer FOREIGN KEY (officer_id) 
        REFERENCES police_officers(officer_id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table 15: news_events
-- Official announcements, news bulletins, and tenders
DROP TABLE IF EXISTS news_events;
CREATE TABLE news_events (
    news_id INT AUTO_INCREMENT PRIMARY KEY,
    category ENUM('NEWS & EVENTS', 'TENDERS', 'NOTIFICATIONS', 'CIRCULARS') DEFAULT 'NEWS & EVENTS',
    title VARCHAR(255) NOT NULL,
    description TEXT,
    date_posted DATE NOT NULL,
    file_attachment VARCHAR(255),
    status ENUM('Active', 'Archived') DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table 16: photo_gallery
-- Official NCRB photo gallery albums
DROP TABLE IF EXISTS photo_gallery;
CREATE TABLE photo_gallery (
    gallery_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    category VARCHAR(100) DEFAULT 'Event',
    event_date DATE NOT NULL,
    photo_count INT DEFAULT 1,
    cover_image VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table 17: anonymous_tips
-- Citizen confidential crime tip submissions
DROP TABLE IF EXISTS anonymous_tips;
CREATE TABLE anonymous_tips (
    tip_id INT AUTO_INCREMENT PRIMARY KEY,
    tracking_code VARCHAR(50) UNIQUE NOT NULL,
    crime_type VARCHAR(100) NOT NULL,
    location VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    date_submitted DATETIME NOT NULL,
    status ENUM('Received', 'Under Review', 'Action Taken', 'Dismissed') DEFAULT 'Received',
    assigned_officer_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_tip_officer FOREIGN KEY (assigned_officer_id) 
        REFERENCES police_officers(officer_id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table 18: fingerprints
-- Biometric minutiae records linked to criminal profiles
DROP TABLE IF EXISTS fingerprints;
CREATE TABLE fingerprints (
    fingerprint_id INT AUTO_INCREMENT PRIMARY KEY,
    criminal_id INT NOT NULL,
    finger_position VARCHAR(50) NOT NULL,
    minutiae_pattern VARCHAR(255) NOT NULL,
    ridge_count INT DEFAULT 14,
    pattern_type ENUM('Loop', 'Whorl', 'Arch', 'Accidental') DEFAULT 'Loop',
    image_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_fp_criminal FOREIGN KEY (criminal_id) 
        REFERENCES criminals(criminal_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- INDEXES FOR OPTIMIZED SEARCH & JOIN PERFORMANCE
CREATE INDEX idx_crimes_type ON crimes(crime_type);
CREATE INDEX idx_crimes_status ON crimes(status);
CREATE INDEX idx_crimes_location ON crimes(city, state);
CREATE INDEX idx_criminals_name ON criminals(name);
CREATE INDEX idx_cases_status ON cases(case_status);
CREATE INDEX idx_fir_number ON FIR(fir_number);
CREATE INDEX idx_officer_badge ON police_officers(badge_number);

-- DATABASE VIEWS
-- View 1: case_summary_view
-- Joins cases, FIR, crimes, officers, and stations for simplified queries
CREATE OR REPLACE VIEW case_summary_view AS
SELECT 
    c.case_id,
    c.case_number,
    f.fir_number,
    cr.crime_type,
    cr.severity,
    c.case_status,
    c.priority,
    c.start_date,
    c.closing_date,
    po.name AS officer_name,
    po.rank AS officer_rank,
    ps.station_name,
    ps.city AS station_city
FROM cases c
INNER JOIN FIR f ON c.fir_id = f.fir_id
INNER JOIN crimes cr ON f.crime_id = cr.crime_id
INNER JOIN police_stations ps ON f.station_id = ps.station_id
LEFT JOIN police_officers po ON c.investigating_officer_id = po.officer_id;

-- View 2: officer_workload_view
-- Aggregates current assigned active/pending cases per officer
CREATE OR REPLACE VIEW officer_workload_view AS
SELECT 
    po.officer_id,
    po.name AS officer_name,
    po.badge_number,
    po.rank,
    ps.station_name,
    COUNT(c.case_id) AS total_assigned_cases,
    SUM(CASE WHEN c.case_status IN ('Active', 'Pending', 'In Court') THEN 1 ELSE 0 END) AS active_cases,
    SUM(CASE WHEN c.case_status = 'Solved' THEN 1 ELSE 0 END) AS solved_cases
FROM police_officers po
INNER JOIN police_stations ps ON po.station_id = ps.station_id
LEFT JOIN cases c ON po.officer_id = c.investigating_officer_id
GROUP BY po.officer_id, po.name, po.badge_number, po.rank, ps.station_name;

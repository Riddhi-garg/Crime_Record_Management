-- Crime Record Management System (CRMS)
-- Realistic Sample Data Population Script

USE crime_record_management;

-- Clear existing data in reverse FK order
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE case_updates;
TRUNCATE TABLE court_records;
TRUNCATE TABLE arrests;
TRUNCATE TABLE evidence;
TRUNCATE TABLE criminal_cases;
TRUNCATE TABLE cases;
TRUNCATE TABLE FIR;
TRUNCATE TABLE crimes;
TRUNCATE TABLE witnesses;
TRUNCATE TABLE victims;
TRUNCATE TABLE criminals;
TRUNCATE TABLE police_officers;
TRUNCATE TABLE police_stations;
TRUNCATE TABLE users;
SET FOREIGN_KEY_CHECKS = 1;

-- 1. Insert Users (Hashed password for 'admin123' and 'officer123')
-- Admin: admin / admin123
-- Officer: officer1 / officer123, officer2 / officer123, officer3 / officer123
INSERT INTO users (user_id, username, password, role, full_name, email) VALUES
(1, 'admin', 'scrypt:32768:8:1$k52Q40wR0XN4Z8Jk$8b18d2dca79d7249911e3fffaee3e5eb56e87bc7e95147575dbbfa139886361a3e9c606df48dfadfc8cbba914ea98f12a20ca4d9a175f73ed2ce5bcac932fcd4', 'Admin', 'Director General Arthur Vance', 'admin@crms.gov.in'),
(2, 'officer1', 'scrypt:32768:8:1$X8gT50wR0XN4Z8Jk$1c1071ee52c222ff492cb91a6d48dc776495dbbf770857efef290b21a8dcf86f87427b3b3cb55c11d4e13292495d4edca297cb73b318d1a1b55ff8e89920194c', 'Officer', 'Inspector Rajesh Kumar', 'rajesh.kumar@crms.gov.in'),
(3, 'officer2', 'scrypt:32768:8:1$X8gT50wR0XN4Z8Jk$1c1071ee52c222ff492cb91a6d48dc776495dbbf770857efef290b21a8dcf86f87427b3b3cb55c11d4e13292495d4edca297cb73b318d1a1b55ff8e89920194c', 'Officer', 'Sub-Inspector Priya Sharma', 'priya.sharma@crms.gov.in'),
(4, 'officer3', 'scrypt:32768:8:1$X8gT50wR0XN4Z8Jk$1c1071ee52c222ff492cb91a6d48dc776495dbbf770857efef290b21a8dcf86f87427b3b3cb55c11d4e13292495d4edca297cb73b318d1a1b55ff8e89920194c', 'Officer', 'ACP Vikramaditya Singh', 'vikram.singh@crms.gov.in'),
(5, 'officer4', 'scrypt:32768:8:1$X8gT50wR0XN4Z8Jk$1c1071ee52c222ff492cb91a6d48dc776495dbbf770857efef290b21a8dcf86f87427b3b3cb55c11d4e13292495d4edca297cb73b318d1a1b55ff8e89920194c', 'Officer', 'Inspector Ananya Roy', 'ananya.roy@crms.gov.in');

-- 2. Insert Police Stations (10 Stations)

INSERT INTO police_stations (station_id, station_name, address, city, state, contact_number) VALUES
(1, 'Central Police Station', '100 MG Road, Civil Lines', 'Metro City', 'State North', '011-23456701'),
(2, 'Cyber Crime HQ', 'Tech Park Avenue, Sector 5', 'Metro City', 'State North', '011-23456702'),
(3, 'North District Station', '45 Grand Trunk Road', 'Metro City', 'State North', '011-23456703'),
(4, 'South Avenue Precinct', '12 Ring Road, South Extension', 'Metro City', 'State North', '011-23456704'),
(5, 'Harbor Maritime Station', 'Dockyard Complex, Pier 4', 'Port Town', 'State Coast', '022-87654301'),
(6, 'Highland Police Post', '78 Ridge View, Hill Area', 'Pine Valley', 'State North', '011-23456706'),
(7, 'Westside Precinct', '89 Park Street, West Suburbs', 'Metro City', 'State North', '011-23456707'),
(8, 'Industrial Zone Station', 'Phase 3, Industrial Estate', 'Steel Town', 'State East', '033-98765401'),
(9, 'Airport Security Precinct', 'Terminal 2 Rd, IGI Zone', 'Metro City', 'State North', '011-23456709'),
(10, 'East End Police Station', '23 Riverfront Road', 'Metro City', 'State North', '011-23456710');

-- 3. Insert Police Officers (20 Officers)
INSERT INTO police_officers (officer_id, name, rank, badge_number, phone, email, station_id, user_id) VALUES
(1, 'Rajesh Kumar', 'Inspector', 'BP-1001', '9876543210', 'rajesh.kumar@crms.gov.in', 1, 2),
(2, 'Priya Sharma', 'Sub-Inspector', 'BP-1002', '9876543211', 'priya.sharma@crms.gov.in', 2, 3),
(3, 'Vikramaditya Singh', 'ACP', 'BP-1003', '9876543212', 'vikram.singh@crms.gov.in', 1, 4),
(4, 'Ananya Roy', 'Inspector', 'BP-1004', '9876543213', 'ananya.roy@crms.gov.in', 4, 5),
(5, 'Sanjay Dutt', 'Senior Inspector', 'BP-1005', '9876543214', 'sanjay.dutt@crms.gov.in', 3, NULL),
(6, 'Amitabh Bacchan', 'DCP', 'BP-1006', '9876543215', 'amitabh.b@crms.gov.in', 1, NULL),
(7, 'Kabir Mehta', 'Sub-Inspector', 'BP-1007', '9876543216', 'kabir.mehta@crms.gov.in', 5, NULL),
(8, 'Rohan Verma', 'Assistant Sub-Inspector', 'BP-1008', '9876543217', 'rohan.verma@crms.gov.in', 2, NULL),
(9, 'Neha Malhotra', 'Inspector', 'BP-1009', '9876543218', 'neha.m@crms.gov.in', 7, NULL),
(10, 'Karan Johar', 'Head Constable', 'BP-1010', '9876543219', 'karan.j@crms.gov.in', 4, NULL),
(11, 'Deepak Punia', 'Sub-Inspector', 'BP-1011', '9876543220', 'deepak.p@crms.gov.in', 6, NULL),
(12, 'Sunil Grover', 'Inspector', 'BP-1012', '9876543221', 'sunil.g@crms.gov.in', 8, NULL),
(13, 'Meera Nair', 'ACP', 'BP-1013', '9876543222', 'meera.n@crms.gov.in', 9, NULL),
(14, 'Tariq Khan', 'Sub-Inspector', 'BP-1014', '9876543223', 'tariq.k@crms.gov.in', 10, NULL),
(15, 'Gautam Gambhir', 'Inspector', 'BP-1015', '9876543224', 'gautam.g@crms.gov.in', 3, NULL),
(16, 'Shilpa Shetty', 'Sub-Inspector', 'BP-1016', '9876543225', 'shilpa.s@crms.gov.in', 5, NULL),
(17, 'Manish Malhotra', 'Head Constable', 'BP-1017', '9876543226', 'manish.m@crms.gov.in', 7, NULL),
(18, 'Farhan Akhtar', 'Inspector', 'BP-1018', '9876543227', 'farhan.a@crms.gov.in', 8, NULL),
(19, 'Zoya Akhtar', 'Sub-Inspector', 'BP-1019', '9876543228', 'zoya.a@crms.gov.in', 9, NULL),
(20, 'Randeep Hooda', 'Senior Inspector', 'BP-1020', '9876543229', 'randeep.h@crms.gov.in', 10, NULL);

-- 4. Insert Criminals (20 Criminals)
INSERT INTO criminals (criminal_id, name, alias, date_of_birth, gender, address, phone, identification_details, status) VALUES
(1, 'Vijay Salgaonkar', 'The Ghost', '1982-05-14', 'Male', '44 Lake View Road, Suburban Hills', '9123456701', 'Scar on right cheek, tattoo on left forearm', 'In Custody'),
(2, 'Gabbar Singh', 'Daku Gabbar', '1975-08-20', 'Male', 'Ramgarh Ravines, Hideout 4', '9123456702', 'Missing left pinky finger, height 6ft 1in', 'Wanted'),
(3, 'Mogambo Rex', 'General M', '1968-11-03', 'Male', 'Subterranean Bunker B-12', '9123456703', 'Bald, prosthetic eye', 'Convicted'),
(4, 'Shakaal K', 'The Shark', '1979-02-17', 'Male', 'Island Estate, Offshore Dock', '9123456704', 'Burn mark on right shoulder', 'Wanted'),
(5, 'Teja Kumar', 'Mark Teja', '1984-07-22', 'Male', '12 Cross Street, Central Ward', '9123456705', 'Cross tattoo on neck', 'Bail'),
(6, 'Crime Master Gogo', 'Gogo', '1988-12-10', 'Male', '78 Gogo Villa, Old City', '9123456706', 'Red cape wearer, mustache', 'In Custody'),
(7, 'Kancha Cheena', 'Cheena', '1973-04-05', 'Male', 'Mandwa Island', '9123456707', 'Tall, completely hairless head', 'Convicted'),
(8, 'Babu Rao Ganpatrao', 'Babu Bhaiya', '1970-09-18', 'Male', 'Star Garage, Fishermens Colony', '9123456708', 'Thick round spectacles', 'Acquitted'),
(9, 'Bulli Bhai', 'Bulli', '1992-01-30', 'Male', 'Flat 402, Green Heights', '9123456709', 'Pierced left ear', 'Wanted'),
(10, 'Robert Dsouza', 'Robbie', '1985-06-15', 'Male', '99 Seaview Apartments', '9123456710', 'Snake tattoo on hand', 'In Custody'),
(11, 'Bhiku Mhatre', 'King of Mumbai', '1980-03-25', 'Male', 'Dharavi Slum Cluster 3', '9123456711', 'Deep cut mark above left eyebrow', 'Bail'),
(12, 'Kallu Mama', 'Mama', '1977-10-12', 'Male', 'Kola Bazar Alley 5', '9123456712', 'Limp in left leg', 'Wanted'),
(13, 'Don Carlos', 'The Don', '1983-05-09', 'Male', 'Penthouse 18, Royal Towers', '9123456713', 'Tailored suit wearer, ring on thumb', 'Wanted'),
(14, 'Charlie Mascarenhas', 'Charlie', '1990-11-28', 'Male', '34 Bandra West', '9123456714', 'Blonde highlights', 'In Custody'),
(15, 'Lallan Singh', 'Lallan', '1986-04-19', 'Male', 'Ghatkopar East Chawl', '9123456715', 'Tattoo of eagle on chest', 'Convicted'),
(16, 'Sardar Khan', 'Sardar', '1965-07-11', 'Male', 'Wasseypur Sector 2', '9123456716', 'Shaved head, long beard', 'In Custody'),
(17, 'Faizal Khan', 'Faizal', '1991-09-02', 'Male', 'Wasseypur Sector 1', '9123456717', 'Deep scar across stomach', 'Wanted'),
(18, 'Perpendicular Singh', 'Perpendicular', '1996-08-14', 'Male', 'Bypass Road Hutments', '9123456718', 'Razor blade mark on forearm', 'In Custody'),
(19, 'Langda Tyagi', 'Langda', '1978-01-22', 'Male', 'Meerut Outskirts', '9123456719', 'Severe right leg limp', 'Bail'),
(20, 'Hathoda Tyagi', 'Hathoda', '1981-12-05', 'Male', 'Outer Ring Road, Village 8', '9123456720', 'Calloused hands, 6ft 3in', 'Convicted');


-- 5. Insert Victims (15 Victims)
INSERT INTO victims (victim_id, name, age, gender, address, phone) VALUES
(1, 'Ramesh Sen', 45, 'Male', '12 Mall Road, Metro City', '9811122201'),
(2, 'Sunita Deshmukh', 34, 'Female', '56 Lotus Apartments, South Ext', '9811122202'),
(3, 'Anil Kapoor', 52, 'Male', '78 Juhu Vista, Metro City', '9811122203'),
(4, 'Kavita Menon', 29, 'Female', '101 Cyber Towers, Tech Zone', '9811122204'),
(5, 'Suresh Oberoi', 60, 'Male', '44 Heritage Bungalow, Civil Lines', '9811122205'),
(6, 'Pooja Bhatt', 26, 'Female', '33 Rose Gardens, West End', '9811122206'),
(7, 'Vikram Seth', 38, 'Male', '89 Park View Lane', '9811122207'),
(8, 'Meenakshi Sundaram', 41, 'Female', '12 Temple Street, Port Town', '9811122208'),
(9, 'Rahul Sharma', 31, 'Male', '67 Green Glen Layout', '9811122209'),
(10, 'Shalini Mishra', 28, 'Female', '14 Sunrise Residency', '9811122210'),
(11, 'Harish Rawat', 50, 'Male', '88 Hill View Road, Pine Valley', '9811122211'),
(12, 'Geeta Dutt', 36, 'Female', '23 Station Road, Industrial Zone', '9811122212'),
(13, 'Rakesh Jhunjhunwala', 58, 'Male', '90 Financial District', '9811122213'),
(14, 'Tanvi Shah', 24, 'Female', '45 College Road, Metro City', '9811122214'),
(15, 'Manohar Parrikar', 62, 'Male', '11 Coastal Highway, Port Town', '9811122215');


-- 6. Insert Witnesses (10 Witnesses)
INSERT INTO witnesses (witness_id, name, age, gender, address, phone, statement) VALUES
(1, 'Gopal Swamy', 50, 'Male', '14 Mall Road Market', '9700011101', 'Saw two men in black jackets fleeing on a blue motorcycle around 11:30 PM.'),
(2, 'Shanti Devi', 62, 'Female', '58 South Ext Alley', '9700011102', 'Heard a loud argument followed by glass breaking near the jewelry shop.'),
(3, 'David Miller', 35, 'Male', 'Tech Park Cafe, Sector 5', '9700011103', 'Noticed suspicious cyber activity and server access from an unauthorized IP.'),
(4, 'Suraj Bhan', 42, 'Male', 'Grand Trunk Dhaba', '9700011104', 'Observed a red sedan parked with headlights off near the bank vault rear door.'),
(5, 'Fatima Sheikh', 29, 'Female', 'Pier 4 Warehouse', '9700011105', 'Saw contraband containers being unloaded into unmarked vans past midnight.'),
(6, 'Rohan Mehra', 23, 'Male', 'University Campus Hostel', '9700011106', 'Witnessed suspect snatching handbag and running towards the metro station.'),
(7, 'Baldev Singh', 58, 'Male', 'Highway Fuel Station', '9700011107', 'Refueled the suspect vehicle, remembered the partial license plate number 4092.'),
(8, 'Anita Desai', 47, 'Female', 'Green Valley Residency', '9700011108', 'Saw person matching suspect description entering the building elevator at 3 AM.'),
(9, 'Mahesh Bhatt', 64, 'Male', 'Studio Complex, Westside', '9700011109', 'Reported seeing suspicious activity around the executive office lockbox.'),
(10, 'Lata Mangeshkar', 71, 'Female', 'Quiet Haven Colony', '9700011110', 'Heard car tires screeching immediately after the alarm sounded.');

-- 7. Insert Crimes (20 Crimes)
INSERT INTO crimes (crime_id, crime_type, description, crime_date, crime_time, location, city, state, severity, status) VALUES
(1, 'Armed Robbery', 'Armed robbery at National Jewelry Vault. 500 grams gold stolen.', '2026-01-10', '22:45:00', '12 Mall Road', 'Metro City', 'State North', 'Critical', 'Under Investigation'),
(2, 'Cyber Fraud', 'Phishing scam targeting online banking credentials of senior citizens.', '2026-01-15', '14:20:00', 'Tech Park, Sector 5', 'Metro City', 'State North', 'Major', 'Solved'),
(3, 'Grand Theft Auto', 'Luxury SUV stolen from hotel valet parking.', '2026-01-20', '01:15:00', 'Grand Trunk Road', 'Metro City', 'State North', 'Major', 'Under Investigation'),
(4, 'Extortion', 'Protection money demand from local business owners using threats.', '2026-01-25', '18:30:00', 'Industrial Estate Phase 3', 'Steel Town', 'State East', 'Critical', 'Solved'),
(5, 'Contraband Smuggling', 'Illegal shipment of prohibited goods seized at harbor docks.', '2026-02-01', '03:10:00', 'Pier 4 Dockyard', 'Port Town', 'State Coast', 'Critical', 'Under Investigation'),
(6, 'Burglary', 'Break-in at residential bungalow while owners were out of town.', '2026-02-05', '02:00:00', '44 Ridge View', 'Pine Valley', 'State North', 'Minor', 'Reported'),
(7, 'Identity Theft', 'Creation of fraudulent passport and identity documents.', '2026-02-08', '11:00:00', 'Terminal 2 Rd', 'Metro City', 'State North', 'Major', 'Solved'),
(8, 'Assault & Battery', 'Physical altercation outside night venue resulting in severe injury.', '2026-02-12', '23:50:00', '89 Park Street', 'Metro City', 'State North', 'Major', 'Solved'),
(9, 'Homicide', 'Fatal shooting during gang confrontation in alleyway.', '2026-02-18', '21:15:00', 'Kola Bazar Alley 5', 'Metro City', 'State North', 'Critical', 'Under Investigation'),
(10, 'Kidnapping', 'Abduction of businessman for ransom demand.', '2026-02-22', '08:45:00', '101 Cyber Towers', 'Metro City', 'State North', 'Critical', 'Solved'),
(11, 'Bank Heist', 'Sophisticated vault breach at Central Financial Branch.', '2026-03-01', '04:30:00', '90 Financial District', 'Metro City', 'State North', 'Critical', 'Under Investigation'),
(12, 'Drug Trafficking', 'Distribution network bust yielding 20kg synthetic substances.', '2026-03-05', '16:00:00', 'Dharavi Sector 3', 'Metro City', 'State North', 'Critical', 'Under Investigation'),
(13, 'Snatching & Mugging', 'Chain snatching on pedestrian walkway by motorbikers.', '2026-03-10', '19:10:00', '33 Rose Gardens', 'Metro City', 'State North', 'Minor', 'Solved'),
(14, 'Arson', 'Intentional fire set at abandoned warehouse facility.', '2026-03-14', '23:00:00', 'Phase 3 Industrial Area', 'Steel Town', 'State East', 'Major', 'Reported'),
(15, 'Counterfeiting', 'Printing and circulating fake high-denomination currency notes.', '2026-03-18', '12:30:00', '23 Riverfront Road', 'Metro City', 'State North', 'Major', 'Solved'),
(16, 'Vehicle Hacking', 'Remote takeover of automated fleet vehicles via malware.', '2026-03-22', '15:45:00', 'Tech Park Avenue', 'Metro City', 'State North', 'Major', 'Under Investigation'),
(17, 'Illegal Firearms', 'Cache of unlicensed weapons recovered during traffic checkpoint.', '2026-03-28', '20:40:00', '78 GT Road Checkpoint', 'Metro City', 'State North', 'Critical', 'Solved'),
(18, 'Shoplifting Syndicate', 'Organized retail theft ring operating across shopping malls.', '2026-04-02', '17:15:00', 'Civil Lines Retail Hub', 'Metro City', 'State North', 'Minor', 'Solved'),
(19, 'Vandalism', 'Defacing public infrastructure and destruction of city property.', '2026-04-05', '01:30:00', 'Metro Rail Station 4', 'Metro City', 'State North', 'Minor', 'Closed'),
(20, 'Wire Fraud', 'Unauthorized transfer of corporate funds to offshore accounts.', '2026-04-10', '10:00:00', 'Financial Center West', 'Metro City', 'State North', 'Major', 'Under Investigation');

-- 8. Insert FIR (First Information Reports - 15 Records)
INSERT INTO FIR (fir_id, fir_number, crime_id, victim_id, station_id, filing_date, description, status) VALUES
(1, 'FIR-2026-0001', 1, 1, 1, '2026-01-11', 'Complainant reported armed robbery at gold vault by 2 masked suspects.', 'Approved'),
(2, 'FIR-2026-0002', 2, 2, 2, '2026-01-16', 'Victim lost Rs 4,50,000 via phishing link impersonating bank tax rebate.', 'Approved'),
(3, 'FIR-2026-0003', 3, 3, 3, '2026-01-21', 'Reported missing vehicle black SUV license plate MC-04-AB-1234.', 'Under Investigation'),
(4, 'FIR-2026-0004', 4, 5, 8, '2026-01-26', 'Factory owner received extortion calls demanding 10 Lakhs monthly.', 'Approved'),
(5, 'FIR-2026-0005', 5, 8, 5, '2026-02-02', 'Maritime authority reported suspicious container drop off without manifest.', 'Approved'),
(6, 'FIR-2026-0006', 6, 6, 6, '2026-02-06', 'House burglary with stolen cash and antique silverware valued at 2 Lakhs.', 'Pending'),
(7, 'FIR-2026-0007', 7, 4, 9, '2026-02-09', 'Passport fraud detected during airport passport verification counter.', 'Approved'),
(8, 'FIR-2026-0008', 8, 7, 7, '2026-02-13', 'Victim hospitalized following unprovoked physical assault outside club.', 'Approved'),
(9, 'FIR-2026-0009', 9, 9, 1, '2026-02-19', 'Fatal shooting reported in alley, victim identified as local shopkeeper.', 'Approved'),
(10, 'FIR-2026-0010', 10, 10, 4, '2026-02-23', 'Executive kidnapped outside office building, ransom message sent to family.', 'Approved'),
(11, 'FIR-2026-0011', 11, 13, 1, '2026-03-02', 'Bank vault drilled open overnight, currency chests emptied.', 'Approved'),
(12, 'FIR-2026-0012', 12, 11, 3, '2026-03-06', 'Narcotics sales reported operating out of local tenement basement.', 'Approved'),
(13, 'FIR-2026-0013', 13, 14, 4, '2026-03-11', 'Gold chain snatched from victim while waiting at bus stop.', 'Closed'),
(14, 'FIR-2026-0014', 14, 12, 8, '2026-03-15', 'Arson attack destroying cotton storage facility.', 'Under Investigation'),
(15, 'FIR-2026-0015', 15, 15, 10, '2026-03-19', 'Fake currency circulating in local wholesale market stalls.', 'Approved');

-- 9. Insert Cases (15 Cases created from FIRs)
INSERT INTO cases (case_id, case_number, fir_id, investigating_officer_id, case_status, priority, start_date, closing_date, remarks) VALUES
(1, 'CASE-2026-0101', 1, 1, 'Active', 'High', '2026-01-11', NULL, 'Prime suspect identified as Gabbar Singh based on CCTV forensics.'),
(2, 'CASE-2026-0102', 2, 2, 'Solved', 'Medium', '2026-01-16', '2026-02-10', 'Phishing server seized, culprit Robert Dsouza arrested and confessed.'),
(3, 'CASE-2026-0103', 3, 5, 'Active', 'Medium', '2026-01-21', NULL, 'Vehicle tracked across state border checkposts.'),
(4, 'CASE-2026-0104', 4, 12, 'Solved', 'High', '2026-01-26', '2026-02-28', 'Extortion ring busted, suspect Mogambo Rex sentenced.'),
(5, 'CASE-2026-0105', 5, 7, 'Active', 'High', '2026-02-02', NULL, 'Customs agency joint taskforce investigating sea route.'),
(6, 'CASE-2026-0106', 6, 11, 'Pending', 'Low', '2026-02-06', NULL, 'Awaiting forensic latent fingerprint match results.'),
(7, 'CASE-2026-0107', 7, 13, 'Solved', 'Medium', '2026-02-09', '2026-03-01', 'Counterfeit passport ring leader Teja Kumar apprehended.'),
(8, 'CASE-2026-0108', 8, 9, 'In Court', 'High', '2026-02-13', NULL, 'Chargesheet filed in District Court against suspect Bhiku Mhatre.'),
(9, 'CASE-2026-0109', 9, 3, 'Active', 'High', '2026-02-19', NULL, 'Special Investigation Team (SIT) formed for homicide inquiry.'),
(10, 'CASE-2026-0110', 10, 4, 'Solved', 'High', '2026-02-23', '2026-03-15', 'Victim rescued safely from hideout, 2 suspects in custody.'),
(11, 'CASE-2026-0111', 11, 1, 'Active', 'High', '2026-03-02', NULL, 'Inside assistance suspected, interviewing bank staff.'),
(12, 'CASE-2026-0112', 12, 5, 'Active', 'High', '2026-03-06', NULL, 'Undercover operation ongoing in slum cluster.'),
(13, 'CASE-2026-0113', 13, 4, 'Solved', 'Low', '2026-03-11', '2026-03-25', 'Stolen ornament recovered, suspect Crime Master Gogo detained.'),
(14, 'CASE-2026-0114', 14, 12, 'Active', 'Medium', '2026-03-15', NULL, 'Chemical accelerant analysis report pending from FSL lab.'),
(15, 'CASE-2026-0115', 15, 14, 'In Court', 'Medium', '2026-03-19', NULL, 'Printing press seized, trial underway at Sessions Court.');

-- 10. Insert Criminal Cases (Many-to-Many M:N Junction)
INSERT INTO criminal_cases (criminal_id, case_id, involvement_type) VALUES
(2, 1, 'Mastermind'),
(6, 1, 'Accomplice'),
(10, 2, 'Prime Suspect'),
(14, 3, 'Prime Suspect'),
(3, 4, 'Mastermind'),
(1, 5, 'Prime Suspect'),
(4, 5, 'Co-Accused'),
(5, 7, 'Prime Suspect'),
(11, 8, 'Prime Suspect'),
(16, 9, 'Mastermind'),
(17, 9, 'Prime Suspect'),
(7, 10, 'Mastermind'),
(18, 10, 'Accomplice'),
(13, 11, 'Mastermind'),
(12, 12, 'Prime Suspect'),
(6, 13, 'Prime Suspect'),
(15, 14, 'Prime Suspect'),
(19, 15, 'Co-Accused'),
(20, 15, 'Mastermind');

-- 11. Insert Evidence (20 Evidence Records)
INSERT INTO evidence (evidence_id, case_id, evidence_type, description, collected_date, collected_by, storage_location, status) VALUES
(1, 1, 'Digital', 'CCTV security camera footage showing suspects entering vault at 22:42.', '2026-01-11', 1, 'Locker A-101, Central HQ', 'Presented in Court'),
(2, 1, 'Weapon', 'Desi katta .315 caliber pistol dropped near vault rear exit.', '2026-01-11', 1, 'Armory Vault B', 'In Lab'),
(3, 2, 'Digital', 'Hard drive containing phishing script logs and credit card databases.', '2026-01-17', 2, 'Cyber Lab Shelf 4', 'In Storage'),
(4, 2, 'Document', 'Forged bank authorization letterhead matching suspect printing.', '2026-01-18', 2, 'Evidence Locker 12', 'Presented in Court'),
(5, 3, 'Physical', 'Broken door lock mechanism from stolen SUV.', '2026-01-22', 5, 'Locker C-05', 'In Storage'),
(6, 4, 'Digital', 'Audio recordings of extortion phone calls demanding ransom money.', '2026-01-27', 12, 'Secure Cyber Drive 02', 'Presented in Court'),
(7, 5, 'Document', 'Fake shipping bill of lading with altered vessel IMO number.', '2026-02-03', 7, 'Maritime Vault 1', 'In Lab'),
(8, 5, 'Physical', 'Contraband wooden crates stamped with false trademark logos.', '2026-02-03', 7, 'Port Warehouse B', 'In Storage'),
(9, 7, 'Document', 'Five counterfeit national passports with identical photograph.', '2026-02-10', 13, 'Airport Locker 9', 'Presented in Court'),
(10, 8, 'Forensic', 'Bloodstained shirt recovered from alley trash bin near venue.', '2026-02-14', 9, 'Forensic Cold Room 2', 'In Lab'),
(11, 9, 'Weapon', '9mm shell casings (qty 3) recovered from homicide crime scene.', '2026-02-19', 3, 'Armory Vault A', 'In Lab'),
(12, 9, 'Digital', 'Dashcam footage from passing taxi capturing getaway vehicle.', '2026-02-20', 3, 'Media Locker 3', 'In Storage'),
(13, 10, 'Digital', 'Ransom note sent via encrypted messaging application.', '2026-02-24', 4, 'Cyber Lab Shelf 1', 'Presented in Court'),
(14, 11, 'Physical', 'Industrial diamond-tipped drill bit found near breached bank safe.', '2026-03-03', 1, 'Locker A-104', 'In Storage'),
(15, 11, 'Forensic', 'Fingerprint lifted from vault keypad glass surface.', '2026-03-03', 1, 'FSL Database Ref 802', 'In Lab'),
(16, 12, 'Physical', '20 kilograms of white crystalline contraband powder in sealed bags.', '2026-03-07', 5, 'High Security Locker S-1', 'In Storage'),
(17, 13, 'Physical', 'Severed gold chain link recovered at bus stop curb.', '2026-03-12', 4, 'Locker B-12', 'Disposed'),
(18, 14, 'Physical', 'Kerosene jerrycan with suspect handprints found behind warehouse.', '2026-03-16', 12, 'Locker C-88', 'In Lab'),
(19, 15, 'Document', '500 sheets of high-grade watermark currency paper.', '2026-03-20', 14, 'Locker D-01', 'Presented in Court'),
(20, 15, 'Physical', 'Offset lithographic printing plates used for forging 500-rupee notes.', '2026-03-20', 14, 'Evidence Vault 4', 'In Storage');

-- 12. Insert Arrests (10 Arrest Records)
INSERT INTO arrests (arrest_id, criminal_id, case_id, officer_id, arrest_date, arrest_location, arrest_status) VALUES
(1, 1, 5, 7, '2026-02-04 04:30:00', 'Pier 4 Dockyard, Port Town', 'In Lockup'),
(2, 2, 1, 1, '2026-01-14 18:00:00', 'Ramgarh Highway Toll Plaza', 'Remand'),
(3, 3, 4, 12, '2026-01-29 11:15:00', 'Bunker B-12 Perimeter', 'Transferred to Prison'),
(4, 5, 7, 13, '2026-02-11 16:45:00', 'Terminal 2 Departure Lounge', 'Bailed'),
(5, 6, 13, 4, '2026-03-12 21:00:00', 'Gogo Villa Old City', 'In Lockup'),
(6, 10, 2, 2, '2026-01-19 09:30:00', 'Seaview Apartments Flat 99', 'In Lockup'),
(7, 11, 8, 9, '2026-02-15 14:20:00', 'Dharavi Main Naka', 'Bailed'),
(8, 14, 3, 5, '2026-01-24 22:10:00', 'Bandra Railway Parking', 'Remand'),
(9, 15, 14, 12, '2026-03-17 03:00:00', 'Ghatkopar Bus Depot', 'Transferred to Prison'),
(10, 18, 10, 4, '2026-03-01 13:00:00', 'Bypass Village Outskirts', 'In Lockup');

-- 13. Insert Court Records (10 Court Proceedings)
INSERT INTO court_records (court_id, case_id, court_name, hearing_date, judge_name, verdict, sentence, case_status) VALUES
(1, 2, 'Metro Cyber Fast Track Court', '2026-02-08', 'Hon. Judge H. R. Khanna', 'Guilty', '3 Years Rigorous Imprisonment & 1 Lakh Fine', 'Closed'),
(2, 4, 'Sessions Court District 1', '2026-02-25', 'Hon. Judge S. M. Sikri', 'Guilty', '7 Years Imprisonment under Extortion Act', 'Closed'),
(3, 7, 'Chief Metropolitan Magistrate Court', '2026-02-28', 'Hon. Judge Y. V. Chandrachud', 'Guilty', '5 Years Imprisonment', 'Closed'),
(4, 8, 'District High Court Bench 3', '2026-03-10', 'Hon. Judge P. N. Bhagwati', 'Pending', 'Awaiting Defense Witness Testimony', 'In Court'),
(5, 10, 'Special Crimes Tribunal', '2026-03-14', 'Hon. Judge V. R. Krishna Iyer', 'Guilty', 'Life Imprisonment for Kidnapping', 'Closed'),
(6, 13, 'City Judicial Magistrate Court', '2026-03-24', 'Hon. Judge R. S. Pathak', 'Guilty', '1 Year Imprisonment & Restitution', 'Closed'),
(7, 15, 'State Sessions Court 4', '2026-04-02', 'Hon. Judge M. H. Kania', 'Pending', 'Prosecution Evidence Verification Hearing', 'In Court'),
(8, 1, 'High Court Central Branch', '2026-04-12', 'Hon. Judge A. M. Ahmadi', 'Pending', 'Bail Hearing & Forensic Review', 'In Court'),
(9, 5, 'Maritime Admiralty Court', '2026-04-18', 'Hon. Judge J. S. Verma', 'Pending', 'Customs Seizure Appeal', 'In Court'),
(10, 11, 'Financial Offenses Tribunal', '2026-04-25', 'Hon. Judge S. P. Bharucha', 'Pending', 'Charge Framing Scheduled', 'In Court');

-- 14. Insert Case Updates (Investigation Timelines)
INSERT INTO case_updates (update_id, case_id, officer_id, update_text, update_date) VALUES
(1, 1, 1, 'FIR filed and crime scene cordoned off by patrol units.', '2026-01-11 10:00:00'),
(2, 1, 1, 'CCTV footage obtained from vault lobby showing armed suspects.', '2026-01-11 15:30:00'),
(3, 1, 1, 'Suspect Gabbar Singh spotted near highway toll plaza, arrest executed.', '2026-01-14 18:30:00'),
(4, 2, 2, 'Cyber trail traced to IP address registered in Bandra.', '2026-01-17 11:20:00'),
(5, 2, 2, 'Suspect Robert Dsouza arrested, hard drive seized containing logs.', '2026-01-19 10:00:00'),
(6, 2, 2, 'Full confession recorded, charge sheet submitted to court.', '2026-01-25 14:00:00'),
(7, 4, 12, 'Ransom call voice pattern matched against database suspect Mogambo Rex.', '2026-01-27 16:45:00'),
(8, 4, 12, 'Bunker raided by SWAT team, suspect arrested with extortion money.', '2026-01-29 12:00:00'),
(9, 9, 3, 'SIT team conducted ballistic test on recovered 9mm shell casings.', '2026-02-21 09:15:00'),
(10, 10, 4, 'Hostage location pinpointed via mobile tower triangulation.', '2026-02-28 22:10:00'),
(11, 10, 4, 'Successful rescue operation executed, victim unharmed.', '2026-03-01 02:40:00');
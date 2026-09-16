CREATE DATABASE HRM_LoTrinhNS;
GO
USE HRM_LoTrinhNS;
GO

-- 1. Create the Roles table
CREATE TABLE Roles (
    role_id INT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL
);

-- 2. Insert your 5 planned roles (Adjust names to fit your career app)
INSERT INTO Roles (role_id, role_name) VALUES 
(1, 'Admin'),
(2, 'Employer'),
(3, 'Candidate'),
(4, 'Interviewer'),
(5, 'Moderator');

-- 3. Create your Users table with role_id as a number
CREATE TABLE Users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role_id INT NOT NULL,
    
    -- This enforces that users can only be assigned a number between 1 and 5
    CONSTRAINT FK_Users_Roles FOREIGN KEY (role_id) REFERENCES Roles(role_id)
);

DELETE FROM Users;


-- Password for all test users below is '123456'
INSERT INTO Users (username, password_hash, email, role_id) VALUES 
('System Admin', 'EcAbknci4zUp0FPIsk83QGU0ZWU=', 'admin@app.com', 1),
('Tech Recruiter', 'EcAbknci4zUp0FPIsk83QGU0ZWU=', 'employer@app.com', 2),
('John Candidate', 'EcAbknci4zUp0FPIsk83QGU0ZWU=', 'candidate@app.com', 3),
('Senior Interviewer', 'EcAbknci4zUp0FPIsk83QGU0ZWU=', 'interviewer@app.com', 4),
('Content Mod', 'EcAbknci4zUp0FPIsk83QGU0ZWU=', 'moderator@app.com', 5);

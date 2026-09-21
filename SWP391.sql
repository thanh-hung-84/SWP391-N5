

/* ============================================================
   1. CREATE DATABASE
   ============================================================ */
CREATE DATABASE SWP391;
GO

USE SWP391;
GO

/* ============================================================
   2. ROLES
   ============================================================ */

CREATE TABLE Roles
(
    RoleID INT IDENTITY(1,1) PRIMARY KEY,

    RoleName NVARCHAR(50) NOT NULL,

    CONSTRAINT UQ_Roles_RoleName
        UNIQUE (RoleName)
);
GO


INSERT INTO Roles (RoleName)
VALUES
    (N'Admin'),
    (N'HR Staff'),
    (N'Manager'),
    (N'Candidate');
GO


/* ============================================================
   3. ADMIN
   ============================================================ */

CREATE TABLE Admin
(
    AdminID INT IDENTITY(1,1) PRIMARY KEY,

    Username NVARCHAR(100) NOT NULL,

    PasswordHash NVARCHAR(255) NOT NULL,

    CreatedAt DATETIME2 NOT NULL
        CONSTRAINT DF_Admin_CreatedAt
        DEFAULT SYSDATETIME(),

    CONSTRAINT UQ_Admin_Username
        UNIQUE (Username)
);
GO


/* ============================================================
   4. ADMIN ROLE
   Admin <-> Roles
   ============================================================ */

CREATE TABLE Role_Table
(
    AdminID INT NOT NULL,

    RoleID INT NOT NULL,

    CONSTRAINT PK_Role_Table
        PRIMARY KEY (AdminID, RoleID),

    CONSTRAINT FK_RoleTable_Admin
        FOREIGN KEY (AdminID)
        REFERENCES Admin(AdminID)
        ON DELETE CASCADE,

    CONSTRAINT FK_RoleTable_Role
        FOREIGN KEY (RoleID)
        REFERENCES Roles(RoleID)
        ON DELETE CASCADE
);
GO


/* ============================================================
   5. CANDIDATE
   Người dùng ứng tuyển
   ============================================================ */

CREATE TABLE Candidate
(
    CandidateID INT IDENTITY(1,1) PRIMARY KEY,

    CandidateName NVARCHAR(100) NOT NULL,

    Address NVARCHAR(255),

    Email NVARCHAR(100) NOT NULL,

    PhoneNumber VARCHAR(15) NOT NULL,

    Nationality NVARCHAR(50),

    PasswordHash NVARCHAR(255) NOT NULL,

    Avatar NVARCHAR(255),

    CreatedAt DATETIME2 NOT NULL
        CONSTRAINT DF_Candidate_CreatedAt
        DEFAULT SYSDATETIME(),

    IsActive BIT NOT NULL
        CONSTRAINT DF_Candidate_IsActive
        DEFAULT 1,

    CONSTRAINT UQ_Candidate_Email
        UNIQUE (Email),

    CONSTRAINT UQ_Candidate_Phone
        UNIQUE (PhoneNumber)
);
GO


/* ============================================================
   6. EMPLOYEE
   Candidate sau khi được tuyển sẽ trở thành Employee

   Candidate 1 ---- 0..1 Employee
   Employee ------ 1 Role
   ============================================================ */

CREATE TABLE Employee
(
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,

    CandidateID INT NOT NULL,

    RoleID INT NOT NULL,

    EmployeeCode VARCHAR(20) NOT NULL,

    HireDate DATE NOT NULL,

    Department NVARCHAR(100),

    Position NVARCHAR(100),

    Salary DECIMAL(18,2),

    IsActive BIT NOT NULL
        CONSTRAINT DF_Employee_IsActive
        DEFAULT 1,

    CreatedAt DATETIME2 NOT NULL
        CONSTRAINT DF_Employee_CreatedAt
        DEFAULT SYSDATETIME(),

    CONSTRAINT UQ_Employee_Candidate
        UNIQUE (CandidateID),

    CONSTRAINT UQ_Employee_Code
        UNIQUE (EmployeeCode),

    CONSTRAINT FK_Employee_Candidate
        FOREIGN KEY (CandidateID)
        REFERENCES Candidate(CandidateID),

    CONSTRAINT FK_Employee_Role
        FOREIGN KEY (RoleID)
        REFERENCES Roles(RoleID),

    CONSTRAINT CK_Employee_Salary
        CHECK
        (
            Salary IS NULL
            OR Salary >= 0
        )
);
GO


/* ============================================================
   7. EMPLOYEE POSITION HISTORY
   Lưu lịch sử chức vụ / phòng ban / thăng tiến

   Ví dụ:

   Employee #1
       HR Staff
       2026-09-16 -> 2027-09-01

       Manager
       2027-09-01 -> NULL
   ============================================================ */

CREATE TABLE EmployeePositionHistory
(
    HistoryID INT IDENTITY(1,1) PRIMARY KEY,

    EmployeeID INT NOT NULL,

    RoleID INT NOT NULL,

    Position NVARCHAR(100),

    Department NVARCHAR(100),

    StartDate DATE NOT NULL,

    EndDate DATE NULL,

    Note NVARCHAR(500),

    CreatedAt DATETIME2 NOT NULL
        CONSTRAINT DF_EmployeePositionHistory_CreatedAt
        DEFAULT SYSDATETIME(),

    CONSTRAINT FK_PositionHistory_Employee
        FOREIGN KEY (EmployeeID)
        REFERENCES Employee(EmployeeID)
        ON DELETE CASCADE,

    CONSTRAINT FK_PositionHistory_Role
        FOREIGN KEY (RoleID)
        REFERENCES Roles(RoleID)
);
GO


/* ============================================================
   8. CV
   ============================================================ */

CREATE TABLE CV
(
    CVID INT IDENTITY(1,1) PRIMARY KEY,

    CandidateID INT NOT NULL,

    FullName NVARCHAR(100),

    Address NVARCHAR(255),

    Email NVARCHAR(100),

    Position NVARCHAR(100),

    NumberExp INT,

    Education NVARCHAR(255),

    Field NVARCHAR(100),

    CurrentSalary DECIMAL(18,2),

    Birthday DATE,

    Nationality NVARCHAR(50),

    Gender NVARCHAR(10),

    FileData NVARCHAR(255),

    DayCreate DATETIME2 NOT NULL
        CONSTRAINT DF_CV_DayCreate
        DEFAULT SYSDATETIME(),

    CONSTRAINT CK_CV_NumberExp
        CHECK
        (
            NumberExp IS NULL
            OR NumberExp >= 0
        ),

    CONSTRAINT CK_CV_CurrentSalary
        CHECK
        (
            CurrentSalary IS NULL
            OR CurrentSalary >= 0
        ),

    CONSTRAINT FK_CV_Candidate
        FOREIGN KEY (CandidateID)
        REFERENCES Candidate(CandidateID)
        ON DELETE CASCADE
);
GO


/* ============================================================
   9. JOB POST
   Không còn EmployerID
   ============================================================ */

CREATE TABLE JobPost
(
    JobPostID INT IDENTITY(1,1) PRIMARY KEY,

    Title NVARCHAR(100) NOT NULL,

    Description NVARCHAR(MAX) NOT NULL,

    Category NVARCHAR(100) NOT NULL,

    Position NVARCHAR(100),

    Location NVARCHAR(255) NOT NULL,

    OfferMin DECIMAL(18,2),

    OfferMax DECIMAL(18,2),

    NumberExp INT,

    Visible BIT NOT NULL
        CONSTRAINT DF_JobPost_Visible
        DEFAULT 1,

    TypeJob NVARCHAR(100),

    Deadline DATE,

    DayCreate DATETIME2 NOT NULL
        CONSTRAINT DF_JobPost_DayCreate
        DEFAULT SYSDATETIME(),

    CreatedBy INT NULL,

    CONSTRAINT CK_JobPost_Salary
        CHECK
        (
            OfferMin IS NULL
            OR OfferMax IS NULL
            OR OfferMin <= OfferMax
        ),

    CONSTRAINT CK_JobPost_NumberExp
        CHECK
        (
            NumberExp IS NULL
            OR NumberExp >= 0
        ),

    CONSTRAINT FK_JobPost_CreatedBy
        FOREIGN KEY (CreatedBy)
        REFERENCES Employee(EmployeeID)
        ON DELETE SET NULL
);
GO


/* ============================================================
   10. APPLY
   Candidate ứng tuyển JobPost
   ============================================================ */

CREATE TABLE Apply
(
    ApplyID INT IDENTITY(1,1) PRIMARY KEY,

    JobPostID INT NOT NULL,

    CandidateID INT NOT NULL,

    CVID INT NOT NULL,

    Status NVARCHAR(50) NOT NULL
        CONSTRAINT DF_Apply_Status
        DEFAULT N'Pending',

    Note NVARCHAR(500),

    FinalResult NVARCHAR(50),

    ConclusionNote NVARCHAR(MAX),

    ConclusionBy INT NULL,

    ConclusionDate DATETIME2 NULL,

    DayCreate DATETIME2 NOT NULL
        CONSTRAINT DF_Apply_DayCreate
        DEFAULT SYSDATETIME(),

    CONSTRAINT UQ_Apply_Candidate_Job
        UNIQUE (CandidateID, JobPostID),

    CONSTRAINT FK_Apply_JobPost
        FOREIGN KEY (JobPostID)
        REFERENCES JobPost(JobPostID)
        ON DELETE CASCADE,

    CONSTRAINT FK_Apply_Candidate
        FOREIGN KEY (CandidateID)
        REFERENCES Candidate(CandidateID),

    CONSTRAINT FK_Apply_CV
        FOREIGN KEY (CVID)
        REFERENCES CV(CVID),

    CONSTRAINT FK_Apply_ConclusionBy
        FOREIGN KEY (ConclusionBy)
        REFERENCES Employee(EmployeeID)
        ON DELETE SET NULL
);
GO


/* ============================================================
   11. SAVED JOB
   ============================================================ */

CREATE TABLE SavedJob
(
    SavedJobID INT IDENTITY(1,1) PRIMARY KEY,

    CandidateID INT NOT NULL,

    JobPostID INT NOT NULL,

    DateCreate DATETIME2 NOT NULL
        CONSTRAINT DF_SavedJob_DateCreate
        DEFAULT SYSDATETIME(),

    CONSTRAINT UQ_SavedJob_Candidate_Job
        UNIQUE (CandidateID, JobPostID),

    CONSTRAINT FK_SavedJob_Candidate
        FOREIGN KEY (CandidateID)
        REFERENCES Candidate(CandidateID)
        ON DELETE CASCADE,

    CONSTRAINT FK_SavedJob_JobPost
        FOREIGN KEY (JobPostID)
        REFERENCES JobPost(JobPostID)
        ON DELETE CASCADE
);
GO


/* ============================================================
   12. POTENTIAL
   HR đánh dấu CV tiềm năng
   ============================================================ */

CREATE TABLE Potential
(
    PotentialID INT IDENTITY(1,1) PRIMARY KEY,

    CVID INT NOT NULL,

    JobPostID INT NOT NULL,

    CreatedBy INT NULL,

    Note NVARCHAR(500),

    CreatedAt DATETIME2 NOT NULL
        CONSTRAINT DF_Potential_CreatedAt
        DEFAULT SYSDATETIME(),

    CONSTRAINT UQ_Potential_CV_Job
        UNIQUE (CVID, JobPostID),

    CONSTRAINT FK_Potential_CV
        FOREIGN KEY (CVID)
        REFERENCES CV(CVID)
        ON DELETE CASCADE,

    CONSTRAINT FK_Potential_JobPost
        FOREIGN KEY (JobPostID)
        REFERENCES JobPost(JobPostID)
        ON DELETE CASCADE,

    CONSTRAINT FK_Potential_CreatedBy
        FOREIGN KEY (CreatedBy)
        REFERENCES Employee(EmployeeID)
        ON DELETE SET NULL
);
GO


/* ============================================================
   13. INTERVIEW BAREM
   ============================================================ */

CREATE TABLE InterviewBarem
(
    BaremID INT IDENTITY(1,1) PRIMARY KEY,

    JobPostID INT NOT NULL,

    BaremName NVARCHAR(150) NOT NULL,

    Description NVARCHAR(500),

    TotalScore DECIMAL(5,2) NOT NULL
        CONSTRAINT DF_InterviewBarem_TotalScore
        DEFAULT 100,

    CreatedBy INT NOT NULL,

    CreatedAt DATETIME2 NOT NULL
        CONSTRAINT DF_InterviewBarem_CreatedAt
        DEFAULT SYSDATETIME(),

    IsActive BIT NOT NULL
        CONSTRAINT DF_InterviewBarem_IsActive
        DEFAULT 1,

    CONSTRAINT CK_InterviewBarem_TotalScore
        CHECK (TotalScore > 0),

    CONSTRAINT FK_InterviewBarem_JobPost
        FOREIGN KEY (JobPostID)
        REFERENCES JobPost(JobPostID)
        ON DELETE CASCADE,

    CONSTRAINT FK_InterviewBarem_CreatedBy
        FOREIGN KEY (CreatedBy)
        REFERENCES Employee(EmployeeID)
);
GO


/* ============================================================
   14. BAREM CRITERIA
   ============================================================ */

CREATE TABLE BaremCriteria
(
    CriteriaID INT IDENTITY(1,1) PRIMARY KEY,

    BaremID INT NOT NULL,

    CriteriaName NVARCHAR(150) NOT NULL,

    Description NVARCHAR(500),

    MaxScore DECIMAL(5,2) NOT NULL,

    Weight DECIMAL(5,2) NOT NULL,

    DisplayOrder INT NOT NULL
        CONSTRAINT DF_BaremCriteria_DisplayOrder
        DEFAULT 1,

    CONSTRAINT CK_BaremCriteria_MaxScore
        CHECK (MaxScore > 0),

    CONSTRAINT CK_BaremCriteria_Weight
        CHECK
        (
            Weight >= 0
            AND Weight <= 100
        ),

    CONSTRAINT CK_BaremCriteria_DisplayOrder
        CHECK (DisplayOrder > 0),

    CONSTRAINT FK_BaremCriteria_Barem
        FOREIGN KEY (BaremID)
        REFERENCES InterviewBarem(BaremID)
        ON DELETE CASCADE
);
GO


/* ============================================================
   15. INTERVIEW
   ============================================================ */

CREATE TABLE Interview
(
    InterviewID INT IDENTITY(1,1) PRIMARY KEY,

    ApplyID INT NOT NULL,

    BaremID INT NOT NULL,

    InterviewRound INT NOT NULL,

    InterviewDate DATE NOT NULL,

    StartTime TIME NOT NULL,

    EndTime TIME NULL,

    InterviewType NVARCHAR(30) NOT NULL,

    Location NVARCHAR(255),

    MeetingLink NVARCHAR(500),

    Status NVARCHAR(50) NOT NULL
        CONSTRAINT DF_Interview_Status
        DEFAULT N'Scheduled',

    Note NVARCHAR(1000),

    CreatedBy INT NOT NULL,

    CreatedAt DATETIME2 NOT NULL
        CONSTRAINT DF_Interview_CreatedAt
        DEFAULT SYSDATETIME(),

    CONSTRAINT UQ_Interview_Apply_Round
        UNIQUE (ApplyID, InterviewRound),

    CONSTRAINT CK_Interview_Round
        CHECK (InterviewRound > 0),

    CONSTRAINT CK_Interview_Time
        CHECK
        (
            EndTime IS NULL
            OR EndTime > StartTime
        ),

    CONSTRAINT CK_Interview_Type
        CHECK
        (
            InterviewType IN
            (
                N'Online',
                N'Offline',
                N'Phone'
            )
        ),

    CONSTRAINT FK_Interview_Apply
        FOREIGN KEY (ApplyID)
        REFERENCES Apply(ApplyID)
        ON DELETE CASCADE,

    CONSTRAINT FK_Interview_Barem
        FOREIGN KEY (BaremID)
        REFERENCES InterviewBarem(BaremID),

    CONSTRAINT FK_Interview_CreatedBy
        FOREIGN KEY (CreatedBy)
        REFERENCES Employee(EmployeeID)
);
GO


/* ============================================================
   16. INTERVIEW PARTICIPANT
   ============================================================ */

CREATE TABLE InterviewParticipant
(
    InterviewID INT NOT NULL,

    EmployeeID INT NOT NULL,

    ParticipantRole NVARCHAR(50),

    IsLeadInterviewer BIT NOT NULL
        CONSTRAINT DF_InterviewParticipant_IsLead
        DEFAULT 0,

    CONSTRAINT PK_InterviewParticipant
        PRIMARY KEY (InterviewID, EmployeeID),

    CONSTRAINT FK_InterviewParticipant_Interview
        FOREIGN KEY (InterviewID)
        REFERENCES Interview(InterviewID)
        ON DELETE CASCADE,

    CONSTRAINT FK_InterviewParticipant_Employee
        FOREIGN KEY (EmployeeID)
        REFERENCES Employee(EmployeeID)
);
GO


/* ============================================================
   17. INTERVIEW EVALUATION
   ============================================================ */

CREATE TABLE InterviewEvaluation
(
    EvaluationID INT IDENTITY(1,1) PRIMARY KEY,

    InterviewID INT NOT NULL,

    InterviewerID INT NOT NULL,

    TotalScore DECIMAL(6,2),

    Recommendation NVARCHAR(50),

    Comment NVARCHAR(MAX),

    EvaluatedAt DATETIME2 NOT NULL
        CONSTRAINT DF_InterviewEvaluation_EvaluatedAt
        DEFAULT SYSDATETIME(),

    CONSTRAINT UQ_InterviewEvaluation
        UNIQUE (InterviewID, InterviewerID),

    CONSTRAINT CK_InterviewEvaluation_Score
        CHECK
        (
            TotalScore IS NULL
            OR TotalScore >= 0
        ),

    CONSTRAINT FK_InterviewEvaluation_Interview
        FOREIGN KEY (InterviewID)
        REFERENCES Interview(InterviewID)
        ON DELETE CASCADE,

    CONSTRAINT FK_InterviewEvaluation_Interviewer
        FOREIGN KEY (InterviewerID)
        REFERENCES Employee(EmployeeID)
);
GO


/* ============================================================
   18. EVALUATION DETAIL
   ============================================================ */

CREATE TABLE EvaluationDetail
(
    EvaluationDetailID INT IDENTITY(1,1) PRIMARY KEY,

    EvaluationID INT NOT NULL,

    CriteriaID INT NOT NULL,

    Score DECIMAL(6,2) NOT NULL,

    Comment NVARCHAR(500),

    CONSTRAINT UQ_EvaluationDetail
        UNIQUE (EvaluationID, CriteriaID),

    CONSTRAINT CK_EvaluationDetail_Score
        CHECK (Score >= 0),

    CONSTRAINT FK_EvaluationDetail_Evaluation
        FOREIGN KEY (EvaluationID)
        REFERENCES InterviewEvaluation(EvaluationID)
        ON DELETE CASCADE,

    CONSTRAINT FK_EvaluationDetail_Criteria
        FOREIGN KEY (CriteriaID)
        REFERENCES BaremCriteria(CriteriaID)
);
GO


/* ============================================================
   19. NOTIFICATION
   ============================================================ */

CREATE TABLE Notification
(
    NotificationID INT IDENTITY(1,1) PRIMARY KEY,

    SenderRole NVARCHAR(50) NOT NULL,

    ReceiverRole NVARCHAR(50) NOT NULL,

    ReceiverID INT NOT NULL,

    Message NVARCHAR(MAX) NOT NULL,

    SentDate DATETIME2 NOT NULL
        CONSTRAINT DF_Notification_SentDate
        DEFAULT SYSDATETIME(),

    IsRead BIT NOT NULL
        CONSTRAINT DF_Notification_IsRead
        DEFAULT 0
);
GO


/* ============================================================
   20. PASSWORD RESET TOKEN
   ============================================================ */

CREATE TABLE PasswordResetToken
(
    Id BIGINT IDENTITY(1,1) PRIMARY KEY,

    Email NVARCHAR(255) NOT NULL,

    TokenHash NVARCHAR(255) NOT NULL,

    CreatedAt DATETIME2 NOT NULL
        CONSTRAINT DF_PasswordReset_CreatedAt
        DEFAULT SYSUTCDATETIME(),

    ExpiresAt DATETIME2 NOT NULL,

    Used BIT NOT NULL
        CONSTRAINT DF_PasswordReset_Used
        DEFAULT 0,

    Attempts INT NOT NULL
        CONSTRAINT DF_PasswordReset_Attempts
        DEFAULT 0,

    Role NVARCHAR(50) NOT NULL,

    CONSTRAINT CK_PasswordReset_Attempts
        CHECK (Attempts >= 0)
);
GO

CREATE INDEX IX_PasswordResetToken_Email
ON PasswordResetToken(Email);
GO


/* ============================================================
   21. INDEX
   ============================================================ */

CREATE INDEX IX_Employee_Role
ON Employee(RoleID);

CREATE INDEX IX_Employee_Department
ON Employee(Department);

CREATE INDEX IX_EmployeePositionHistory_Employee
ON EmployeePositionHistory(EmployeeID);

CREATE INDEX IX_EmployeePositionHistory_Role
ON EmployeePositionHistory(RoleID);

CREATE INDEX IX_JobPost_Visible
ON JobPost(Visible);

CREATE INDEX IX_JobPost_Deadline
ON JobPost(Deadline);

CREATE INDEX IX_Apply_Candidate
ON Apply(CandidateID);

CREATE INDEX IX_Apply_JobPost
ON Apply(JobPostID);

CREATE INDEX IX_Apply_Status
ON Apply(Status);

CREATE INDEX IX_Interview_Date
ON Interview(InterviewDate, StartTime);

CREATE INDEX IX_Interview_Status
ON Interview(Status);

CREATE INDEX IX_InterviewParticipant_Employee
ON InterviewParticipant(EmployeeID, InterviewID);

CREATE INDEX IX_InterviewEvaluation_Interviewer
ON InterviewEvaluation(InterviewerID);

CREATE INDEX IX_Potential_JobPost
ON Potential(JobPostID);
GO


/* ============================================================
   22. SAMPLE ADMIN
   ============================================================ */

INSERT INTO Admin
(
    Username,
    PasswordHash
)
VALUES
(
    N'admin',
    N'123456'
);
GO


/* ============================================================
   23. ADMIN ROLE
   ============================================================ */

INSERT INTO Role_Table
(
    AdminID,
    RoleID
)
SELECT
    1,
    RoleID
FROM Roles
WHERE RoleName = N'Admin';
GO


/* ============================================================
   24. SAMPLE CANDIDATE
   ============================================================ */

INSERT INTO Candidate
(
    CandidateName,
    Address,
    Email,
    PhoneNumber,
    Nationality,
    PasswordHash,
    Avatar
)
VALUES

(
    N'Nguyễn Văn Nam',
    N'Hà Nội',
    N'nam@gmail.com',
    '0911111111',
    N'Việt Nam',
    N'123456',
    N'avatar1.png'
),

(
    N'Trần Thị Hoa',
    N'Hồ Chí Minh',
    N'hoa@gmail.com',
    '0912222222',
    N'Việt Nam',
    N'123456',
    N'avatar2.png'
),

(
    N'Lê Văn Minh',
    N'Đà Nẵng',
    N'minh@gmail.com',
    '0913333333',
    N'Việt Nam',
    N'123456',
    N'avatar3.png'
),

(
    N'Phạm Thị Lan',
    N'Hải Phòng',
    N'lan@gmail.com',
    '0914444444',
    N'Việt Nam',
    N'123456',
    N'avatar4.png'
),

(
    N'Hoàng Văn Tuấn',
    N'Cần Thơ',
    N'tuan@gmail.com',
    '0915555555',
    N'Việt Nam',
    N'123456',
    N'avatar5.png'
);
GO


/* ============================================================
   25. CANDIDATE -> EMPLOYEE
   Candidate #1 được tuyển thành HR Staff
   Candidate #2 được tuyển thành HR Staff
   Candidate #3 được tuyển thành Manager

   Candidate #4, #5 vẫn là Candidate
   ============================================================ */

INSERT INTO Employee
(
    CandidateID,
    RoleID,
    EmployeeCode,
    HireDate,
    Department,
    Position,
    Salary
)
VALUES

(
    1,
    (
        SELECT RoleID
        FROM Roles
        WHERE RoleName = N'HR Staff'
    ),
    'EMP001',
    CAST(GETDATE() AS DATE),
    N'Human Resources',
    N'HR Staff',
    1500
),

(
    2,
    (
        SELECT RoleID
        FROM Roles
        WHERE RoleName = N'HR Staff'
    ),
    'EMP002',
    CAST(GETDATE() AS DATE),
    N'Human Resources',
    N'HR Staff',
    1400
),

(
    3,
    (
        SELECT RoleID
        FROM Roles
        WHERE RoleName = N'Manager'
    ),
    'EMP003',
    CAST(GETDATE() AS DATE),
    N'IT',
    N'Manager',
    3000
);
GO


/* ============================================================
   26. EMPLOYEE POSITION HISTORY
   ============================================================ */

INSERT INTO EmployeePositionHistory
(
    EmployeeID,
    RoleID,
    Position,
    Department,
    StartDate,
    EndDate,
    Note
)
VALUES

(
    1,
    (
        SELECT RoleID
        FROM Roles
        WHERE RoleName = N'HR Staff'
    ),
    N'HR Staff',
    N'Human Resources',
    CAST(GETDATE() AS DATE),
    NULL,
    N'Được tuyển dụng từ Candidate'
),

(
    2,
    (
        SELECT RoleID
        FROM Roles
        WHERE RoleName = N'HR Staff'
    ),
    N'HR Staff',
    N'Human Resources',
    CAST(GETDATE() AS DATE),
    NULL,
    N'Được tuyển dụng từ Candidate'
),

(
    3,
    (
        SELECT RoleID
        FROM Roles
        WHERE RoleName = N'Manager'
    ),
    N'Manager',
    N'IT',
    CAST(GETDATE() AS DATE),
    NULL,
    N'Được tuyển dụng từ Candidate'
);
GO


/* ============================================================
   27. SAMPLE CV
   ============================================================ */

INSERT INTO CV
(
    CandidateID,
    FullName,
    Address,
    Email,
    Position,
    NumberExp,
    Education,
    Field,
    CurrentSalary,
    Birthday,
    Nationality,
    Gender,
    FileData
)
VALUES

(
    1,
    N'Nguyễn Văn Nam',
    N'Hà Nội',
    N'nam@gmail.com',
    N'Java Developer',
    2,
    N'Đại học Bách Khoa',
    N'Công nghệ thông tin',
    1500,
    '1998-05-12',
    N'Việt Nam',
    N'Nam',
    N'cv_nam.pdf'
),

(
    2,
    N'Trần Thị Hoa',
    N'Hồ Chí Minh',
    N'hoa@gmail.com',
    N'HR Staff',
    3,
    N'Đại học Kinh tế',
    N'Quản trị nhân sự',
    1200,
    '1996-09-20',
    N'Việt Nam',
    N'Nữ',
    N'cv_hoa.pdf'
),

(
    3,
    N'Lê Văn Minh',
    N'Đà Nẵng',
    N'minh@gmail.com',
    N'Backend Developer',
    3,
    N'Đại học Bách Khoa',
    N'Công nghệ thông tin',
    1800,
    '1997-12-01',
    N'Việt Nam',
    N'Nam',
    N'cv_minh.pdf'
),

(
    4,
    N'Phạm Thị Lan',
    N'Hải Phòng',
    N'lan@gmail.com',
    N'Accountant',
    4,
    N'Đại học Thương mại',
    N'Tài chính',
    1300,
    '1994-07-07',
    N'Việt Nam',
    N'Nữ',
    N'cv_lan.pdf'
),

(
    5,
    N'Hoàng Văn Tuấn',
    N'Cần Thơ',
    N'tuan@gmail.com',
    N'UI/UX Designer',
    2,
    N'Đại học Kiến trúc',
    N'Thiết kế',
    1100,
    '1999-03-15',
    N'Việt Nam',
    N'Nam',
    N'cv_tuan.pdf'
);
GO


/* ============================================================
   28. SAMPLE JOB POST
   CreatedBy = EmployeeID
   ============================================================ */

INSERT INTO JobPost
(
    Title,
    Description,
    Category,
    Position,
    Location,
    OfferMin,
    OfferMax,
    NumberExp,
    Visible,
    TypeJob,
    Deadline,
    CreatedBy
)
VALUES

(
    N'Tuyển Java Developer',
    N'Phát triển và bảo trì hệ thống Java.',
    N'IT',
    N'Java Developer',
    N'Hà Nội, Việt Nam',
    1500,
    2500,
    2,
    1,
    N'Full-time',
    DATEADD(DAY, 30, CAST(GETDATE() AS DATE)),
    1
),

(
    N'Tuyển HR Staff',
    N'Thực hiện công tác tuyển dụng và quản lý hồ sơ nhân sự.',
    N'Human Resources',
    N'HR Staff',
    N'Hà Nội, Việt Nam',
    1000,
    1800,
    1,
    1,
    N'Full-time',
    DATEADD(DAY, 30, CAST(GETDATE() AS DATE)),
    2
),

(
    N'Tuyển Backend Developer',
    N'Phát triển API và hệ thống backend.',
    N'IT',
    N'Backend Developer',
    N'Hà Nội, Việt Nam',
    1800,
    3000,
    2,
    1,
    N'Full-time',
    DATEADD(DAY, 30, CAST(GETDATE() AS DATE)),
    1
),

(
    N'Tuyển Accountant',
    N'Quản lý và kiểm tra các nghiệp vụ kế toán.',
    N'Finance',
    N'Accountant',
    N'Hà Nội, Việt Nam',
    1000,
    1700,
    2,
    1,
    N'Full-time',
    DATEADD(DAY, 30, CAST(GETDATE() AS DATE)),
    2
),

(
    N'Tuyển UI/UX Designer',
    N'Thiết kế giao diện và trải nghiệm người dùng.',
    N'Design',
    N'UI/UX Designer',
    N'Hà Nội, Việt Nam',
    1000,
    2000,
    1,
    1,
    N'Full-time',
    DATEADD(DAY, 30, CAST(GETDATE() AS DATE)),
    1
);
GO


/* ============================================================
   29. SAMPLE APPLY
   ============================================================ */

INSERT INTO Apply
(
    JobPostID,
    CandidateID,
    CVID,
    Status,
    Note
)
VALUES

(
    1,
    1,
    1,
    N'Pending',
    N'Ứng tuyển Java Developer'
),

(
    2,
    2,
    2,
    N'Pending',
    N'Ứng tuyển HR Staff'
),

(
    3,
    3,
    3,
    N'Pending',
    N'Ứng tuyển Backend Developer'
),

(
    4,
    4,
    4,
    N'Pending',
    N'Ứng tuyển Accountant'
),

(
    5,
    5,
    5,
    N'Pending',
    N'Ứng tuyển UI/UX Designer'
);
GO


/* ============================================================
   30. SAMPLE SAVED JOB
   ============================================================ */

INSERT INTO SavedJob
(
    CandidateID,
    JobPostID
)
VALUES
(1, 3),
(2, 1),
(3, 1),
(4, 4),
(5, 5);
GO


/* ============================================================
   31. SAMPLE POTENTIAL
   ============================================================ */

INSERT INTO Potential
(
    CVID,
    JobPostID,
    CreatedBy,
    Note
)
VALUES

(
    1,
    1,
    1,
    N'CV phù hợp với vị trí Java Developer'
),

(
    3,
    3,
    2,
    N'Ứng viên có kinh nghiệm Backend tốt'
);
GO


/* ============================================================
   32. CREATE INTERVIEW BAREM
   CreatedBy = Employee
   ============================================================ */

INSERT INTO InterviewBarem
(
    JobPostID,
    BaremName,
    Description,
    TotalScore,
    CreatedBy
)
VALUES
(
    1,
    N'Barem Java Developer',
    N'Barem đánh giá ứng viên Java Developer',
    100,
    1
);
GO


/* ============================================================
   33. BAREM CRITERIA
   ============================================================ */

INSERT INTO BaremCriteria
(
    BaremID,
    CriteriaName,
    Description,
    MaxScore,
    Weight,
    DisplayOrder
)
VALUES

(
    1,
    N'Kiến thức chuyên môn',
    N'Đánh giá kiến thức Java và lập trình',
    30,
    30,
    1
),

(
    1,
    N'Kinh nghiệm',
    N'Đánh giá kinh nghiệm thực tế',
    20,
    20,
    2
),

(
    1,
    N'Giải quyết vấn đề',
    N'Khả năng phân tích và xử lý vấn đề',
    20,
    20,
    3
),

(
    1,
    N'Giao tiếp',
    N'Khả năng giao tiếp và trình bày',
    15,
    15,
    4
),

(
    1,
    N'Thái độ',
    N'Tinh thần làm việc và thái độ',
    15,
    15,
    5
);
GO


/* ============================================================
   34. CREATE INTERVIEW
   ============================================================ */

INSERT INTO Interview
(
    ApplyID,
    BaremID,
    InterviewRound,
    InterviewDate,
    StartTime,
    EndTime,
    InterviewType,
    Location,
    MeetingLink,
    Status,
    Note,
    CreatedBy
)
VALUES
(
    1,
    1,
    1,
    DATEADD(DAY, 3, CAST(GETDATE() AS DATE)),
    '09:00',
    '10:00',
    N'Offline',
    N'Hà Nội, Việt Nam',
    NULL,
    N'Scheduled',
    N'Vòng phỏng vấn chuyên môn',
    1
);
GO


/* ============================================================
   35. INTERVIEW PARTICIPANTS
   Employee #1 = HR
   Employee #3 = Manager
   ============================================================ */

INSERT INTO InterviewParticipant
(
    InterviewID,
    EmployeeID,
    ParticipantRole,
    IsLeadInterviewer
)
VALUES

(
    1,
    1,
    N'HR',
    1
),

(
    1,
    3,
    N'Manager',
    0
);
GO


/* ============================================================
   36. INTERVIEW EVALUATION
   ============================================================ */

INSERT INTO InterviewEvaluation
(
    InterviewID,
    InterviewerID,
    TotalScore,
    Recommendation,
    Comment
)
VALUES
(
    1,
    1,
    85,
    N'Pass',
    N'Ứng viên có kiến thức chuyên môn tốt.'
);
GO


/* ============================================================
   37. EVALUATION DETAIL
   ============================================================ */

INSERT INTO EvaluationDetail
(
    EvaluationID,
    CriteriaID,
    Score,
    Comment
)
VALUES

(
    1,
    1,
    27,
    N'Kiến thức Java tốt'
),

(
    1,
    2,
    17,
    N'Có 2 năm kinh nghiệm'
),

(
    1,
    3,
    18,
    N'Khả năng giải quyết vấn đề tốt'
),

(
    1,
    4,
    12,
    N'Giao tiếp khá tốt'
),

(
    1,
    5,
    11,
    N'Thái độ tích cực'
);
GO


/* ============================================================
   38. SAMPLE NOTIFICATION
   ============================================================ */

INSERT INTO Notification
(
    SenderRole,
    ReceiverRole,
    ReceiverID,
    Message
)
VALUES

(
    N'HR Staff',
    N'Candidate',
    4,
    N'Bạn đã được mời tham gia phỏng vấn vòng 1.'
),

(
    N'HR Staff',
    N'Manager',
    3,
    N'Có lịch phỏng vấn Java Developer cần tham gia.'
);
GO


/* ============================================================
   39. PASSWORD RESET TOKEN
   ============================================================ */

INSERT INTO PasswordResetToken
(
    Email,
    TokenHash,
    ExpiresAt,
    Role
)
VALUES
(
    N'nam@gmail.com',
    N'example_token_hash',
    DATEADD(MINUTE, 30, SYSUTCDATETIME()),
    N'Candidate'
);
GO


/* ============================================================
   40. TEST
   ============================================================ */


/* ---------------- ROLES ---------------- */

SELECT *
FROM Roles;


/* ---------------- CANDIDATE ---------------- */

SELECT *
FROM Candidate;


/* ---------------- EMPLOYEE ---------------- */

SELECT
    e.EmployeeID,
    e.EmployeeCode,
    c.CandidateID,
    c.CandidateName,
    c.Email,
    r.RoleName,
    e.Department,
    e.Position,
    e.HireDate,
    e.Salary,
    e.IsActive
FROM Employee e
JOIN Candidate c
    ON e.CandidateID = c.CandidateID
JOIN Roles r
    ON e.RoleID = r.RoleID;


/* ---------------- CANDIDATE -> EMPLOYEE -> ROLE ---------------- */

SELECT
    c.CandidateID,
    c.CandidateName,
    e.EmployeeID,
    e.EmployeeCode,
    r.RoleName,
    e.Position,
    e.Department,
    e.HireDate
FROM Candidate c
LEFT JOIN Employee e
    ON c.CandidateID = e.CandidateID
LEFT JOIN Roles r
    ON e.RoleID = r.RoleID
ORDER BY c.CandidateID;


/* ---------------- EMPLOYEE POSITION HISTORY ---------------- */

SELECT
    eph.HistoryID,
    e.EmployeeCode,
    c.CandidateName,
    r.RoleName,
    eph.Position,
    eph.Department,
    eph.StartDate,
    eph.EndDate,
    eph.Note
FROM EmployeePositionHistory eph
JOIN Employee e
    ON eph.EmployeeID = e.EmployeeID
JOIN Candidate c
    ON e.CandidateID = c.CandidateID
JOIN Roles r
    ON eph.RoleID = r.RoleID
ORDER BY
    e.EmployeeID,
    eph.StartDate;


/* ---------------- JOB POST ---------------- */

SELECT
    jp.JobPostID,
    jp.Title,
    jp.Category,
    jp.Position,
    jp.Location,
    jp.OfferMin,
    jp.OfferMax,
    jp.NumberExp,
    jp.TypeJob,
    jp.Deadline,
    jp.Visible,
    e.EmployeeCode AS CreatedByEmployee,
    c.CandidateName AS CreatedByName
FROM JobPost jp
LEFT JOIN Employee e
    ON jp.CreatedBy = e.EmployeeID
LEFT JOIN Candidate c
    ON e.CandidateID = c.CandidateID;


/* ---------------- APPLICATION ---------------- */

SELECT
    a.ApplyID,
    c.CandidateName,
    jp.Title AS JobTitle,
    cv.Position AS CVPosition,
    a.Status,
    a.DayCreate
FROM Apply a
JOIN Candidate c
    ON a.CandidateID = c.CandidateID
JOIN JobPost jp
    ON a.JobPostID = jp.JobPostID
JOIN CV cv
    ON a.CVID = cv.CVID;


/* ---------------- SAVED JOB ---------------- */

SELECT
    sj.SavedJobID,
    c.CandidateName,
    jp.Title
FROM SavedJob sj
JOIN Candidate c
    ON sj.CandidateID = c.CandidateID
JOIN JobPost jp
    ON sj.JobPostID = jp.JobPostID;


/* ---------------- POTENTIAL ---------------- */

SELECT
    p.PotentialID,
    c.CandidateName,
    jp.Title AS JobTitle,
    e.EmployeeCode AS CreatedByEmployee,
    p.Note,
    p.CreatedAt
FROM Potential p
JOIN CV cv
    ON p.CVID = cv.CVID
JOIN Candidate c
    ON cv.CandidateID = c.CandidateID
JOIN JobPost jp
    ON p.JobPostID = jp.JobPostID
LEFT JOIN Employee e
    ON p.CreatedBy = e.EmployeeID;


/* ---------------- BAREM ---------------- */

SELECT
    ib.BaremID,
    jp.Title AS JobTitle,
    ib.BaremName,
    ib.TotalScore,
    e.EmployeeCode AS CreatedByEmployee
FROM InterviewBarem ib
JOIN JobPost jp
    ON ib.JobPostID = jp.JobPostID
JOIN Employee e
    ON ib.CreatedBy = e.EmployeeID;


/* ---------------- BAREM CRITERIA ---------------- */

SELECT
    bc.CriteriaID,
    ib.BaremName,
    bc.CriteriaName,
    bc.MaxScore,
    bc.Weight,
    bc.DisplayOrder
FROM BaremCriteria bc
JOIN InterviewBarem ib
    ON bc.BaremID = ib.BaremID
ORDER BY
    bc.BaremID,
    bc.DisplayOrder;


/* ---------------- INTERVIEW ---------------- */

SELECT
    i.InterviewID,
    c.CandidateName,
    jp.Title AS JobTitle,
    i.InterviewRound,
    i.InterviewDate,
    i.StartTime,
    i.EndTime,
    i.InterviewType,
    i.Location,
    i.Status
FROM Interview i
JOIN Apply a
    ON i.ApplyID = a.ApplyID
JOIN Candidate c
    ON a.CandidateID = c.CandidateID
JOIN JobPost jp
    ON a.JobPostID = jp.JobPostID
ORDER BY
    i.InterviewDate,
    i.StartTime;


/* ---------------- INTERVIEW PARTICIPANTS ---------------- */

SELECT
    i.InterviewID,
    c.CandidateName,
    jp.Title AS JobTitle,
    e.EmployeeCode,
    c2.CandidateName AS EmployeeName,
    r.RoleName,
    ip.ParticipantRole,
    ip.IsLeadInterviewer
FROM InterviewParticipant ip
JOIN Interview i
    ON ip.InterviewID = i.InterviewID
JOIN Employee e
    ON ip.EmployeeID = e.EmployeeID
JOIN Candidate c2
    ON e.CandidateID = c2.CandidateID
JOIN Roles r
    ON e.RoleID = r.RoleID
JOIN Apply a
    ON i.ApplyID = a.ApplyID
JOIN Candidate c
    ON a.CandidateID = c.CandidateID
JOIN JobPost jp
    ON a.JobPostID = jp.JobPostID;


/* ---------------- EVALUATION ---------------- */

SELECT
    ie.EvaluationID,
    c.CandidateName,
    jp.Title AS JobTitle,
    e.EmployeeCode AS InterviewerCode,
    c2.CandidateName AS Interviewer,
    r.RoleName,
    ie.TotalScore,
    ie.Recommendation,
    ie.Comment
FROM InterviewEvaluation ie
JOIN Interview i
    ON ie.InterviewID = i.InterviewID
JOIN Employee e
    ON ie.InterviewerID = e.EmployeeID
JOIN Candidate c2
    ON e.CandidateID = c2.CandidateID
JOIN Roles r
    ON e.RoleID = r.RoleID
JOIN Apply a
    ON i.ApplyID = a.ApplyID
JOIN Candidate c
    ON a.CandidateID = c.CandidateID
JOIN JobPost jp
    ON a.JobPostID = jp.JobPostID;


/* ---------------- EVALUATION DETAIL ---------------- */

SELECT
    ie.EvaluationID,
    c.CandidateName,
    c2.CandidateName AS Interviewer,
    bc.CriteriaName,
    bc.MaxScore,
    bc.Weight,
    ed.Score,
    ed.Comment
FROM EvaluationDetail ed
JOIN InterviewEvaluation ie
    ON ed.EvaluationID = ie.EvaluationID
JOIN BaremCriteria bc
    ON ed.CriteriaID = bc.CriteriaID
JOIN Interview i
    ON ie.InterviewID = i.InterviewID
JOIN Apply a
    ON i.ApplyID = a.ApplyID
JOIN Candidate c
    ON a.CandidateID = c.CandidateID
JOIN Employee e
    ON ie.InterviewerID = e.EmployeeID
JOIN Candidate c2
    ON e.CandidateID = c2.CandidateID
ORDER BY
    ie.EvaluationID,
    bc.DisplayOrder;
GO
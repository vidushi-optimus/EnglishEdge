-- =========================
-- CREATE DATABASE
-- =========================
IF DB_ID('LMS_DB') IS NOT NULL
   DROP DATABASE LMS_DB;
GO
CREATE DATABASE LMS_DB;
GO
USE LMS_DB;
GO
-- =========================
-- ROLES
-- =========================
CREATE TABLE Roles (
   role_id INT IDENTITY(1,1) PRIMARY KEY,
   name NVARCHAR(50) NOT NULL UNIQUE
);
-- =========================
-- USERS
-- =========================
CREATE TABLE Users (
   user_id INT IDENTITY(1,1) PRIMARY KEY,
   u_name NVARCHAR(100) NOT NULL,
   email NVARCHAR(150) NOT NULL UNIQUE,
   password_hash NVARCHAR(255) NOT NULL,
   role_id INT NOT NULL,
   created_at DATETIME DEFAULT GETDATE(),
   is_active BIT DEFAULT 1,
   CONSTRAINT FK_Users_Role FOREIGN KEY (role_id)
       REFERENCES Roles(role_id)
);
-- =========================
-- SESSIONS
-- =========================
CREATE TABLE Sessions (
   session_id INT IDENTITY(1,1) PRIMARY KEY,
   user_id INT NOT NULL,
   last_conversation DATETIME,
   CONSTRAINT FK_Session_User FOREIGN KEY (user_id)
       REFERENCES Users(user_id)
);
-- =========================
-- MESSAGES (FINAL CORRECT CHAT TABLE)
-- =========================
CREATE TABLE Messages (
   msg_id INT IDENTITY(1,1) PRIMARY KEY,
   session_id INT NOT NULL,
   message NVARCHAR(MAX) NOT NULL,
   type NVARCHAR(10) CHECK (type IN ('AI', 'USER')),
   timestamp DATETIME DEFAULT GETDATE(),
   CONSTRAINT FK_Message_Session FOREIGN KEY (session_id)
       REFERENCES Sessions(session_id)
);
-- =========================
-- MENTOR-STUDENT MAPPING
-- =========================
CREATE TABLE MentorStudent (
   id INT IDENTITY(1,1) PRIMARY KEY,
   mentor_id INT NOT NULL,
   student_id INT NOT NULL,
   assigned_at DATETIME DEFAULT GETDATE(),
   CONSTRAINT FK_Mentor FOREIGN KEY (mentor_id)
       REFERENCES Users(user_id),
   CONSTRAINT FK_Student FOREIGN KEY (student_id)
       REFERENCES Users(user_id)
);
-- =========================
-- STAGES
-- =========================
CREATE TABLE Stages (
   stage_id INT IDENTITY(1,1) PRIMARY KEY,
   stage_name NVARCHAR(100),
   stage_desc NVARCHAR(255),
   pass_score INT,
   sequence_number INT,
   threshold INT
);
-- =========================
-- PROGRESS
-- =========================
CREATE TABLE Progress (
   progress_id INT IDENTITY(1,1) PRIMARY KEY,
   student_id INT NOT NULL,
   stage_id INT NOT NULL,
   current_score INT,
   status NVARCHAR(50),
   completed_at DATETIME,
   CONSTRAINT FK_Progress_User FOREIGN KEY (student_id)
       REFERENCES Users(user_id),
   CONSTRAINT FK_Progress_Stage FOREIGN KEY (stage_id)
       REFERENCES Stages(stage_id)
);
-- =========================
-- QUIZZES
-- =========================
CREATE TABLE Quizzes (
   quiz_id INT IDENTITY(1,1) PRIMARY KEY,
   user_id INT NOT NULL,
   stage_id INT NOT NULL,
   quiz_status NVARCHAR(50),
   attempt_date DATETIME DEFAULT GETDATE(),
   CONSTRAINT FK_Quiz_User FOREIGN KEY (user_id)
       REFERENCES Users(user_id),
   CONSTRAINT FK_Quiz_Stage FOREIGN KEY (stage_id)
       REFERENCES Stages(stage_id)
);
-- =========================
-- QUIZ ATTEMPTS (SUMMARY)
-- =========================
CREATE TABLE QuizAttempts (
   id INT IDENTITY(1,1) PRIMARY KEY,
   user_id INT NOT NULL,
   stage_id INT NOT NULL,
   passed_quizzes INT DEFAULT 0,
   total_quizzes INT DEFAULT 0,
   CONSTRAINT FK_QA_User FOREIGN KEY (user_id)
       REFERENCES Users(user_id),
   CONSTRAINT FK_QA_Stage FOREIGN KEY (stage_id)
       REFERENCES Stages(stage_id)
);
-- =========================
-- ASSIGNMENTS
-- =========================
CREATE TABLE Assignments (
   assignment_id INT IDENTITY(1,1) PRIMARY KEY,
   mentor_id INT NOT NULL,
   student_id INT NOT NULL,
   title NVARCHAR(150),
   description NVARCHAR(255),
   deadline DATETIME,
   created_at DATETIME DEFAULT GETDATE(),
   is_completed BIT DEFAULT 0,
   CONSTRAINT FK_Assignment_Mentor FOREIGN KEY (mentor_id)
       REFERENCES Users(user_id),
   CONSTRAINT FK_Assignment_Student FOREIGN KEY (student_id)
       REFERENCES Users(user_id)
);
-- =========================
-- SUBMISSIONS
-- =========================
CREATE TABLE Submissions (
   submission_id INT IDENTITY(1,1) PRIMARY KEY,
   assignment_id INT NOT NULL,
   student_id INT NOT NULL,
   status NVARCHAR(50),
   submitted_at DATETIME DEFAULT GETDATE(),
   CONSTRAINT FK_Submission_Assignment FOREIGN KEY (assignment_id)
       REFERENCES Assignments(assignment_id),
   CONSTRAINT FK_Submission_Student FOREIGN KEY (student_id)
       REFERENCES Users(user_id)
);
-- =========================
-- CERTIFICATES
-- =========================
CREATE TABLE Certificates (
   certificate_id INT IDENTITY(1,1) PRIMARY KEY,
   user_id INT NOT NULL,
   stage_id INT NOT NULL,
   issue_date DATETIME DEFAULT GETDATE(),
   certification_url NVARCHAR(255),
   verification_code NVARCHAR(100),
   CONSTRAINT FK_Cert_User FOREIGN KEY (user_id)
       REFERENCES Users(user_id),
   CONSTRAINT FK_Cert_Stage FOREIGN KEY (stage_id)
       REFERENCES Stages(stage_id)
);
-- =========================
-- LEADERBOARD
-- =========================
CREATE TABLE Leaderboard (
   id INT IDENTITY(1,1) PRIMARY KEY,
   user_id INT NOT NULL,
   points INT DEFAULT 0,
   rank INT,
   CONSTRAINT FK_Leaderboard_User FOREIGN KEY (user_id)
       REFERENCES Users(user_id)
);
-- =========================
-- NOTIFICATIONS
-- =========================
CREATE TABLE Notifications (
   notif_id INT IDENTITY(1,1) PRIMARY KEY,
   user_id INT NOT NULL,
   message NVARCHAR(255),
   type NVARCHAR(50),
   created_at DATETIME DEFAULT GETDATE(),
   is_sent BIT DEFAULT 0,
   CONSTRAINT FK_Notif_User FOREIGN KEY (user_id)
       REFERENCES Users(user_id)
);
-- =========================
-- CREATE DATABASE
-- =========================
IF DB_ID('EnglishEdge_DB') IS NOT NULL
   DROP DATABASE EnglishEdge_DB;
GO

CREATE DATABASE EnglishEdge_DB;
GO

USE EnglishEdge_DB;
GO

-- =========================
-- ROLES
-- =========================
CREATE TABLE Roles (
   role_id INT IDENTITY(1,1) PRIMARY KEY,
   name NVARCHAR(50) NOT NULL UNIQUE
);

-- =========================
-- USERS (AUTH SYSTEM)
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
-- SESSIONS (CHATBOT)
-- =========================
CREATE TABLE Sessions (
   session_id INT IDENTITY(1,1) PRIMARY KEY,
   user_id INT NOT NULL,
   last_conversation DATETIME,
   CONSTRAINT FK_Session_User FOREIGN KEY (user_id)
       REFERENCES Users(user_id)
);

-- =========================
-- MESSAGES (CHATBOT)
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
-- STAGES (LEVELS)
-- =========================
CREATE TABLE Stages (
   stage_id INT IDENTITY(1,1) PRIMARY KEY,
   stage_name NVARCHAR(100),
   stage_desc NVARCHAR(255),
   pass_score INT,
   sequence_number INT
);

-- =========================
-- QUIZZES (SCIENCE QUIZ)
-- =========================
CREATE TABLE Quizzes (
   quiz_id INT IDENTITY(1,1) PRIMARY KEY,
   user_id INT NOT NULL,
   stage_id INT NOT NULL,
   score INT,
   quiz_status NVARCHAR(50),
   attempt_date DATETIME DEFAULT GETDATE(),
   CONSTRAINT FK_Quiz_User FOREIGN KEY (user_id)
       REFERENCES Users(user_id),
   CONSTRAINT FK_Quiz_Stage FOREIGN KEY (stage_id)
       REFERENCES Stages(stage_id)
);

-- =========================
-- PROGRESS (ALL GAMES)
-- =========================
CREATE TABLE Progress (
   progress_id INT IDENTITY(1,1) PRIMARY KEY,
   user_id INT NOT NULL,
   stage_id INT NOT NULL,
   game_type NVARCHAR(50), -- vocab / sentence / quiz
   score INT,
   status NVARCHAR(50),
   updated_at DATETIME DEFAULT GETDATE(),
   CONSTRAINT FK_Progress_User FOREIGN KEY (user_id)
       REFERENCES Users(user_id),
   CONSTRAINT FK_Progress_Stage FOREIGN KEY (stage_id)
       REFERENCES Stages(stage_id)
);

-- =========================
-- LEADERBOARD
-- =========================
CREATE TABLE Leaderboard (
   id INT IDENTITY(1,1) PRIMARY KEY,
   user_id INT NOT NULL,
   total_points INT DEFAULT 0,
   rank INT,
   CONSTRAINT FK_Leaderboard_User FOREIGN KEY (user_id)
       REFERENCES Users(user_id)
);
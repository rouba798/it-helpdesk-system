-- ============================================================
-- IT Help Desk & Ticketing Management System
-- Database Schema (Week 1 Deliverable)
-- Target: SQL Server
-- Naming conventions: SQL Server Standards v1.5 (Lively & Sarsany)
--   - Tables: singular, PascalCase, no prefixes
--   - Columns: PascalCase, [Table]Id for PK, matching name for FK
--   - Constraints: {Pk/Fk/Ck/Un}{Table}_{Field}
--   - Bit fields: affirmative names (IsX, HasX)
--   - Date/time fields: word "Date" or "Time" present
-- ============================================================

-- ---------------------------
-- Role
-- ---------------------------
CREATE TABLE dbo.Role (
    RoleId        INT IDENTITY(1,1) NOT NULL,
    RoleName      VARCHAR(50) NOT NULL,
    Description   VARCHAR(255) NULL,
    CONSTRAINT PkRole_RoleId PRIMARY KEY (RoleId),
    CONSTRAINT UnRole_RoleName UNIQUE (RoleName)
);

-- ---------------------------
-- [User]  (bracketed: User is a reserved word in T-SQL)
-- ---------------------------
CREATE TABLE dbo.[User] (
    UserId          INT IDENTITY(1,1) NOT NULL,
    FullName        VARCHAR(150) NOT NULL,
    Email           VARCHAR(150) NOT NULL,
    PasswordHash    VARCHAR(255) NOT NULL,
    RoleId          INT NOT NULL,
    Department      VARCHAR(100) NULL,
    ProfileImageUrl VARCHAR(255) NULL,
    IsActive        BIT NOT NULL DEFAULT 1,
    CreatedDate     DATETIME NOT NULL DEFAULT GETDATE(),
    UpdatedDate     DATETIME NULL,
    CONSTRAINT PkUser_UserId PRIMARY KEY (UserId),
    CONSTRAINT UnUser_Email UNIQUE (Email),
    CONSTRAINT FkUser_RoleId FOREIGN KEY (RoleId) REFERENCES dbo.Role (RoleId)
);

-- ---------------------------
-- Category (Hardware, Software, Network, Email, Access Request, Other)
-- ---------------------------
CREATE TABLE dbo.Category (
    CategoryId    INT IDENTITY(1,1) NOT NULL,
    CategoryName  VARCHAR(50) NOT NULL,
    CONSTRAINT PkCategory_CategoryId PRIMARY KEY (CategoryId),
    CONSTRAINT UnCategory_CategoryName UNIQUE (CategoryName)
);

-- ---------------------------
-- Priority (Low, Medium, High, Critical)
-- ---------------------------
CREATE TABLE dbo.Priority (
    PriorityId    INT IDENTITY(1,1) NOT NULL,
    PriorityName  VARCHAR(20) NOT NULL,
    SortOrder     INT NOT NULL,
    CONSTRAINT PkPriority_PriorityId PRIMARY KEY (PriorityId),
    CONSTRAINT UnPriority_PriorityName UNIQUE (PriorityName)
);

-- ---------------------------
-- Status (Open, In Progress, Pending, Resolved, Closed)
-- ---------------------------
CREATE TABLE dbo.Status (
    StatusId    INT IDENTITY(1,1) NOT NULL,
    StatusName  VARCHAR(20) NOT NULL,
    SortOrder   INT NOT NULL,
    CONSTRAINT PkStatus_StatusId PRIMARY KEY (StatusId),
    CONSTRAINT UnStatus_StatusName UNIQUE (StatusName)
);

-- ---------------------------
-- Ticket
-- ---------------------------
CREATE TABLE dbo.Ticket (
    TicketId          INT IDENTITY(1,1) NOT NULL,
    TicketReference   VARCHAR(20) NOT NULL,          -- e.g. TCK-2026-0001
    Title             VARCHAR(200) NOT NULL,
    Description       VARCHAR(MAX) NOT NULL,
    CategoryId        INT NOT NULL,
    PriorityId        INT NOT NULL,
    StatusId          INT NOT NULL,
    CreatedByUserId   INT NOT NULL,                  -- Employee who submitted
    AssignedToUserId  INT NULL,                       -- IT Support Agent
    CreatedDate       DATETIME NOT NULL DEFAULT GETDATE(),
    UpdatedDate       DATETIME NULL,
    ResolvedDate      DATETIME NULL,
    ClosedDate        DATETIME NULL,
    CONSTRAINT PkTicket_TicketId PRIMARY KEY (TicketId),
    CONSTRAINT UnTicket_TicketReference UNIQUE (TicketReference),
    CONSTRAINT FkTicket_CategoryId FOREIGN KEY (CategoryId) REFERENCES dbo.Category (CategoryId),
    CONSTRAINT FkTicket_PriorityId FOREIGN KEY (PriorityId) REFERENCES dbo.Priority (PriorityId),
    CONSTRAINT FkTicket_StatusId FOREIGN KEY (StatusId) REFERENCES dbo.Status (StatusId),
    CONSTRAINT FkTicket_CreatedByUserId FOREIGN KEY (CreatedByUserId) REFERENCES dbo.[User] (UserId),
    CONSTRAINT FkTicket_AssignedToUserId FOREIGN KEY (AssignedToUserId) REFERENCES dbo.[User] (UserId)
);

-- ---------------------------
-- TicketComment (internal notes + replies)
-- ---------------------------
CREATE TABLE dbo.TicketComment (
    CommentId     INT IDENTITY(1,1) NOT NULL,
    TicketId      INT NOT NULL,
    UserId        INT NOT NULL,
    CommentText   VARCHAR(MAX) NOT NULL,
    IsInternal    BIT NOT NULL DEFAULT 0,   -- internal note vs. visible reply
    CreatedDate   DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PkTicketComment_CommentId PRIMARY KEY (CommentId),
    CONSTRAINT FkTicketComment_TicketId FOREIGN KEY (TicketId) REFERENCES dbo.Ticket (TicketId) ON DELETE CASCADE,
    CONSTRAINT FkTicketComment_UserId FOREIGN KEY (UserId) REFERENCES dbo.[User] (UserId)
);

-- ---------------------------
-- TicketAttachment
-- ---------------------------
CREATE TABLE dbo.TicketAttachment (
    AttachmentId      INT IDENTITY(1,1) NOT NULL,
    TicketId          INT NOT NULL,
    UploadedByUserId  INT NOT NULL,
    FileName          VARCHAR(255) NOT NULL,
    FileUrl           VARCHAR(500) NOT NULL,
    FileType          VARCHAR(50) NULL,
    FileSizeKb        INT NULL,
    UploadedDate      DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PkTicketAttachment_AttachmentId PRIMARY KEY (AttachmentId),
    CONSTRAINT FkTicketAttachment_TicketId FOREIGN KEY (TicketId) REFERENCES dbo.Ticket (TicketId) ON DELETE CASCADE,
    CONSTRAINT FkTicketAttachment_UploadedByUserId FOREIGN KEY (UploadedByUserId) REFERENCES dbo.[User] (UserId)
);

-- ---------------------------
-- Notification
-- ---------------------------
CREATE TABLE dbo.Notification (
    NotificationId  INT IDENTITY(1,1) NOT NULL,
    UserId          INT NOT NULL,
    TicketId        INT NULL,
    Message         VARCHAR(255) NOT NULL,
    IsRead          BIT NOT NULL DEFAULT 0,
    CreatedDate     DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PkNotification_NotificationId PRIMARY KEY (NotificationId),
    CONSTRAINT FkNotification_UserId FOREIGN KEY (UserId) REFERENCES dbo.[User] (UserId),
    CONSTRAINT FkNotification_TicketId FOREIGN KEY (TicketId) REFERENCES dbo.Ticket (TicketId)
);

-- ---------------------------
-- ActivityLog (audit trail)
-- ---------------------------
CREATE TABLE dbo.ActivityLog (
    LogId       INT IDENTITY(1,1) NOT NULL,
    UserId      INT NULL,
    TicketId    INT NULL,
    Action      VARCHAR(255) NOT NULL,   -- e.g. "Reassigned ticket", "Changed status to Resolved"
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PkActivityLog_LogId PRIMARY KEY (LogId),
    CONSTRAINT FkActivityLog_UserId FOREIGN KEY (UserId) REFERENCES dbo.[User] (UserId),
    CONSTRAINT FkActivityLog_TicketId FOREIGN KEY (TicketId) REFERENCES dbo.Ticket (TicketId)
);

-- ============================================================
-- Special-purpose indexes (Rule 3a: {U/N}IX_{TableName}{Purpose})
-- Most common filters on the dashboard/ticket list
-- ============================================================
CREATE NONCLUSTERED INDEX NIX_TicketStatusFilter ON dbo.Ticket (StatusId);
CREATE NONCLUSTERED INDEX NIX_TicketAssignedAgent ON dbo.Ticket (AssignedToUserId);
CREATE NONCLUSTERED INDEX NIX_TicketCreatedBy ON dbo.Ticket (CreatedByUserId);

-- ============================================================
-- Seed data
-- ============================================================
SET NOCOUNT ON;

INSERT INTO dbo.Role (RoleName, Description)
VALUES
('Admin', 'Full system access'),
('IT Support Agent', 'Manage and resolve tickets'),
('Employee', 'Create and track tickets'),
('Manager', 'Monitor team tickets and reports');

INSERT INTO dbo.Category (CategoryName)
VALUES
('Hardware'), ('Software'), ('Network'), ('Email'), ('Access Request'), ('Other');

INSERT INTO dbo.Priority (PriorityName, SortOrder)
VALUES
('Low', 1), ('Medium', 2), ('High', 3), ('Critical', 4);

INSERT INTO dbo.Status (StatusName, SortOrder)
VALUES
('Open', 1), ('In Progress', 2), ('Pending', 3), ('Resolved', 4), ('Closed', 5);

-- Sample users (password hashes are placeholders — replace with real hashes from ASP.NET Identity)
INSERT INTO dbo.[User] (FullName, Email, PasswordHash, RoleId, Department)
VALUES
('Ada Admin', 'admin@company.com', 'hash_placeholder', 1, 'IT'),
('Sam Support', 'sam.support@company.com', 'hash_placeholder', 2, 'IT'),
('Emma Employee', 'emma@company.com', 'hash_placeholder', 3, 'Sales'),
('Mona Manager', 'mona@company.com', 'hash_placeholder', 4, 'Sales');

-- Sample ticket
INSERT INTO dbo.Ticket (TicketReference, Title, Description, CategoryId, PriorityId, StatusId, CreatedByUserId, AssignedToUserId)
VALUES
('TCK-2026-0001', 'Outlook not syncing', 'My Outlook has not synced emails since this morning.', 4, 2, 1, 3, 2);

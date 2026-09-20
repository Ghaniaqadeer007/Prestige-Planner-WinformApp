-- ============================================
-- EVENT MANAGEMENT SYSTEM | Prestige Planners
-- Forms:
-- Login | EventDetails | VenueSelection
-- SummaryBooking | GuestManagement | Invitation
-- ============================================

USE master;
GO

IF DB_ID('EventManagementSystem') IS NULL
CREATE DATABASE EventManagementSystem;
GO

USE EventManagementSystem;
GO

-- ============================================
-- TABLES
-- ============================================

CREATE TABLE Users
(
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(50) UNIQUE NOT NULL,
    Password NVARCHAR(100) NOT NULL,
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    Phone NVARCHAR(20),
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

CREATE TABLE Venues
(
    VenueID INT IDENTITY(1,1) PRIMARY KEY,
    VenueName NVARCHAR(100) UNIQUE NOT NULL,
    Location NVARCHAR(100),
    Capacity INT,
    PricePerEvent DECIMAL(12,2)
);
GO

INSERT INTO Venues VALUES
('Royal Palace','Lahore',150,120000),
('Dream Garden Marquee','Gulberg Lahore',350,185000),
('PC Executive Hall','Mall Road Lahore',500,250000);
GO

CREATE TABLE Events
(
    EventID INT IDENTITY(1,1) PRIMARY KEY,
    EventName NVARCHAR(100),
    EventType NVARCHAR(50),
    EventDate DATE,
    TotalGuests INT,
    AdditionalNotes NVARCHAR(300),
    UserID INT FOREIGN KEY REFERENCES Users(UserID)
);
GO

CREATE TABLE Bookings
(
    BookingID INT IDENTITY(1,1) PRIMARY KEY,
    EventID INT FOREIGN KEY REFERENCES Events(EventID),
    EventType NVARCHAR(50),
    VenueName NVARCHAR(100),
    TotalGuests INT,
    EventDate DATE,

    VenueCost DECIMAL(12,2),
    CateringCost DECIMAL(12,2),
    DecorationCost DECIMAL(12,2),
    PhotographyCost DECIMAL(12,2),
    InvitationCost DECIMAL(12,2),

    TotalBill DECIMAL(12,2),
    BookingStatus NVARCHAR(20) DEFAULT 'Confirmed',
    BookedAt DATETIME DEFAULT GETDATE()
);
GO

CREATE TABLE Guests
(
    GuestID INT IDENTITY(1,1) PRIMARY KEY,
    BookingID INT FOREIGN KEY REFERENCES Bookings(BookingID),

    Name NVARCHAR(100),
    Email NVARCHAR(100),
    Phone NVARCHAR(20),

    RSVP NVARCHAR(20) DEFAULT 'Pending',
    Invite_Status NVARCHAR(20) DEFAULT 'Not Sent'
);
GO

CREATE TABLE InvitationLogs
(
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    GuestID INT FOREIGN KEY REFERENCES Guests(GuestID),

    GuestName NVARCHAR(100),
    SendMethod NVARCHAR(30),
    TemplateName NVARCHAR(50),

    SentAt DATETIME DEFAULT GETDATE()
);
GO

CREATE TABLE AuditLog
(
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    TableName NVARCHAR(50),
    ActionName NVARCHAR(50),
    Message NVARCHAR(200),
    ActionDate DATETIME DEFAULT GETDATE()
);
GO

-- ============================================
-- FUNCTIONS
-- ============================================

CREATE FUNCTION fn_CalculateBill
(
    @Guests INT,
    @Rate DECIMAL(10,2)
)
RETURNS DECIMAL(12,2)
AS
BEGIN
    RETURN @Guests * @Rate;
END;
GO

CREATE FUNCTION fn_GetRSVPCount
(
    @BookingID INT,
    @Status NVARCHAR(20)
)
RETURNS INT
AS
BEGIN
    DECLARE @Count INT;

    SELECT @Count = COUNT(*)
    FROM Guests
    WHERE BookingID = @BookingID
    AND RSVP = @Status;

    RETURN ISNULL(@Count,0);
END;
GO

-- ============================================
-- VIEWS
-- ============================================

CREATE VIEW vw_BookingSummary
AS
SELECT
    b.BookingID,
    b.EventType,
    b.VenueName,
    b.TotalGuests,
    b.EventDate,
    b.TotalBill,
    b.BookingStatus
FROM Bookings b;
GO

CREATE VIEW vw_GuestOverview
AS
SELECT
    g.GuestID,
    g.Name,
    g.Email,
    g.RSVP,
    b.EventType
FROM Guests g
JOIN Bookings b
ON g.BookingID = b.BookingID;
GO

-- ============================================
-- STORED PROCEDURES
-- ============================================

CREATE PROCEDURE sp_RegisterUser
(
    @Username NVARCHAR(50),
    @Password NVARCHAR(100),
    @FullName NVARCHAR(100),
    @Email NVARCHAR(100),
    @Phone NVARCHAR(20)
)
AS
BEGIN

    INSERT INTO Users
    (
        Username,
        Password,
        FullName,
        Email,
        Phone
    )

    VALUES
    (
        @Username,
        @Password,
        @FullName,
        @Email,
        @Phone
    );

END;
GO

CREATE PROCEDURE sp_LoginUser
(
    @Username NVARCHAR(50),
    @Password NVARCHAR(100)
)
AS
BEGIN

    SELECT *
    FROM Users
    WHERE Username=@Username
    AND Password=@Password;

END;
GO

CREATE PROCEDURE sp_SaveBooking
(
    @EventID INT,
    @EventType NVARCHAR(50),
    @VenueName NVARCHAR(100),
    @TotalGuests INT,
    @EventDate DATE,
    @TotalBill DECIMAL(12,2)
)
AS
BEGIN

    INSERT INTO Bookings
    (
        EventID,
        EventType,
        VenueName,
        TotalGuests,
        EventDate,

        VenueCost,
        CateringCost,
        DecorationCost,
        PhotographyCost,
        InvitationCost,

        TotalBill
    )

    VALUES
    (
        @EventID,
        @EventType,
        @VenueName,
        @TotalGuests,
        @EventDate,

        @TotalBill*0.48,
        @TotalBill*0.30,
        @TotalBill*0.10,
        @TotalBill*0.07,
        @TotalBill*0.05,

        @TotalBill
    );

END;
GO

CREATE PROCEDURE sp_AddGuest
(
    @BookingID INT,
    @Name NVARCHAR(100),
    @Email NVARCHAR(100),
    @Phone NVARCHAR(20)
)
AS
BEGIN

    INSERT INTO Guests
    (
        BookingID,
        Name,
        Email,
        Phone
    )

    VALUES
    (
        @BookingID,
        @Name,
        @Email,
        @Phone
    );

END;
GO

-- ============================================
-- TRIGGERS
-- ============================================

CREATE TRIGGER trg_PreventDuplicateGuest
ON Guests
INSTEAD OF INSERT
AS
BEGIN

    IF EXISTS
    (
        SELECT *
        FROM Guests g
        JOIN inserted i
        ON g.Email = i.Email
        AND g.BookingID = i.BookingID
    )

    BEGIN
        PRINT 'Guest already exists';
    END

    ELSE

    BEGIN
        INSERT INTO Guests
        (
            BookingID,
            Name,
            Email,
            Phone,
            RSVP,
            Invite_Status
        )

        SELECT
            BookingID,
            Name,
            Email,
            Phone,
            RSVP,
            Invite_Status

        FROM inserted;
    END

END;
GO

CREATE TRIGGER trg_BookingAudit
ON Bookings
AFTER INSERT
AS
BEGIN

    INSERT INTO AuditLog
    (
        TableName,
        ActionName,
        Message
    )

    SELECT
        'Bookings',
        'INSERT',
        'New booking for ' + EventType

    FROM inserted;

END;
GO

-- ============================================
-- SAMPLE DATA
-- ============================================

EXEC sp_RegisterUser
'admin',
'admin123',
'Admin User',
'admin@gmail.com',
'03001234567';
GO

INSERT INTO Events
(
    EventName,
    EventType,
    EventDate,
    TotalGuests,
    AdditionalNotes,
    UserID
)

VALUES
(
    'Ali Wedding',
    'Wedding',
    '2026-12-25',
    150,
    'Outdoor Setup',
    1
);
GO

EXEC sp_SaveBooking
1,
'Wedding',
'Royal Palace',
150,
'2026-12-25',
1000000;
GO

EXEC sp_AddGuest
1,
'Ali Khan',
'ali@gmail.com',
'03111111111';
GO

-- ============================================
-- TEST QUERIES
-- ============================================

SELECT * FROM Users;

SELECT * FROM Venues;

SELECT * FROM Events;

SELECT * FROM vw_BookingSummary;

SELECT * FROM vw_GuestOverview;

SELECT * FROM AuditLog;

SELECT dbo.fn_CalculateBill(150,5000) AS TotalBill;

SELECT dbo.fn_GetRSVPCount(1,'Pending') AS PendingGuests;
GO
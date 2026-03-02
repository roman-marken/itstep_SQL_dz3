
CREATE DATABASE Academy;
GO
USE Academy;
GO

CREATE TABLE Faculties(
    Id INT IDENTITY PRIMARY KEY,
    Financing MONEY NOT NULL DEFAULT 0 CHECK(Financing >= 0),
    Name NVARCHAR(100) NOT NULL UNIQUE CHECK(Name <> '')
);

CREATE TABLE Departments(
    Id INT IDENTITY PRIMARY KEY,
    Financing MONEY NOT NULL DEFAULT 0 CHECK(Financing >= 0),
    Name NVARCHAR(100) NOT NULL UNIQUE CHECK(Name <> ''),
    FacultyId INT NOT NULL,
    FOREIGN KEY (FacultyId) REFERENCES Faculties(Id)
);

CREATE TABLE Curators(
    Id INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(MAX) NOT NULL CHECK(Name <> ''),
    Surname NVARCHAR(MAX) NOT NULL CHECK(Surname <> '')
);

CREATE TABLE Groups(
    Id INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(10) NOT NULL UNIQUE CHECK(Name <> ''),
    [Year] INT NOT NULL CHECK([Year] BETWEEN 1 AND 5),
    DepartmentId INT NOT NULL,
    FOREIGN KEY (DepartmentId) REFERENCES Departments(Id)
);

CREATE TABLE Teachers(
    Id INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(MAX) NOT NULL CHECK(Name <> ''),
    Surname NVARCHAR(MAX) NOT NULL CHECK(Surname <> ''),
    Salary MONEY NOT NULL CHECK(Salary > 0)
);

CREATE TABLE Subjects(
    Id INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL UNIQUE CHECK(Name <> '')
);

CREATE TABLE Lectures(
    Id INT IDENTITY PRIMARY KEY,
    LectureRoom NVARCHAR(MAX) NOT NULL CHECK(LectureRoom <> ''),
    SubjectId INT NOT NULL,
    TeacherId INT NOT NULL,
    FOREIGN KEY (SubjectId) REFERENCES Subjects(Id),
    FOREIGN KEY (TeacherId) REFERENCES Teachers(Id)
);

CREATE TABLE GroupsLectures(
    Id INT IDENTITY PRIMARY KEY,
    GroupId INT NOT NULL,
    LectureId INT NOT NULL,
    FOREIGN KEY (GroupId) REFERENCES Groups(Id),
    FOREIGN KEY (LectureId) REFERENCES Lectures(Id)
);

CREATE TABLE GroupsCurators(
    Id INT IDENTITY PRIMARY KEY,
    CuratorId INT NOT NULL,
    GroupId INT NOT NULL,
    FOREIGN KEY (CuratorId) REFERENCES Curators(Id),
    FOREIGN KEY (GroupId) REFERENCES Groups(Id)
);

-- 1
SELECT T.Surname, G.Name
FROM Teachers T CROSS JOIN Groups G;

-- 2
SELECT F.Name
FROM Faculties F
JOIN Departments D ON D.FacultyId = F.Id
GROUP BY F.Name, F.Financing
HAVING SUM(D.Financing) > F.Financing;

-- 3
SELECT C.Surname, G.Name
FROM Curators C
JOIN GroupsCurators GC ON GC.CuratorId = C.Id
JOIN Groups G ON G.Id = GC.GroupId;

-- 4
SELECT DISTINCT T.Surname
FROM Teachers T
JOIN Lectures L ON L.TeacherId = T.Id
JOIN GroupsLectures GL ON GL.LectureId = L.Id
JOIN Groups G ON G.Id = GL.GroupId
WHERE G.Name = 'P107';

-- 5
SELECT DISTINCT T.Surname, F.Name
FROM Teachers T
JOIN Lectures L ON L.TeacherId = T.Id
JOIN GroupsLectures GL ON GL.LectureId = L.Id
JOIN Groups G ON G.Id = GL.GroupId
JOIN Departments D ON D.Id = G.DepartmentId
JOIN Faculties F ON F.Id = D.FacultyId;

-- 6
SELECT D.Name, G.Name
FROM Departments D
JOIN Groups G ON G.DepartmentId = D.Id;

-- 7
SELECT S.Name
FROM Subjects S
JOIN Lectures L ON L.SubjectId = S.Id
JOIN Teachers T ON T.Id = L.TeacherId
WHERE T.Name = 'Samantha' AND T.Surname = 'Adams';

-- 8
SELECT DISTINCT D.Name
FROM Departments D
JOIN Groups G ON G.DepartmentId = D.Id
JOIN GroupsLectures GL ON GL.GroupId = G.Id
JOIN Lectures L ON L.Id = GL.LectureId
JOIN Subjects S ON S.Id = L.SubjectId
WHERE S.Name = N'Теория баз данных';

-- 9
SELECT G.Name
FROM Groups G
JOIN Departments D ON D.Id = G.DepartmentId
JOIN Faculties F ON F.Id = D.FacultyId
WHERE F.Name = N'Компьютерные науки';

-- 10
SELECT G.Name, F.Name
FROM Groups G
JOIN Departments D ON D.Id = G.DepartmentId
JOIN Faculties F ON F.Id = D.FacultyId
WHERE G.[Year] = 5;

-- 11
SELECT T.Surname, S.Name, G.Name
FROM Teachers T
JOIN Lectures L ON L.TeacherId = T.Id
JOIN Subjects S ON S.Id = L.SubjectId
JOIN GroupsLectures GL ON GL.LectureId = L.Id
JOIN Groups G ON G.Id = GL.GroupId
WHERE L.LectureRoom = 'B103';

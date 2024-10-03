--- To create database

create database coding;
use coding;

--- To create a table

CREATE TABLE Crime(
    CrimeID INT PRIMARY KEY, 
    IncidentType VARCHAR(255), 
    IncidentDate DATE, 
    Location VARCHAR(255), 
    Description TEXT, 
    Status VARCHAR(20) 
); 

CREATE TABLE Victim ( 
    VictimID INT PRIMARY KEY, 
    CrimeID INT, 
    Name VARCHAR(255), 
    ContactInfo VARCHAR(255), 
    Injuries VARCHAR(255), 
    FOREIGN KEY (CrimeID) REFERENCES Crime(CrimeID) 
); 
 
CREATE TABLE Suspect ( 
    SuspectID INT PRIMARY KEY, 
    CrimeID INT, 
    Name VARCHAR(255), 
    Description TEXT, 
    CriminalHistory TEXT, 
    FOREIGN KEY (CrimeID) REFERENCES Crime(CrimeID) 
); 

--- Insert data 

INSERT INTO Crime (CrimeID, IncidentType, IncidentDate, Location, Description, Status) 
VALUES 
    (1, 'Robbery', '2023-09-15', '123 Main St, Cityville', 'Armed robbery at a convenience store', 'Open'), 
    (2, 'Homicide', '2023-09-20', '456 Elm St, Townsville', 'Investigation into a murder case', 'Under Investigation'), 
    (3, 'Theft', '2023-09-10', '789 Oak St, Villagetown', 'Shoplifting incident at a mall', 'Closed'); 
 
INSERT INTO Victim (VictimID, CrimeID, Name, ContactInfo, Injuries) 
VALUES 
    (1, 1, 'John Doe', 'johndoe@example.com', 'Minor injuries'), 
    (2, 2, 'Jane Smith', 'janesmith@example.com', 'Deceased'),
	(3, 3, 'Alice Johnson', 'alicejohnson@example.com', 'None');
	
INSERT INTO Suspect (SuspectID, CrimeID, Name, Description, CriminalHistory) 
VALUES 
(1, 1, 'Robber 1', 'Armed and masked robber', 'Previous robbery convictions'), 
(2, 2, 'Unknown', 'Investigation ongoing', NULL), 
(3, 3, 'Suspect 1', 'Shoplifting suspect', 'Prior shoplifting arrests');

--- SQL Quries

--- 1. Select all open incidents.

SELECT *from Crime where Status='open';

--- 2. Find the total number of incidents.

SELECT Count(CrimeID) from Crime;

--- 3. List all unique incident types. 

SELECT DISTINCT (IncidentType) from Crime;

--- 4. Retrieve incidents that occurred between '2023-09-01' and '2023-09-10'.

SELECT IncidentType from Crime 
WHERE IncidentDate BETWEEN '2023-09-01' and '2023-09-10';

--- Creating an age column

ALTER TABLE Crime
ADD Age int;

--- Insert the values for Age 

UPDATE Crime
SET Age = 23
WHERE CrimeID ='1';

UPDATE Crime
SET Age = 28
WHERE CrimeID = '2';

UPDATE Crime
SET Age = 31
WHERE CrimeID = '3';

--- 5. List persons involved in incidents in descending order of age. 

SELECT *from Crime 
Order By Age DESC;


--- 6. Find the average age of persons involved in incidents. 

SELECT AVG(Age) from Crime;

--- 7. List incident types and their counts, only for open cases.

SELECT IncidentType ,count(IncidentType) from Crime
WHERE Status = 'Open'
Group By IncidentType


--- 8. Find persons with names containing 'Doe'.

SELECT *
FROM Victim
WHERE Name LIKE '%Doe%';

--- 9. Retrieve the names of persons involved in open cases and closed cases. 

SELECT Victim.Name, Crime.Status
FROM Victim
INNER JOIN Crime ON Victim.CrimeID = Crime.CrimeID
WHERE Crime.Status = 'Open' OR Crime.Status = 'Closed';

--- 10. List incident types where there are persons aged 23 or 31 involved.

SELECT IncidentType 
FROM Crime
WHERE Age = 23 OR Age = 31;

--- 11. Find persons involved in incidents of the same type as 'Robbery'.

SELECT *FROM Crime
WHERE IncidentType = 'Robbery';  --- You can find  only one person because the others did Homicide and Theft.

--- 12. List incident types with more than one open case.

SELECT IncidentType 
FROM Crime
WHERE Status = 'Open'
GROUP BY IncidentType   --- You will not get any values because there is only one open case.
HAVING COUNT(Status) > 1;

--- 13. List all incidents with suspects whose names also appear as victims in other incidents.

SELECT DISTINCT c.IncidentType
FROM Crime c
JOIN Victim v ON c.CrimeID = v.CrimeID
JOIN Suspect s ON c.CrimeID = s.CrimeID   --- No output will be shown as no victim is a suspect here.
WHERE s.Name = v.Name;

--- 14.  Retrieve all incidents along with victim and suspect details. 

SELECT DISTINCT c.IncidentType
FROM Crime c
JOIN Victim V ON c.CrimeID = V.CrimeID
JOIN Suspect s ON c.CrimeID = s.CrimeID

--- 15. Find incidents where the suspect is older than any victim. 
 
 --- For this we need to add Age values into the table Suspect 

ALTER TABLE Suspect
ADD Age int;

UPDATE Suspect
SET Age = '43'
WHERE SuspectID = 1;

UPDATE Suspect
SET Age = '21'
WHERE SuspectID = 2;

UPDATE Suspect
SET Age = '34'
WHERE SuspectID = 3;

--- Similarly, for Victim table also we need to add the values
 
 ALTER TABLE Victim
 ADD Age int;

 UPDATE Victim
SET Age = '28'
WHERE VictimID = 1;

UPDATE Victim
SET Age = '31'
WHERE VictimID = 2;

UPDATE Victim
SET Age = '29'
WHERE VictimID = 3;

--- Now, coming to the query

SELECT c.IncidentType
FROM Crime c
JOIN Suspect s ON c.CrimeID = s.CrimeID
JOIN Victim v ON c.CrimeID = v.CrimeID
WHERE s.Age > v.Age;

--- 16. Find suspects involved in multiple incidents.

SELECT s.Name
FROM Suspect s
JOIN Crime c ON s.CrimeID = c.CrimeID   --- You will get no output as no suspects are involved in multiple incidents 
GROUP BY s.Name    
HAVING COUNT(c.CrimeID) > 1;

--- 17. List incidents with no suspects involved. 

SELECT c.IncidentType
FROM Crime c
LEFT JOIN Suspect s ON c.CrimeID = s.CrimeID   --- No output because every incident includes a suspect 
WHERE s.CrimeID IS NULL;

--- 18.  List all cases where at least one incident is of type 'Homicide' and all other incidents are of type 'Robbery'.

SELECT CrimeID
FROM Crime
GROUP BY CrimeID
HAVING MAX(IncidentType) = 'Homicide'   --- This will ensure that the value of Homicide > 1
   AND MIN(IncidentType) = 'Robbery';   --- This will ensure that the other values are 'Robbery'

--- 19. Retrieve a list of all incidents and the associated suspects, showing suspects for each incident, or 'No Suspect' if there are none.

SELECT C.IncidentType, s.Name from Crime C
JOIN Suspect s ON c.CrimeID = s.CrimeID
UPDATE Suspect 
SET Name = 'NO Suspect'
WHERE SuspectID IS NULL;

--- 20.  List all suspects who have been involved in incidents with incident types 'Robbery' or 'Assault'

SELECT S.Name from Suspect s
JOIN Crime c ON s.CrimeID= c.CrimeID
WHERE c.IncidentType ='Robbery' OR c.IncidentType ='Theft';







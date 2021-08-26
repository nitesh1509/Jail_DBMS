DROP DATABASE IF EXISTS JAILDB;
CREATE SCHEMA JAILDB;
USE JAILDB;

-- Table Structure of `JAIL`

DROP TABLE IF EXISTS JAIL;
CREATE TABLE JAIL (
	JId int(15) NOT NULL,
	JName varchar(15) NOT NULL,
	JAdd varchar(100) NOT NULL,
	JCapacity int(8) NOT NULL,
	PRIMARY KEY (JId),
	UNIQUE (JName),
	UNIQUE (JAdd)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table `JAIL`

LOCK TABLES JAIL WRITE;

INSERT INTO JAIL VALUES (1,'Tihar Jail','Delhi',1500),(2,'KalaPani','Andaman and Nicobar',250);

UNLOCK TABLES;


-- Table Structure of `POLICEOFFICER`

DROP TABLE IF EXISTS POLICEOFFICER;
CREATE TABLE POLICEOFFICER (
	POId int(15) NOT NULL,
	POFName varchar(15) NOT NULL,
	POLName varchar(15) DEFAULT NULL,
	POJailId int(15) NOT NULL,
	POAdd varchar(100) DEFAULT NULL,
	PODOB date DEFAULT NULL,
	POSalary int(8) NOT NULL,
	PODateofPosting date NOT NULL,
	JobType varchar(15) NOT NULL, 
	PRIMARY KEY (POId),
	FOREIGN KEY (POJailId) REFERENCES JAIL(JId) ON DELETE CASCADE
-- CHECK (JobType = 'Jailer' OR JobType = 'Guard')
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table `POLICEOFFICER`

LOCK TABLES POLICEOFFICER WRITE;

INSERT INTO POLICEOFFICER VALUES 
(1,'Tanish','Lad',1,'Yawatmal,Maharashtra','1992-12-07',10000,'2015-11-05','Jailer'),
(2,'Manish','Lad',2,'Mumbai,Maharashtra','1954-08-15',25000,'1985-09-04','Jailer'),
(3,'Kushagra','Aggarwal',1,'Kolkata','1914-02-14',5000,'1948-02-14','Gaurd'),
(4,'Shantanu','Aggarwal',2,'Satna,Madhya Pradesh','1947-08-15',7000,'1975-05-18','Guard'),
(5,'Manas','Kabre',1,'Bengaluru','1987-10-31',5000,'2005-08-14','Guard'),
(6,'Nikunj','Nawal',2,'Indore,MP','2000-03-14',30000,'2019-11-05','Guard');

UNLOCK TABLES;

-- Table Structure of `DEPARTMENT`


DROP TABLE IF EXISTS DEPARTMENT;
CREATE TABLE DEPARTMENT (
	DJailId int(15) NOT NULL,
	DName varchar(30) NOT NULL,
	DHeadId int(15) NOT NULL,
	DWage int(8) NOT NULL,
	DWorkHours int(4) NOT NULL,
	PRIMARY KEY (DJailId,DName),
	FOREIGN KEY (DHeadId) REFERENCES POLICEOFFICER (POId) ON DELETE CASCADE,
	FOREIGN KEY (DJailId) REFERENCES JAIL (JId) ON DELETE CASCADE,
	UNIQUE (DHeadId)
	-- UNIQUE (`DName`)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- Dumping data for table `DEPARTMENT`

LOCK TABLES DEPARTMENT WRITE;

INSERT INTO DEPARTMENT VALUES (1, 'Toilet Cleaning', 3, 200, 20),(2,'Toilet Cleaning',4,200,20),(1, 'Kitchen', 5, 100, 14),(2, 'Kitchen', 6, 100, 14);

UNLOCK TABLES;


-- Table Structure of `PRISONER`

DROP TABLE IF EXISTS PRISONER;
CREATE TABLE PRISONER (
	PId int(15) NOT NULL,
	PFirstName varchar(15) NOT NULL,
	PLastName varchar(15) DEFAULT NULL,
	PJailId int(15) NOT NULL,
	PDname varchar(30) NOT NULL,
	PAdd varchar(100) DEFAULT NULL,
	PConfinementPeriod int(4) NOT NULL,
	PDOB date DEFAULT NULL,
	PDateofImprisonment date NOT NULL,
	PRIMARY KEY (PId),
	FOREIGN KEY (PJailId,PDname) REFERENCES DEPARTMENT (DJailId,DName) ON DELETE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- Dumping data for table `PRISONER`

LOCK TABLES PRISONER WRITE;

INSERT INTO PRISONER VALUES (125,'Naman','Baheti',1,'Toilet Cleaning','Katra No. 5,Lahore',14,'2000-02-29','2018-03-15'),(128,'Sajal','Khandelwal',2,'Kitchen','Raj Mahal No. 3,Alwar',5,'2001-05-25','2018-04-02');

UNLOCK TABLES;



-- Table Structure of `CRIME`

DROP TABLE IF EXISTS CRIME;
CREATE TABLE CRIME (
	CPId int(15) NOT NULL,
	CType varchar(15) NOT NULL,
	CDate date DEFAULT NULL,
	CLocation varchar(100) DEFAULT NULL,
	PRIMARY KEY (CPId,CType),
	FOREIGN KEY (CPId) REFERENCES PRISONER (PId) ON DELETE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- Dumping data for table `CRIME`

LOCK TABLES CRIME WRITE;

INSERT INTO CRIME VALUES (125,'Rape','2018-02-10','Hyderabad'),(125,'Murder','2018-02-14','Flat No. 3,Udaipur'),(128,'Robbery','2018-01-17','Mahal no. 4,Alwar');

UNLOCK TABLES;


-- Table Structure of `VISITOR`


DROP TABLE IF EXISTS VISITOR;
CREATE TABLE VISITOR (
	VPId int(15) NOT NULL,
	VFName varchar(15) NOT NULL,
	VLName varchar(15) DEFAULT NULL,
	VAdd varchar(100) DEFAULT NULL,
	VDOB date DEFAULT NULL,
	PRIMARY KEY (VPId,VFName),
	FOREIGN KEY (VPId) REFERENCES PRISONER (PId) ON DELETE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- Dumping data for table `VISITOR`

LOCK TABLES VISITOR WRITE;

INSERT INTO VISITOR VALUES (125,'Rohit','Sharma','Mumbai','1954-05-15' ),(128,'Amogh','Tiwari','Delhi','1924-05-18'),(125, 'Anubhav', 'Sharma', 'Jaipur', '1967-05-05');

UNLOCK TABLES;



-- Table Structure of `PWORKSFOR`


DROP TABLE IF EXISTS PWORKSFOR;
CREATE TABLE PWORKSFOR (
	PId int(15) NOT NULL,
	JId int(15) NOT NULL,
	DName varchar(15) NOT NULL,
	PRIMARY KEY (PId),
	FOREIGN KEY (JId,DName) REFERENCES DEPARTMENT (DJailId,DName) ON DELETE CASCADE,
	FOREIGN KEY (PId) REFERENCES PRISONER (PId) ON DELETE CASCADE
	-- FOREIGN KEY (`DName`,`JId`) REFERENCES `DEPARTMENT` (`DName`,`DJailId`) DELETE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- Dumping data for table `PWORKSFOR`

LOCK TABLES PWORKSFOR WRITE;

INSERT INTO PWORKSFOR VALUES (125,1,'Toilet Cleaning'),(128,2,'Kitchen');

UNLOCK TABLES;


-- Table Structure of `JWORKSFOR`


DROP TABLE IF EXISTS `JWORKSFOR`;
CREATE TABLE `JWORKSFOR` (
	`JId` int(15) NOT NULL,
	`DName` varchar(15) NOT NULL,
	`POId` int(15) NOT NULL,
	PRIMARY KEY (`JId`,`DName`),
	FOREIGN KEY (`JId`,`DName`) REFERENCES `DEPARTMENT` (`DJailId`,`DName`) ON DELETE CASCADE,
	FOREIGN KEY (`POId`) REFERENCES `POLICEOFFICER` (`POId`) ON DELETE CASCADE
	-- FOREIGN KEY (`DName`) REFERENCES `DEPARTMENT` (`DName`) DELETE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- Dumping data for table `JWORKSFOR`

LOCK TABLES `JWORKSFOR` WRITE;

INSERT INTO `JWORKSFOR` VALUES (1,'Toilet Cleaning',3),(2,'Kitchen',4);

UNLOCK TABLES;



-- Table Structure of `VISITORCONTACT`


DROP TABLE IF EXISTS `VISITORCONTACT`;
CREATE TABLE `VISITORCONTACT` (
	`VPId` int(15) NOT NULL,
	`VFName` varchar(15) NOT NULL,
	`VContact` varchar(10) NOT NULL,
	PRIMARY KEY (`VPId`,`VFName`,`VContact`),
	FOREIGN KEY (`VPId`,`VFName`) REFERENCES `VISITOR` (`VPId`,`VFName`) ON DELETE CASCADE
	-- CHECK (VContact like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
)ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- Dumping data for table `VISITORCONTACT`

LOCK TABLES `VISITORCONTACT` WRITE;

INSERT INTO `VISITORCONTACT` VALUES (125, 'Rohit', '9861655245'),(125, 'Rohit', '5281688785'),(125, 'Anubhav', '3562875249'),(128,'Amogh','9865472158');

UNLOCK TABLES;


-- Table Structure of `POLICEOFFICERCONTACT`


DROP TABLE IF EXISTS `POLICEOFFICERCONTACT`;
CREATE TABLE `POLICEOFFICERCONTACT` (
	`POId` int(15) NOT NULL,
	`POContact` varchar(10) NOT NULL,
	PRIMARY KEY (`POId`,`POContact`),
	FOREIGN KEY (`POId`) REFERENCES `POLICEOFFICER` (`POId`) ON DELETE CASCADE
	-- CHECK (Contact like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
)ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- Dumping data for table `POLICEOFFICERCONTACT`

LOCK TABLES `POLICEOFFICERCONTACT` WRITE;

INSERT INTO `POLICEOFFICERCONTACT` VALUES (1 ,'9865321245'),(2 ,'7845129826'),(3 ,'6589421578'),(4 ,'2563985641'),(5 ,'2514869574'),(6,'9876543210');

UNLOCK TABLES;



-- Table Structure of `POLICEOFFICEREMAIL`

DROP TABLE IF EXISTS `POLICEOFFICEREMAIL`;
CREATE TABLE `POLICEOFFICEREMAIL` (
	`POId` int(15) NOT NULL,
	`POEMAIL` varchar(100) NOT NULL,
	PRIMARY KEY (`POId`,`POEMAIL`),
	FOREIGN KEY (`POId`) REFERENCES `POLICEOFFICER` (`POId`) ON DELETE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- Dumping data for table `POLICEOFFICEREMAIL`

LOCK TABLES `POLICEOFFICEREMAIL` WRITE;

INSERT INTO `POLICEOFFICEREMAIL` VALUES (5,'manas1@gmail.com'),(5,'manas2@gmail.com'),(6,'nikunjnawal@gmail.com');

UNLOCK TABLES;



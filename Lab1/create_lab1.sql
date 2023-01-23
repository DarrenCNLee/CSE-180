DROP SCHEMA Lab1 CASCADE;
CREATE SCHEMA Lab1;

CREATE TABLE Highways (
    highwayNum INT, 
    length NUMERIC(4,1), 
    speedLimit INT,
    PRIMARY KEY (highwayNum)
);

CREATE TABLE Exits (
    highwayNum INT,
    exitNum INT,
    description VARCHAR(60),
    mileMarker NUMERIC(4,1), 
    exitCity VARCHAR(20),
    exitState CHAR(2),
    isExitOpen BOOLEAN,
    PRIMARY KEY (highwayNum, exitNum),
    FOREIGN KEY (highwayNum) REFERENCES Highways(highwayNum)
);

CREATE TABLE Interchanges (
    highwayNum1 INT, 
    exitNum1 INT, 
    highwayNum2 INT, 
    exitNum2 INT,
    PRIMARY KEY (highwayNum1, exitNum1, highwayNum2, exitNum2),
    FOREIGN KEY (highwayNum1, exitNum1) REFERENCES Exits(highwayNum, exitNum),
    FOREIGN KEY (highwayNum2, exitNum2) REFERENCES Exits(highwayNum, exitNum)
);

CREATE TABLE Cameras (
    cameraID INT,
    highwayNum INT,
    mileMarker NUMERIC(4,1),
    isCameraWorking BOOLEAN,
    PRIMARY KEY (cameraID),
    FOREIGN KEY (highwayNum) REFERENCES Highways(highwayNum)
);

CREATE TABLE Owners (
    ownerState CHAR(2), 
    ownerLicenseID CHAR(8),
    name VARCHAR(60),
    address VARCHAR(60),
    startDate DATE,
    expirationDate DATE,
    PRIMARY KEY (ownerState, ownerLicenseID)
);

CREATE TABLE Vehicles (
    vehicleState CHAR(2), 
    vehicleLicensePlate CHAR(7), 
    ownerState CHAR(2),
    ownerLicenseID CHAR(8),
    year INT,
    color CHAR(2),
    PRIMARY KEY (vehicleState, vehicleLicensePlate),
    FOREIGN KEY (ownerState, ownerLicenseID) REFERENCES Owners(ownerState, ownerLicenseID)
);

CREATE TABLE Photos (
    cameraID INT, 
    vehicleState CHAR(2),
    vehicleLicensePlate CHAR(7),
    photoTimestamp TIMESTAMP,
    PRIMARY KEY (cameraID, photoTimestamp),
    FOREIGN KEY (cameraID) REFERENCES Cameras(cameraID),
    FOREIGN KEY (vehicleState, vehicleLicensePlate) REFERENCES Vehicles(vehicleState, vehicleLicensePlate)
);
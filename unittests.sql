INSERT INTO
    Vehicles(ownerState, ownerLicenseID)
VALUES
    ('errorState', 'errorID');

INSERT INTO
    Photos(vehicleState, vehicleLicensePlate)
VALUES
    ('errorState', 'errorLicensePlate');

INSERT INTO
    Photos(cameraID)
VALUES
    ('errorID');

UPDATE
    Exits
SET
    mileMarker = 99;

UPDATE
    Exits
SET
    mileMarker = -255;

UPDATE
    Interchanges
SET
    highwayNum1 = 1,
    highwayNum2 = 2;

UPDATE
    Interchanges
SET
    highwayNum1 = 4,
    highwayNum2 = 3;

UPDATE
    Owners
SET
    startDate = NULL,
    expirationDate = NULL;

UPDATE
    Owners
SET
    startDate = NULL,
    expirationDate = DATE '2023-02-21';
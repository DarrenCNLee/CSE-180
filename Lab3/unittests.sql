INSERT INTO
    Vehicles(ownerState, ownerLicenseID)
VALUES
    ('ZZ', 'errorID');

INSERT INTO
    Photos(cameraID, vehicleState, vehicleLicensePlate)
VALUES
    (50, 'ZZ', 'zzPlate');

INSERT INTO
    Photos(cameraID)
VALUES
    (999);

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
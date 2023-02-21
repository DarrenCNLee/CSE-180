INSERT INTO
    Vehicles(
        vehicleState,
        vehicleLicensePlate,
        ownerState,
        ownerLicenseID
    )
VALUES
    ('a', 'b', 'ZZ', 'errorID');

INSERT INTO
    Photos(
        cameraID,
        vehicleState,
        vehicleLicensePlate,
        photoTimestamp
    )
VALUES
    (
        50,
        'ZZ',
        'zzPlate',
        TIMESTAMP '2022-12-01 16:20:01'
    );

INSERT INTO
    Photos(cameraID, photoTimestamp)
VALUES
    (999, TIMESTAMP '2022-12-01 16:20:01');

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
    highwayNum2 = 34;

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
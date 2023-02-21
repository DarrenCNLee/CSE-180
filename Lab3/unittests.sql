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
    highwayNum2 = 8,
    exitNum2 = 34
FROM
    Interchanges i
WHERE
    i.highwayNum1 = 1
    AND i.exitNum1 = 1
    AND i.highwayNum2 = 17
    AND i.exitNum2 = 1;

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
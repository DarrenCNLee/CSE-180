START TRANSACTION ISOLATION LEVEL SERIALIZABLE;

INSERT INTO
    Photos
SELECT
    pc.cameraID,
    NULL,
    pc.vehicleLicensePlate,
    pc.vehicleLicensePlate,
    pc.photoTimestamp
FROM
    PhotoChanges pc
WHERE
    (pc.cameraID, pc.photoTimestamp) NOT IN (
        SELECT
            pho.camerID,
            pho.photoTimestamp
        FROM
            Photos ph
    );

UPDATE
    Photos
SET
    vehicleLicensePlate = ph.vehicleLicensePlate,
    vehicleState = 'CA'
FROM
    PhotoChange pc
WHERE
    (pc.cameraID, pc.photoTimestamp) IN (
        SELECT
            pho.cameraID,
            pho.photoTimestamp
        FROM
            Photos
    );

COMMIT;
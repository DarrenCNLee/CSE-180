START TRANSACTION ISOLATION LEVEL SERIALIZABLE;

INSERT INTO
    Photos
SELECT
    pc.cameraID,
    NULL,
    pc.vehicleLicensePlate,
    pc.photoTimestamp
FROM
    PhotoChanges pc
WHERE
    (pc.cameraID, pc.photoTimestamp) NOT IN (
        SELECT
            pho.cameraID,
            pho.photoTimestamp
        FROM
            Photos pho
    );

UPDATE
    Photos
SET
    vehicleLicensePlate = pc.vehicleLicensePlate,
    vehicleState = 'CA'
FROM
    PhotoChanges pc
WHERE
    (pc.cameraID, pc.photoTimestamp) IN (
        SELECT
            pho.cameraID,
            pho.photoTimestamp
        FROM
            Photos pho
    );

COMMIT;
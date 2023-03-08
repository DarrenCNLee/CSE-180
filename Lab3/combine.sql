START TRANSACTION ISOLATION LEVEL SERIALIZABLE;

UPDATE
    Photos pho
SET
    vehicleLicensePlate = pc.vehicleLicensePlate,
    vehicleState = 'CA'
FROM
    PhotoChanges pc
WHERE
    pc.cameraID = pho.cameraID
    AND pc.photoTimestamp = pho.photoTimestamp;

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

COMMIT;
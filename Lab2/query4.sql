SELECT
    p.cameraID AS theCameraID,
    p.photoTimestamp AS theTimestamp,
    o.name AS theOwnerName,
    o.address AS theOwnerAddress
FROM
    Photos p,
    Owners o,
    Cameras c,
    Vehicles v,
    Highways h
WHERE
    c.isCameraWorking = TRUE
    AND p.cameraID = c.cameraID
    AND DATE(p.photoTimestamp) = DATE '2022-12-01'
    AND p.vehicleLicensePlate = v.vehicleLicensePlate
    AND p.vehicleState = v.vehicleState
    AND (
        v.color = 'RE'
        OR v.color = 'GR'
    )
    AND o.name LIKE '_o%'
    AND o.ownerState = v.ownerState
    AND o.ownerLicenseID = v.ownerLicenseID
    AND c.highwayNum = h.highwayNum
    AND h.speedLimit <= 65;
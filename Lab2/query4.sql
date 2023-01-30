SELECT
    DISTINCT p.cameraID AS theCameraID,
    p.photoTimestamp AS theTimestamp,
    o.name as theOwnerName,
    o.address as theOwnerAddress
FROM
    Photos p,
    Owners o,
    Cameras c,
    Vehicles v,
    Highways h
WHERE
    p.cameraID = c.cameraID
    AND c.isCameraWorking = TRUE
    AND DATE(p.photoTimestamp) = DATE '12/01/22'
    AND p.vehicleState = v.ownerState
    AND p.vehicleLicensePlate = v.vehicleLicensePlate
    AND (
        v.color = 'RE'
        or v.color = 'GR'
    )
    AND o.ownerState = v.ownerState
    AND o.ownerLicenseID = v.ownerLicenseID
    AND o.name = '_o%'
    AND c.highwayNum = h.highwayNum
    AND h.speedLimit <= 65;
SELECT
    DISTINCT v.vehicleLicensePlate,
    v.ownerState,
    o.expirationDate
FROM
    Vehicles v,
    Owners o
WHERE
    v.vehicleState = 'CA'
    AND v.year < 2021
    AND v.ownerState != 'CA'
    AND o.expirationDate IS NOT NULL
    AND v.ownerState = o.ownerState
    AND v.ownerLicenseID = o.ownerLicenseID;
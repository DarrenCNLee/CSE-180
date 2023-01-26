SELECT
    DISTINCT vehicleLicensePlate,
    ownerState,
    expirationDate
FROM
    Vehicles
WHERE
    vehicleState = 'CA'
    AND year < 2021
    AND ownerState != 'CA'
    AND expirationDate IS NOT NULL;
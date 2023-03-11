CREATE OR REPLACE FUNCTION 
determineSpeedingViolationsAndFines(maxFineTotal INTEGER)
RETURNS INTEGER AS $$

    DECLARE
        totalFines INTEGER;

    DECLARE finingCursor CURSOR FOR 
            SELECT o.ownerState, o.ownerLicenseID, COUNT(*)
            FROM Owners o, DistancesAndIntervalsForPhotos d, Highways h, Vehicles v 
            WHERE d.vehicleLicensePlate = v.vehicleLicensePlate 
                AND v.ownerState = o.ownerState 
                AND v.ownerLicenseID = o.ownerLicenseID 
                AND d.highwayNum = h.highwayNum 
                AND (d.distBetweenCameraMileMarkers / d.photoIntervalInHours) > h.speedLimit
            GROUP BY o.ownerState, o.ownerLicenseID
            ORDER BY COUNT(*) DESC;

    BEGIN

    if maxFineTotal <= 0 THEN 
        RETURN -1;
        END IF;

        totalFines := 0;

        OPEN finingCursor; 

        LOOP
        
            FETCH finingCursor INTO theOwnerState, theOwnerLicense, numViolations;

            EXIT WHEN NOT FOUND OR totalFines >= maxFineTotal;

            IF numViolations >= 3 THEN totalFines := totalFines + 50 * numViolations; 
            ELSIF numViolations = 2 THEN totalFines 

            UPDATE Owners
            SET speedingViolations = numViolations
            WHERE ownerState = theOwnerState 
                AND ownerLicense = theOwnerLicense;


        END LOOP;
        CLOSE finingCursor;

    RETURN totalFines;

    END

$$ LANGUAGE plpgsql;
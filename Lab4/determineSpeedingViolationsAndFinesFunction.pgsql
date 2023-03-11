CREATE OR REPLACE FUNCTION 
determineSpeedingViolationsAndFines(maxFineTotal INTEGER)
RETURNS INTEGER AS $$

    DECLARE
        totalFines INTEGER;
        curFines INTEGER;

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

            EXIT WHEN NOT FOUND;

            IF numViolations >= 3 THEN curFines := 50 * numViolations; 
            ELSIF numViolations = 2 THEN curFines :=  40; 
            ELSIF numViolations = 1 THEN curFines := 10;
            ELSE curFines := 0;
            END IF; 

            totalFines := totalFines + curFines;

            EXIT WHEN totalFines >= maxFineTotal;

            UPDATE Owners
            SET speedingViolations = numViolations,
                fine = curFines
            WHERE ownerState = theOwnerState 
                AND ownerLicense = theOwnerLicense;

        END LOOP;
        CLOSE finingCursor;

    RETURN totalFines;

    END

$$ LANGUAGE plpgsql;
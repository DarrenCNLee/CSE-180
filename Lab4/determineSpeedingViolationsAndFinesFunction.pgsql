CREATE OR REPLACE FUNCTION 
determineSpeedingViolationsAndFines(maxFineTotal INTEGER)
RETURNS INTEGER AS $$

    DECLARE
        -- total fines assessed
        totalFines INTEGER; 

        -- fines for the current owner
        curFines INTEGER;

        theOwnerState CHAR(2);
        theOwnerLicenseID CHAR(8);

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

    -- input validation
    if maxFineTotal <= 0 THEN 
        -- illegal value of maxFineTotal
        RETURN -1;
        END IF;

        totalFines := 0;

        OPEN finingCursor; 

        LOOP
        
            FETCH finingCursor INTO theOwnerState, theOwnerLicenseID, numViolations;

            -- Exit if there are no more records for finingCursor,
            -- or when we already have assessed maxFineTotal fines.
            EXIT WHEN NOT FOUND totalFines >= maxFineTotal; 

            IF numViolations >= 3 THEN curFines := 50 * numViolations; 
            ELSIF numViolations = 2 THEN curFines :=  40; 
            ELSIF numViolations = 1 THEN curFines := 10;
            ELSE curFines := 0;
            END IF; 

            -- if the adding the current fine will make totalFines greater than the maxFineTotal, go to the next tuple
            CONTINUE WHEN totalFines + curFines > maxFineTotal;
            
            -- otherwise increase totalFines by the curFines
            totalFines := totalFines + curFines;

            -- update the Owners table by setting the number of speeding violations and the fines
            UPDATE Owners
            SET speedingViolations = numViolations,
                fine = curFines
            WHERE ownerState = theOwnerState 
                AND ownerLicenseID = theOwnerLicenseID;

        END LOOP;
        CLOSE finingCursor;

    RETURN totalFines;

    END

$$ LANGUAGE plpgsql;
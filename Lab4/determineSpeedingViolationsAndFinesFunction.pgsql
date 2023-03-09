CREATE OR REPLACE FUNCTION 
determineSpeedingViolationsAndFines(maxFineTotal INTEGER)
RETURNS INTEGER AS $$

    DECLARE
        numFined INTEGER;
        
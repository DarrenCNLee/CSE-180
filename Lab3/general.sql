ALTER TABLE
    Exits
ADD
    CONSTRAINT mileMarkerNonNegative CHECK(mileMarker >= 0);

ALTER TABLE
    Interchanges
ADD
    CONSTRAINT interchangeHighways CHECK(highwayNum1 < highwayNum2);

ALTER TABLE
ADD
    CONSTRAINT startNullExpirationNull CHECK(
        startDate IS NOT NULL
        OR expirationDate IS NULL
    );
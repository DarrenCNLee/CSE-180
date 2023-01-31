SELECT
    e1.highwayNum,
    e1.exitNum AS firstExitNum,
    e2.exitnum AS secondExitNum,
    e2.mileMarker - e1.mileMarker AS exitDistance
FROM
    Highways h,
    Exits e1,
    Exits e2
WHERE
    e1.highwayNum = e2.highwayNum
    AND e1.mileMarker < e2.mileMarker
    AND exitDistance <= 5;
CREATE VIEW MisdirectedExitView AS
SELECT
    e1.highwayNum,
    e1.exitNum,
    e1.mileMarker,
    COUNT(*) AS misdirectedProverCount
FROM
    Exits e1,
    Exits e2
WHERE
    e2.exitNum > e1.exitNum
    AND e2.mileMarker < e1.mileMarker
GROUP BY
    e1.highwayNum,
    e1.exitNum,
    e1.mileMarker
HAVING
    COUNT(*) >= 2;
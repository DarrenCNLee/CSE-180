SELECT
    h.highwayNum,
    h.length,
    COUNT(*) AS openMisdirectedExitCount
FROM
    Highways h,
    Exits e
WHERE
    e.isExitOpen
    AND e.highwayNum = h.highwayNum
    AND h.highwayNum IN (
        SELECT
            m.highwayNum
        FROM
            MisdirectedExitView m
    )
GROUP BY
    h.highwayNum,
    h.length;

-- output of the query on the load data before deletions:
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
--  highwaynum | length | openmisdirectedexitcount
-- ------------+--------+--------------------------
--           1 |  150.3 |                        3
--           8 |   90.0 |                        2
--          13 |   45.5 |                        4
--          17 |  102.6 |                        4
--         280 |  200.9 |                        3
-- (5 rows)


DELETE FROM
    Exits
WHERE
    highwayNum = 17
    AND exitNum = 34;

DELETE FROM
    Exits
WHERE
    highwayNum = 280
    AND exitNum = 95;

-- output of the query after the deletions:
--  highwaynum | length | openmisdirectedexitcount
-- ------------+--------+--------------------------
--           1 |  150.3 |                        3
--           8 |   90.0 |                        2
--          13 |   45.5 |                        4
--          17 |  102.6 |                        3
-- (4 rows)


-- Yes, the answer is different after deleting the tuples from Exits
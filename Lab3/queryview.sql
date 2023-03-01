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
    AND (h.highwayNum, e.exitNum) IN (
        SELECT
            m.highwayNum, m.exitNum
        FROM
            MisdirectedExitView m
    )
GROUP BY
    h.highwayNum,
    h.length;


-- output of the query on the load data before deletions:
--  highwaynum | length | openmisdirectedexitcount
-- ------------+--------+--------------------------
--           1 |  150.3 |                        1
--          13 |   45.5 |                        2
--          17 |  102.6 |                        3
--         280 |  200.9 |                        1
-- (4 rows)


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
--           1 |  150.3 |                        1
--          13 |   45.5 |                        2
--          17 |  102.6 |                        2
-- (3 rows)

-- Yes, the answer is different after deleting the tuples from Exits
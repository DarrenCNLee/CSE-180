SELECT
    DISTINCT highwayNum1 AS h1,
    exitNum1 AS e1,
    highwayNum2 AS h2,
    exitNum2 AS e2
FROM
    Interchanges i,
    Exits ex1,
    Exits ex2
WHERE
    ex1.isExitOpen = TRUE
    AND ex1.isExitOpen = TRUE
    AND ex1.exitNum = i.exitNum1
    AND ex2.exitNum = i.exitNum2
    AND ex1.description = ex2.description
    AND (
        ex1.exitCity != ex2.exitCity
        OR ex1.exitState != ex2.exitState
    )
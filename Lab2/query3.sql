SELECT
    DISTINCT h.highwayNum,
    h.length
FROM
    Highways h,
    Cameras c
WHERE
    h.highwayNum NOT IN (
        SELECT
            h2.highwayNum
        FROM
            Highways h2,
            Cameras c2
        WHERE
            h2.highwayNum = c2.highwayNum
            AND c2.isCameraWorking = TRUE
    )
    AND c.highwayNum = h.highwayNum
    AND h.length > 100
ORDER BY
    h.length DESC;
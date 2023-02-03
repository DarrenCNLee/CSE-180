SELECT
    h.highwayNum,
    h.length
FROM
    Highways h
WHERE
    h.highwayNum NOT IN (
        SELECT
            c.highwayNum
        FROM
            Cameras c
        WHERE
            c.isCameraWorking = TRUE
    )
    AND h.length > 100
ORDER BY
    h.length DESC;
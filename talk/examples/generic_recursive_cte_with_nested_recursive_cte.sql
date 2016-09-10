WITH RECURSIVE cte(n) AS (
  SELECT 1

  UNION

  SELECT *
  FROM (
    WITH RECURSIVE nested(m) AS (
      SELECT 1

      UNION

      SELECT m + 1
      FROM nested
      WHERE m < 10
    )
    SELECT *
    FROM nested
  ) t
)

SELECT *
FROM cte
ORDER BY n DESC

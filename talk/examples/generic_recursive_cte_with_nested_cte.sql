WITH RECURSIVE cte(n) AS (
  SELECT 1

  UNION

  SELECT *
  FROM (
    WITH nested AS (
      SELECT n + 1
      FROM cte
      WHERE n < 10
    )
    SELECT *
    FROM nested
  ) t
)

SELECT *
FROM cte
ORDER BY n DESC

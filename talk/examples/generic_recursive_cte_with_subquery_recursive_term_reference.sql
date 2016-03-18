WITH RECURSIVE cte(n) AS (
  SELECT 1

  UNION

  SELECT
    (
      SELECT MAX(n)
      FROM cte
    ) + 1
  FROM cte
  WHERE n < 10
)

SELECT *
FROM cte
ORDER BY n DESC

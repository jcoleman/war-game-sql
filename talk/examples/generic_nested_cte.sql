WITH cte(n) AS (
  SELECT *
  FROM (
    WITH cte2(m) AS (
      SELECT *
      FROM generate_series(1, 10)
    )
    SELECT m * 2
    FROM cte2
  ) t
)

SELECT *
FROM cte
ORDER BY n DESC

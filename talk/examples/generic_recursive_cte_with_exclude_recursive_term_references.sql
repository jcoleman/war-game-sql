WITH RECURSIVE cte(n) AS (
  SELECT 1

  UNION

  (
    SELECT n + 1
    FROM cte
    WHERE n < 10
    
    EXCEPT

    SELECT n
    FROM cte
    WHERE n < 2
  )
)

SELECT *
FROM cte
ORDER BY n DESC

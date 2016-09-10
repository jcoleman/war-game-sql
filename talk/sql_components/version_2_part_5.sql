WITH RECURSIVE
  -- ...
  simulation_hands (hand, packets) AS (
    -- ...

    UNION ALL

    SELECT hand, packets
    -- ...
    WHERE
      -- End when either there is a stalemate
      -- or a player no cards remaining.
      packets[1] = packets[2] 
      OR ARRAY_LENGTH(packets[1], 1) = 0
      OR ARRAY_LENGTH(packets[2], 1) = 0
  )

SELECT * FROM simulation_hands;

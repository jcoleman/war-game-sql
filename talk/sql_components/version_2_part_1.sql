WITH RECURSIVE
  -- ...
  simulation_hands (hand, packets) AS (
    SELECT
      1 AS hand,
      -- Unfortunately ARRAY_AGG doesn't handle arrays :(
      -- but support for this will be added in 9.5 :)
      ARRAY[
        (SELECT packet FROM player_packets WHERE player_index = 1),
        (SELECT packet FROM player_packets WHERE player_index = 2)
      ] AS packets

    UNION ALL

WITH RECURSIVE
  -- ...
  simulation_hands (hand, packets) AS (
    -- ...

    UNION ALL

    SELECT
      hand + 1 AS hand,
      ARRAY[
        (CASE WHEN winner = 1 THEN
                pending_cards || retained_packets[1]
              ELSE retained_packets[1] END),
        (CASE WHEN winner = 2 THEN
                pending_cards || retained_packets[1]
              ELSE retained_packets[2] END)
      ] AS packets
    FROM (
      -- Find the most recently added tuple (hand, packets).
      SELECT *
      FROM simulation_hands
      ORDER BY hand DESC
      LIMIT 1
    ) last_simulation_hand_packets

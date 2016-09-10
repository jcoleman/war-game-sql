WITH RECURSIVE
  -- ...
  simulation_hands (hand, packets) AS (
    -- ...

    UNION ALL

    SELECT hand, packets
    -- ...
    INNER JOIN LATERAL (
      SELECT
        -- Determine what cards each player will keep.
        ARRAY[
          packets[1][1:ARRAY_LENGTH(packets[1], 1)],
          packets[2][1:ARRAY_LENGTH(packets[2], 1)]
        ] AS retained_packets,
        -- Determine which cards are being played this hand.
        ARRAY[
          COALESCE(packets[0][ARRAY_LENGTH(packets[1], 1)], -1),
          COALESCE(packets[1][ARRAY_LENGTH(packets[2], 1)], -1)
        ] AS last_cards
    ) simulation_hand_precalculations ON TRUE

WITH RECURSIVE
  -- ...
  simulation_hands AS (
    -- ...
    UNION ALL

    (
      WITH (
        -- ...
      )
      -- Return each player's resulting hand after cards have been played.
      SELECT
        (SELECT MAX(simulation_hands.hand) + 1 FROM simulation_hands) AS hand,
        player_index,
        (CASE WHEN winner THEN pending_cards || packet ELSE packet END) AS packet
      FROM simulation_hand_calculations
      WHERE
        1 > (
          -- Either one player has all of the cards (that is,
          -- there's only one player_index) or there are multiple
          -- player indices but the packets are all equal (stalemate).
          SELECT COUNT(DISTINCT(player_index, player_packet))
          FROM last_simulation_hand_packets
          WHERE ARRAY_LENGTH(player_packet) > 0
        )
    )
  )

SELECT * FROM simulation_hands;

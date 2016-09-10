WITH RECURSIVE
  -- ...
  simulation_hands AS (
    -- ...
    UNION ALL

    (
      WITH
        -- ...
        simulation_hand_precalculations AS (
          -- Remove the last card from each player's packet and determine
          -- what card will be played in opposition.
          SELECT
            player_index,
            packet[1:(ARRAY_LENGTH(packet) - 1)] AS retained_cards,
            COALESCE(packet[ARRAY_LENGTH(packet)], -1) AS last_card,
            (
              SELECT ARRAY_AGG(p2.packet[ARRAY_LENGTH(p2.packet)])
              FROM last_simulation_hand_packets p2
            ) AS pending_cards,
            COALESCE((
              SELECT MAX(p3.packet[ARRAY_LENGTH(p3.packet)])
              FROM last_simulation_hand_packets p3
              WHERE p3.player_index != last_simulation_hand_packets.player_index
            ), -1) AS max_opposing_card
          FROM last_simulation_hand_packets
        ),

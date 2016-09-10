    SELECT hand, packet_1, packet_1, pending_cards, war_count, winner
    -- ...
    WHERE
      -- Continue until stalemate (equal packets) or
      -- one player has all of the cards.
      NOT (
        packet_1 = packet_2
        OR ARRAY_LENGTH(packet_1, 1) = 0
        OR ARRAY_LENGTH(packet_2, 1) = 0
      )
  )

SELECT * FROM simulation_hands;

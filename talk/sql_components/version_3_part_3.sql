    SELECT hand, packet_1, packet_1, pending_cards, war_count, winner

    INNER JOIN LATERAL (
      SELECT
        last_simulation_results.packet_1[
          1:(ARRAY_LENGTH(packet_1, 1) - 1)
        ] AS retained_packet_1,
        last_simulation_results.packet_2[
          1:(ARRAY_LENGTH(packet_2, 1) - 1)
        ] AS retained_packet_2,
        ARRAY[
          COALESCE(packet_1[ARRAY_LENGTH(packet_1, 1)], -1),
          COALESCE(packet_2[ARRAY_LENGTH(packet_2, 1)], -1)
        ] AS last_cards
    ) simulation_hand_precalculations ON TRUE

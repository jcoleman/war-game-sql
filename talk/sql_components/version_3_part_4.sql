    SELECT hand, packet_1, packet_1, pending_cards, war_count, winner

    INNER JOIN LATERAL (
      SELECT
        (
          SELECT ARRAY_AGG(c.n ORDER BY RANDOM())
          FROM UNNEST(last_cards || last_simulation_results.pending_cards) c(n)
          WHERE c.n > -1
        ) AS pending_cards,
        (
          CASE
          WHEN last_cards[1] = last_cards[2] THEN NULL::INTEGER
          WHEN last_cards[1] > last_cards[2] THEN 1
          ELSE 2
          END
        ) AS winner
    ) simulation_hand_calculations ON TRUE

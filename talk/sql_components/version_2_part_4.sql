WITH RECURSIVE
  -- ...
  simulation_hands (hand, packets) AS (
    -- ...

    UNION ALL

    SELECT hand, packets
    -- ...
    INNER JOIN LATERAL (
      SELECT
        -- Determine the set of cards that are "in play".
        (
          SELECT ARRAY_AGG(card ORDER BY RANDOM())
          FROM UNNEST(last_cards) AS cards(card)
          WHERE card > -1
        ) as pending_cards,
        -- Determine the index of the winning packet.
        (
          CASE
          WHEN last_cards[1] = last_cards[2] THEN NULL
          WHEN last_cards[1] > last_cards[2] THEN 1
          ELSE 2
          END
        ) AS winning_index
    ) simulation_hand_calculations ON TRUE

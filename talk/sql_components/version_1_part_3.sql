WITH RECURSIVE
  -- ...
  simulation_hands AS (
    -- ...
    UNION ALL

    (
      WITH
        -- ...
        simulation_hand_calculations AS (
          -- Determine what cards each player will keep in their
          -- packet, what cards are in play, and who won (if either).
          SELECT
            player_index,
            retained_cards,
            -- Shuffle the "in play" cards to avoid potential cycles.
            (SELECT * from UNNEST(pending_cards) ORDER BY RANDOM()) AS pending_cards,
            (
              CASE
              WHEN last_card = max_opposing_card THEN NULL
              WHEN last_card > max_opposing_card THEN TRUE
              ELSE FALSE
              END
            ) AS winner
          FROM simulation_hand_precalculations
        )

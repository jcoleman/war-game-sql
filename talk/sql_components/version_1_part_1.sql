WITH RECURSIVE
  -- ...
  simulation_hands AS (
    -- Initial data: first hand each player starts with
    -- their randomly dealt packet (calculated previously).
    SELECT 1 AS hand, player_index, packet
    FROM player_packets

    -- We just want to keep appending to our result set
    -- rather than having PG check for uniqueness.
    UNION ALL

    (
      WITH last_simulation_hand_packets AS (
        -- Find the most recently played hand and the packet
        -- each player had at that point in the game.
        select *
        from simulation_hands
        where simulation_hands.hand = (
          select max(h2.hand)
          from simulation_hands h2
        )
      ),

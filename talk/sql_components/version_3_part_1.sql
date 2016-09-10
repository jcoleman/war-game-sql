WITH RECURSIVE
  -- ...
  simulation_hands (
    hand, packet_1, packet_2, pending_cards, war_count, winner
  ) AS (
    -- Initial data: first hand; each player's packet is
    -- inlined into a single row; no winner or other data.
    SELECT
      1 AS hand,
      (
        SELECT packet FROM player_packets WHERE player_index = 0
      ) AS packet_1,
      (
        SELECT packet FROM player_packets WHERE player_index = 1
      ) AS packet_2,
      ARRAY[]::INTEGER[],
      0,
      NULL::INTEGER

    UNION ALL

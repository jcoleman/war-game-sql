WITH RECURSIVE
  -- ...
  simulation_hands (hand, packet_1, packet_2, pending_cards, war_count, winner) AS (
    -- ...

    UNION ALL

    SELECT
      hand + 1 AS hand,
      ( CASE simulation_hand_calculations.winner WHEN 1 THEN
          simulation_hand_calculations.pending_cards || retained_packet_1
        ELSE retained_packet_1 END ) AS packet_1,
      ( CASE simulation_hand_calculations.winner WHEN 2 THEN
          simulation_hand_calculations.pending_cards || retained_packet_2
        ELSE retained_packet_2 END ) AS packet_2,
      ( CASE WHEN simulation_hand_calculations.winner IS NULL THEN
          simulation_hand_calculations.pending_cards
        ELSE ARRAY[]::INTEGER[] END ) AS pending_cards,
      (
        CASE WHEN last_simulation_results.winner IS NOT NULL
                  AND simulation_hand_calculations.winner IS NULL
        THEN last_simulation_results.war_count + 1
        ELSE last_simulation_results.war_count END ) AS war_count,
      simulation_hand_calculations.winner
    FROM (
      SELECT *
      FROM simulation_hands
      ORDER BY hand DESC
      LIMIT 1
    ) last_simulation_results

WITH
  deck_cards AS (
    SELECT face_values.card, suits.i AS suit
    FROM generate_series(1, 13) AS face_values(card)
    CROSS JOIN generate_series(1, 4) AS suits(i)
    ORDER BY RANDOM()
  ),
  deck_cards_with_player_indices AS (
    SELECT (ROW_NUMBER() OVER ()) % 2 AS player_index, card
    FROM deck_cards
  ),
  player_packets AS (
    SELECT player_index, ARRAY_AGG(card) AS packet
    FROM deck_cards_with_player_indices
    GROUP BY player_index
  ),

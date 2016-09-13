with recursive
  deck_cards as (
    select face_values.card, suits.i as suit
    from generate_series(1, 4) as face_values(card)
    cross join generate_series(1, 2) as suits(i)
    order by random()
  ),
  deck_cards_with_player_indices as (
    select (row_number() over ()) % 2 as player_index, deck_cards,card
    from deck_cards
  ),
  player_packets as (
    select player_index, array_agg(card) as packet
    from deck_cards_with_player_indices
    group by player_index
  ),
  simulation_hands as (
    -- Initial data: first hand each player starts with
    -- their randomly dealt packet (calculated previously).
    select 1 as hand, player_index, packet
    from player_packets
  )

select * from simulation_hands;

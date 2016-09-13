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
    select
      1 as hand,
      (select packet from player_packets where player_index = 0) as packet_1,
      (select packet from player_packets where player_index = 1) as packet_2,
      array[]::integer[],
      0,
      null::integer
  )

select * from simulation_hands;

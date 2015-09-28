with recursive
  deck_cards as (
    select face_values.card, suits.i as suit
    from generate_series(1, 13) as face_values(card)
    cross join generate_series(1, 4) as suits(i)
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
  simulation_hands (hand, packets) as (
    select
      1 as hand,
      -- Unfortunately array_agg doesn't yet handle aggregating arrays :(
      -- but support for this will be added in 9.5 :)
      array[
        (select packet from player_packets where player_index = 1),
        (select packet from player_packets where player_index = 2)
      ] as packets

    union all

    (
      select
        hand + 1 as hand,
        array[
          (case when winner = 1 then pending_cards || retained_packets[1] else retained_packets[1] end),
          (case when winner = 2 then pending_cards || retained_packets[1] else retained_packets[2] end)
        ] as packets
      from (
        select *
        from simulation_hands
        order by hand desc
        limit 1
      ) last_simulation_hand_packets
      inner join lateral (
        select
          array[
            packets[1][1:array_length(packets[1], 1)],
            packets[2][1:array_length(packets[2], 1)]
          ] as retained_packets,
          --array[
          --  packets[0][array_length(packets[0])],
          --  packets[1][array_length(packets[1])]
          --] as pending_cards,
          array[
            coalesce(packets[0][array_length(packets[1], 1)], -1),
            coalesce(packets[1][array_length(packets[2], 1)], -1)
          ] as last_cards
      ) simulation_hand_precalculations on true
      inner join lateral (
        select
          (
            select array_agg(card)
            from unnest(last_cards) as cards(card)
            where card > -1
            order by random()
          ) as pending_cards,
          (
            case
            when last_cards[1] = last_cards[2] then null
            when last_cards[1] > last_cards[2] then 1
            else 2
            end
          ) as winning_index
      ) simulation_hand_calculations on true
      where
        packets[1] = packets[2] -- stalemate
        or array_length(packets[1], 1) = 0
        or array_length(packets[2], 1) = 0
    )
  )

select * from simulation_hands